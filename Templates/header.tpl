<?php 
#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Filename       header.tpl                                                  ##
##  Developed by:  Dzoki                                                       ##
##  License:       TravianZ Project                                            ##
##  Copyright:     TravianZ (c) 2010-2025. All rights reserved.                ##
##                                                                             ##
#################################################################################
?>

<div id="header">
<!-- Mobile-only panorama banner (hidden on desktop via CSS, shown on mobile) -->
<div id="mobile_header_banner">
    <span class="mobile_server_name"><?php echo SERVER_NAME; ?></span>
</div>
<?php
$_serverEnd = isset($database) ? $database->getServerEndState() : false;

$_protect_ts = isset($session->userinfo['protect']) ? (int)$session->userinfo['protect'] : 0;
$_gold_protect_ts = isset($session->userinfo['gold_protect']) ? (int)$session->userinfo['gold_protect'] : 0;
$_active_protect_ts = max($_protect_ts, $_gold_protect_ts);

// Hide any other timers (like beginner protection) when the server has ended
if ($_serverEnd === false && $_active_protect_ts > time()) {
    $_protect_remaining = $_active_protect_ts - time();
?>
    <div id="bp_timer_box" style="position: absolute; left: 20px; top: 20px; background: #1cb5c9; color: white; border-radius: 12px; padding: 5px 12px; font-weight: bold; font-family: Tahoma, Arial, sans-serif; font-size: 14px; display: flex; align-items: center; gap: 6px; z-index: 1000; box-shadow: 0 2px 5px rgba(0,0,0,0.3);">
        <span style="font-size: 16px;">🕊️</span>
        <span id="bp_countdown"><?php echo $generator->getTimeFormat($_protect_remaining); ?></span>
    </div>
    <script>
    (function(){
        var rem = <?php echo $_protect_remaining; ?>;
        var el = document.getElementById('bp_countdown');
        if(!el) return;
        setInterval(function(){
            rem--;
            if(rem <= 0){ el.parentNode.style.display='none'; return; }
            var h = Math.floor(rem/3600);
            var m = Math.floor((rem%3600)/60);
            var s = rem%60;
            el.textContent = (h<10?'0'+h:h)+':'+(m<10?'0'+m:m)+':'+(s<10?'0'+s:s);
        }, 1000);
    })();
    </script>
<?php
}
?>
<?php
// Post-Wonder grace period: server has ended, show winner + countdown to the new round.
if ($_serverEnd !== false):
    $_se_remaining = (int)$_serverEnd['remaining'];
?>
    <div id="server_end_box" style="position:absolute; left:20px; top:50px; background:linear-gradient(to bottom,#a01818,#6e0f0f); color:#fff; border:1px solid #4d0a0a; border-radius:12px; padding:7px 14px; font-family:Tahoma,Arial,sans-serif; font-size:13px; font-weight:bold; line-height:1.5; z-index:1001; box-shadow:0 2px 6px rgba(0,0,0,0.4); text-align:center;">
        <div>🏆 <?php echo (defined('LANG') && LANG === 'ar') ? 'انتهى السيرفر — الفائز' : 'Server ended — winner'; ?>: <a href="spieler.php?uid=<?php echo $_serverEnd['uid']; ?>" style="color:#00ff00; text-decoration:none; font-weight:bold;" onmouseover="this.style.textDecoration='underline'" onmouseout="this.style.textDecoration='none'"><?php echo htmlspecialchars($_serverEnd['winner']); ?></a></div>
        <div style="margin-top:4px; font-weight:normal;"><?php echo (defined('LANG') && LANG === 'ar') ? 'جولة جديدة بعد' : 'New round in'; ?>: <span id="server_end_countdown" style="font-size:16px; font-weight:bold; display:block; margin-top:2px;"><?php echo $generator->getTimeFormat($_se_remaining); ?></span></div>
    </div>
    <script>
    (function(){
        var rem = <?php echo $_se_remaining; ?>;
        var el = document.getElementById('server_end_countdown');
        if(!el) return;
        function p(n){ return n<10 ? '0'+n : n; }
        function fmt(t){
            if(t<=0) return '<?php echo (defined('LANG') && LANG === 'ar') ? 'جارٍ بدء الجولة الجديدة…' : 'starting new round…'; ?>';
            var h=Math.floor(t/3600), m=Math.floor((t%3600)/60), s=t%60;
            return p(h)+':'+p(m)+':'+p(s);
        }
        el.textContent = fmt(rem);
        setInterval(function(){ rem--; el.textContent = fmt(rem); }, 1000);
    })();
    </script>
<?php endif; ?>
    <input type="checkbox" id="mobile-nav-toggle" style="display:none;" />
    <label for="mobile-nav-toggle" class="mobile-hamburger" style="display:none;">
        <span></span>
        <span></span>
        <span></span>
    </label>
    <label for="mobile-nav-toggle" class="mobile-sidebar-backdrop" style="display:none;"></label>
    
    <div id="mtop">
        <a href="plus.php?id=3" id="plus">
        <span id="header_gold_display">
            <?php if($session->gold >= 2): ?>
                <img src="<?php echo GP_LOCATE; ?>img/a/gold.gif" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'الذهب' : 'Gold'; ?>" title="<?php echo number_format($session->gold); ?> <?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" />
                <span class="gold_amount"><?php echo number_format($session->gold); ?></span>
            <?php else: ?>
                <img src="<?php echo GP_LOCATE; ?>img/a/gold_g.gif" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'الذهب' : 'Gold'; ?>" title="<?php echo number_format($session->gold); ?> <?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" />
                <span class="gold_amount low"><?php echo number_format($session->gold); ?></span>
            <?php endif; ?>
        </span>
        </a>
        <a href="<?php echo ($_SESSION['id_user'] != 1 ? 'dorf1.php' : '#'); ?>" id="n1" accesskey="1"><img src="img/x.gif" title="<?php echo (defined('LANG') && LANG === 'ar' ? 'نظرة عامة على القرية' : 'Village overview'); ?>" alt="<?php echo (defined('LANG') && LANG === 'ar' ? 'نظرة عامة على القرية' : 'Village overview'); ?>" /></a>
        <a href="<?php echo ($_SESSION['id_user'] != 1 ? 'dorf2.php' : '#'); ?>" id="n2" accesskey="2"><img src="img/x.gif" title="<?php echo (defined('LANG') && LANG === 'ar' ? 'مركز القرية' : 'Village centre'); ?>" alt="<?php echo (defined('LANG') && LANG === 'ar' ? 'مركز القرية' : 'Village centre'); ?>" /></a>
        <a href="karte.php" id="n3" accesskey="3"><img src="img/x.gif" title="<?php echo (defined('LANG') && LANG === 'ar' ? 'الخريطة' : 'Map'); ?>" alt="<?php echo (defined('LANG') && LANG === 'ar' ? 'الخريطة' : 'Map'); ?>" /></a>
        <a href="statistiken.php" id="n4" accesskey="4"><img src="img/x.gif" title="<?php echo (defined('LANG') && LANG === 'ar' ? 'الإحصائيات' : 'Statistics'); ?>" alt="<?php echo (defined('LANG') && LANG === 'ar' ? 'الإحصائيات' : 'Statistics'); ?>" /></a>
        <?php
        if($message->unread && !$message->nunread) {
        $class = "i2";
        }
        else if(!$message->unread && $message->nunread) {
        $class = "i3";
        }
        else if($message->unread && $message->nunread) {
        $class = "i1";
        }
        else {
        $class = "i4";
        }
        ?>
          <div id="n5" class="<?php echo $class ?>" style="position:relative;">
          <?php if(defined('LANG') && LANG === 'ar'): ?>
            <span style="position:relative; display:inline-block;">
              <a href="nachrichten.php" accesskey="6"><img src="img/x.gif" class="l" title="الرسائل" alt="الرسائل"/></a>
              <span id="nav_msg_badge" style="display:none; position: absolute; top: -8px; right: -8px; left: auto; background: #ff2828; color: white; border-radius: 50%; padding: 1px 5px; font-size: 11px; font-weight: bold; font-family: Tahoma, Arial, sans-serif; box-shadow: 0 2px 4px rgba(0,0,0,0.4); z-index: 10; pointer-events: none; border: 1.5px solid #fff; min-width: 14px; text-align: center; line-height: 14px;"></span>
            </span>
            <span style="position:relative; display:inline-block;">
              <a href="<?php echo ($_SESSION['id_user'] != 1 ? 'berichte.php' : '#'); ?>" accesskey="5"><img src="img/x.gif" class="r" title="التقارير" alt="التقارير" /></a>
              <span id="nav_report_badge" style="display:none; position: absolute; top: -8px; left: -8px; right: auto; background: #ff2828; color: white; border-radius: 50%; padding: 1px 5px; font-size: 11px; font-weight: bold; font-family: Tahoma, Arial, sans-serif; box-shadow: 0 2px 4px rgba(0,0,0,0.4); z-index: 10; pointer-events: none; border: 1.5px solid #fff; min-width: 14px; text-align: center; line-height: 14px;"></span>
            </span>
          <?php else: ?>
            <span style="position:relative; display:inline-block;">
              <a href="<?php echo ($_SESSION['id_user'] != 1 ? 'berichte.php' : '#'); ?>" accesskey="5"><img src="img/x.gif" class="l" title="Reports" alt="Reports"/></a>
              <span id="nav_report_badge" style="display:none; position: absolute; top: -8px; left: -5px; right: auto; background: #ff2828; color: white; border-radius: 50%; padding: 1px 5px; font-size: 11px; font-weight: bold; font-family: Tahoma, Arial, sans-serif; box-shadow: 0 2px 4px rgba(0,0,0,0.4); z-index: 10; pointer-events: none; border: 1.5px solid #fff; min-width: 14px; text-align: center; line-height: 14px;"></span>
            </span>
            <span style="position:relative; display:inline-block;">
              <a href="nachrichten.php" accesskey="6"><img src="img/x.gif" class="r" title="Messages" alt="Messages" /></a>
              <span id="nav_msg_badge" style="display:none; position: absolute; top: -8px; right: -5px; left: auto; background: #ff2828; color: white; border-radius: 50%; padding: 1px 5px; font-size: 11px; font-weight: bold; font-family: Tahoma, Arial, sans-serif; box-shadow: 0 2px 4px rgba(0,0,0,0.4); z-index: 10; pointer-events: none; border: 1.5px solid #fff; min-width: 14px; text-align: center; line-height: 14px;"></span>
            </span>
          <?php endif; ?>
        </div>
        <script>
        (function() {
            function updateNavMsgBadge() {
                var xhr = new XMLHttpRequest();
                xhr.open('GET', 'direct_message_api.php?action=summary&_t=' + new Date().getTime(), true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        try {
                            var data = JSON.parse(xhr.responseText);
                            var badge = document.getElementById('nav_msg_badge');
                            if (data.ok) {
                                var msgUnread = parseInt(data.messages_unread || 0, 10);
                                var notUnread = parseInt(data.notices_unread || 0, 10);
                                
                                if (badge) {
                                    if (msgUnread > 0) {
                                        badge.textContent = msgUnread;
                                        badge.style.display = 'inline-block';
                                    } else {
                                        badge.style.display = 'none';
                                    }
                                }

                                var reportBadge = document.getElementById('nav_report_badge');
                                if (reportBadge) {
                                    if (notUnread > 0) {
                                        reportBadge.textContent = notUnread;
                                        reportBadge.style.display = 'inline-block';
                                    } else {
                                        reportBadge.style.display = 'none';
                                    }
                                }
                                
                                var n5 = document.getElementById('n5');
                                if (n5) {
                                    var cls = 'i4';
                                    if (msgUnread > 0 && notUnread > 0) cls = 'i1';
                                    else if (msgUnread > 0) cls = 'i2';
                                    else if (notUnread > 0) cls = 'i3';
                                    n5.className = cls;
                                }
                            }
                        } catch(e) {}
                    }
                };
                xhr.send();
            }
            updateNavMsgBadge();
            setInterval(updateNavMsgBadge, 3000);
        })();
        </script>
<style>
/* === GLOBAL: Override gpack's "div#mtop a#plus span { display:none }" ===
   Moving #plus inside #mtop triggered the gpack hiding rule.
   This higher-specificity rule (3 IDs) keeps gold visible on ALL screens. */
div#mtop a#plus span#header_gold_display {
    display: inline-flex !important;
    align-items: center !important;
    gap: 3px !important;
}
div#mtop a#plus span#header_gold_display span.gold_amount,
div#mtop a#plus span#header_gold_display span.gold_amount.low {
    display: inline !important;
}

/* === Desktop Gold Display Override ===
   Override gpack's margin-left:115px to place gold on the LEFT.
   Nav circles follow naturally in the middle. */
@media screen and (min-width: 981px) {
    div#mtop a#plus {
        float: left !important;
        margin-left: 120px !important;  /* Brings gold closer to the 5 circles */
        margin-right: 8px !important;
        margin-top: 18px !important;
        display: inline-flex !important;
        align-items: center;
        gap: 4px;
        background: linear-gradient(to bottom, #ffc107, #ff9800);
        border: 1px solid #d87b00;
        border-radius: 5px;
        padding: 2px 8px;
        height: 22px;
        text-decoration: none;
        box-shadow: inset 0 1px 1px rgba(255,255,255,0.5), 0 1px 3px rgba(0,0,0,0.2);
    }
    div#mtop a#plus:hover {
        background: linear-gradient(to bottom, #ffca28, #ffa726);
    }
    div#mtop a#plus span,
    div#mtop a#plus span#header_gold_display {
        display: inline-flex !important;
        align-items: center;
        gap: 3px;
    }
    div#mtop a#plus span#header_gold_display .gold_amount,
    div#mtop a#plus span#header_gold_display .gold_amount.low {
        color: #fff;
        font-size: 12px;
        font-weight: 900;
        text-shadow: 1px 1px 1px rgba(0,0,0,0.3);
    }
    div#mtop a#plus img {
        width: 14px;
        height: 14px;
    }
}

.day_image {
    background-image: url("../gpack/travian_default/img/l/day.gif");
width: 18px;
height:18px;
}
.night_image {
      background-image: url("../gpack/travian_default/img/l/night.gif");
width: 18px;
height:18px;
}
  #day_night_container {
    width: 30px;
    height: 60px;
    position: relative;
  }
  #day_night_wrapper > #day_night_container {
    display: table;
    position: static;
  }
  #day_night_container div {
    position: absolute;
    top: 50%;
  }
  #day_night_container div div {
    position: relative;
    top: -50%;
  }
  #day_night_container > div {
    display: table-cell;
    vertical-align: middle;
    position: static;
  }
</style>
<?php
$hour = date('Hi'); 
if ($hour > 1759 or $hour < 500) {
$day_night_img = 'night_image';
} elseif ($hour > 1200) {
$day_night_img = 'day_image';
} else {
}
?>
<div id="day_night_wrapper" style="position: absolute; top: 10px; <?php echo (defined('LANG') && LANG === 'ar') ? 'left: 20px;' : 'right: 20px;'; ?> z-index: 100;">
  <div id="day_night_container">
 <div><div><p><img src="img/x.gif" style="display: block; margin: 0 auto; vertical-align:middle;" class="<?php echo $day_night_img;?>"  /></p></div></div>
  </div>
</div>
        <div class="clear"></div>
    </div>
</div>
