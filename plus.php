<?php
include_once("GameEngine/Generator.php");
$start_timer = $generator->pageLoadTimeStart();

#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Filename       plus.php                                                    ##
##  Developed by:  Dzoki                                                       ##
##  License:       TravianX Project                                            ##
##  Copyright:     TravianX (c) 2010-2011. All rights reserved.                ##
##                                                                             ##
#################################################################################


use App\Utils\AccessLogger;

include_once("GameEngine/Village.php");
AccessLogger::logRequest();

if(isset($_GET['newdid'])) {
	$_SESSION['wid'] = $_GET['newdid'];
	header("Location: ".$_SERVER['PHP_SELF']);
	exit;
}
else $building->procBuild($_GET);

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html<?php echo (defined('LANG') && LANG === 'ar') ? ' dir="rtl"' : ''; ?>>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><?php
	echo SERVER_NAME . ' &raquo; &raquo; &raquo; PLUS ';

	if (!empty($_GET['id'])) {
	    switch ($_GET['id']) {
	        case '2':
	            echo (defined('LANG') && LANG === 'ar') ? 'المميزات' : 'Advantages';
	            break;

	        case '3':
	            echo (defined('LANG') && LANG === 'ar') ? 'الذهب' : 'Gold';
	            break;

	        case '4':
	            echo (defined('LANG') && LANG === 'ar') ? 'الأسئلة الشائعة' : 'FAQ';
	            break;

	        case '5':
	            echo (defined('LANG') && LANG === 'ar') ? 'اكسب الذهب' : 'Earn Gold';
	            break;
	    }
	} else {
	    echo (defined('LANG') && LANG === 'ar') ? 'التعرفة' : 'Tariffs';
	}
	?></title>
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
<?php
if(isset($_GET['id'])){
	$id = preg_replace("/[^a-zA-Z0-9_-]/", "", $_GET['id']);
} 
else $id = "";

if(empty($id)) include ("Templates/Plus/1.tpl");

if($id == 1){
	include ("Templates/Plus/3.tpl");
}
if($id == 2){
	include ("Templates/Plus/2.tpl");
}
if($id == 3){
	include ("Templates/Plus/3.tpl");
}
if($id == 4){
	include ("Templates/Plus/4.tpl");
}
if(isset($_GET['mail']) && $id == 5){
	include ("Templates/Plus/invite.tpl");
}else if($id == 5){
	include ("Templates/Plus/5.tpl");
}
if($id == 7){
	include ("Templates/Plus/7.tpl");
}
if($id == 8){
	include ("Templates/Plus/8.tpl");
}
if($id == 9){
	include ("Templates/Plus/9.tpl");
}
if($id == 10){
	include ("Templates/Plus/10.tpl");
}
if($id == 11){
	include ("Templates/Plus/11.tpl");
}
if($id == 12){
	include ("Templates/Plus/12.tpl");
}
if($id == 13){
	include ("Templates/Plus/13.tpl");
}
if($id == 14){
	include ("Templates/Plus/14.tpl");
}
if($id == 15){
	include ("Templates/Plus/15.tpl");
}
if($id == 16){
	include ("Templates/Plus/16.tpl");
}
if($id == 17){
	include ("Templates/Plus/17.tpl");
}
if($id == 18){
	include ("Templates/Plus/18.tpl");
}
if($id == 19){
	include ("Templates/Plus/19.tpl");
}
if($id == 20){
	include ("Templates/Plus/20.tpl");
}
if($id == 21){
	include ("Templates/Plus/21.tpl");
}
if($id > 21){
	include ("Templates/Plus/3.tpl");
}
if(isset($_POST['mail'])){
	$mailer->sendInvite($_POST['mail'], $session->uid, $_POST['text']);
}
?>

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

