<?php

#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Filename       statistiken.php                                             ##
##  Developed by:  Dzoki                                                       ##
##  License:       TravianX Project                                            ##
##  Copyright:     TravianX (c) 2010-2011. All rights reserved.                ##
##                                                                             ##
#################################################################################


use App\Utils\AccessLogger;

include_once("GameEngine/Village.php");
AccessLogger::logRequest();

$__start = $generator->pageLoadTimeStart();
if(isset($_GET['rank'])){ $_POST['rank']=$_GET['rank']; }
$_GET['aid'] = $session->alliance;
$_GET['hero'] = count($database->getHero($session->uid));
$ranking->procRankReq($_GET);
$ranking->procRank($_POST);
if(isset($_GET['newdid'])) {
	$_SESSION['wid'] = $_GET['newdid'];
	header("Location: ".$_SERVER['PHP_SELF']."?id=".$_GET['id']);
	exit;
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html<?php echo (defined('LANG') && LANG === 'ar') ? ' dir="rtl"' : ''; ?>>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><?php
	echo SERVER_NAME . ' &raquo; &raquo; &raquo; Statistics (';

	if (!empty($_GET['id'])) {
	    switch ($_GET['id']) {
	        case '4':
	            echo 'Alliances';
	            break;

	        case '2':
	            echo 'Villages';
	            break;

	        case '8':
	            echo 'Heroes';
	            break;

	        case '0':
	            echo 'General';
	            break;

	        case '99':
	            echo 'WW';
	            break;

	        case '100':
	            echo 'Hall of Fame';
	            break;
	    }
	} else {
	    echo 'Players';
	}

	echo ')';
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
	<link rel="stylesheet" type="text/css" href="mobile.css?v=51" />
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
		<div id="content"  class="statistics">
<h1><?php echo (defined('LANG') && LANG === 'ar') ? 'الإحصائيات' : 'Statistics'; ?></h1>
<div id="textmenu">
   <a href="statistiken.php" <?php if(!isset($_GET['id']) || (isset($_GET['id']) && ($_GET['id'] == 1 || $_GET['id'] == 31 || $_GET['id'] == 32 || $_GET['id'] == 7))) { echo "class=\"selected \""; } ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'اللاعبون' : 'Player'; ?></a>
 | <a href="statistiken.php?id=4" <?php if(isset($_GET['id']) && ($_GET['id'] == 4 || $_GET['id'] == 41 || $_GET['id'] == 42 || $_GET['id'] == 43)) { echo "class=\"selected \""; } ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'التحالفات' : 'Alliances'; ?></a>
 | <a href="statistiken.php?id=2" <?php if(isset($_GET['id']) && $_GET['id'] == 2) { echo "class=\"selected \""; } ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'القرى' : 'Villages'; ?></a>
 | <a href="statistiken.php?id=8" <?php if(isset($_GET['id']) && $_GET['id'] == 8) { echo "class=\"selected \""; } ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'الأبطال' : 'Heroes'; ?></a>
 | <a href="statistiken.php?id=0" <?php if(isset($_GET['id']) && $_GET['id'] == 0) { echo "class=\"selected \""; } ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'عام' : 'General'; ?></a>
 <?php if(WW == true) { ?>
 | <a href="statistiken.php?id=99" <?php if(isset($_GET['id']) && $_GET['id'] == 99) { echo "class=\"selected \""; } ?>>WW</a>
 <?php } ?>
 | <a href="statistiken.php?id=100" <?php if(isset($_GET['id']) && $_GET['id'] == 100) { echo "class=\"selected \""; } ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'سجل الفائزين' : 'Winners Record'; ?></a>
</div>
<?php
if(isset($_GET['id'])) {
	switch($_GET['id']) {
		case 31:
			include("Templates/Ranking/player_attack.tpl");
			break;
		case 32:
			include("Templates/Ranking/player_defend.tpl");
			break;
		case 40:
            include("Templates/Ranking/player_loot.tpl");
            break;
		case 44:
            include("Templates/Ranking/alliance_loot.tpl");
            break;
		case 7:
			include("Templates/Ranking/player_top10.tpl");
			break;
		case 2:
			include("Templates/Ranking/villages.tpl");
			break;
		case 4:
			include("Templates/Ranking/alliance.tpl");
			break;
		case 8:
			include("Templates/Ranking/heroes.tpl");
			break;
		case 11:
			include("Templates/Ranking/player_1.tpl");
			break;
		case 12:
			include("Templates/Ranking/player_2.tpl");
			break;
		case 13:
			include("Templates/Ranking/player_3.tpl");
			break;
		case 41:
			include("Templates/Ranking/alliance_attack.tpl");
			break;
		case 42:
			include("Templates/Ranking/alliance_defend.tpl");
			break;
		case 43:
			include("Templates/Ranking/ally_top10.tpl");
			break;
		case 0:
			include("Templates/Ranking/general.tpl");
			break;
		case 1:
			include("Templates/Ranking/overview.tpl");
			break;
		case 99:
			include("Templates/Ranking/ww.tpl");
			break;
		case 100:
			include("Templates/Ranking/winner_history.tpl");
			break;
	}
}
else {
	include("Templates/Ranking/overview.tpl");
}
?>
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

