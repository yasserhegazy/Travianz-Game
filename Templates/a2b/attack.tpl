<?php
$ckey = $generator->generateRandStr(6);

 if (!isset($process['t1']) || $process['t1'] == ''){  $t1 = 0; }else{  $t1 = $process['t1']; }
 if (!isset($process['t2']) || $process['t2'] == ''){  $t2 = 0; }else{  $t2 = $process['t2']; }
 if (!isset($process['t3']) || $process['t3'] == ''){  $t3 = 0; }else{  $t3 = $process['t3']; if ($session->tribe == 3) $scout=1; }
 if (!isset($process['t4']) || $process['t4'] == ''){  $t4 = 0; }else{  $t4 = $process['t4']; if ($session->tribe == 1 || $session->tribe == 2 || $session->tribe == 4 || $session->tribe == 5) $scout=1; }
 if (!isset($process['t5']) || $process['t5'] == ''){  $t5 = 0; }else{  $t5 = $process['t5']; }
 if (!isset($process['t6']) || $process['t6'] == ''){  $t6 = 0; }else{  $t6 = $process['t6']; }
 if (!isset($process['t7']) || $process['t7'] == ''){  $t7 = 0; }else{  $t7 = $process['t7']; }
 if (!isset($process['t8']) || $process['t8'] == ''){  $t8 = 0; }else{  $t8 = $process['t8']; }
 if (!isset($process['t9']) || $process['t9'] == ''){  $t9 = 0; }else{  $t9 = $process['t9']; }
 if (!isset($process['t10']) || $process['t10'] == ''){  $t10 = 0; }else{  $t10 = $process['t10']; }
 if (!isset($process['t11']) || $process['t11'] == ''){  $t11 = 0; }else{  $t11 = $process['t11']; $showhero=1; }
 

$totalunits = 0;
for($i = 1; $i <= 11; $i++){
    $totalunits += (($i != 3 && $session->tribe == 3) ||
                    ($i != 4 && $session->tribe != 3)) ? (!empty($process['t'.$i]) ? $process['t'.$i] : 0) : 0;
}
 
if (isset($scout) && $scout == 1 && isset($totalunits) && $totalunits == 0 && $process['c'] != 2) {
    $process['c'] = 1;
}
$id = $database->addA2b($ckey, time(), $process['0'], $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9, $t10, $t11, $process['c']);

$actionType = (["Scout", "Reinforcement", "Normal attack", "Raid"])[$process['c'] - 1];

$uid = $session->uid;
$tribe = $session->tribe;
$start = ($tribe - 1) * 10 + 1;
$end = $tribe * 10;
?>

<h1><?php echo $actionType." to ".$process[1]; ?></h1>
<form method="post" action="a2b.php">

            <table id="short_info" cellpadding="1" cellspacing="1">

                <tbody>

                    <tr>

                        <th><?php echo (defined('LANG') && LANG === 'ar') ? 'الهدف:' : 'Destination:'; ?></th>

                        <td><a href="karte.php?d=<?php echo $process[0]; ?>&c=<?php echo $generator->getMapCheck($process[0]); ?>"><?php echo $process[1]; ?> (<?php echo $coor['x']; ?>|<?php echo $coor['y']; ?>)</a></td>

                    </tr>

                    <tr>

                        <th><?php echo (defined('LANG') && LANG === 'ar') ? 'المالك:' : 'Owner:'; ?></th>

                        <td><a href="spieler.php?uid=<?php echo $process['2']; ?>"><?php echo $database->getUserField($process['2'],'username',0); ?></a></td>

                    </tr>

                </tbody>

            </table>



            <table class="troop_details" cellpadding="1" cellspacing="1">

                <thead>

                    <tr>

                        <td><?php echo $process[1]; ?></td>

                        <td colspan="<?php if(!empty($process['t11'])){ echo"11"; }else{ echo"10"; } ?>"><?php echo $actionType." to ".$process['1']; ?></td>

                    </tr>

                </thead>

                <tbody class="units">

                    <tr>

                        <td></td>
                 <?php
                for($i=$start;$i<=($end);$i++) {
                      echo "<td><img src=\"img/x.gif\" class=\"unit u$i\" title=\"".$technology->getUnitName($i)."\" alt=\"".$technology->getUnitName($i)."\" /></td>";
                  } if (!empty($process['t11'])){
                  $heroName = (defined('LANG') && LANG === 'ar') ? 'البطل' : 'Hero';
                  echo "<td><img src=\"img/x.gif\" class=\"unit uhero\" title=\"$heroName\" alt=\"$heroName\" /></td>";

                  }?>

                    </tr>

                    <tr>

                        <th><?php echo (defined('LANG') && LANG === 'ar') ? 'القوات' : 'Troops'; ?></th>

                        <td <?php if (!isset($process['t1']) || $process['t1'] == ''){ echo "class=\"none\">0"; }else{ echo ">".$process['t1'];} ?></td>

                        <td <?php if (!isset($process['t2']) || $process['t2'] == ''){ echo "class=\"none\">0"; }else{ echo ">".$process['t2'];} ?></td>

                        <td <?php if (!isset($process['t3']) || $process['t3'] == ''){ echo "class=\"none\">0"; }else{ echo ">".$process['t3'];} ?></td>

                        <td <?php if (!isset($process['t4']) || $process['t4'] == ''){ echo "class=\"none\">0"; }else{ echo ">".$process['t4'];} ?></td>

                        <td <?php if (!isset($process['t5']) || $process['t5'] == ''){ echo "class=\"none\">0"; }else{ echo ">".$process['t5'];} ?></td>

                        <td <?php if (!isset($process['t6']) || $process['t6'] == ''){ echo "class=\"none\">0"; }else{ echo ">".$process['t6'];} ?></td>

                        <td <?php if (!isset($process['t7']) || $process['t7'] == ''){ echo "class=\"none\">0"; }else{ echo ">".$process['t7'];} ?></td>

                        <td <?php if (!isset($process['t8']) || $process['t8'] == ''){ echo "class=\"none\">0"; }else{ $kata='1'; echo ">".$process['t8'];} ?></td>

                        <td <?php if (!isset($process['t9']) || $process['t9'] == ''){ echo "class=\"none\">0"; }else{ echo ">".$process['t9'];} ?></td>

                        <td <?php if (!isset($process['t10']) || $process['t10'] == ''){ echo "class=\"none\">0"; }else{ echo ">".$process['t10'];} ?></td>

                        <?php if (!isset($process['t11']) || $process['t11'] == ''){ echo ""; }else{ echo "<td>".$process['t11']."</td>";} ?>

                     </tr>

                </tbody>
                                         <?php                if ($process['c']==1){

?>
                <tbody class="options">
        <tr>
            <th><?php echo (defined('LANG') && LANG === 'ar') ? 'الخيارات' : 'Options'; ?></th>
            <td colspan="<?php if(!empty($process['t11'])){ echo"11"; }else{ echo"10"; } ?>"><input class="radio" name="spy" value="1" checked="checked" type="radio"><?php echo (defined('LANG') && LANG === 'ar') ? 'تجسس على الموارد والقوات' : 'Scout resources and troops'; ?><br>
            <input class="radio" name="spy" value="2" type="radio"><?php echo (defined('LANG') && LANG === 'ar') ? 'تجسس على الدفاعات والقوات' : 'Scout defences and troops'; ?></td>
        </tr>
    </tbody>
    <?php } ?>


        <?php if(isset($kata) && $process['c'] != 2){?><tr>

            <?php if($process['c']== 3){ ?><tbody class="cata">
                <tr>
                    <th><?php echo (defined('LANG') && LANG === 'ar') ? 'الهدف:' : 'Destination:'; ?></th>
                    <td colspan="<?php echo !empty($process['t11']) ? 11 : 10; ?>">

                        <select name="ctar1" class="dropdown">
                            <option value="0"><?php echo (defined('LANG') && LANG === 'ar') ? 'عشوائي' : 'Random'; ?></option>
                            <?php if($building->getTypeLevel(16) >= 5) { ?>
                <optgroup label="<?php echo (defined('LANG') && LANG === 'ar') ? 'الموارد' : 'Resources'; ?>">
                <option value="1"><?php echo (defined('LANG') && LANG === 'ar') ? 'الحطاب' : 'Woodcutter'; ?></option>
                                <option value="2"><?php echo (defined('LANG') && LANG === 'ar') ? 'حفرة الطين' : 'Clay Pit'; ?></option>
                                <option value="3"><?php echo (defined('LANG') && LANG === 'ar') ? 'منجم الحديد' : 'Iron Mine'; ?></option>
                                <option value="4"><?php echo (defined('LANG') && LANG === 'ar') ? 'حقل القمح' : 'Cropland'; ?></option>
                                <option value="5"><?php echo (defined('LANG') && LANG === 'ar') ? 'معمل النشر' : 'Sawmill'; ?></option>
                                <option value="6"><?php echo (defined('LANG') && LANG === 'ar') ? 'مصنع الطوب' : 'Brickyard'; ?></option>

                                <option value="7"><?php echo (defined('LANG') && LANG === 'ar') ? 'مسبك الحديد' : 'Iron Foundry'; ?></option>
                                <option value="8"><?php echo (defined('LANG') && LANG === 'ar') ? 'المطحنة' : 'Grain Mill'; ?></option>
                                <option value="9"><?php echo (defined('LANG') && LANG === 'ar') ? 'المخبز' : 'Bakery'; ?></option>
                            </optgroup>
                            <?php } ?>
                            <?php if($building->getTypeLevel(16) >= 3) { ?>
                            <optgroup label="<?php echo (defined('LANG') && LANG === 'ar') ? 'البنية التحتية' : 'Infrastructure'; ?>">
                                <option value="10"><?php echo (defined('LANG') && LANG === 'ar') ? 'المخزن' : 'Warehouse'; ?></option>
                                <option value="11"><?php echo (defined('LANG') && LANG === 'ar') ? 'مخزن الحبوب' : 'Granary'; ?></option>
                                <?php if($building->getTypeLevel(16) >= 10) { ?>
                                <option value="15"><?php echo (defined('LANG') && LANG === 'ar') ? 'المبنى الرئيسي' : 'Main building'; ?></option>
                                <option value="17"><?php echo (defined('LANG') && LANG === 'ar') ? 'السوق' : 'Marketplace'; ?></option>
                                <option value="18"><?php echo (defined('LANG') && LANG === 'ar') ? 'السفارة' : 'Embassy'; ?></option>
                                <option value="24"><?php echo (defined('LANG') && LANG === 'ar') ? 'البلدية' : 'Townhall'; ?></option>
                                <option value="25"><?php echo (defined('LANG') && LANG === 'ar') ? 'السكن' : 'Residence'; ?></option>
                                <option value="26"><?php echo (defined('LANG') && LANG === 'ar') ? 'القصر' : 'Palace'; ?></option>
                                <option value="27"><?php echo (defined('LANG') && LANG === 'ar') ? 'الخزنة' : 'Treasury'; ?></option>
                                <option value="28"><?php echo (defined('LANG') && LANG === 'ar') ? 'المكتب التجاري' : 'Trade office'; ?></option>
                                <option value="35"><?php echo (defined('LANG') && LANG === 'ar') ? 'مصنع الجعة' : 'Brewery'; ?></option>
                                <?php } ?>
                                <option value="38"><?php echo (defined('LANG') && LANG === 'ar') ? 'المخزن الكبير' : 'Great warehouse'; ?></option>
                                <option value="39"><?php echo (defined('LANG') && LANG === 'ar') ? 'مخزن الحبوب الكبير' : 'Great granary'; ?></option>
                                <option value="40"><?php echo (defined('LANG') && LANG === 'ar') ? 'معجزة العالم' : 'Wonder of the World'; ?></option>
                            </optgroup>
                            <?php } ?>
                            <?php if($building->getTypeLevel(16) >= 10) { ?>
                            <optgroup label="<?php echo (defined('LANG') && LANG === 'ar') ? 'العسكرية' : 'Military'; ?>">
                                <option value="12"><?php echo (defined('LANG') && LANG === 'ar') ? 'الحداد' : 'Blacksmith'; ?></option>
                                <option value="13"><?php echo (defined('LANG') && LANG === 'ar') ? 'مستودع الأسلحة' : 'Armoury'; ?></option>
                                <option value="14"><?php echo (defined('LANG') && LANG === 'ar') ? 'ساحة البطولة' : 'Tournament square'; ?></option>
                                <option value="16"><?php echo (defined('LANG') && LANG === 'ar') ? 'نقطة التجمع' : 'Rally point'; ?></option>
                                <option value="19"><?php echo (defined('LANG') && LANG === 'ar') ? 'الثكنة' : 'Barracks'; ?></option>
                                <option value="20"><?php echo (defined('LANG') && LANG === 'ar') ? 'الإسطبل' : 'Stable'; ?></option>
                                <option value="21"><?php echo (defined('LANG') && LANG === 'ar') ? 'المصنع' : 'Workshop'; ?></option>

                                <option value="22"><?php echo (defined('LANG') && LANG === 'ar') ? 'الأكاديمية' : 'Academy'; ?></option>
                                <option value="29"><?php echo (defined('LANG') && LANG === 'ar') ? 'الثكنة الكبيرة' : 'Great barracks'; ?></option>
                                <option value="30"><?php echo (defined('LANG') && LANG === 'ar') ? 'الإسطبل الكبير' : 'Great stable'; ?></option>
                                <option value="37"><?php echo (defined('LANG') && LANG === 'ar') ? 'مبنى البطل' : 'Hero\'s mansion'; ?></option>
                            </optgroup>
                            <?php } ?>
                        </select>

            <?php if($building->getTypeLevel(16) == 20 && $process['t8'] >= 20) { ?>
                     <select name="ctar2" class="dropdown">
                <option value="0">-</option>
                <option value="99"><?php echo (defined('LANG') && LANG === 'ar') ? 'عشوائي' : 'Random'; ?></option>
                            <?php if($building->getTypeLevel(16) >= 5) { ?>
                            <optgroup label="<?php echo (defined('LANG') && LANG === 'ar') ? 'الموارد' : 'Resources'; ?>">
                                <option value="1"><?php echo (defined('LANG') && LANG === 'ar') ? 'الحطاب' : 'Woodcutter'; ?></option>
                                <option value="2"><?php echo (defined('LANG') && LANG === 'ar') ? 'حفرة الطين' : 'Clay Pit'; ?></option>
                                <option value="3"><?php echo (defined('LANG') && LANG === 'ar') ? 'منجم الحديد' : 'Iron Mine'; ?></option>
                                <option value="4"><?php echo (defined('LANG') && LANG === 'ar') ? 'حقل القمح' : 'Cropland'; ?></option>
                                <option value="5"><?php echo (defined('LANG') && LANG === 'ar') ? 'معمل النشر' : 'Sawmill'; ?></option>
                                <option value="6"><?php echo (defined('LANG') && LANG === 'ar') ? 'مصنع الطوب' : 'Brickyard'; ?></option>

                                <option value="7"><?php echo (defined('LANG') && LANG === 'ar') ? 'مسبك الحديد' : 'Iron Foundry'; ?></option>
                                <option value="8"><?php echo (defined('LANG') && LANG === 'ar') ? 'المطحنة' : 'Grain Mill'; ?></option>
                                <option value="9"><?php echo (defined('LANG') && LANG === 'ar') ? 'المخبز' : 'Bakery'; ?></option>
                            </optgroup>
                            <?php } ?>
                            <?php if($building->getTypeLevel(16) >= 3) { ?>
                            <optgroup label="<?php echo (defined('LANG') && LANG === 'ar') ? 'البنية التحتية' : 'Infrastructure'; ?>">
                                <option value="10"><?php echo (defined('LANG') && LANG === 'ar') ? 'المخزن' : 'Warehouse'; ?></option>
                                <option value="11"><?php echo (defined('LANG') && LANG === 'ar') ? 'مخزن الحبوب' : 'Granary'; ?></option>
                                <?php if($building->getTypeLevel(16) >= 10) { ?>
                                <option value="15"><?php echo (defined('LANG') && LANG === 'ar') ? 'المبنى الرئيسي' : 'Main building'; ?></option>
                                <option value="17"><?php echo (defined('LANG') && LANG === 'ar') ? 'السوق' : 'Marketplace'; ?></option>
                                <option value="18"><?php echo (defined('LANG') && LANG === 'ar') ? 'السفارة' : 'Embassy'; ?></option>
                                <option value="24"><?php echo (defined('LANG') && LANG === 'ar') ? 'البلدية' : 'Townhall'; ?></option>
                                <option value="25"><?php echo (defined('LANG') && LANG === 'ar') ? 'السكن' : 'Residence'; ?></option>
                                <option value="26"><?php echo (defined('LANG') && LANG === 'ar') ? 'القصر' : 'Palace'; ?></option>

                                <option value="27"><?php echo (defined('LANG') && LANG === 'ar') ? 'الخزنة' : 'Treasury'; ?></option>
                                <option value="28"><?php echo (defined('LANG') && LANG === 'ar') ? 'المكتب التجاري' : 'Trade office'; ?></option>
                                <option value="35"><?php echo (defined('LANG') && LANG === 'ar') ? 'مصنع الجعة' : 'Brewery'; ?></option>
                                <?php } ?>
                                <option value="38"><?php echo (defined('LANG') && LANG === 'ar') ? 'المخزن الكبير' : 'Great warehouse'; ?></option>
                                <option value="39"><?php echo (defined('LANG') && LANG === 'ar') ? 'مخزن الحبوب الكبير' : 'Great granary'; ?></option>
								<option value="40"><?php echo (defined('LANG') && LANG === 'ar') ? 'معجزة العالم' : 'Wonder of the World'; ?></option>
                            </optgroup>
                            <?php } ?>
                            <?php if($building->getTypeLevel(16) >= 10) { ?>
                            <optgroup label="<?php echo (defined('LANG') && LANG === 'ar') ? 'العسكرية' : 'Military'; ?>">
                                <option value="12"><?php echo (defined('LANG') && LANG === 'ar') ? 'الحداد' : 'Blacksmith'; ?></option>
                                <option value="13"><?php echo (defined('LANG') && LANG === 'ar') ? 'مستودع الأسلحة' : 'Armoury'; ?></option>
                                <option value="14"><?php echo (defined('LANG') && LANG === 'ar') ? 'ساحة البطولة' : 'Tournament square'; ?></option>
                                <option value="16"><?php echo (defined('LANG') && LANG === 'ar') ? 'نقطة التجمع' : 'Rally point'; ?></option>
                                <option value="19"><?php echo (defined('LANG') && LANG === 'ar') ? 'الثكنة' : 'Barracks'; ?></option>
                                <option value="20"><?php echo (defined('LANG') && LANG === 'ar') ? 'الإسطبل' : 'Stable'; ?></option>
                                <option value="21"><?php echo (defined('LANG') && LANG === 'ar') ? 'المصنع' : 'Workshop'; ?></option>

                                <option value="22"><?php echo (defined('LANG') && LANG === 'ar') ? 'الأكاديمية' : 'Academy'; ?></option>
                                <option value="29"><?php echo (defined('LANG') && LANG === 'ar') ? 'الثكنة الكبيرة' : 'Great barracks'; ?></option>
                                <option value="30"><?php echo (defined('LANG') && LANG === 'ar') ? 'الإسطبل الكبير' : 'Great stable'; ?></option>
                                <option value="37"><?php echo (defined('LANG') && LANG === 'ar') ? 'مبنى البطل' : 'Hero\'s mansion'; ?></option>
                            </optgroup>
                            <?php } ?>
                        </select>
                    <?php }?>

                    <span class="info"><?php echo (defined('LANG') && LANG === 'ar') ? '(سيتم الهجوم بالمقاليع)' : '(will be attacked by catapult(s))'; ?></span>
                     </td>
                </tr>
            </tbody><?PHP
            }
            else if($process['c']=='4')
            {
                ?><tbody class="infos">               
		<tr>
		<th><?php echo (defined('LANG') && LANG === 'ar') ? 'الهدف:' : 'Destination:'; ?></th>
        <td colspan="<?php echo !empty($process['t11']) ? 11 : 10; ?>">
                <?php

                echo (defined('LANG') && LANG === 'ar') ? 'تحذير: المقاليع تهاجم بفعالية <b>فقط</b> في الهجوم العادي (لا تأثير لها في النهب!)' : 'Warning: Catapult will <b>ONLY</b> shoot with a normal attack (they dont shoot with raids!)';
                ?>
        </td>
        </tr>
                <?php
            }
            ?>

        <?php } ?>



             <tbody class="infos">
    <tr>

   <th><?php echo (defined('LANG') && LANG === 'ar') ? 'الوصول:' : 'Arrived:'; ?></th>



            <?php               
            $troopsTime = $units->getWalkingTroopsTime($village->wid, $process[0], $session->uid, $session->tribe, $process, 1, 't');
            $time = $database->getArtifactsValueInfluence($session->uid, $village->wid, 2, $troopsTime);
            ?>

            <td colspan="<?php echo !empty($process['t11']) ? 11 : 10; ?>">

            <div class="in"><?php echo (defined('LANG') && LANG === 'ar') ? 'في' : 'in'; ?> <?php echo $generator->getTimeFormat($time); ?></div>

            <div class="at"><?php echo (defined('LANG') && LANG === 'ar') ? 'الساعة' : 'at'; ?> <span id="tp2"> <?php echo $generator->procMtime(date('U') + $time, 9)?></span><span> <?php echo (defined('LANG') && LANG === 'ar') ? 'ساعة' : 'hours'; ?></span></div>

            </td>

        </tr>

    </tbody>

</table>

<input name="timestamp" value="<?php echo time(); ?>" type="hidden">

<input name="timestamp_checksum" value="<?php echo $ckey; ?>" type="hidden">

<input name="ckey" value="<?php echo $id; ?>" type="hidden">

<input name="id" value="39" type="hidden">

<input name="a" value="533374" type="hidden">
<input name="c" value="3" type="hidden">


        <p class="btn"><input value="ok" name="s1" id="btn_ok"

class="dynamic_img " src="img/x.gif" alt="OK" type="image" onclick="if (this.disabled==false) {document.getElementsByTagName('form')[0].submit();} this.disabled=true;" onLoad="this.disabled=false;"></p>


</form>
</div>
