<?php
//TODO: Reduce this file by a lot, by using arrays
try { @mysqli_query($database->dblink, "ALTER TABLE " . TB_PREFIX . "vdata ADD COLUMN crop_immunity INT(11) UNSIGNED NOT NULL DEFAULT 0"); } catch (\Exception $e) {}
try { @mysqli_query($database->dblink, "ALTER TABLE " . TB_PREFIX . "users ADD COLUMN paid_gold INT(9) NOT NULL DEFAULT 0"); } catch (\Exception $e) {}
// Generate CSRF token for forms on this page
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}
$MyGold = mysqli_query($database->dblink, "SELECT * FROM " . TB_PREFIX . "users WHERE `id`='" . $session->uid . "'") or die(mysqli_error($database->dblink));
$golds = mysqli_fetch_array($MyGold);
?>
<style>
/* Green action buttons for gold features */
.gold-btn {
    display: inline-block;
    background: linear-gradient(135deg, #71D000 0%, #5ab800 50%, #4a9900 100%);
    color: #fff !important;
    border: 1px solid #3d8000;
    border-radius: 4px;
    padding: 3px 14px;
    font-size: 12px;
    font-weight: bold;
    text-decoration: none !important;
    cursor: pointer;
    text-shadow: 0 1px 1px rgba(0,0,0,0.2);
    box-shadow: 0 1px 3px rgba(0,0,0,0.15), inset 0 1px 0 rgba(255,255,255,0.25);
    transition: all 0.2s ease;
    font-family: inherit;
    line-height: 1.4;
}
.gold-btn:hover {
    background: linear-gradient(135deg, #82e800 0%, #6cd400 50%, #5ab800 100%);
    box-shadow: 0 2px 5px rgba(0,0,0,0.2), inset 0 1px 0 rgba(255,255,255,0.3);
    transform: translateY(-1px);
}
.gold-btn.disabled {
    background: linear-gradient(135deg, #999 0%, #777 100%);
    border-color: #666;
    cursor: default;
    opacity: 0.7;
}
.gold-btn.disabled:hover {
    transform: none;
    box-shadow: 0 1px 3px rgba(0,0,0,0.15);
}
/* Ensure button elements also get gold-btn style properly */
button.gold-btn {
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
}
</style>
<?php
include ("Templates/Plus/pmenu.tpl");

$MyGold = mysqli_query($database->dblink, "SELECT * FROM " . TB_PREFIX . "users WHERE `id`='" . $session->uid . "'") or die(mysqli_error($database->dblink));
$golds = mysqli_fetch_array($MyGold);

$today = date("mdHi");

if (mysqli_num_rows($MyGold)) {
    if ($session->gold == 0)
        echo "<p>".((defined('LANG') && LANG === 'ar') ? 'لا تملك ذهباً حالياً.' : 'You currently don\'t own gold.')."</p>";
    else
        echo "<p>".((defined('LANG') && LANG === 'ar') ? 'لديك حالياً <b> '.$session->gold.' </b> ذهب' : 'You currently have <b> '.$session->gold.' </b>  gold')."</p>";
}

if (isset($_GET['nopaid'])) {
    echo '<div style="background-color:rgba(255,0,0,0.1); border:1px solid red; padding:10px; margin-bottom:15px; border-radius:4px; text-align:center;">
        <a href="plus1.php" style="color:red; font-weight:bold; font-size:14px; text-decoration:none;">'.((defined('LANG') && LANG === 'ar') ? 'رصيد الذهب المدفوع منخفض اضغط هنا للشراء' : 'Insufficient paid gold, click here to buy').'</a>
    </div>';
}

if (isset($_GET['success']) && $_GET['success'] == 'protection_removed') {
    echo '<div style="background-color:#ffebeb; border:1px solid #cc0000; padding:10px; margin:10px 0; border-radius:4px; text-align:center;">
        <span style="color:#cc0000; font-weight:bold; font-size:14px;">'.((defined('LANG') && LANG === 'ar') ? 'تم إزالة الحماية بنجاح' : 'Protection has been removed successfully').'</span>
    </div>';
}
?>
<table class="plusFunctions" cellpadding="1" cellspacing="1">
	<thead>
		<tr>
			<th colspan="5"><?php echo (defined('LANG') && LANG === 'ar') ? 'خصائص <font color="#FF6F0F">بلاس</font>' : '<font color="#71D000">P</font><font color="#FF6F0F">l</font><font color="#71D000">u</font><font color="#FF6F0F">s</font> Functions'; ?></th>
		</tr>
		<tr>
			<td></td>

			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'الوصف' : 'Description'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'المدة' : 'Duration'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'الذهب' : 'Gold'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'الإجراء' : 'Action'; ?></td>
		</tr>
	</thead>
	<tbody>

		<tr>
			<td class="man"><a href="#" onClick="return Popup(0,6);"><img
					class="help" src="img/x.gif" alt="" title="" /></a></td>
			<td class="desc"><b><?php echo (defined('LANG') && LANG === 'ar') ? 'حساب <font color="#FF6F0F">بلاس</font>' : '<font color="#71D000">P</font><font color="#FF6F0F">l</font><font color="#71D000">u</font><font color="#FF6F0F">s</font> Account'; ?></b><br /> <span class="run">
<?php
$datetimep = $golds['plus'];
$datetime1 = $golds['b1'];
$datetime2 = $golds['b2'];
$datetime3 = $golds['b3'];
$datetime4 = $golds['b4'];
$datetimeap = $golds['ap'];
$datetimedp = $golds['dp'];

// Retrieve the current date/time
$date2 = strtotime("NOW");

function formatRemainingTime($endTimestamp, $nowTimestamp) {
    $remaining = (int)$endTimestamp - (int)$nowTimestamp;
    if ($remaining <= 0) {
        return '';
    }

    $days = intdiv($remaining, 86400);
    $rem = $remaining % 86400;
    $hours = intdiv($rem, 3600);
    $rem %= 3600;
    $mins = intdiv($rem, 60);
    $secs = $rem % 60;

    $untilStr = date('H:i:s', (int)$endTimestamp);
    $isAr = (defined('LANG') && LANG === 'ar') ? 1 : 0;

    if($isAr) {
        $html = 'المتبقي: <b>'.$days.'</b> أيام <b>'.$hours.'</b> ساعات <b>'.$mins.'</b> دقائق <b>'.$secs.'</b> ثواني (حتى '.$untilStr.')';
    } else {
        $html = 'Remaining: <b>'.$days.'</b> days <b>'.$hours.'</b> hours <b>'.$mins.'</b> mins <b>'.$secs.'</b> secs (until '.$untilStr.')';
    }

    return '<span class="live-plus-timer" data-remaining="'.$remaining.'" data-ar="'.$isAr.'" data-until="'.$untilStr.'">'.$html.'</span>';
}

if ($datetimep == 0) echo ((defined('LANG') && LANG === 'ar') ? 'احصل على بلس' : 'get PLUS')."<br>";
else 
{
    if ($datetimep <= $date2) {
        print ((defined('LANG') && LANG === 'ar') ? 'انتهت ميزة بلس الخاصة بك.' : 'Your PLUS advantage has ended.')."<br>";
        mysqli_query($database->dblink, "UPDATE " . TB_PREFIX . "users set plus = '0' where `id`='" . $session->uid . "'") or die(mysqli_error($database->dblink));
    } else {
        echo "<font color='#B3B3B3' size='1'>" . formatRemainingTime($datetimep, $date2) . "</font>";
    }
}
    ?>
    </span></td>
			<td class="dur"><?php
    
if (PLUS_TIME >= 86400) {
        echo '' . (PLUS_TIME / 86400) . ((defined('LANG') && LANG === 'ar') ? ' أيام' : ' Days');
    } else if (PLUS_TIME < 86400) {
        echo '' . (PLUS_TIME / 3600) . ((defined('LANG') && LANG === 'ar') ? ' ساعات' : ' Hours');
    }
    ?>
            </td>
			<td class="cost"><img src="img/x.gif" class="gold" alt="Gold"
				title="Gold" alt="Gold" title="Gold" />20</td>
			<td class="act">

<?php
    $MyGold = mysqli_query($database->dblink, "SELECT * FROM " . TB_PREFIX . "users WHERE `id`='" . $session->uid . "'") or die(mysqli_error($database->dblink));
    $golds = mysqli_fetch_array($MyGold);
    
if ($session->access != BANNED) {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 19 && $datetimep < $date2) {
            echo '<a href="plus.php?id=8" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '✨ تفعيل' : '✨ Activate').'</a>';
        } elseif ($golds['gold'] > 19 && $datetimep > $date2) {
            echo '<a href="plus.php?id=8" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '🔄 تمديد' : '🔄 Extend').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
} else {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 19 && $datetimep < $date2) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'تفعيل' : 'Activate').'</a>';
        } elseif ($golds['gold'] > 19 && $datetimep > $date2) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'تمديد' : 'Extend').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
}
?>
			</td>
		</tr>

		<tr>
			<td colspan="5" class="empty"></td>

		</tr>
		<tr>
			<td class="man"><a href="#" onClick="return Popup(1,6);"><img
					class="help" src="img/x.gif" alt="" title="" /></a></td>
			<td class="desc">+<b>25</b>% <img class="r1" src="img/x.gif"
				alt="Lumber" title="Lumber" /> <?php echo (defined('LANG') && LANG === 'ar') ? 'الإنتاج: الخشب' : 'Production: Lumber'; ?><br /> <span
				class="run">
<?php

$tl_b1 = $golds['b1'];
if ($tl_b1 >= $date2) {
    echo "<font color='#B3B3B3' size='1'>" . formatRemainingTime($tl_b1, $date2) . "</font> ";
}
?>
&nbsp;    </span>

			</td>
			<td class="dur"><?php

if (PLUS_PRODUCTION >= 86400) {
    echo '' . (PLUS_PRODUCTION / 86400) . ((defined('LANG') && LANG === 'ar') ? ' أيام' : ' Days');
} else if (PLUS_PRODUCTION < 86400) {
    echo '' . (PLUS_PRODUCTION / 3600) . ((defined('LANG') && LANG === 'ar') ? ' ساعات' : ' Hours');
}
?></td>
			<td class="cost"><img src="img/x.gif" class="gold" alt="Gold"
				title="Gold" />5</td>
			<td class="act"><span class="none">

<?php
if ($session->access != BANNED) {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 4 && $tl_b1 < $date2) {
            echo '<a href="plus.php?id=9" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '✨ تفعيل' : '✨ Activate').'</a>';
        } elseif ($golds['gold'] > 4 && $datetime1 > $date2) {
            echo '<a href="plus.php?id=9" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '🔄 تمديد' : '🔄 Extend').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
} else {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 4 && $tl_b1 < $date2) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'تفعيل' : 'Activate').'</a>';
        } elseif ($golds['gold'] > 4 && $datetime1 > $date2) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'تمديد' : 'Extend').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
}
?>
   </td>
		</tr>

		<tr>
			<td class="man"><a href="#" onClick="return Popup(2,6);"><img
					class="help" src="img/x.gif" alt="" title="" /></a></td>

			<td class="desc">+<b>25</b>% <img class="r2" src="img/x.gif"
				alt="Clay" title="Clay" /> <?php echo (defined('LANG') && LANG === 'ar') ? 'الإنتاج: الطين' : 'Production: Clay'; ?><br /> <span class="run">
<?php

$tl_b2 = $golds['b2'];
if ($tl_b2 >= $date2) {
    echo "<font color='#B3B3B3' size='1'>" . formatRemainingTime($tl_b2, $date2) . "</font>";
}
?>
&nbsp;    </span>
			</td>
			<td class="dur"><?php

if (PLUS_PRODUCTION >= 86400) {
    echo '' . (PLUS_PRODUCTION / 86400) . ((defined('LANG') && LANG === 'ar') ? ' أيام' : ' Days');
} else if (PLUS_PRODUCTION < 86400) {
    echo '' . (PLUS_PRODUCTION / 3600) . ((defined('LANG') && LANG === 'ar') ? ' ساعات' : ' Hours');
}
?></td>
			<td class="cost"><img src="img/x.gif" class="gold" alt="Gold"
				title="Gold" />5</td>

			<td class="act">
<?php
if ($session->access != BANNED) {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 4 && $tl_b2 < $date2) {
            echo '<a href="plus.php?id=10" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '✨ تفعيل' : '✨ Activate').'</a>';
        } elseif ($golds['gold'] > 4 && $tl_b2 > $date2) {
            echo '<a href="plus.php?id=10" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '🔄 تمديد' : '🔄 Extend').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
} else {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 4 && $tl_b2 < $date2) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'تفعيل' : 'Activate').'</a>';
        } elseif ($golds['gold'] > 4 && $tl_b2 > $date2) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'تمديد' : 'Extend').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
}
?>
			</td>
		</tr>

		<tr>
			<td class="man"><a href="#" onClick="return Popup(3,6);"><img
					class="help" src="img/x.gif" alt="" title="" /></a></td>
			<td class="desc">+<b>25</b>% <img class="r3" src="img/x.gif"
				alt="Iron" title="Iron" /> <?php echo (defined('LANG') && LANG === 'ar') ? 'الإنتاج: الحديد' : 'Production: Iron'; ?><br /> <span class="run">
<?php

$tl_b3 = $golds['b3'];
if ($tl_b3 >= $date2) {
    echo "<font color='#B3B3B3' size='1'>" . formatRemainingTime($tl_b3, $date2) . "</font>";
}
?>
&nbsp;    </span>
			</td>
			<td class="dur"><?php

if (PLUS_PRODUCTION >= 86400) {
    echo '' . (PLUS_PRODUCTION / 86400) . ((defined('LANG') && LANG === 'ar') ? ' أيام' : ' Days');
} else if (PLUS_PRODUCTION < 86400) {
    echo '' . (PLUS_PRODUCTION / 3600) . ((defined('LANG') && LANG === 'ar') ? ' ساعات' : ' Hours');
}
?></td>
			<td class="cost"><img src="img/x.gif" class="gold" alt="Gold"
				title="Gold" />5</td>
			<td class="act">
<?php
if ($session->access != BANNED) {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 4 && $tl_b3 < $date2) {
            echo '<a href="plus.php?id=11" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '✨ تفعيل' : '✨ Activate').'</a>';
        } elseif ($golds['gold'] > 4 && $tl_b3 > $date2) {
            echo '<a href="plus.php?id=11" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '🔄 تمديد' : '🔄 Extend').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
} else {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 4 && $tl_b3 < $date2) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'تفعيل' : 'Activate').'</a>';
        } elseif ($golds['gold'] > 4 && $tl_b3 > $date2) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'تمديد' : 'Extend').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
}
?>
			</td>
		</tr>

		<tr>

			<td class="man"><a href="#" onClick="return Popup(4,6);"><img
					class="help" src="img/x.gif" alt="" title="" /></a></td>
			<td class="desc">+<b>25</b>% <img class="r4" src="img/x.gif"
				alt="Crop" title="Crop" /> <?php echo (defined('LANG') && LANG === 'ar') ? 'الإنتاج: القمح' : 'Production: Crop'; ?><br /> <span class="run">
<?php

$tl_b4 = $golds['b4'];
if ($tl_b4 >= $date2) {
    echo "<font color='#B3B3B3' size='1'>" . formatRemainingTime($tl_b4, $date2) . "</font>";
}
?>
&nbsp;    </span>
			</td>
			<td class="dur"><?php

if (PLUS_PRODUCTION >= 86400) {
    echo '' . (PLUS_PRODUCTION / 86400) . ((defined('LANG') && LANG === 'ar') ? ' أيام' : ' Days');
} else if (PLUS_PRODUCTION < 86400) {
    echo '' . (PLUS_PRODUCTION / 3600) . ((defined('LANG') && LANG === 'ar') ? ' ساعات' : ' Hours');
}
?></td>
			<td class="cost"><img src="img/x.gif" class="gold" alt="Gold"
				title="Gold" />5</td>
			<td class="act">
<?php
if ($session->access != BANNED) {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 4 && $tl_b4 < $date2) {
            echo '<a href="plus.php?id=12" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '✨ تفعيل' : '✨ Activate').'</a>';
        } elseif ($golds['gold'] > 4 && $tl_b4 > $date2) {
            echo '<a href="plus.php?id=12" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '🔄 تمديد' : '🔄 Extend').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
} else {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 4 && $tl_b4 < $date2) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'تفعيل' : 'Activate').'</a>';
        } elseif ($golds['gold'] > 4 && $tl_b4 > $date2) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'تمديد' : 'Extend').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
}
?>
			</td>
		</tr>

		<!-- ========== 75% CROP REDUCTION (moved here per Hassan) ========== -->
		<tr>
			<td class="man"><a href="#" onClick="return Popup(0,6);"><img class="help" src="img/x.gif" alt="" title="" /></a></td>
			<td class="desc">
				<span style="font-weight: normal;"><?php echo (defined('LANG') && LANG === 'ar') ? '<b><span dir="ltr">-75%</span></b> <img class="r5" src="img/x.gif" alt="Crop Consumption" title="Crop Consumption" /> تقليل استهلاك القمح' : '<b>-75%</b> <img class="r5" src="img/x.gif" alt="Crop Consumption" title="Crop Consumption" /> Crop Consumption Reduction'; ?></span><br />
				<span class="run">
<?php
$cropRedTime = $golds['crop_reduction'];
if ($cropRedTime > $date2) {
    echo "<font color='#B3B3B3' size='1'>" . formatRemainingTime($cropRedTime, $date2) . "</font>";
} else {
    echo (defined('LANG') && LANG === 'ar') ? 'يعمل فقط عندما يكون إنتاج القمح بالسالب' : 'Only works when crop production is negative';
}
?>
				</span>
			</td>
			<td class="dur"><?php echo (defined('LANG') && LANG === 'ar') ? '5 ساعات' : '5 Hours'; ?></td>
			<td class="cost"><img src="img/x.gif" class="gold" alt="Gold" title="Gold" />350</td>
			<td class="act">
<?php
if ($session->access != BANNED) {
    if ($golds['gold'] >= 350) {
        if ($village->getProd("crop") < 0) {
            if ($cropRedTime <= $date2) {
                echo '<a href="plus.php?id=18" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '✨ تفعيل' : '✨ Activate').'</a>';
            } else {
                echo '<a href="plus.php?id=18" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '🔄 تمديد' : '🔄 Extend').'</a>';
            }
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'إنتاج القمح أكثر من 0' : 'Crop production is more than 0').'</span>';
        }
    } else {
        echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
    }
} else {
    echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</a>';
}
?>
			</td>
		</tr>

		<tr>
			<td colspan="5" class="empty"></td>
		</tr>
		<tr>

			<td class="man"><a href="#" onClick="return Popup(7,6);"><img
					class="help" src="img/x.gif" alt="" title="" /></a></td>
			<td class="desc"><?php echo (defined('LANG') && LANG === 'ar') ? 'إكمال أوامر البناء والأبحاث في هذه القرية الآن (لا يعمل مع القصر والسكن).' : 'Complete construction orders and researches in this
				village now (does not work for Palace and Residence).'; ?></td>
			<td class="dur"><?php echo (defined('LANG') && LANG === 'ar') ? 'الآن' : 'now'; ?></td>
			<td class="cost"><img src="img/x.gif" class="gold" alt="Gold"
				title="Gold" />2</td>
			<td class="act">
<?php
if ($session->access != BANNED) {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 1) {
            echo '<a href="plus.php?id=7" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '⚡ إنهاء' : '⚡ Finish').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
} else {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 1) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'إنهاء' : 'Finish').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
}
?>
			</td>
		</tr>

		<tr>
			<td class="man"><a href="#" onClick="return Popup(8,6);"><img
					class="help" src="img/x.gif" alt="" title="" /></a></td>
			<td class="desc"><?php echo (defined('LANG') && LANG === 'ar') ? 'الانتقال الى تاجر المبادلة' : '1:1 Trade with the NPC merchant'; ?></td>
			<td class="dur"><?php echo (defined('LANG') && LANG === 'ar') ? 'الآن' : 'now'; ?></td>
			<td class="cost"><img src="img/x.gif" class="gold" alt="Gold"
				title="Gold" />3</td>

			<td class="act">
<?php
if ($session->access != BANNED) {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 2) {
            echo '<a href="build.php?gid=17&t=3" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '➡️ انتقال' : '➡️ Go').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
} else {
    if (mysqli_num_rows($MyGold)) {
        if ($golds['gold'] > 2) {
            echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'انتقال' : 'Go').'</a>';
        } else {
            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
        }
    }
}
?>
			</td>
		</tr>

	</tbody>
</table>


<table class="plusFunctions" cellpadding="1" cellspacing="1">
		<thead>
			<tr>
				<th colspan="5"><?php echo (defined('LANG') && LANG === 'ar') ? 'خدمات الذهب' : 'Gold Services'; ?></th>
			</tr>
			<tr>
				<td></td>
				<td><?php echo (defined('LANG') && LANG === 'ar') ? 'الوصف' : 'Description'; ?></td>
				<td><?php echo (defined('LANG') && LANG === 'ar') ? 'المدة' : 'Duration'; ?></td>
				<td><?php echo (defined('LANG') && LANG === 'ar') ? 'الذهب' : 'Gold'; ?></td>
				<td><?php echo (defined('LANG') && LANG === 'ar') ? 'الإجراء' : 'Action'; ?></td>
			</tr>
		</thead>
		<tbody>

			<tr>
				<td class="man"><a href="#" onClick="return Popup(0,6);"><img class="help" src="img/x.gif" alt="" title="" /></a></td>
				<td class="desc"><?php echo (defined('LANG') && LANG === 'ar') ? '<b>إنهاء تدريب الجنود فوراً</b><br />إكمال جميع تدريبات القوات في هذه القرية حالاً' : '<b>Finish troop training instantly</b><br />Complete all troop training in this village now'; ?></td>
				<td class="dur"><?php echo (defined('LANG') && LANG === 'ar') ? 'الآن' : 'now'; ?></td>
				<td class="cost"><img src="img/x.gif" class="gold" alt="Gold" title="Gold" />35</td>
				<td class="act">
				<?php
				$MyGold = mysqli_query($database->dblink, "SELECT * FROM " . TB_PREFIX . "users WHERE `id`='" . $session->uid . "'") or die(mysqli_error($database->dblink));
				$golds = mysqli_fetch_array($MyGold);
				$trainingRows = $database->getTraining($village->wid);
				$hasTraining = !empty($trainingRows);
				if ($session->access != BANNED) {
				    if ($golds['gold'] >= 35) {
				        if ($hasTraining) {
				            echo '<a href="plus.php?id=16" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '⚡ إنهاء' : '⚡ Finish').'</a>';
				        } else {
				            echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'لا تدريب' : 'No training').'</span>';
				        }
				    } else {
				        echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
				    }
				} else {
				    echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'إنهاء' : 'Finish').'</a>';
				}
				?>
				</td>
			</tr>

			<tr>
				<td class="man"><a href="#" onClick="return Popup(0,6);"><img class="help" src="img/x.gif" alt="" title="" /></a></td>
				<td class="desc"><?php echo (defined('LANG') && LANG === 'ar') ? '<b>وصول التعزيزات فوراً</b><br />عودة جميع القوات إلى هذه القرية حالاً (لا يعمل مع المنجنيقات ومحطمات الأبواب والزعماء)' : '<b>Instant reinforcement arrival</b><br />Return all troops to this village now (does not work with catapults, battering rams and chiefs)'; ?></td>
				<td class="dur"><?php echo (defined('LANG') && LANG === 'ar') ? 'الآن' : 'now'; ?></td>
				<td class="cost"><img src="img/x.gif" class="gold" alt="Gold" title="Gold" />35</td>
				<td class="act">
				<?php
				$MyGold = mysqli_query($database->dblink, "SELECT * FROM " . TB_PREFIX . "users WHERE `id`='" . $session->uid . "'") or die(mysqli_error($database->dblink));
				$golds = mysqli_fetch_array($MyGold);
				if ($session->access != BANNED) {
				    if ($golds['gold'] >= 35) {
				        echo '<a href="plus.php?id=17" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '🚀 تعجيل' : '🚀 Speed up').'</a>';
				    } else {
				        echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
				    }
				} else {
				    echo '<a href="banned.php" class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'تعجيل' : 'Speed up').'</a>';
				}
				?>
				</td>
			</tr>

			<!-- ========== BUY RESOURCES WITH GOLD ========== -->
			<tr>
				<td colspan="5" class="empty"></td>
			</tr>
<?php
// Gather village storage data for the Fill Storage calculator
$_villageData = $database->getVillage($village->wid);
$_curWood = (int)$_villageData['wood'];
$_curClay = (int)$_villageData['clay'];
$_curIron = (int)$_villageData['iron'];
$_curCrop = (int)$_villageData['crop'];
$_maxStore = (int)$_villageData['maxstore'];
$_maxCrop  = (int)$_villageData['maxcrop'];
$_playerGold = (int)$golds['gold'];
?>
			<tr>
				<td class="man"><a href="#" onClick="return Popup(0,6);"><img class="help" src="img/x.gif" alt="" title="" /></a></td>
				<td class="desc">
					<b><?php echo (defined('LANG') && LANG === 'ar') ? 'شراء الموارد' : 'Buy Resources'; ?></b><br />
					<span class="run">
						<?php echo (defined('LANG') && LANG === 'ar') ? 'كل 1 ذهب = 20,000 من كل مورد. لا يعمل بالذهب المجاني.' : 'Each 1 gold = 20,000 of each resource. Does not work with free gold.'; ?>
					</span>
				</td>
				<td class="dur">
					<form method="POST" action="plus.php?id=19" id="buyResourcesForm" style="display:inline;">
						<input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($_SESSION['csrf_token']); ?>" />
						<label><?php echo (defined('LANG') && LANG === 'ar') ? 'كمية الذهب:' : 'Gold:'; ?></label>
						<input type="number" name="gold_amount" id="goldAmountInput" min="1" max="<?php echo $_playerGold; ?>" value="1" style="width:50px; text-align:center;" 
							onchange="updateResourcePreview(this.value)" oninput="updateResourcePreview(this.value)" />
						<button type="button" id="fillStorageBtn" onclick="fillStorageCalc()" class="gold-btn" style="font-size:10px; padding:2px 8px;">
							<?php echo (defined('LANG') && LANG === 'ar') ? '🏪 ملئ المخزن' : '🏪 Fill Storage'; ?>
						</button>
						<div id="resourcePreview" style="color:#B3B3B3; font-size:11px; margin:3px 0;">
							(<?php echo (defined('LANG') && LANG === 'ar') ? 'الموارد: 20,000 لكل نوع' : 'Resources: 20,000 each type'; ?>)
						</div>
						<div id="fillBreakdown" style="display:none; background:rgba(0,0,0,0.03); border:1px solid #ddd; border-radius:4px; padding:6px 10px; margin:5px 0; font-size:11px; line-height:1.7;">
						</div>
					</form>
				</td>
				<td class="cost"><img src="img/x.gif" class="gold" alt="Gold" title="Gold" /><?php echo (defined('LANG') && LANG === 'ar') ? 'متغير' : 'varies'; ?></td>
				<td class="act">
<?php
if ($session->access != BANNED) {
    echo '<button type="submit" name="buy_resources" form="buyResourcesForm" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '💰 شراء' : '💰 Buy').'</button>';
}
?>
				</td>
			</tr>
			<tr style="display:none;"><!-- hidden row for script only -->
				<td colspan="5">
					<script>
					var _RATE = 20000;
					var _curRes = {
						wood: <?php echo $_curWood; ?>,
						clay: <?php echo $_curClay; ?>,
						iron: <?php echo $_curIron; ?>,
						crop: <?php echo $_curCrop; ?>
					};
					var _maxStore = <?php echo $_maxStore; ?>;
					var _maxCrop  = <?php echo $_maxCrop; ?>;
					var _playerGold = <?php echo $_playerGold; ?>;
					var _isAr = <?php echo (defined('LANG') && LANG === 'ar') ? 'true' : 'false'; ?>;

					function updateResourcePreview(val) {
						var amount = parseInt(val) || 0;
						var total = amount * _RATE;
						var fmtTotal = total.toLocaleString();
						var addWood = Math.min(total, _maxStore - _curRes.wood); addWood = Math.max(0, addWood);
						var addClay = Math.min(total, _maxStore - _curRes.clay); addClay = Math.max(0, addClay);
						var addIron = Math.min(total, _maxStore - _curRes.iron); addIron = Math.max(0, addIron);
						var addCrop = Math.min(total, _maxCrop  - _curRes.crop); addCrop = Math.max(0, addCrop);

						var html = _isAr
							? '(الموارد: ' + fmtTotal + ' لكل نوع)'
							: '(Resources: ' + fmtTotal + ' each type)';
						document.getElementById('resourcePreview').innerHTML = html;

						var bd = document.getElementById('fillBreakdown');
						if (amount > 0) {
							bd.style.display = 'block';
							bd.innerHTML = (_isAr ? '🪵 خشب' : '🪵 Wood') + ': ' + _curRes.wood.toLocaleString() + ' ← <b style="color:#060">' + (_curRes.wood + addWood).toLocaleString() + '</b> / ' + _maxStore.toLocaleString() + '<br>'
								+ (_isAr ? '🧱 طين' : '🧱 Clay') + ': ' + _curRes.clay.toLocaleString() + ' ← <b style="color:#960">' + (_curRes.clay + addClay).toLocaleString() + '</b> / ' + _maxStore.toLocaleString() + '<br>'
								+ (_isAr ? '⚙️ حديد' : '⚙️ Iron') + ': ' + _curRes.iron.toLocaleString() + ' ← <b style="color:#666">' + (_curRes.iron + addIron).toLocaleString() + '</b> / ' + _maxStore.toLocaleString() + '<br>'
								+ (_isAr ? '🌾 قمح' : '🌾 Crop') + ': ' + _curRes.crop.toLocaleString() + ' ← <b style="color:#C90">' + (_curRes.crop + addCrop).toLocaleString() + '</b> / ' + _maxCrop.toLocaleString();
						} else {
							bd.style.display = 'none';
						}
					}

					function fillStorageCalc() {
						var spaceWood = Math.max(0, _maxStore - _curRes.wood);
						var spaceClay = Math.max(0, _maxStore - _curRes.clay);
						var spaceIron = Math.max(0, _maxStore - _curRes.iron);
						var spaceCrop = Math.max(0, _maxCrop  - _curRes.crop);

						var minSpace = Math.min(spaceWood, spaceClay, spaceIron, spaceCrop);

						var limitRes = '';
						if (minSpace === spaceWood) limitRes = _isAr ? 'الخشب' : 'Wood';
						else if (minSpace === spaceClay) limitRes = _isAr ? 'الطين' : 'Clay';
						else if (minSpace === spaceIron) limitRes = _isAr ? 'الحديد' : 'Iron';
						else limitRes = _isAr ? 'القمح' : 'Crop';

						if (Math.floor(minSpace / _RATE) === 0) {
							var goldNeeded = 0;
							var input = document.getElementById('goldAmountInput');
							input.value = "0";
							updateResourcePreview(0);
							var bd = document.getElementById('fillBreakdown');
							bd.style.display = 'block';
							bd.innerHTML += '<br><span style="color:#D4A017; font-weight:bold;">⚡ '
								+ (_isAr ? 'المساحة المتبقية لـ ' + limitRes + ' غير كافية لعملية شراء واحدة' : 'Remaining storage for ' + limitRes + ' is insufficient for a single gold purchase')
								+ '</span>';
							return;
						}

						var goldNeeded = Math.floor(minSpace / _RATE);
						goldNeeded = Math.min(goldNeeded, _playerGold);

						var input = document.getElementById('goldAmountInput');
						input.value = goldNeeded;
						updateResourcePreview(goldNeeded);

						var note = '<br><span style="color:#D4A017; font-weight:bold;">⚡ '
							+ (_isAr ? 'المحدد: ' + limitRes + ' (سيمتلئ أولاً)' : 'Limiting: ' + limitRes + ' (fills first)')
							+ '</span>';
						document.getElementById('fillBreakdown').innerHTML += note;
					}
					</script>
				</td>
			</tr>

			<!-- ========== CROP REFILL & NEGATIVE PROTECT ========== -->
			<tr>
				<td colspan="5" class="empty"></td>
			</tr>
			<tr>
				<td class="man"><a href="#"><img class="help" src="img/x.gif" alt="" title="" /></a></td>
				<td class="desc">
					<b><?php echo (defined('LANG') && LANG === 'ar') ? 'تعبئة مخازن الحبوب ومنع السالب' : 'Crop Refill & Protect (1 hr)'; ?></b><br/>
					<span><?php echo (defined('LANG') && LANG === 'ar') ? 'يملأ مخازن الحبوب للحد الأقصى ويمنعها من النزول تحت 1,500' : 'Refills crop to max and prevents it from going below 1500.'; ?></span><br/>
                    <span class="run">
<?php
// Display remaining time if active
$village_id = $village->wid;
$res = mysqli_query($database->dblink, "SELECT crop_immunity FROM " . TB_PREFIX . "vdata WHERE wref = $village_id");
if ($res) {
    if ($row = mysqli_fetch_assoc($res)) {
        if (isset($row['crop_immunity']) && $row['crop_immunity'] >= $date2) {
            echo "<font color='#B3B3B3' size='1'>" . formatRemainingTime($row['crop_immunity'], $date2) . "</font>";
        }
    }
}
?>
                    </span>
				</td>
				<td class="dur">1 <?php echo (defined('LANG') && LANG === 'ar') ? 'ساعة' : 'Hour'; ?></td>
				<td class="cost"><img src="img/x.gif" class="gold" alt="Gold" title="Gold" />10,000</td>
				<td class="act">
					<form method="POST" action="plus.php?id=21" style="display:inline;">
						<input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($_SESSION['csrf_token']); ?>" />
<?php 
if ($session->access != BANNED) {
    if ($village->getProd("crop") < 0) {
        echo '<button type="submit" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? 'تفعيل' : 'Activate').'</button>';
    } else {
        echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'مخزن الحبوب اكثر من 0' : 'Crop storage is more than 0').'</span>';
    }
}
?>
					</form>
				</td>
			</tr>

			<!-- ========== 24-HOUR GOLD PROTECTION ========== -->
			<tr>
				<td colspan="5" class="empty"></td>
			</tr>
			<tr>
				<td class="man"><a href="#" onClick="return Popup(0,6);"><img class="help" src="img/x.gif" alt="" title="" /></a></td>
				<td class="desc">
<?php
$protectTime = $golds['gold_protect'];
$protectCount = (int)$golds['gold_protect_count'];
$protectCost = 1000 * pow(2, $protectCount);
$isProtected = ($protectTime > $date2) || $database->hasBeginnerProtection($village->wid);
?>
					<b><?php echo (defined('LANG') && LANG === 'ar') ? 'تفعيل الحماية 24 ساعة' : '24-Hour Gold Protection'; ?></b><br />
					<span class="run">
<?php
if ($isProtected) {
    echo "<font color='#71D000'>" . ((defined('LANG') && LANG === 'ar') ? '✅ الحماية مفعلة - ' : '✅ Protection Active - ') . "</font>";
    echo "<font color='#B3B3B3' size='1'>" . formatRemainingTime($protectTime, $date2) . "</font>";
} else {
    echo (defined('LANG') && LANG === 'ar') 
        ? 'يتطلب كلمة سر الحساب. لا يشمل القرى التي فيها تحفة أثرية. التكلفة تتضاعف في كل مرة.' 
        : 'Requires account password. Does not include villages with artifacts. Cost doubles each activation.';
}
?>
					</span>
<?php if (!$isProtected): ?>
					<br /><br />
					<?php if (isset($_GET['error']) && $_GET['error'] == 'password'): ?>
						<span style="color:red; font-weight:bold;"><?php echo (defined('LANG') && LANG === 'ar') ? '❌ كلمة السر غير صحيحة!' : '❌ Incorrect password!'; ?></span><br />
					<?php endif; ?>
					<form method="POST" action="plus.php?id=20" id="protectForm" style="display:inline;">
						<input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($_SESSION['csrf_token']); ?>" />
						<label><?php echo (defined('LANG') && LANG === 'ar') ? 'كلمة السر:' : 'Password:'; ?></label>
						<input type="password" name="password" required style="width:120px;" />
						<br />
						<span style="color:#B3B3B3; font-size:11px;">
							<?php echo (defined('LANG') && LANG === 'ar') 
								? 'التكلفة: ' . number_format($protectCost) . ' ذهب (المرة رقم ' . ($protectCount + 1) . ')' 
								: 'Cost: ' . number_format($protectCost) . ' gold (activation #' . ($protectCount + 1) . ')'; ?>
						</span>
					</form>
<?php else: ?>
					<br /><br />
					<?php if (isset($_GET['error']) && $_GET['error'] == 'password_remove'): ?>
						<span style="color:red; font-weight:bold;"><?php echo (defined('LANG') && LANG === 'ar') ? '❌ كلمة السر غير صحيحة!' : '❌ Incorrect password!'; ?></span><br />
					<?php endif; ?>
					<form method="POST" action="plus.php?id=20" id="removeProtectForm" style="display:inline;">
						<input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($_SESSION['csrf_token']); ?>" />
						<label style="color:#cc0000; font-weight:bold;"><?php echo (defined('LANG') && LANG === 'ar') ? 'كلمة السر لإزالة الحماية:' : 'Password to remove:'; ?></label>
						<input type="password" name="password" required style="width:120px;" />
						<input type="hidden" name="remove_protection" value="1" />
					</form>
<?php endif; ?>
				</td>
				<td class="dur"><?php echo (defined('LANG') && LANG === 'ar') ? '24 ساعة' : '24 Hours'; ?></td>
				<td class="cost">
				<?php if ($isProtected): ?>
					<span style="color:green; font-weight:bold;"><?php echo (defined('LANG') && LANG === 'ar') ? 'مجاناً' : 'Free'; ?></span>
				<?php else: ?>
					<img src="img/x.gif" class="gold" alt="Gold" title="Gold" /><?php echo number_format($protectCost); ?>
				<?php endif; ?>
				</td>
				<td class="act">
<?php
if (!$isProtected) {
    if ($session->access != BANNED && $golds['gold'] >= $protectCost) {
        echo '<button type="submit" name="activate_protection" form="protectForm" class="gold-btn">'.((defined('LANG') && LANG === 'ar') ? '🛡️ تفعيل' : '🛡️ Activate').'</button>';
    } else {
        echo '<span class="gold-btn disabled">'.((defined('LANG') && LANG === 'ar') ? 'ذهب غير كافي' : 'too little gold').'</span>';
    }
} else {
    echo '<button type="submit" form="removeProtectForm" class="gold-btn" style="background:#cc0000; color:white; border-color:#990000;">'.((defined('LANG') && LANG === 'ar') ? '❌ إزالة' : '❌ Remove').'</button>';
}
?>
				</td>
			</tr>

		</tbody>
	</table>
</div>

<script>
setInterval(function() {
    var timers = document.querySelectorAll('.live-plus-timer');
    timers.forEach(function(el) {
        var remaining = parseInt(el.getAttribute('data-remaining'));
        if (remaining <= 0) return;
        remaining--;
        el.setAttribute('data-remaining', remaining);
        
        var isAr = el.getAttribute('data-ar') === '1';
        var d = Math.floor(remaining / 86400);
        var r = remaining % 86400;
        var h = Math.floor(r / 3600);
        r %= 3600;
        var m = Math.floor(r / 60);
        var s = r % 60;
        
        var untilStr = el.getAttribute('data-until');
        
        if (remaining <= 0) {
            el.innerHTML = isAr ? 'انتهت المدة' : 'Expired';
        } else {
            var html = isAr 
                ? 'المتبقي: <b>'+d+'</b> أيام <b>'+h+'</b> ساعات <b>'+m+'</b> دقائق <b>'+s+'</b> ثواني (حتى '+untilStr+')'
                : 'Remaining: <b>'+d+'</b> days <b>'+h+'</b> hours <b>'+m+'</b> mins <b>'+s+'</b> secs (until '+untilStr+')';
            el.innerHTML = html;
        }
    });
}, 1000);
</script>
