<?php
include_once("GameEngine/Generator.php");
$start_timer = $generator->pageLoadTimeStart();

/** --------------------------------------------------- **\
| ********* DO NOT REMOVE THIS COPYRIGHT NOTICE ********* |
+---------------------------------------------------------+
| Credits:     All the developers including the leaders:  |
|              Advocaite & Dzoki & Donnchadh              |
|                                                         |
| Copyright:   TravianZ Project All rights reserved       |
\** --------------------------------------------------- **/

?><?php
if(!$session->logged_in) {
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
    <title></title>
    <style type="text/css">
div.c1 {text-align: center}
    </style>
</head>

<body>
    <div id="side_navi">
        <a id="logo" href="<?php echo HOMEPAGE; ?>" name="logo"><img src="img/x.gif" alt="Travian"></a>

        <p><a href="<?php echo HOMEPAGE; ?>"><?php echo HOME; ?></a> <a href="login.php"><?php echo LOGIN; ?></a> <a href="anmelden.php"><?php echo REG; ?></a></p>
    </div><?php
    }
    else {
    ?>

    <div id="side_navi">
        <a id="logo" href="<?php echo HOMEPAGE; ?>" name="logo"><img src="img/x.gif" <?php if($session->plus) { echo "class=\"logo_plus\""; } ?> alt="Travian"></a>

        <p>
        <a href="<?php echo HOMEPAGE; ?>"><?php echo HOME; ?></a>
        <a href="#" onclick="return Popup(0,0,1);"><?php echo INSTRUCT; ?></a>
        <a href="spieler.php?uid=<?php echo $session->uid; ?>"><?php echo PROFILE; ?></a>
        <?php if($session->access == MULTIHUNTER) {
            echo "<a href=\"Admin/admin.php\"><font color=\"Blue\">".MH_PANEL."</font></a>";
        } ?>
        <?php if($session->access == ADMIN) {
            echo "<a href=\"Admin/admin.php\"><font color=\"Red\">".ADMIN_PANEL."</font></a>";
            echo "<a href=\"sysmsg.php\">".SYSTEM_MESSAGE."</a>";
        } ?>
        <a href="nachrichten.php?t=5" id="public_chat_link"><?php echo MASS_MESSAGE; ?> <span id="public_chat_badge" style="display:none; background:#ff2828; color:#fff; border-radius:8px; padding:0 5px; font-size:10px; font-weight:bold; font-family:Tahoma,Arial,sans-serif; line-height:16px;"></span></a>
        <a href="logout.php"><?php echo LOGOUT;?></a>
        <script>
        (function(){
            var STORAGE_KEY = 'public_chat_last_seen';
            // If we're on the chat page right now, update the timestamp
            if (window.location.href.indexOf('chat.php') !== -1 || (window.location.href.indexOf('nachrichten.php') !== -1 && window.location.href.indexOf('t=5') !== -1)) {
                sessionStorage.setItem(STORAGE_KEY, Math.floor(Date.now()/1000));
            }
            function pollChatBadge() {
                var since = sessionStorage.getItem(STORAGE_KEY) || '0';
                var xhr = new XMLHttpRequest();
                xhr.open('GET', 'chat_api.php?action=unread&since=' + since + '&_t=' + Date.now(), true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        try {
                            var data = JSON.parse(xhr.responseText);
                            var badge = document.getElementById('public_chat_badge');
                            if (badge && data.ok) {
                                var c = parseInt(data.count || 0, 10);
                                if (c > 0) {
                                    badge.textContent = c > 99 ? '99+' : c;
                                    badge.style.display = 'inline-block';
                                } else {
                                    badge.style.display = 'none';
                                }
                            }
                        } catch(e){}
                    }
                };
                xhr.send();
            }
            pollChatBadge();
            setInterval(pollChatBadge, 5000);
        })();
        </script>
        </p>
        <p>
        <?php
        // no PLUS needed for Support
        if ($_SESSION['id_user'] != 1) {
        ?>
        <a href="plus.php?id=3"><?php echo TRAVIAN_PLUS; ?></a>
        <?php
        }
        // no support for support :-D
        if ($_SESSION['id_user'] != 1) {
        ?>
        <a href="spieler.php?uid=1"><?php echo SUPPORT;?></a>
        <?php
        }
        ?>
        </p>
    </div><?php /* close #side_navi */
        if(NEW_FUNCTIONS_DISPLAY_LINKS) include("Templates/links.tpl");
        include("Templates/natars.tpl");

        $timestamp = $database->isDeleting($session->uid);
        if($timestamp){
            echo "<div class=\"delete-timer\" style=\"text-align:center;padding:5px;font-size:12px;\">";
            if($timestamp > time() + 172800){
                echo "<a href=\"spieler.php?s=3&id=" . $session->uid . "&a=1&e=4\"><img class=\"del\" src=\"img/x.gif\" alt=\"Cancel process\" title=\"Cancel process\" /> </a>";
            }
            $time = $generator->getTimeFormat(($timestamp - time()));
            echo "<a href=\"spieler.php?s=3\"> The account will be deleted in <span id=\"timer" . ++$session->timer . "\">" . $time . "</span> .</a>";
            echo "</div>";
        }
    ?><?php
    if($_SESSION['ok'] == 1){
    ?>

    <div id="content" class="village1">
        <h1><?php echo ANNOUNCEMENT; ?></h1>
		<br />
<h3 style="font-size:22px; font-weight:bold;">
مرحبًا بك أيها القائد
<span style="color:#159447;">
<?php echo $session->username; ?>
</span>
</h3>
        <?php include("Templates/text.tpl"); ?>
        <div class="c1">
		<br />
            <h3><a href="dorf1.php?ok">&raquo; <?php echo GO2MY_VILLAGE; ?></a></h3>
        </div>
    </div>

    <br /><br /><br /><br /><div id="side_info">
        <?php 
        include("Templates/multivillage.tpl");
        include("Templates/quest.tpl");
        include("Templates/news.tpl");
		if(!NEW_FUNCTIONS_DISPLAY_LINKS) {
			echo "<br><br><br><br>";
			include("Templates/links.tpl");
		}
        ?>
    </div>

    <div class="clear"></div>

    <div class="footer-stopper"></div>

    <div class="clear"></div><?php
    include("Templates/footer.tpl");
    include("Templates/res.tpl");
    ?>

    <div id="stime">
        <div id="ltime">
            <div id="ltimeWrap">
                <?php echo CALCULATED_IN;?> <b><?php
echo round(($generator->pageLoadTimeEnd()-$start_timer)*1000);
?></b> ms

<br /><?php echo SERVER_TIME;?> <span id="tp1" class="b"><?php echo date('H:i:s'); ?></span>
            </div>
        </div>
    </div>

    <div id="ce"></div><?php
    die();
    }
    }
    ?>
</body>
</html>
