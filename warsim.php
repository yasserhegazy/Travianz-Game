<?php
include_once("GameEngine/Generator.php");
$start_timer = $generator->pageLoadTimeStart();

#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Filename       warsim.php                                                  ##
##  Developed by:  Dzoki                                                       ##
##  License:       TravianX Project                                            ##
##  Copyright:     TravianX (c) 2010-2011. All rights reserved.                ##
##                                                                             ##
#################################################################################

use App\Utils\AccessLogger;

include_once("GameEngine/Village.php");
AccessLogger::logRequest();

$battle->procSim($_POST);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html<?php echo (defined('LANG') && LANG === 'ar') ? ' dir="rtl"' : ''; ?>>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><?php echo SERVER_NAME ?> - <?php echo (defined('LANG') && LANG === 'ar') ? 'محاكي المعارك' : 'Combat Simulator'; ?></title>
	<link rel="shortcut icon" href="favicon.ico"/>
	<meta http-equiv="cache-control" content="max-age=0" />
	<meta http-equiv="pragma" content="no-cache" />
	<meta http-equiv="expires" content="0" />
	<meta http-equiv="imagetoolbar" content="no" />
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<script src="mt-full.js?0faab" type="text/javascript"></script>
	<script src="unx.js?g5c8m" type="text/javascript"></script>
	<script src="new.js?0faab" type="text/javascript"></script>
	<link href="<?php echo GP_LOCATE; ?>lang/<?php echo LANG; ?>/lang.css?f4b7d" rel="stylesheet" type="text/css" />
	<link href="<?php echo GP_LOCATE; ?>lang/<?php echo LANG; ?>/compact.css?v2" rel="stylesheet" type="text/css" />
	<?php
	if($session->gpack == null || GP_ENABLE == false) {
	echo "
	<link href='".GP_LOCATE."travian.css?v2' rel='stylesheet' type='text/css' />
	<link href='".GP_LOCATE."lang/".LANG."/lang.css?v2' rel='stylesheet' type='text/css' />";
	} else {
	echo "
	<link href='".$session->gpack."travian.css?v2' rel='stylesheet' type='text/css' />
	<link href='".$session->gpack."lang/".LANG."/lang.css?v2' rel='stylesheet' type='text/css' />";
	}
	?>
	<script type="text/javascript">

		window.addEvent('domready', start);
	</script>

	<?php if(defined('LANG') && LANG === 'ar'): ?>
	
	<?php endif; ?>
	<link rel="stylesheet" type="text/css" href="mobile.css?v=47" />
</head>


<body class="v35 ie ie8">
<script>if('scrollRestoration'in history)history.scrollRestoration='manual';window.scrollTo(0,0);window.addEventListener('load',function(){window.scrollTo(0,0);setTimeout(function(){window.scrollTo(0,0)},0);setTimeout(function(){window.scrollTo(0,0)},50);setTimeout(function(){window.scrollTo(0,0)},100);setTimeout(function(){window.scrollTo(0,0)},200)});</script>
<div class="wrapper">
<img style="filter:chroma();" src="img/x.gif" id="msfilter" alt="" />
<div id="dynamic_header">
	</div>
<?php include("Templates/header.tpl"); ?>
<div id="mid">
<?php include("Templates/menu.tpl"); ?>
<div id="content"  class="warsim">
<h1><?php echo (defined('LANG') && LANG === 'ar') ? 'محاكي المعارك' : 'Combat simulator'; ?></h1>
<form action="warsim.php" method="post">
<?php
if(isset($_POST['result'])) {
	$target = isset($_POST['target'])? $_POST['target'] : array();
	$tribe = isset($_POST['mytribe'])? $_POST['mytribe'] : $session->tribe;
	include("Templates/Simulator/res_a".$tribe.".tpl");
    foreach($target as $tar) {
        include("Templates/Simulator/res_d".$tar.".tpl");
    }
    echo "<p>".((defined('LANG') && LANG === 'ar') ? 'نوع الهجوم:' : 'Type of attack:')." <b>";
    echo $form->getValue('ktyp') == 0 ? ((defined('LANG') && LANG === 'ar') ? 'عادي' : 'Normal') : ((defined('LANG') && LANG === 'ar') ? 'للنهب' : 'Raid');
    echo "</b></p>";
    echo "<p>";
    if (isset($_POST['result'][7]) && isset($_POST['result'][8])){
        if ($form->getValue('ktyp') == 1) {
            echo ((defined('LANG') && LANG === 'ar') ? "تلميح: محطمة الأبواب لا تعمل في نمط الهجوم للنهب.<br>" : "Hint: The ram does not work during a raid.<br>");
        }elseif ($_POST['result'][7] == 0){
            echo ((defined('LANG') && LANG === 'ar') ? "الضرر الناتج عن محطمة الأبواب: من مستوى <b>" : "Damage done by ram: from level <b>").$form->getValue('walllevel').((defined('LANG') && LANG === 'ar') ? "</b> إلى مستوى <b>0</b></p>" : "</b> to level <b>0</b></p>");
        }elseif ($_POST['result'][7] == $_POST['result'][8]){
            echo ((defined('LANG') && LANG === 'ar') ? "الضرر الناتج عن محطمة الأبواب: من مستوى <b>" : "Damage done by ram: from level <b>").$form->getValue('walllevel').((defined('LANG') && LANG === 'ar') ? "</b> إلى مستوى <b>" : "</b> to level <b>").$form->getValue('walllevel')."</b></p>";
        }else{
            echo ((defined('LANG') && LANG === 'ar') ? "الضرر الناتج عن محطمة الأبواب: من مستوى <b>" : "Damage done by ram: from level <b>").$form->getValue('walllevel').((defined('LANG') && LANG === 'ar') ? "</b> إلى مستوى <b>" : "</b> to level <b>").$_POST['result'][7]."</b></p>";
        }
    }

    if (isset($_POST['result'][3]) && isset($_POST['result'][4])){
        if ($form->getValue('ktyp') == 1) {
            echo ((defined('LANG') && LANG === 'ar') ? "تلميح: المقلاع لا يطلق المتفجرات في نمط الهجوم للنهب.</p>" : "Hint: The catapult does not shoot during a raid.</p>");
        }elseif ($_POST['result'][3] == 0){
            echo ((defined('LANG') && LANG === 'ar') ? "الضرر الناتج عن المقلاع: من مستوى <b>" : "Damage done by catapult: from level <b>").$form->getValue('kata').((defined('LANG') && LANG === 'ar') ? "</b> إلى مستوى <b>0</b></p>" : "</b> to level <b>0</b></p>");
        }elseif ($_POST['result'][3] == $_POST['result'][4]){
            echo ((defined('LANG') && LANG === 'ar') ? "الضرر الناتج عن المقلاع: من مستوى <b>" : "Damage done by catapult: from level <b>").$form->getValue('kata').((defined('LANG') && LANG === 'ar') ? "</b> إلى مستوى <b>" : "</b> to level <b>").$form->getValue('kata')."</b></p></p>";
        }else{
            echo ((defined('LANG') && LANG === 'ar') ? "الضرر الناتج عن المقلاع: من مستوى <b>" : "Damage done by catapult: from level <b>").$form->getValue('kata').((defined('LANG') && LANG === 'ar') ? "</b> إلى مستوى <b>" : "</b> to level <b>").$_POST['result'][7]."</b></p>";
        }
    }
}

if (!empty($_GET['target'])) {
    // this only works for Nature, as GET links like this one will come from an oasis
    if (!$_GET['target'] != 4) {
        $_GET['target'] = 4;
    }

    // fill-in session value-array data
    foreach ($_GET as $key => $value) {
        if ($key[0] === 'u' && is_numeric($value)) {
            $form->setValue('a2_' . substr($key, 1), $value);
        }
    }


}

$target = isset($_POST['target'])? $_POST['target'] : (!empty($_GET['target']) ? array((int) $_GET['target']) : array());
$tribe = isset($_POST['mytribe'])? $_POST['mytribe'] : $session->tribe;
if(count($target) > 0) {
	include("Templates/Simulator/att_".preg_replace("/[^a-zA-Z0-9_-]/","",$tribe).".tpl");
	echo "<table id=\"defender\" class=\"fill_in\" cellpadding=\"1\" cellspacing=\"1\">

	<thead>
		<tr>
			<th>
				".((defined('LANG') && LANG === 'ar') ? 'المدافع' : 'Defender')." <span class=\"small\"></span>
			</th>
		</tr>
	</thead>";
	foreach($target as $tar) {
		include("Templates/Simulator/def_".$tar.".tpl");
	}
	include("Templates/Simulator/def_end.tpl");
	echo "<div class=\"clear\"></div>";
}
?>
<table id="select" cellpadding="1" cellspacing="1">
<thead><tr>
	<td><?php echo (defined('LANG') && LANG === 'ar') ? 'المهاجم' : 'Attacker'; ?></td>
	<td><?php echo (defined('LANG') && LANG === 'ar') ? 'المدافع' : 'Defender'; ?></td>
	<td><?php echo (defined('LANG') && LANG === 'ar') ? 'نوع الهجوم' : 'Type of attack'; ?></td>
</tr></thead>
<tbody><tr>
	<td>
		<label><input class="radio" type="radio" name="a1_v" value="1" <?php if($tribe == 1) { echo "checked"; } ?>/> <?php echo (defined('LANG') && LANG === 'ar') ? 'الرومان' : 'Romans'; ?></label><br/>
		<label><input class="radio" type="radio" name="a1_v" value="2" <?php if($tribe == 2) { echo "checked"; } ?>/> <?php echo (defined('LANG') && LANG === 'ar') ? 'الجرمان' : 'Teutons'; ?></label><br/>
		<label><input class="radio" type="radio" name="a1_v" value="3" <?php if($tribe == 3) { echo "checked"; } ?>/> <?php echo (defined('LANG') && LANG === 'ar') ? 'الإغريق' : 'Gauls'; ?></label><br/>
		<label><input class="radio" type="radio" name="a1_v" value="5" <?php if($tribe == 3) { echo "checked"; } ?>/> <?php echo (defined('LANG') && LANG === 'ar') ? 'التتار' : 'Natars'; ?></label>
	</td><td>
		<label><input class="check" type="checkbox" name="a2_v1" value="1" <?php if(in_array(1,$target)) { echo "checked"; } ?>/> <?php echo (defined('LANG') && LANG === 'ar') ? 'الرومان' : 'Romans'; ?></label><br/>
		<label><input class="check" type="checkbox" name="a2_v2" value="1" <?php if(in_array(2,$target)) { echo "checked"; } ?>/> <?php echo (defined('LANG') && LANG === 'ar') ? 'الجرمان' : 'Teutons'; ?></label><br/>
		<label><input class="check" type="checkbox" name="a2_v3" value="1" <?php if(in_array(3,$target)) { echo "checked"; } ?>/> <?php echo (defined('LANG') && LANG === 'ar') ? 'الإغريق' : 'Gauls'; ?></label><br/>
		<label><input class="check" type="checkbox" name="a2_v4" value="1" <?php if(in_array(4,$target)) { echo "checked"; } ?>/> <?php echo (defined('LANG') && LANG === 'ar') ? 'الطبيعة' : 'Nature'; ?></label><br/>
		<label><input class="check" type="checkbox" name="a2_v5" value="1" <?php if(in_array(5,$target)) { echo "checked"; } ?>/> <?php echo (defined('LANG') && LANG === 'ar') ? 'التتار' : 'Natars'; ?></label>
		</td><td>
		<label><input class="radio" type="radio" name="ktyp" value="0" <?php if($form->getValue('ktyp') == 0 || $form->getValue('ktyp') == "") { echo "checked"; } ?>/> <?php echo (defined('LANG') && LANG === 'ar') ? 'عادي' : 'normal'; ?></label><br/>

		<label><input class="radio" type="radio" name="ktyp" value="1" <?php if($form->getValue('ktyp') == 1) { echo "checked"; } ?>/> <?php echo (defined('LANG') && LANG === 'ar') ? 'للنهب' : 'raid'; ?></label><br/>
		<label><input type="hidden" name="uid" value="<?php echo $session->uid; ?>" /></label>
	</td>
</tr></tbody>
</table>

<p class="btn"><button value="ok" name="s1" id="btn_ok" class="trav_buttons" alt="OK" /> <?php echo (defined('LANG') && LANG === 'ar') ? 'تم' : 'OK'; ?> </button></p>
</form>
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
</div>
<div class="footer-stopper"></div>
<div class="clear"></div>

<?php
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

<div id="ce"></div>
</body>
</html>

