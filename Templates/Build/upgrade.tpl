<?php

$bid = $village->resarray['f'.$id.'t'];
$bindicate = $building->canBuild($id, $bid);
if($bindicate == 1) {
	echo "<p><span class=\"none\">".MAX_LEVEL."</span></p>";
} else if($bindicate == 10) {
	echo "<p><span class=\"none\">".BUILDING_MAX_LEVEL_UNDER."</span></p>";
} else if($bindicate == 11) {
	echo "<p><span class=\"none\">".BUILDING_BEING_DEMOLISHED."</span></p>";
} else {
	$loopsame = count($database->getBuildingByField($village->wid, $id));
	$doublebuild = 0;
	$master = count($database->getMasterJobsByField($village->wid,$id));

    //-- If available resources combined are not enough, remove NPC button
	$uprequire = $building->resourceRequired($id,$village->resarray['f'.$id.'t'],1 + $loopsame + $doublebuild + $master);
?>
<?php
$total_required = (int)($uprequire['wood'] + $uprequire['clay'] + $uprequire['iron'] + $uprequire['crop']);
?>
<div style="display: flex; flex-wrap: wrap; gap: 20px; align-items: stretch; margin-top: 15px;">
    <!-- Column 1: Normal Upgrade -->
    <div style="flex: 1; min-width: 250px;">
        <p id="contract" style="margin-top:0;"><b><?php echo COSTS_UPGRADING_LEVEL;?> <?php echo $village->resarray['f'.$id]+1+$loopsame+$doublebuild+$master; ?>:</b><br />
        <link rel="stylesheet" type="text/css" href="responsive_blocks.css" />
        <div class="res-wrap">
            <span class="res-item"><img class="r1" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG == 'ar') ? 'الخشب' : 'Lumber'; ?>" title="<?php echo (defined('LANG') && LANG == 'ar') ? 'الخشب' : 'Lumber'; ?>" /><?php echo number_format($uprequire['wood']); ?></span>
            <span class="res-item"><img class="r2" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG == 'ar') ? 'الطين' : 'Clay'; ?>" title="<?php echo (defined('LANG') && LANG == 'ar') ? 'الطين' : 'Clay'; ?>" /><?php echo number_format($uprequire['clay']); ?></span>
            <span class="res-item"><img class="r3" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG == 'ar') ? 'الحديد' : 'Iron'; ?>" title="<?php echo (defined('LANG') && LANG == 'ar') ? 'الحديد' : 'Iron'; ?>" /><?php echo number_format($uprequire['iron']); ?></span>
            <span class="res-item"><img class="r4" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG == 'ar') ? 'القمح' : 'Crop'; ?>" title="<?php echo (defined('LANG') && LANG == 'ar') ? 'القمح' : 'Crop'; ?>" /><?php echo number_format($uprequire['crop']); ?></span>
            <span class="res-item"><img class="r5" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG == 'ar') ? 'استهلاك القمح' : 'Crop consumption'; ?>" title="<?php echo (defined('LANG') && LANG == 'ar') ? 'استهلاك القمح' : 'Crop consumption'; ?>" /><?php echo $uprequire['pop']; ?></span>
        <?php
        if($session->gold >= 3 && $village->acrop >= 0) {
                           $npc_label = (defined('LANG') && LANG == 'ar') ? NPC_TRADE : 'NPC trade';
                           $npc_style = (defined('LANG') && LANG == 'ar') ? ' style="transform:scaleX(-1);display:inline-block;"' : '';
                           echo "<span class=\"res-item\"><a href=\"build.php?gid=17&t=3&r1=".$uprequire['wood']."&r2=".$uprequire['clay']."&r3=".$uprequire['iron']."&r4=".$uprequire['crop']."\" title=\"".$npc_label."\"><img class=\"npc\" src=\"img/x.gif\" alt=\"".$npc_label."\" title=\"".$npc_label."\"".$npc_style." /></a></span>";
        } 
        ?>
        </div>
        </p><br />
<?php
    if($village->acrop < 0) {
        echo "<span class=\"none\">Paralyzed: Crop storage is negative. You Cannot Build Or Upgrade.</span>";
    } else if($bindicate == 2) {
   		echo "<span class=\"none\">".WORKERS_ALREADY_WORK."</span>";
	if($session->goldclub == 1){
?>	</br>
<?php
	if($id <= 18) {
	if($session->gold >= 1 && $village->master == 0){
	    echo "<a class=\"build\" href=\"dorf1.php?master=$bid&id=$id&c=$session->checker\">".CONSTRUCTING_MASTER_BUILDER." </a>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}else{
		echo "<span class=\"none\">".CONSTRUCTING_MASTER_BUILDER."</span>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}
	}else{
	if($session->gold >= 1 && $village->master == 0){
	    echo "<a class=\"build\" href=\"dorf2.php?master=$bid&id=$id&c=$session->checker\">".CONSTRUCTING_MASTER_BUILDER." </a>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}else{
		echo "<span class=\"none\">".CONSTRUCTING_MASTER_BUILDER."</span>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}
	}
	}
    }
    else if($bindicate == 3) {
    	echo "<span class=\"none\">".WORKERS_ALREADY_WORK_WAITING."</span>";
	if($session->goldclub == 1){
?>	</br>
<?php
	if($id <= 18) {
	if($session->gold >= 1 && $village->master == 0){
	    echo "<a class=\"build\" href=\"dorf1.php?master=$bid&id=$id&c=$session->checker\">".CONSTRUCTING_MASTER_BUILDER." </a>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}else{
		echo "<span class=\"none\">".CONSTRUCTING_MASTER_BUILDER."</span>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}
	}else{
	if($session->gold >= 1 && $village->master == 0){
	    echo "<a class=\"build\" href=\"dorf2.php?master=$bid&id=$id&c=$session->checker\">".CONSTRUCTING_MASTER_BUILDER." </a>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}else{
		echo "<span class=\"none\">".CONSTRUCTING_MASTER_BUILDER."</span>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}
	}
	}
    }
    else if($bindicate == 4) {
    	echo "<span class=\"none\">".ENOUGH_FOOD_EXPAND_CROPLAND."</span>";
    }
    else if($bindicate == 5) {
    	echo "<span class=\"none\">".UPGRADE_WAREHOUSE.".</span>";
    }
    else if($bindicate == 6) {
    	echo "<span class=\"none\">".UPGRADE_GRANARY.".</span>";
    }
    else if($bindicate == 7) {
	if($village->allcrop - $village->pop - $technology->getUpkeep($village->unitall, 0) > 0){
    	$neededtime = $building->calculateAvaliable($id,$village->resarray['f'.$id.'t'],1+$loopsame+$doublebuild+$master);
    	echo "<span class=\"none\">".ENOUGH_RESOURCES." ".$neededtime[0]." at  ".$neededtime[1]."</span>";
	}else{
		echo "<span class=\"none\">".YOUR_CROP_NEGATIVE."</span>";
	}
	if($session->goldclub == 1){
?>	</br>
<?php
	if($id <= 18) {
	if($session->gold >= 1 && $village->master == 0){
	    echo "<a class=\"build\" href=\"dorf1.php?master=$bid&id=$id&c=$session->checker\">".CONSTRUCTING_MASTER_BUILDER." </a>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}else{
		echo "<span class=\"none\">".CONSTRUCTING_MASTER_BUILDER."</span>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}
	}else{
	if($session->gold >= 1 && $village->master == 0){
	    echo "<a class=\"build\" href=\"dorf2.php?master=$bid&id=$id&c=$session->checker\">".CONSTRUCTING_MASTER_BUILDER." </a>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}else{
		echo "<span class=\"none\">".CONSTRUCTING_MASTER_BUILDER."</span>";
		echo '<font color="#B3B3B3">('.COSTS.': <img src="'.GP_LOCATE.'img/a/gold_g.gif" alt="Gold" title="'.GOLD.'"/>1)</font>';
	}
	}
	}
    }
    else if($bindicate == 8) {
		if($session->access==BANNED){
    	echo "<a class=\"build\" href=\"banned.php\">".UPGRADE_LEVEL." ";
		}
		else if($id <= 18) {
    	echo "<a class=\"build\" href=\"dorf1.php?a=$id&c=$session->checker\">".UPGRADE_LEVEL." ";
        }
        else {
        echo "<a class=\"build\" href=\"dorf2.php?a=$id&c=$session->checker\">".UPGRADE_LEVEL." ";
        }
		echo $village->resarray['f'.$id]+1;
		echo ".</a>";
		}
    else if($bindicate == 9) {
		if($session->access==BANNED){
    	echo "<a class=\"build\" href=\"banned.php\">".UPGRADE_LEVEL." ";
		}
    	else if($id <= 18) {
    	echo "<a class=\"build\" href=\"dorf1.php?a=$id&c=$session->checker\">".UPGRADE_LEVEL." ";
        }
        else {
        echo "<a class=\"build\" href=\"dorf2.php?a=$id&c=$session->checker\">".UPGRADE_LEVEL." ";
        }
		echo $village->resarray['f'.$id] + 1 + $loopsame + $master;
		echo ".</a> <span class=\"none\">".WAITING."</span> ";
    }

    echo '</div>'; // End of Column 1

    // Column 2: Max Level Upgrade
    $currentBuildingType = $village->resarray['f'.$id.'t'];
    $currentBuildingLevel = (int) $village->resarray['f'.$id];
    $buildingMaxLevel = $building->getMaxLevel($currentBuildingType);
    $excludeFromGoldMax = [25, 26, 40];

    if ($currentBuildingType > 0 && $currentBuildingLevel < $buildingMaxLevel && $buildingMaxLevel > 0 && !in_array($currentBuildingType, $excludeFromGoldMax)) {
        $upgradeCost = $buildingMaxLevel - $currentBuildingLevel;
        $upgrade_text = (defined('LANG') && LANG == 'ar') ? "تطوير الى مستوى ".$buildingMaxLevel : "Upgrade to level ".$buildingMaxLevel;
        
        echo '<div style="flex: 1; min-width: 150px; background: #fffafa; border: 1px solid #f5c6c6; border-radius: 6px; padding: 15px; display: flex; flex-direction: column; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(231, 76, 60, 0.08);">';
        
        if ($session->gold >= $upgradeCost) {
            echo "<a href=\"build.php?id=$id&upgradeToMax=1\" style=\"display:block; font-weight:bold; color:#27ae60; text-align:center; text-decoration:none; margin-bottom:8px; font-size:15px;\">$upgrade_text</a>";
            echo "<span style=\"display:flex; align-items:center; justify-content:center; gap:5px; font-size:16px; font-weight:bold; color:#d4af37;\">";
            echo "<img src=\"".GP_LOCATE."img/a/gold_g.gif\" alt=\"Gold\" /> $upgradeCost";
            echo "</span>";
        } else {
            echo "<span style=\"display:block; font-weight:bold; color:#c0392b; text-align:center; margin-bottom:8px; font-size:15px;\">$upgrade_text</span>";
            echo "<span style=\"display:flex; align-items:center; justify-content:center; gap:5px; font-size:16px; font-weight:bold; color:#d4af37;\">";
            echo "<img src=\"".GP_LOCATE."img/a/gold_g.gif\" alt=\"Gold\" /> $upgradeCost";
            echo "</span>";
        }
        
        echo '</div>';
    }

    echo '</div>'; // End of Flex Container
}



// Gold demolish (هدم بالذهب) is only available in the Main Building (المبنى الرئيسي)

?>
