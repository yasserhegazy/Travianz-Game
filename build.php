<?php

#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Filename       build.php                                                   ##
##  Developed by:  Dzoki                                                       ##
##  License:       TravianX Project                                            ##
##  Copyright:     TravianX (c) 2010-2011. All rights reserved.                ##
##                                                                             ##
#################################################################################

use App\Utils\AccessLogger;

ob_start();
include_once( "GameEngine/Village.php" );
include_once( "GameEngine/Units.php" );
AccessLogger::logRequest();

if(isset($_GET['newdid'])){
    $_SESSION['wid'] = $_GET['newdid'];
    header("Location: " . $_SERVER['PHP_SELF'].(isset($_GET['id']) ? '?id='.$_GET['id'] : (isset($_GET['gid']) ? '?gid='.$_GET['gid'] : '')));
    exit;
}
if(isset($_GET['id']) && ($_GET['id'] < 1 || $_GET['id'] > 40 && ($_GET['id'] == 99 && $village->natar == 0 || $_GET['id'] != 99))){
    header("Location: dorf2.php");
    exit;
}

$pagestart = $generator->pageLoadTimeStart();
$alliance->procAlliForm($_POST);
$technology->procTech($_POST);
$market->procMarket($_POST);

// Early handler: Finish all building orders with gold (from Building.tpl clock icon)
// Building.tpl links to ?buildingFinish=1 without preserving id, so handle it early
if (isset($_GET['buildingFinish']) && $_GET['buildingFinish'] == 1 && !isset($_GET['id']) && !isset($_GET['gid'])) {
    if ($session->gold >= 2) {
        $building->finishAll("dorf2.php");
        exit;
    }
    header("Location: dorf2.php");
    exit;
}

if ( isset( $_GET['gid'] ) ) {
    $temp_id = $building->getTypeField( preg_replace( "/[^a-zA-Z0-9_-]/", "", $_GET['gid'] ) );
    if ($temp_id) {
        $_GET['id'] = strval( $temp_id );
    } else {
        header("Location: dorf2.php");
        exit;
    }
} else if ( isset( $_POST['id'] ) ) {
    $_GET['id'] = preg_replace( "/[^a-zA-Z0-9_-]/", "", $_POST['id'] ); // WTF is this?
}

if ( isset( $_POST['t'] ) ) {
    $_GET['t'] = preg_replace( "/[^a-zA-Z0-9_-]/", "", $_POST['t'] );
}

if ( isset( $_GET['id'] ) ) {
    if($_GET['id'] == '999' && $session->gold >= 3) {
        $village->resarray['f999t'] = 17;
    } else if ( ! ctype_digit( preg_replace( "/[^a-zA-Z0-9_-]/", "", $_GET['id'] ) ) ) {
        $_GET['id'] = "1";
    }

    if (isset($_GET['upgradeToMax'])) {
        $building->upgradeToMax($_GET['id']);
        header("Location: " . ($_GET['id'] <= 18 ? "dorf1.php" : "dorf2.php"));
        exit;
    }
    if (isset($_GET['demolishToZero'])) {
        $building->demolishToZero($_GET['id']);
        header("Location: " . ($_GET['id'] <= 18 ? "dorf1.php" : "dorf2.php"));
        exit;
    }
    if (isset($_GET['goldDemolish']) && isset($_GET['slot'])) {
        $building->demolishToZero($_GET['slot']);
        header("Location: " . ($_GET['slot'] <= 18 ? "dorf1.php" : "dorf2.php"));
        exit;
    }

    // Gold instant demolish via POST (from Main Building form checkbox)
    if (!empty($_REQUEST["demolish"]) && isset($_REQUEST["c"]) && $_REQUEST["c"] == $session->mchecker
        && isset($_POST['goldDemolish']) && $_POST['goldDemolish'] == '1'
        && isset($_POST['type'])) {
        $slot = (int) $_POST['type'];
        if (($slot >= 19 && $slot <= 40) || $slot == 99) {
            $slotLevel = (int) $village->resarray['f'.$slot];
            if ($session->gold >= $slotLevel && $slotLevel > 0) {
                $building->demolishToZero($slot);
                $session->changeChecker();
                header("Location: build.php?gid=15&ty=$slot&cancel=0&demolish=0");
                exit;
            } else {
                header("Location: build.php?gid=15&ty=$slot&cancel=0&demolish=0&nogold=1");
                exit;
            }
        }
    }

    $checkBuildings = [0, 16, 17, 25, 26, 27];

    if ( $_GET['id'] < 19 || ( isset( $_GET['gid'] ) && ! in_array( $_GET['gid'], $checkBuildings ) ) ) {
        $_GET['t'] = "";
        $_GET['s'] = "";
    }

    if ( $village->resarray[ 'f' . $_GET['id'] . 't' ] == 17 ) {
        $market->procRemove( $_GET );
    }

    if ( $village->resarray[ 'f' . $_GET['id'] . 't' ] == 18 ) {
        $alliance->procAlliance( $_GET );
    }

    if ( $village->resarray[ 'f' . $_GET['id'] . 't' ] == 12 || $village->resarray[ 'f' . $_GET['id'] . 't' ] == 13 || $village->resarray[ 'f' . $_GET['id'] . 't' ] == 22 ) {
        $technology->procTechno( $_GET );
	// Gold upgrade AB tech to max level (20), 1 gold per level
	if (isset($_GET["upgradeABMax"]) && isset($_GET["abType"]) && isset($_GET["abUnit"])) {
		$abType = $_GET["abType"] === "a" ? "a" : "b";
		$abUnit = min(8, max(1, (int)$_GET["abUnit"]));
		$abdata = $database->getABTech($village->wid);
		$currentLevel = (int)$abdata[$abType . $abUnit];
		$goldCost = 20 - $currentLevel;
		if ($currentLevel < 20 && $session->gold >= $goldCost) {
			$technology->upgradeABToMax($abType, $abUnit);
		}
		header("Location: build.php?id=" . (int)$_GET["id"]);
		exit;
	}
    }
}

if ($session->goldclub == 1 && count($session->villages) > 1) {
    if (isset($_POST['routeid'])) $routeid = $_POST['routeid'];

    if (isset($_POST['action']) && $_POST['action'] == 'addRoute') {
        if ($session->gold >= 2 && $session->goldclub == 1) {
            for ($i = 1; $i <= 4; $i ++) {
                if (empty($_POST['r'.$i])) $_POST['r'.$i] = 0;
            }
            
            $totalres = preg_replace("/[^0-9]/", "", $_POST['r1']) + preg_replace("/[^0-9]/", "", $_POST['r2']) + preg_replace("/[^0-9]/", "", $_POST['r3']) + preg_replace("/[^0-9]/", "", $_POST['r4']);
            $reqMerc  = ceil(($totalres - 0.1) / $market->maxcarry);
            $second   = date("s");
            $minute   = date("i");
            $hour     = date("G") - $_POST['start'];
            
            if (date("G") > $_POST['start']) $day = 1;
            else $day = 0;
            
            $timestamp = strtotime("-$hour hours -$second second -$minute minutes +$day day");
            
            if ($totalres > 0 && $_POST['tvillage'] != $village->wid && in_array($_POST['tvillage'], $session->villages) && ($_POST['start'] >= 0 && $_POST['start'] <= 23) && ($_POST['deliveries'] >= 1 && $_POST['deliveries'] <= 3)) {
                $database->createTradeRoute($session->uid, $_POST['tvillage'], $village->wid, $_POST['r1'], $_POST['r2'], $_POST['r3'], $_POST['r4'], $_POST['start'], $_POST['deliveries'], $reqMerc, $timestamp);
                $route = 1;
                header("Location: build.php?gid=17&t=4");
                exit;
            } else {
                $route = 1;
                header("Location: build.php?gid=17&t=4&create");
                exit;
            }
        }
    }

    if (isset($_POST['routeid']) && isset($_POST['action']) && $_POST['action'] == 'extendRoute') {
        if ($session->gold >= 2 && $session->goldclub == 1) {
            $traderoute = $database->getTradeRouteUid($_POST['routeid']);
            if ($traderoute == $session->uid) {
                $database->editTradeRoute($_POST['routeid'], "timeleft", 604800, 1);
                $newgold = $session->gold - 2;
                $database->updateUserField($session->uid, 'gold', $newgold, 1);
            }
        }
        $route = 1;
        unset($routeid);
        header("Location: build.php?gid=17&t=4");
        exit;
    }

    if (isset($_POST['routeid']) && isset($_POST['action']) && $_POST['action'] == 'editRoute2') {
        if($session->goldclub == 1){
            for ($i = 1; $i <= 4; $i ++) {
                if (empty($_POST['r'.$i])) {
                    $_POST['r'.$i] = 0;
                }
            }
            $totalres = preg_replace("/[^0-9]/", "", $_POST['r1']) + preg_replace("/[^0-9]/", "", $_POST['r2']) + preg_replace("/[^0-9]/", "", $_POST['r3']) + preg_replace("/[^0-9]/", "", $_POST['r4']);
            $reqMerc  = ceil(($totalres - 0.1) / $market->maxcarry);
            
            $traderoute = $database->getTradeRouteUid($_POST['routeid']);
            if ($totalres > 0 && $traderoute == $session->uid && ($_POST['start'] >= 0 && $_POST['start'] <= 23) && ($_POST['deliveries'] >= 1 && $_POST['deliveries'] <= 3)) {
                $database->editTradeRoute($_POST['routeid'], "wood", $_POST['r1'], 0);
                $database->editTradeRoute($_POST['routeid'], "clay", $_POST['r2'], 0);
                $database->editTradeRoute($_POST['routeid'], "iron", $_POST['r3'], 0);
                $database->editTradeRoute($_POST['routeid'], "crop", $_POST['r4'], 0);
                $database->editTradeRoute($_POST['routeid'], "start", $_POST['start'], 0);
                $database->editTradeRoute($_POST['routeid'], "deliveries", $_POST['deliveries'], 0);
                $database->editTradeRoute($_POST['routeid'], "merchant", $reqMerc, 0);
                $second = date("s");
                $minute = date("i");
                $hour   = date("G") - $_POST['start'];
                if (date("G") > $_POST['start'])  $day = 1;
                else $day = 0;
                $timestamp = strtotime("-$hour hours -$second seconds -$minute minutes +$day day");
                $database->editTradeRoute($_POST['routeid'], "timestamp", $timestamp, 0);
            }
            
            $route = 1;
            unset($routeid);
            header("Location: build.php?gid=17&t=4");
            exit;
        } 
    }

    if (isset($_POST['routeid']) && isset($_POST['action']) && $_POST['action'] == 'delRoute') {
        if($session->goldclub == 1){
            $traderoute = $database->getTradeRouteUid($_POST['routeid']);
            if ($traderoute == $session->uid) $database->deleteTradeRoute($_POST['routeid']);
            $route = 1;
            unset($routeid);
            header("Location: build.php?gid=17&t=4");
            exit;
        }
    }
}

if (isset($_GET['t']) == 99) {
    if(isset($_GET['action'])){
        if($_GET['action'] == 'addList') $create = 1;
        elseif($_GET['action'] == 'addraid') $create = 2;
        elseif($_GET['action'] == 'showSlot' && $_GET['eid']) $create = 3; 
    }       
    else $create = 0;

    if(isset($_GET['slid']) && $_GET['slid']){
        $FLData = $database->getFLData($_GET['slid']);
        if ($FLData['owner'] == $session->uid) $checked[$_GET['slid']] = 1;
    }

    if(isset($_GET['action']) && $_GET['action'] == 'deleteList') {
        $database->delFarmList($_GET['lid'], $session->uid);
        header("Location: build.php?id=39&t=99");
        exit;
    } elseif(isset($_GET['action']) && $_GET['action'] == 'deleteSlot') {
        $database->delSlotFarm($_GET['eid'], $session->uid, $_GET['lid']);
        header("Location: build.php?id=39&t=99");
        exit;
    }

    if(isset($_POST['action']) && $_POST['action'] == 'startRaid') $units->startRaidList($_POST);

    if(isset($_GET['slid']) && is_numeric($_GET['slid'])) {
        $FLData = $database->getFLData($_GET['slid']);
        if ($FLData['owner'] == $session->uid) $checked[$_GET['slid']] = 1;
    }

    if(isset($_GET['evasion']) && is_numeric($_GET['evasion'])) {
        $evasionvillage = $database->getVillage($_GET['evasion']);
        if($evasionvillage['owner'] == $session->uid) $database->setVillageEvasion($_GET['evasion']);
        
        header("Location: build.php?id=39&t=99");
        exit;
    }

    if (isset($_POST['maxevasion']) && is_numeric($_POST['maxevasion'])) {
        $database->updateUserField($session->uid, "maxevasion", $_POST['maxevasion'], 1);
        header("Location: build.php?id=39&t=99" );
        exit;
    }
} else {
    $create = 0;
}

if(isset($_POST['a']) == 533374 && isset($_POST['id']) == 39) $units->Settlers($_POST);

if(isset($_GET['mode']) && $_GET['mode'] == 'troops' && isset($_GET['cancel']) && $_GET['cancel'] == 1){
    $oldmovement = $database->getMovementById($_GET['moveid']);
    $now = time();
    if(($now - $oldmovement[0]['starttime']) < 90 && $oldmovement[0]['from'] == $village->wid){
        $qc = "SELECT Count(*) as Total FROM " . TB_PREFIX . "movement where proc = 0 and moveid = " . $database->escape((int)$_GET['moveid']);
        $resultc = mysqli_fetch_array(mysqli_query($database->dblink, $qc), MYSQLI_ASSOC);
        if($resultc['Total'] == 1){
            $q = "UPDATE " . TB_PREFIX . "movement set proc  = 1 where proc = 0 and moveid = " . $database->escape((int)$_GET['moveid']);
            $database->query($q);
            $end = $now + ($now - $oldmovement[0]['starttime']);
            $q2 = "SELECT id FROM " . TB_PREFIX . "send ORDER BY id DESC";
            $lastid = mysqli_fetch_array(mysqli_query($database->dblink, $q2));
            $database->addMovement(4, $oldmovement[0]['to'], $oldmovement[0]['from'], $oldmovement[0]['ref'], $now, $end);
        }
    }
    header("Location: " . $_SERVER['PHP_SELF'] . "?id=" . $_GET['id']);
    exit();
}

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html<?php echo (defined('LANG') && LANG === 'ar') ? ' dir="rtl"' : ''; ?>>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><?php echo SERVER_NAME; ?></title>
	<link rel="shortcut icon" href="favicon.ico"/>
	<meta http-equiv="cache-control" content="max-age=0" />
	<meta http-equiv="pragma" content="no-cache" />
	<meta http-equiv="expires" content="0" />
	<meta http-equiv="imagetoolbar" content="no" />
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />

	<script src="mt-full.js?ebe79" type="text/javascript"></script>
	<script src="unx.js?g5c8m" type="text/javascript"></script>
	<script src="new.js?ebe79" type="text/javascript"></script>
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
		// Primary: MooTools domready
		window.addEvent('domready', start);
		// Fallback: native DOMContentLoaded — ensures timers start even if MooTools
		// domready fires too early or fails in modern browsers.
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
				// DOM already ready (script deferred or inline after body)
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
<div id="content"  class="build">
<?php
if(isset($_GET['id']) || isset($_GET['gid']) || $route == 1 || isset($_POST['routeid']) || isset($_GET['buildingFinish']) || isset($_GET['trainingFinish']) || isset($_GET['upgradeToMax'])) {
    
    if(isset($_GET['s']) && !ctype_digit($_GET['s'])) $_GET['s'] = null;
    if(isset($_GET['t']) && !ctype_digit($_GET['t'])) $_GET['t'] = null;
	if (!ctype_digit($_GET['id'])) $_GET['id'] = 1;

	// Self-heal resource field types if they somehow became 0
	if ($_GET['id'] >= 1 && $_GET['id'] <= 18 && $village->resarray['f'.$_GET['id'].'t'] == 0) {
		$vtypes = [
			1 => [4,4,1,4,4,2,3,4,4,3,3,4,4,1,4,2,1,2],
			2 => [3,4,1,3,2,2,3,4,4,3,3,4,4,1,4,2,1,2],
			3 => [1,4,1,3,2,2,3,4,4,3,3,4,4,1,4,2,1,2],
			4 => [1,4,1,2,2,2,3,4,4,3,3,4,4,1,4,2,1,2],
			5 => [1,4,1,3,1,2,3,4,4,3,3,4,4,1,4,2,1,2],
			6 => [4,4,1,3,4,4,4,4,4,4,4,4,4,4,4,2,4,4],
			7 => [1,4,4,1,2,2,3,4,4,3,3,4,4,1,4,2,1,2],
			8 => [3,4,4,1,2,2,3,4,4,3,3,4,4,1,4,2,1,2],
			9 => [3,4,4,1,1,2,3,4,4,3,3,4,4,1,4,2,1,2],
			10 => [3,4,4,1,2,2,2,4,4,3,3,4,4,1,4,2,1,2],
			11 => [3,1,4,1,1,2,2,4,4,3,3,4,4,1,4,2,1,2],
			12 => [1,4,1,1,2,2,3,4,4,3,3,4,4,1,4,2,1,2]
		];
		$vt = $village->type;
		if(isset($vtypes[$vt])) {
			$realType = $vtypes[$vt][$_GET['id'] - 1];
			$database->query("UPDATE " . TB_PREFIX . "fdata SET f" . $_GET['id'] . "t = $realType WHERE vref = " . $village->wid);
			$village->resarray['f'.$_GET['id'].'t'] = $realType;
		}
	}

	$id = $_GET['id'];
	if($_GET['id'] == 99 && $village->resarray['f99t'] == 40){
	   include("Templates/Build/ww.tpl");
	} elseif($village->resarray['f'.$_GET['id'].'t'] == 0 && $_GET['id'] >= 19) {
		include("Templates/Build/avaliable.tpl");
	}
	else {
		if(isset($_GET['t'])) {
		    if($_GET['t'] == 1) $_SESSION['loadMarket'] = 1;
			include("Templates/Build/".$village->resarray['f'.$_GET['id'].'t']."_".$_GET['t'].".tpl");
		} elseif(isset($_GET['s'])) {
			include("Templates/Build/".$village->resarray['f'.$_GET['id'].'t']."_".$_GET['s'].".tpl");
		}
		else include("Templates/Build/".$village->resarray['f'.$_GET['id'].'t'].".tpl");
		
		if((isset($_GET['buildingFinish'])) && $_GET['buildingFinish'] == 1) {
        	if($session->gold >= 2) {
        		$building->finishAll(($_GET['id'] <= 18 ? "dorf1.php" : "dorf2.php"));
        		exit;
        	}
        }
		if((isset($_GET['trainingFinish'])) && $_GET['trainingFinish'] == 1) {
        	if($session->gold >= 35) {
        		$building->finishTrainingGold();
        		header("Location: " . ($_GET['id'] <= 18 ? "dorf1.php" : "dorf2.php"));
        		exit;
        	}
        }
	}
}else{
header("Location: ".$_SERVER['PHP_SELF']."?id=39");
exit;
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
echo round(($generator->pageLoadTimeEnd()-$pagestart)*1000);
?></b> ms

<br />Server time: <span id="tp1" class="b"><?php echo date('H:i:s'); ?></span>
</div>
	</div>
</div>

<div id="ce">    </div>
<script type="text/javascript">
	// update TITLE to include building name, as it's not very possible to do in PHP in current codebase
	if (document.getElementsByTagName('h1').length) {
		document.title = document.title + ' » » ' + document.getElementsByTagName('h1')[0].innerHTML.replace(/(<([^>]+)>)/ig,"");
	} 
	else document.title + ' » » New Building'
</script>
</body>
</html>
