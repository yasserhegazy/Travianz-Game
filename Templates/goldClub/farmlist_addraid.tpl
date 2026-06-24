<?php
// If the player has no farm lists, auto-create a default one instead of redirecting
if(!$database->getVilFarmlist($session->uid)){
	$defaultName = (defined('LANG') && LANG === 'ar') ? 'قائمة افتراضية' : 'Default List';
	$database->createFarmList($village->wid, $session->uid, $defaultName);
}

if(isset($_POST['action']) && $_POST['action'] == 'addSlot' && isset($_POST['lid']) && ($FLData = $database->getFLData($_POST['lid']))['owner'] == $session->uid) {

	$troops = 0;
	for($i = 1; $i <= 6; $i++){
		if(!in_array($i + ($session->tribe - 1) * 10, [4, 14, 23])) {
            $troops += isset($_POST['t'.$i]) ? (int)$_POST['t'.$i] : 0;
        }
	}
    
    if(!empty($_POST['target_id'])){
        $Wref = $_POST['target_id'];
        $WrefCoor = $database->getCoor($Wref);
        $WrefX = $WrefCoor['x'];
        $WrefY = $WrefCoor['y'];
        $type = $database->getVillageType2($Wref);
        $oasistype = $type;
        $vdata = $database->getVillage($Wref);
    }elseif($_POST['x'] != "" && $_POST['y'] != "" && is_numeric($_POST['x']) && is_numeric($_POST['y']) && $_POST['x'] <= WORLD_MAX && $_POST['y'] <= WORLD_MAX){
        $Wref = $database->getVilWref($_POST['x'], $_POST['y']);
        $WrefX = $_POST['x'];
        $WrefY = $_POST['y'];
        $type = $database->getVillageType2($Wref);
        $oasistype = $type;
        $vdata = $database->getVillage($Wref);
    }

    if($_POST['x'] == "" && $_POST['y'] == "" && empty($_POST['target_id'])) $errormsg = "Enter coordinates.";
    elseif(($_POST['x'] == "" || $_POST['y'] == "") && empty($_POST['target_id'])) $errormsg = "Enter the correct coordinates.";	
    elseif($oasistype == 0 && $vdata == 0) $errormsg = "There is no village on those coordinates.";   	
    elseif($troops == 0) $errormsg = "No troops has been selected.";   	
    elseif($database->hasBeginnerProtection($Wref) == 1) $errormsg = "اللاعب تحت الحماية.";  
    elseif($_POST['target_id'] == $FLData['wref'] || $vdata['wref'] == $FLData['wref']) $errormsg = "You can't attack the same village you're sending troops from.";
    elseif($session->gold < 5) $errormsg = (defined('LANG') && LANG === 'ar') ? "ليس لديك ذهب كافٍ. إضافة قرية يكلف 5 ذهب." : "Not enough gold. Adding a village costs 5 gold.";
    else
    {   
		if(!empty($_POST['target_id'])){
		    $Wref = $_POST['target_id'];
		    $WrefCoor = $database->getCoor($Wref);
		    $WrefX = $WrefCoor['x'];
		    $WrefY = $WrefCoor['y'];
		}else{
		    $Wref = $database->getVilWref($_POST['x'], $_POST['y']);
		    $WrefX = $_POST['x'];
		    $WrefY = $_POST['y'];
		}
		
        $coor = $database->getCoor($village->wid);        
        $distance = $database->getDistance($coor['x'], $coor['y'], $WrefX, $WrefY);
        $database->updateUserField($session->uid, 'gold', $session->gold - 5, 1);
        $database->addSlotFarm($_POST['lid'], $Wref, $WrefX, $WrefY, $distance, $_POST['t1'], $_POST['t2'], $_POST['t3'], $_POST['t4'], $_POST['t5'], $_POST['t6']);

        header("Location: build.php?id=39&t=99");
		exit;
}
}
?>

<div id="raidListSlot">
    <h4><?php echo (defined('LANG') && LANG === 'ar') ? 'إضافة مزرعة' : 'Add Slot'; ?></h4>
<font color="#FF0000"><b>    
<?php if(isset($errormsg)) echo $errormsg; ?>
</b></font>
    
    <form action="build.php?id=39&t=99&action=addraid" method="post">
        <div class="boxes boxesColor gray"><div class="boxes-tl"></div><div class="boxes-tr"></div><div class="boxes-tc"></div><div class="boxes-ml"></div><div class="boxes-mr"></div><div class="boxes-mc"></div><div class="boxes-bl"></div><div class="boxes-br"></div><div class="boxes-bc"></div><div class="boxes-contents cf">   
        <input type="hidden" name="action" value="addSlot">
            <table cellpadding="1" cellspacing="1" class="transparent" id="raidList">
                <tbody><tr>
                    <th><?php echo (defined('LANG') && LANG === 'ar') ? 'اسم القائمة:' : 'List name:'; ?></th>
                    <td>
                        <select name="lid">
<?php

$sql = mysqli_query($database->dblink, "SELECT id, name, owner, wref FROM ".TB_PREFIX."farmlist WHERE owner = ".(int)$session->uid." ORDER BY name ASC");
	while($row = mysqli_fetch_array($sql)){
		$loop_lid = $row["id"];
		$lname = $row["name"];
		$lvname = $database->getVillageField($row["wref"], 'name');
        $selected = (isset($_GET['lid']) && $_GET['lid'] == $loop_lid) ? 'selected' : '';
		echo '<option value="'.$loop_lid.'" '.$selected.'>'.$lvname.' - '.$lname.'</option>';
}
?>    
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><?php echo (defined('LANG') && LANG === 'ar') ? 'القرية المستهدفة:' : 'Target village:'; ?></th>
                    <td class="target">
                        
            <div class="coordinatesInput">
<?php
$px = isset($_POST['x']) ? htmlspecialchars($_POST['x']) : '';
$py = isset($_POST['y']) ? htmlspecialchars($_POST['y']) : '';
if(empty($px) && empty($py) && !empty($_GET['z'])) {
    $coor = $database->getCoor($_GET['z']);
    $px = $coor['x'];
    $py = $coor['y'];
}
?>
                <div class="xCoord">
                    <label for="xCoordInput">X:</label>
                    <input value="<?php echo $px; ?>" name="x" id="xCoordInput" class="text coordinates x ">
                </div>
                <br />
                <div class="yCoord">
                    <label for="yCoordInput">Y:</label>
                    <input value="<?php echo $py; ?>" name="y" id="yCoordInput" class="text coordinates y ">
                </div>
                <div class="clear"></div>
            </div>
            <br />
                                <div class="targetSelect">
                            <label class="lastTargets"><?php echo (defined('LANG') && LANG === 'ar') ? 'الأهداف السابقة:' : 'Last targets:'; ?></label>
							<select name="target_id">
<?php
$getwref = "SELECT movement.to, movement.ref, attacks.* FROM ".TB_PREFIX."movement as movement INNER JOIN ".TB_PREFIX."attacks as attacks ON attacks.id = movement.ref WHERE attacks.attack_type = 4 AND movement.proc = 1 AND movement.from = ".$village->wid;
$arraywref = $database->query_return($getwref);
echo '<option value="">' . ((defined('LANG') && LANG === 'ar') ? 'اختر قرية' : 'Select village') . '</option>';
if(mysqli_num_rows(mysqli_query($database->dblink, $getwref)) != 0){
	foreach($arraywref as $row){
		$towref = $row["to"];
		$vilInfo = $database->getVillageByWorldID($towref);
		if($vilInfo['fieldtype'] > 0 && !$vilInfo['occupied']) continue;
		$tocoor = $database->getCoor($towref);
		if($vilInfo['oasistype'] == 0) $tovname = $database->getVillageField($towref, 'name');
		else $tovname = $database->getOasisField($towref, 'name');
		
		if($vill[$towref] == 0) echo '<option value="'.$towref.'">'.$tovname.' ('.$tocoor['x'].'|'.$tocoor['y'].')</option>';
		$vill[$towref] = 1;
	}
}
?>
							</select>
                        </div>
                        <div class="clear"></div>
                    </td>
                </tr>
            </tbody></table>
            </div>
                </div>
        <?php include("Templates/goldClub/trooplist.tpl"); ?>
<br />
<button type="submit" value="save" name="save" id="save" class="trav_buttons"><?php echo (defined('LANG') && LANG === 'ar') ? 'حفظ (-5 ذهب)' : 'Create <span style=\"color:#000;font-weight:normal;\">(5 <img src=\"img/x.gif\" class=\"gold\" alt=\"Gold\">)</span>'; ?></button>
</form>
</div>



