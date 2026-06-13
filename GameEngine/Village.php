<?php
error_reporting(E_ALL & ~E_DEPRECATED & ~E_NOTICE & ~E_WARNING);
ini_set('display_errors', 1);
#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Filename       Village.php                                                 ##
##  License:       TravianZ Project                                            ##
##  Copyright:     TravianZ (c) 2010-2025. All rights reserved.                ##
##                                                                             ##
#################################################################################

include_once("Session.php");
include_once("Building.php");
include_once("Market.php");
include_once("GameEngine/Units.php");
include_once("Technology.php");

class Village {

	public $type;
	public $coor = [];
	public $awood, $aclay, $airon, $acrop, $pop, $maxstore, $maxcrop, $atotal;
	public $wid, $vname, $capital, $natar, $master;
	public $resarray = [];
	public $unitarray, $techarray, $unitall, $researching, $abarray = [];
	private $infoarray = [];
	private $production = [];
	private $oasisowned, $ocounter = [];

    function __construct() {
        global $session, $database;
        
        if(isset($_SESSION['wid'])) $this->wid = $_SESSION['wid'];
        else $this->wid = $session->villages[0];

        $this->preloadVillagesData();

        //add new line code
        //check exist village if from village destroy to avoid error msg.
        if(!$database->checkVilExist($this->wid)){
            $this->wid=$database->getVillageID($session->uid);
            $_SESSION['wid'] = $this->wid;
        }

        $this->LoadTown();
        $database->cacheResourceLevels($this->wid);
		$this->calculateProduction();
		$this->processProduction();
		$this->ActionControl();
	}

	private function preloadVillagesData() {
        global $database, $session;

        // preload villages for this user account
        $database->getProfileVillages($session->uid, 5);

        // preload villages world data records
        $database->cacheVillageByWorldIDs($session->uid);
    }

	public function getProd($type) {
		return $this->production[$type];
	}

	public function getAllUnits($vid) {
		global $database, $technology;
		return $technology->getUnits($database->getUnit($vid),$database->getEnforceVillage($vid,0));
	}

	private function LoadTown($second_run = false) {
		global $database, $session, $logging, $technology;
		
		$this->infoarray = $database->getVillage($this->wid);
		if($this->infoarray['owner'] != $session->uid && !$session->isAdmin) {
			unset($_SESSION['wid']);
			$logging->addIllegal($session->uid,$this->wid,1);
			$this->wid = $session->villages[0];
			$this->infoarray = $database->getVillage($this->wid);
		}
		$this->resarray = $database->getResourceLevel($this->wid);
		$this->coor = $database->getCoor($this->wid);
		$this->type = $database->getVillageType($this->wid);
		$this->oasisowned = $database->getOasis($this->wid);
		$this->ocounter = $this->sortOasis();
		$this->unitarray = $database->getUnit($this->wid);
		$this->enforcetome = $database->getEnforceVillage($this->wid,0);
		$this->enforcetoyou = $database->getEnforceVillage($this->wid,1);
		$this->enforceoasis = $database->getOasisEnforce($this->wid,0);
		$this->unitall =  $technology->getAllUnits($this->wid);
		$this->techarray = $database->getTech($this->wid);
		$this->abarray = $database->getABTech($this->wid);
		$this->researching = $database->getResearching($this->wid, !$second_run);

		$this->capital = $this->infoarray['capital'];
		$this->natar = $this->infoarray['natar'];
		$this->currentcel = $this->infoarray['celebration'];
		$this->wid = $this->infoarray['wref'];
		$this->vname = $this->infoarray['name'];
		$this->awood = $this->infoarray['wood'];
		$this->aclay = $this->infoarray['clay'];
		$this->airon = $this->infoarray['iron'];
		$this->acrop = $this->infoarray['crop'];
		$this->atotal = (int)($this->awood + $this->aclay + $this->airon + $this->acrop);
		$this->pop = $this->infoarray['pop'];
		$this->maxstore = $this->infoarray['maxstore'];
		$this->maxcrop = $this->infoarray['maxcrop'];
		$this->allcrop = $this->getCropProd();
		$this->loyalty = $this->infoarray['loyalty'];
		$this->master = count($database->getMasterJobs($this->wid));
		
		//If resources overflow the warehouse/granary limit, set them at the maximum value
        $resourceUpdates = [];
		if($this->awood > $this->maxstore)
		{ 
		    $this->awood = $this->maxstore; 
		    $resourceUpdates['wood'] = $this->maxstore; 	
		}
		
		if($this->aclay > $this->maxstore)
		{ 
		    $this->aclay = $this->maxstore; 
		    $resourceUpdates['clay'] = $this->maxstore; 	
		}
		
		if($this->airon > $this->maxstore)
		{ 
		    $this->airon = $this->maxstore;
		    $resourceUpdates['iron'] = $this->maxstore; 
		}
		
		if($this->acrop > $this->maxcrop)
		{
		    $this->acrop = $this->maxcrop; 
		    $resourceUpdates['crop'] = $this->maxcrop; 
		}
		
		if($this->acrop < 0) {
    $resourceUpdates['crop'] = floor($this->acrop);
}

		if (count($resourceUpdates)) {
            $database->updateResource($this->wid, array_keys($resourceUpdates), array_values($resourceUpdates));

            // reload cache if we've updated resources and the like
            if ($second_run) {
                // update DB cache
                call_user_func(get_class($database).'::clearVillageCache');
                $this->preloadVillagesData();
            }
		} 
		else if ($second_run) $this->preloadVillagesData();
	}

	private function calculateProduction() {
		global $technology, $database, $session;

		// clear cache, since we're updating village data
        call_user_func(get_class($database).'::clearVillageCache');
		$upkeep = $technology->getUpkeep($this->unitall, 0, $this->wid);
		$this->production['wood'] = $this->getWoodProd();
		$this->production['clay'] = $this->getClayProd();
		$this->production['iron'] = $this->getIronProd();
		
		$cropProd = $this->getCropProd(); // raw crop field production (village "empty" base)
		$popCost = !$this->natar ? $this->pop : round($this->pop / 2);
		$totalUpkeep = $popCost + $upkeep;
		$netCrop = $cropProd - $totalUpkeep;
		
		// 75% Crop Reduction: Add 75% of base crop production as bonus
		// Example at x100: base=30M, net=-2M → bonus=22.5M → final=+20.5M
		if ($session->cropReduction == 1) {
			$cropBonus = round($cropProd * 0.75);
			$netCrop = $netCrop + $cropBonus;
		}
		

		
		$this->production['crop'] = $netCrop;
	}

	private function processProduction() {
		global $database;
		
		$timepast = time() - $this->infoarray['lastupdate'];
		$nwood = min(($this->production['wood'] / 3600) * $timepast, $this->maxstore);
		$nclay = min(($this->production['clay'] / 3600) * $timepast, $this->maxstore);
		$niron = min(($this->production['iron'] / 3600) * $timepast, $this->maxstore);
		$ncrop = min(($this->production['crop'] / 3600) * $timepast, $this->maxcrop);
		
		$now = time();
		$res = @mysqli_query($database->dblink, "SELECT crop_immunity FROM " . TB_PREFIX . "vdata WHERE wref = " . (int)$this->wid);
		$has_immunity = false;
		if ($res && mysqli_num_rows($res)) {
			$row = mysqli_fetch_assoc($res);
			if (isset($row['crop_immunity']) && $row['crop_immunity'] > $now) {
				$has_immunity = true;
			}
		}

		if ($has_immunity && $ncrop < 0) {
		    $max_drop = $this->acrop - 1500;
		    if ($max_drop < 0) {
		        $ncrop = 0; 
		    } else {
		        if (abs($ncrop) > $max_drop) {
		            $ncrop = -$max_drop;
		        }
		    }
		}

		call_user_func(get_class($database).'::clearVillageCache');
		$database->modifyResource($this->wid, $nwood, $nclay, $niron, $ncrop, 1);
		$database->updateVillage($this->wid);
        $this->LoadTown(true);
	}

	private function getWoodProd() {
		global $bid1, $bid5, $session;
		
		$wood = $sawmill = 0;
		$woodholder = [];
		for($i = 1; $i <= 38; $i++) {
		    if($this->resarray['f'.$i.'t'] == 1) array_push($woodholder,'f'.$i);
		    if($this->resarray['f'.$i.'t'] == 5) $sawmill = $this->resarray['f'.$i];
		}
		
		for($i = 0; $i <= count($woodholder) - 1; $i++) $wood += $bid1[$this->resarray[$woodholder[$i]]]['prod'];
		$wood = $wood + $wood * $this->ocounter[0];
		
		if($sawmill >= 1) $wood += $wood / 100 * $bid5[$sawmill]['attri'];
		if($session->bonus1 == 1) $wood *= 1.25;

		return round($wood * SPEED);
	}

	private function getClayProd() {
		global $bid2, $bid6, $session;
		
		$clay = $brick = 0;
		$clayholder = [];
		for($i = 1; $i <= 38; $i++) {
		    if($this->resarray['f'.$i.'t'] == 2) array_push($clayholder,'f'.$i);
			if($this->resarray['f'.$i.'t'] == 6) $brick = $this->resarray['f'.$i];
		}
		
		for($i = 0; $i <= count($clayholder) - 1; $i++) $clay+= $bid2[$this->resarray[$clayholder[$i]]]['prod'];
		$clay = $clay + $clay * $this->ocounter[1];
		
		if($brick >= 1) $clay += $clay / 100 * $bid6[$brick]['attri'];
		if($session->bonus2 == 1) $clay *= 1.25;

		return round($clay * SPEED);
	}

	private function getIronProd() {
		global $bid3, $bid7, $session;
		
		$iron = $foundry = 0;
		$ironholder = [];
		for($i = 1; $i <= 38; $i++) {
		    if($this->resarray['f'.$i.'t'] == 3) array_push($ironholder,'f'.$i);
		    if($this->resarray['f'.$i.'t'] == 7) $foundry = $this->resarray['f'.$i];
		}
		
		for($i = 0;$i <= count($ironholder) - 1; $i++) $iron+= $bid3[$this->resarray[$ironholder[$i]]]['prod'];
		$iron = $iron + $iron * $this->ocounter[2];
		
		if($foundry >= 1) $iron += $iron / 100 * $bid7[$foundry]['attri'];
		if($session->bonus3 == 1) $iron *= 1.25;

		return round($iron * SPEED);
	}

	private function getCropProd() {
		global $bid4, $bid8, $bid9, $session;
		
		$crop = $grainmill = $bakery = 0;
		$cropholder = [];
		for($i = 1; $i <= 38; $i++) {
		    if($this->resarray['f'.$i.'t'] == 4) array_push($cropholder,'f'.$i);
		    if($this->resarray['f'.$i.'t'] == 8) $grainmill = $this->resarray['f'.$i];
		    if($this->resarray['f'.$i.'t'] == 9) $bakery = $this->resarray['f'.$i];
		}
		
		for ($i = 0; $i <= count($cropholder) - 1; $i++) $crop += $bid4[$this->resarray[$cropholder[$i]]]['prod'];
		$bonus = $this->ocounter[3];
		$crop = $crop + $crop * $this->ocounter[3];
		
		if($grainmill >= 1 || $bakery >= 1) {
		    $crop += $crop / 100 * ((isset($bid8[$grainmill]['attri']) ? $bid8[$grainmill]['attri'] : 0) + (isset($bid9[$bakery]['attri']) ? $bid9[$bakery]['attri'] : 0));
		}
		if($session->bonus4 == 1) $crop *= 1.25;

		return round($crop * SPEED);
	}

	private function sortOasis() {
		$crop = $clay = $wood = $iron = 0.0;
		if(!empty($this->oasisowned)){
			foreach($this->oasisowned as $oasis){
			switch($oasis['type']){
                case 1:
                case 2:
                    $wood += 1.0;
                    break;
                case 3:
                    $wood += 0.75;
                    $crop += 0.75;
                    break;
                case 4:
                case 5:
                    $clay += 1.0;
                    break;
                case 6:
                    $clay += 0.75;
                    $crop += 0.75;
                    break;
                case 7:
                case 8:
                    $iron += 1.0;
                    break;
                case 9:
                    $iron += 0.75;
                    $crop += 0.75;
                    break;
                case 10:
                case 11:
                    $crop += 1.0;
                    break;
                case 12:
                    $crop += 1.5;
                    break;
				}
			}
		}
		return [$wood, $clay, $iron, $crop];
	}

	private function ActionControl() {
		global $session, $database;
		
        if(isset($_POST['change_vname']) && isset($_POST['vname'])) {
            $name = trim($_POST['vname']);
            if(!empty($name)) {
                $database->setVillageName($this->wid, $name);
                $this->vname = $name;
                $this->infoarray['name'] = $name;
            }
        }

		if(SERVER_WEB_ROOT) $page = $_SERVER['SCRIPT_NAME'];
		else 
		{
			$explode = explode("/",$_SERVER['SCRIPT_NAME']);
			$i = count($explode)-1;
			$page = $explode[$i];
		}
		
		if($page == "build.php" && $session->uid != $this->infoarray['owner']) {
			unset($_SESSION['wid']);
			header("Location: dorf1.php");
			exit;
		}
	}

};
$village = new Village;
$building = new Building;

// if automation is not currently running, run it for this user,
// so if they are waiting for some automation to take place
// (units, resources, buildings...), the script will calculate that
// before showing the page
// ... this is a quick fix for automation being called async by AJAX
//     and users seeing old values on their page even though new values
//     already exist after the initial AJAX call
if ( !file_exists( AUTOMATION_LOCK_FILE_NAME ) ) {
	define( 'AUTOMATION_MANUAL_RUN', true );
	// this file is auto-removed by the Automation.php script
	file_put_contents( AUTOMATION_LOCK_FILE_NAME, '' );
	include_once("Automation.php");
}
?>
