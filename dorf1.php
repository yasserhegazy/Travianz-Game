<?php
include_once("GameEngine/Generator.php");
$start_timer = $generator->pageLoadTimeStart();

#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Filename       dorf1.php                                                   ##
##  Developed by:  Dzoki                                                       ##
##  License:       TravianX Project                                            ##
##  Copyright:     TravianX (c) 2010-2011. All rights reserved.                ##
##                                                                             ##
#################################################################################
use App\Utils\AccessLogger;

include_once("GameEngine/Village.php");
AccessLogger::logRequest();

if(isset($_GET['ok'])){
	$database->updateUserField($session->uid,'ok', 0, 1);
	$_SESSION['ok'] = '0';
}

if(isset($_GET['newdid'])) {
    $_SESSION['wid'] = $_GET['newdid'];
    $database->query("UPDATE ".TB_PREFIX."users SET village_select=".$database->escape((int) $_GET['newdid'])." WHERE id=".$session->uid);  
	header("Location: ".$_SERVER['PHP_SELF']);
	exit;
} 
else $building->procBuild($_GET);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html<?php echo (defined('LANG') && LANG === 'ar') ? ' dir="rtl"' : ''; ?>>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><?php echo SERVER_NAME . ' - Village overview &raquo; ' . $village->vname; ?></title>
	<link rel="shortcut icon" href="favicon.ico"/>
	<meta http-equiv="cache-control" content="max-age=0" />
	<meta http-equiv="pragma" content="no-cache" />
	<meta http-equiv="expires" content="0" />
	<meta http-equiv="imagetoolbar" content="no" />
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<script src="mt-full.js?0faab" type="text/javascript"></script>
	<script src="unx.js?g5c8m" type="text/javascript"></script>
	<script src="new.js?0faab" type="text/javascript"></script>
	<link href="<?php echo GP_LOCATE; ?>lang/<?php echo LANG; ?>/compact.css?v2" rel="stylesheet" type="text/css" />
	<link href="<?php echo GP_LOCATE; ?>lang/<?php echo LANG; ?>/lang.css?v2" rel="stylesheet" type="text/css" />
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
	// Primary: MooTools domready
	window.addEvent('domready', start);
	// Fallback: native DOMContentLoaded for modern browsers
	(function(){
		var _started = false;
		function _safeStart() {
			if (_started) return;
			_started = true;
			if (typeof start === 'function') start();
		}
		if (document.readyState === 'loading') {
			document.addEventListener('DOMContentLoaded', _safeStart);
		} else {
			_safeStart();
		}
	})();
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
<div id="content"  class="village1">
<h1><?php echo $village->vname; if($village->loyalty!='100'){ if($village->loyalty>'33'){ $color="gr"; }else{ $color="re"; } ?><div id="loyality" class="<?php echo $color; ?>"><?php echo LOYALTY; ?> <?php echo floor($village->loyalty); ?>%</div><?php } ?></h1>
<div id="cap" align="left"><?php if($village->capital!='0') { echo "<font color=gray>(".CAPITAL1.")</font>"; } ?></div>
<?php include("Templates/field.tpl");
$timer = 1;
?>
<div id="map_details">
<br /><br />
<?php
include("Templates/movement.tpl");
include("Templates/production.tpl");
include("Templates/troops.tpl");

if($building->NewBuilding) include("Templates/Building.tpl");
?>
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
