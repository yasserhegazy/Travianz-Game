<?php 
if(!is_numeric($_SESSION['search'])) {
?>
	<center><font color=orange size=2><p class=\"error\"><?php echo (defined('LANG') && LANG === 'ar') ? 'اللاعب' : 'The user'; ?> <b>"<?php echo $_SESSION['search']; ?>"</b> <?php echo (defined('LANG') && LANG === 'ar') ? 'غير موجود.' : 'does not exist.'; ?></p></font></center>
<?php
    $search = 0;
}
else {
    $search = $_SESSION['search'];
}
?>

<table cellpadding="1" cellspacing="1" id="player_loot" class="row_table_data">
<thead>
<tr>
<th colspan="3">

<?php echo (defined('LANG') && LANG === 'ar') ? 'أنجح الناهبين' : 'The most successful looters'; ?>

<div id="submenu">

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'العشرة الأوائل' : 'Top 10'; ?>" href="statistiken.php?id=7">
<img class="btn_top10" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'العشرة الأوائل' : 'Top 10'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'مدافع' : 'defender'; ?>" href="statistiken.php?id=32">
<img class="btn_def" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'مدافع' : 'defender'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'مهاجم' : 'attacker'; ?>" href="statistiken.php?id=31">
<img class="btn_off" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'مهاجم' : 'attacker'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'سارق' : 'looter'; ?>" href="statistiken.php?id=40">
<img class="active btn_loot" src="img/x.gif" style="width:30px;height:30px;background:url('gpack/travian_t4/img/s/loot.gif') no-repeat 0 bottom;" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'سارق' : 'looter'; ?>">
</a>

</div>

</th>
</tr>

<tr>
<td style="width:55px;"></td>

<td style="width:220px;">
<?php echo (defined('LANG') && LANG === 'ar') ? 'اللاعب' : 'Player'; ?>
</td>

<td style="width:420px;">
<?php echo (defined('LANG') && LANG === 'ar') ? 'صافي النهب' : 'Loot'; ?>
</td>
</tr>
</thead>

<tbody>
<?php
$rankArray = $ranking->getRank();

if(isset($_GET['rank'])){
    $multiplier = 1;
    if(is_numeric($_GET['rank'])) {
        if($_GET['rank'] > count($rankArray)) {
            $_GET['rank'] = count($rankArray) - 1;
        }
        while($_GET['rank'] > (20 * $multiplier)) $multiplier++;
        $start = 20 * $multiplier - 19;
    }
    else {
        $start = ($_SESSION['start'] + 1);
    }
}
else {
    $start = ($_SESSION['start'] + 1);
}

if(count($rankArray) > 1) {
    for($i = $start; $i < $start + 20; $i++) {
        if(isset($rankArray[$i]['username']) && $rankArray[$i] != "pad") {

            if($i == $search) {
                echo "<tr class=\"hl\"><td class=\"ra fc\">";
            } else {
                echo "<tr><td class=\"ra\">";
            }

            echo $i.".</td><td class=\"pla\" style=\"width:220px;text-align:right;\"> ";
            echo $database->getProtectedPlayerLink(
                $rankArray[$i]['id'],
                $rankArray[$i]['username']
            );

            $loot = $rankArray[$i]['loot'];

$lootColor = ($loot < 0) ? '#8B0000' : '#006400';

echo "</td><td class=\"po\" style=\"width:420px;color:".$lootColor.";\"><span dir=\"ltr\">".(($loot < 0 ? '-' : '') . number_format(abs($loot)))."</span></td></tr>";
        }
    }
}
else {
    echo "<td class=\"none\" colspan=\"3\">".(defined('LANG') && LANG === 'ar' ? 'لا يوجد لاعبون' : 'No users found')."</td>";
}
?>
</tbody>
</table>

<?php 
include("ranksearch.tpl");
?>