    <?php
	$place = $place1 = $place2 = $place3 = "?";


    for($i=1;$i<=0;$i++) {
    echo "Row ".$i;
    }

    $result = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE access<".(INCLUDE_ADMIN?"10":"8")." AND id > 5 AND tribe<=3 AND tribe > 0 AND ap > 0 ORDER BY ap DESC, id DESC Limit 10");
    $result2 = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE id = '".$session->uid."' ORDER BY ap DESC, id DESC Limit 1");
	?>
	<table cellpadding="1" cellspacing="1">
	<thead>
		<tr>
			<th>
<?php echo (defined('LANG') && LANG === 'ar') ? 'أفضل 10 لاعبين' : 'Top 10 players'; ?>

<div id="submenu">

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'العشرة الأوائل' : 'Top 10'; ?>" href="statistiken.php?id=7">
<img class="active btn_top10" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'العشرة الأوائل' : 'Top 10'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'مدافع' : 'defender'; ?>" href="statistiken.php?id=32">
<img class="btn_def" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'مدافع' : 'defender'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'مهاجم' : 'attacker'; ?>" href="statistiken.php?id=31">
<img class="btn_off" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'مهاجم' : 'attacker'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'سارق' : 'looter'; ?>" href="statistiken.php?id=40">
<img class="btn_loot" src="img/x.gif" style="width:30px;height:30px;background:url('gpack/travian_t4/img/s/loot.gif') no-repeat 0 top;" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'سارق' : 'looter'; ?>">
</a>

</div>

<div id="submenu2">

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'الرومان' : 'Romans'; ?>" href="statistiken.php?id=11">
<img class="btn_v1" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'الرومان' : 'Romans'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'الجرمان' : 'Teutons'; ?>" href="statistiken.php?id=12">
<img class="btn_v2" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'الجرمان' : 'Teutons'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'الإغريق' : 'Gauls'; ?>" href="statistiken.php?id=13">
<img class="btn_v3" src="img/x.gif" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'الإغريق' : 'Gauls'; ?>">
</a>

</div>

</th>
		</tr>
	</thead>
</table>
<table cellpadding="1" cellspacing="1" id="top10_offs" class="top10 row_table_data">
	<thead>
		<tr>
			<th onclick="return Popup(3,5)"><img src="img/x.gif" class="help" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'تعليمات' : 'Instructions'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'تعليمات' : 'Instructions'; ?>">
			</th>
			<th colspan="2"><?php echo (defined('LANG') && LANG === 'ar') ? 'مهاجمو اليوم' : 'Attackers of the day'; ?></th>
		</tr>
		<tr>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'المركز' : 'No.'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'اللاعب' : 'Player'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'النقاط' : 'Points'; ?></td>
		</tr>
	</thead>
	<tbody>
<?php
    $goldRewards = [1=>450, 2=>300, 3=>250, 4=>200, 5=>150, 6=>140, 7=>130, 8=>120, 9=>110, 10=>100];
    $i = 1;
    while($row = mysqli_fetch_array($result))
      {
	  if($row['id']==$session->uid) {
	  if($row['id']==$session->uid) {
	  $place = $i;
	  }
	  }
	  $reward = isset($goldRewards[$i]) ? ' <span style="color:#FFA500; font-size:10px; font-weight:bold" title="Gold Reward">💰 +'.$goldRewards[$i].'</span>' : '';
	  if($row['id']==$session->uid) echo "<tr class=\"own hl\">"; else echo "<tr>"; 
      echo "<td class=\"ra fc\">".$i++.".&nbsp;</td>";
      echo "<td class=\"pla\">".$database->getProtectedPlayerLink($row['id'], $row['username']).$reward."</td>";
      echo "<td class=\"val lc\">".$row['ap']."</td>";
      echo "</tr>";
      }
?>
		 <tr>
			<td colspan="3" class="empty"></td>
		</tr>
<?php
    while($row = mysqli_fetch_array($result2))
      {
		if($place == "?") {
    echo "<tr class=\"own hl\">";
} else {
    echo "<tr class=\"none\">";
}
      echo "<td class=\"ra fc\">".$place."&nbsp;</td>";
	  	if($row['id'] == $session->uid) {
		echo "<td class=\"pla\">".$database->getProtectedPlayerLink($row['id'], $row['username'])."</td>"; } else { echo "<td class=\"pla\">".$database->getProtectedPlayerLink(
    $row['id'],
    $row['username']
)."</td>"; }
      echo "<td class=\"val lc\">".$row['ap']."</td>";
      echo "</tr>";
      }
?>
         </tbody>
</table>


<?php
    $i = 1;
    $result = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE access<".(INCLUDE_ADMIN?"10":"8")." AND id > 5 AND tribe<=3 AND tribe > 0 ORDER BY dp DESC, id DESC Limit 10");
    $result2 = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE id = '".$session->uid."' ORDER BY dp DESC Limit 1");
?>
<table cellpadding="1" cellspacing="1" id="top10_defs" class="top10 row_table_data">
	<thead>
		<tr>
			<th onclick="return Popup(3,5)"><img src="img/x.gif" class="help" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'تعليمات' : 'Instructions'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'تعليمات' : 'Instructions'; ?>">
			</th>
			<th colspan="2"><?php echo (defined('LANG') && LANG === 'ar') ? 'مدافعو اليوم' : 'Defenders of the day'; ?></th>
		</tr>
		<tr>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'المركز' : 'No.'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'اللاعب' : 'Player'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'النقاط' : 'Points'; ?></td>
		</tr>
	</thead>
	<tbody>
<?php
    while($row = mysqli_fetch_array($result))
      {
		  if($row['dp'] <= 0) {
    continue;
}
	  if($row['id']==$session->uid) {
	  $place1 = $i;
	  }
	  $reward = isset($goldRewards[$i]) ? ' <span style="color:#FFA500; font-size:10px; font-weight:bold" title="Gold Reward">💰 +'.$goldRewards[$i].'</span>' : '';
	  if($row['id']==$session->uid) {
	  echo "<tr class=\"own hl\">"; } else { echo "<tr>"; }
      echo "<td class=\"ra fc\">".$i++.".&nbsp;</td>";
	  echo "<td class=\"pla\">".$database->getProtectedPlayerLink($row['id'], $row['username']).$reward."</td>";
      echo "<td class=\"val lc\">".$row['dp']."</td>";
      echo "</tr>";
      }
?>
	
		 <tr>
			<td colspan="3" class="empty"></td>
		</tr>
<?php
    while($row = mysqli_fetch_array($result2))
      {
     if($place1 == "?") {
    echo "<tr class=\"own hl\">";
} else {
    echo "<tr class=\"none\">";
}
      echo "<td class=\"ra fc\">".$place1."&nbsp;</td>";
     
		echo "<td class=\"pla\">".$database->getProtectedPlayerLink($row['id'], $row['username'])."</td>";
      echo "<td class=\"val lc\">".$row['dp']."</td>";
      echo "</tr>";
      }
?>
         </tbody>
</table>
	
<?php
    $i = 1;
    $result = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE access<".(INCLUDE_ADMIN?"10":"8")." AND id > 5 AND tribe<=3 AND tribe > 0 ORDER BY clp DESC, id DESC Limit 10");
    $result2 = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE id = '".$session->uid."' ORDER BY clp DESC Limit 1");
?>
<div class="clear"></div>
<table cellpadding="1" cellspacing="1" id="top10_climbers" class="top10 row_table_data">
	<thead>
		<tr>
			<th onclick="return Popup(3,5)"><img src="img/x.gif" class="help" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'تعليمات' : 'Instructions'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'تعليمات' : 'Instructions'; ?>">
			</th>
			<th colspan="2"><?php echo (defined('LANG') && LANG === 'ar') ? 'مطورو اليوم' : 'Climbers of the day'; ?></th>
		</tr>
		<tr>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'المركز' : 'No.'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'اللاعب' : 'Player'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'السكان' : 'Ranks'; ?></td>
		</tr>
	</thead>
	<tbody>
<?php
    while($row = mysqli_fetch_array($result))
      {
		  if($row['clp'] <= 0) {
    continue;
}
	  if($row['id']==$session->uid) {
	  $place2 = $i;
	  }
	  $reward = isset($goldRewards[$i]) ? ' <span style="color:#FFA500; font-size:10px; font-weight:bold" title="Gold Reward">💰 +'.$goldRewards[$i].'</span>' : '';
	  if($row['id']==$session->uid) {
	  echo "<tr class=\"own hl\">"; } else { echo "<tr>"; }
      echo "<td class=\"ra fc\">".$i++.".&nbsp;</td>";
      echo "<td class=\"pla\">".$database->getProtectedPlayerLink($row['id'], $row['username']).$reward."</td>";
      echo "<td class=\"val lc\">".$row['clp']."</td>";
      echo "</tr>";
      }
?>
		 <tr>
			<td colspan="3" class="empty"></td>
		</tr>
<?php
    while($row = mysqli_fetch_array($result2))
{
    if($place2 == "?") {
        echo "<tr class=\"own hl\">";
    } else {
        echo "<tr class=\"none\">";
    }

    echo "<td class=\"ra fc\">".$place2."&nbsp;</td>";

    if($place2 == "?") {
        echo "<td class=\"pla\">".$database->getProtectedPlayerLink($row['id'], $row['username'])."</td>";
    } else {
        echo "<td class=\"pla\">".$row['username']."</td>";
    }

    echo "<td class=\"val lc\">".$row['clp']."</td>";
    echo "</tr>";
}
?>
         </tbody>
</table>
<?php
    $i = 1;
    $result = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE access<".(INCLUDE_ADMIN?"10":"8")." AND id > 5 AND tribe<=3 AND tribe > 0 AND (RR - Rc) > 0 ORDER BY (RR - Rc) DESC, id DESC Limit 10");
    $result2 = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE id = '".$session->uid."' ORDER BY RR DESC Limit 1");
?>
<table cellpadding="1" cellspacing="1" id="top10_raiders" class="top10 row_table_data">
	<thead>
		<tr>
			<th onclick="return Popup(3,5)"><img src="img/x.gif" class="help" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'تعليمات' : 'Instructions'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'تعليمات' : 'Instructions'; ?>">
			</th>
			<th colspan="2"><?php echo (defined('LANG') && LANG === 'ar') ? 'سارقو اليوم' : 'Robbers of the day'; ?></th>
		</tr>
		<tr>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'المركز' : 'No.'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'اللاعب' : 'Player'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'الموارد' : 'Resources'; ?></td>
		</tr>
	</thead>
	<tbody>
<?php
    while($row = mysqli_fetch_array($result))
      {
	  if(($row['RR'] - $row['Rc']) > 0) {
	  if($row['id']==$session->uid) {
	  $place3 = $i;
	  }
	  $reward = isset($goldRewards[$i]) ? ' <span style="color:#FFA500; font-size:10px; font-weight:bold" title="Gold Reward">💰 +'.$goldRewards[$i].'</span>' : '';
	  if($row['id']==$session->uid) {
	  echo "<tr class=\"own hl\">"; } else { echo "<tr>"; }
      echo "<td class=\"ra fc\">".$i++.".&nbsp;</td>";
      echo "<td class=\"pla\">".$database->getProtectedPlayerLink($row['id'], $row['username']).$reward."</td>";
      echo "<td class=\"val lc\">".($row['RR'] - $row['Rc'])."</td>";
      echo "</tr>";
	  }
      }
?>
		 <tr>
			<td colspan="3" class="empty"></td>
		</tr>
<?php
    while($row = mysqli_fetch_array($result2))
{
    if($place3 == "?") {
        echo "<tr class=\"own hl\">";
    } else {
        echo "<tr class=\"none\">";
    }

    echo "<td class=\"ra fc\">".$place3."&nbsp;</td>";

    if($place3 == "?") {
        echo "<td class=\"pla\">".$database->getProtectedPlayerLink($row['id'], $row['username'])."</td>";
    } else {
        echo "<td class=\"pla\">".$row['username']."</td>";
    }

    echo "<td class=\"val lc\">".($row['RR'] - $row['Rc'])."</td>";
    echo "</tr>";
}
	  
//	mysqli_close($con);
?>
         </tbody>
</table>

<?php
// Calculate seconds until next midnight (00:00 server time)
$now = time();
$nextMidnight = strtotime('tomorrow midnight');
$secondsLeft = max(0, $nextMidnight - $now);
?>
<?php
$totalGold = 500;

if(isset($goldRewards[$place])) $totalGold += $goldRewards[$place];
if(isset($goldRewards[$place1])) $totalGold += $goldRewards[$place1];
if(isset($goldRewards[$place2])) $totalGold += $goldRewards[$place2];
if(isset($goldRewards[$place3])) $totalGold += $goldRewards[$place3];
?>

<div id="dailyGoldCountdown" style="
clear:both;
display:block;
position:relative;
z-index:1;
margin:10px auto;
max-width:520px;
padding:14px 18px;
background:#f7f3e7;
border:1px solid #c9b27a;
border-radius:8px;
text-align:center;
color:#4a3a1a;
font-family:'Noto Sans Arabic','Noto Sans',sans-serif;
clear:both;
">

    <div style="
    font-size:15px;
    margin-bottom:10px;
    ">
        <?php echo (defined('LANG') && LANG == 'ar') ? '500 ذهب مجاني لجميع اللاعبين + مكافأة إضافية لأفضل 10' : '500 free gold for all players + bonus for Top 10'; ?>
    </div>

    <div style="
    display:flex;
    justify-content:center;
    align-items:center;
    gap:10px;
    direction:rtl;
    margin-bottom:12px;
    ">

        <div style="
        border:1px solid #c9b27a;
        border-radius:6px;
        padding:8px 12px;
        min-width:60px;
        background:#fff;
        ">
            <div id="dgSeconds" style="
            font-size:30px;
            font-weight:normal;
            line-height:1;
            ">00</div>

            <div style="
            font-size:10px;
            margin-top:4px;
            ">
                <?php echo (defined('LANG') && LANG == 'ar') ? 'ثانية' : 'Sec'; ?>
            </div>
        </div>

        <span style="
        font-size:24px;
        font-weight:normal;
        ">:</span>

        <div style="
        border:1px solid #c9b27a;
        border-radius:6px;
        padding:8px 12px;
        min-width:60px;
        background:#fff;
        ">
            <div id="dgMinutes" style="
            font-size:30px;
            font-weight:normal;
            line-height:1;
            ">00</div>

            <div style="
            font-size:10px;
            margin-top:4px;
            ">
                <?php echo (defined('LANG') && LANG == 'ar') ? 'دقيقة' : 'Min'; ?>
            </div>
        </div>

        <span style="
        font-size:24px;
        font-weight:normal;
        ">:</span>

        <div style="
        border:1px solid #c9b27a;
        border-radius:6px;
        padding:8px 12px;
        min-width:60px;
        background:#fff;
        ">
            <div id="dgHours" style="
            font-size:30px;
            font-weight:normal;
            line-height:1;
            ">00</div>

            <div style="
            font-size:10px;
            margin-top:4px;
            ">
                <?php echo (defined('LANG') && LANG == 'ar') ? 'ساعة' : 'Hours'; ?>
            </div>
        </div>

    </div>

    <div style="
    font-size:14px;
    ">
        <?php echo (defined('LANG') && LANG == 'ar') ? 'بنهاية اليوم سوف تحصل على ' : 'At the end of the day you will receive '; ?>

        <span style="
        color:#c69214;
        font-weight:bold;
        font-size:20px;
        ">
            <?php echo $totalGold; ?>
        </span>

        <?php echo (defined('LANG') && LANG == 'ar') ? ' ذهب' : ' gold'; ?>
    </div>

</div>
<script type="text/javascript">
(function(){
    var left = <?php echo (int)$secondsLeft; ?>;
    function pad(n){ return n < 10 ? '0'+n : n; }
    function tick(){
        if(left <= 0){
            document.getElementById('dgHours').textContent = '00';
            document.getElementById('dgMinutes').textContent = '00';
            document.getElementById('dgSeconds').textContent = '00';
            return;
        }
        var h = Math.floor(left/3600);
        var m = Math.floor((left%3600)/60);
        var s = left%60;
        document.getElementById('dgHours').textContent = pad(h);
        document.getElementById('dgMinutes').textContent = pad(m);
        document.getElementById('dgSeconds').textContent = pad(s);
        left--;
    }
    tick();
    setInterval(tick, 1000);
})();
</script>
