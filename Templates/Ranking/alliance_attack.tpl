<?php
if(!is_numeric($_SESSION['search'])) {
?>
	<center><font color=orange size=2><p class=\"error\"><?php echo (defined('LANG') && LANG === 'ar') ? 'التحالف' : 'The alliance'; ?> <b>"<?php echo $_SESSION['search']; ?>"</b> <?php echo (defined('LANG') && LANG === 'ar') ? 'غير موجود.' : 'does not exist.'; ?></p></font></center>
<?php
    $search = 0;
}
else $search = $_SESSION['search'];
?>
<table cellpadding="1" cellspacing="1" id="alliance_off" class="row_table_data">
			<thead>
				<tr>
					<th colspan="5">
						<?php echo (defined('LANG') && LANG === 'ar') ? 'أنجح التحالفات هجوماً' : 'The best alliances (off)'; ?>						
						<div id="submenu">

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'العشرة الأوائل' : 'Top 10'; ?>"
href="statistiken.php?id=43">
<img class="btn_top10" src="img/x.gif"
alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'العشرة الأوائل' : 'Top 10'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'مدافع' : 'defender'; ?>"
href="statistiken.php?id=42">
<img class="btn_def" src="img/x.gif"
alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'مدافع' : 'defender'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'مهاجم' : 'attacker'; ?>"
href="statistiken.php?id=41">
<img class="btn_off active" src="img/x.gif"
alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'مهاجم' : 'attacker'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'سارق' : 'looter'; ?>"
href="statistiken.php?id=44">
<img class="btn_loot" src="img/x.gif"
style="width:30px;height:30px;background:url('gpack/travian_t4/img/s/loot.gif') no-repeat 0 top;"
alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'سارق' : 'looter'; ?>">
</a>

</div>
					</th>
				</tr>
		<tr><td></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'التحالف' : 'Alliance'; ?></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'عدد اللاعبين' : 'Player'; ?></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'النقاط' : 'Points'; ?></td></tr>
		</thead><tbody>
        <?php
        $rankArray = $ranking->getRank();
        if(isset($_GET['rank'])){
            $multiplier = 1;
            if(is_numeric($_GET['rank'])) {
                if($_GET['rank'] > count($rankArray)) {
                    $_GET['rank'] = count($rankArray) - 1;
                }
                
                while($_GET['rank'] > (20*$multiplier))  $multiplier++;
                
                $start = 20 * $multiplier - 19;
            }
            else $start = ($_SESSION['start'] + 1);
        }
        else $start = ($_SESSION['start'] + 1);
        
        if(count($rankArray) > 1) {
            for($i = $start; $i < $start + 20; $i++) {
                if(isset($rankArray[$i]['name']) && $rankArray[$i] != "pad") {
                    if($i == $search) echo "<tr class=\"hl\"><td class=\"ra fc\" >";
                    else echo "<tr><td class=\"ra \" >";
                    
                    echo $i.".</td><td class=\"al \" ><a href=\"allianz.php?aid=".$rankArray[$i]['id']."\">".$rankArray[$i]['tag']."</a></td><td class=\"pla \" >";
                    echo $rankArray[$i]['players']."</td><td class=\"po \">".$rankArray[$i]['Aap']."</td></tr>";
                }
            }
        }
        else echo "<td class=\"none\" colspan=\"5\">".(defined('LANG') && LANG === 'ar' ? 'لا توجد تحالفات' : 'No alliances found')."</td>";
        ?>
 </tbody>
</table>
<?php
include("ranksearch.tpl");
?>
