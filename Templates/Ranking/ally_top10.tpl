    <?php
	$place = $place1 = $place2 = $place3 = "?";   

	for($i=1;$i<=0;$i++) {
    echo "Row ".$i;
    }
	
    $result = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."alidata WHERE ap > 0 ORDER BY ap DESC, id DESC Limit 10");
    $result2 = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."alidata WHERE id = '".$session->alliance."' ORDER BY ap DESC, id DESC Limit 1");
	?>
	<table cellpadding="1" cellspacing="1">
	<thead>
		<tr>
			<th><?php echo (defined('LANG') && LANG === 'ar') ? 'أفضل 10 تحالفات' : 'Top 10 Alliances'; ?>
			<div id="submenu">

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'العشرة الأوائل' : 'Top 10'; ?>"
href="statistiken.php?id=43">
<img class="btn_top10 active" src="img/x.gif"
alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'العشرة الأوائل' : 'Top 10'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'مدافع' : 'defender'; ?>"
href="statistiken.php?id=42">
<img class="btn_def" src="img/x.gif"
alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'مدافع' : 'defender'; ?>">
</a>

<a title="<?php echo (defined('LANG') && LANG === 'ar') ? 'مهاجم' : 'attacker'; ?>"
href="statistiken.php?id=41">
<img class="btn_off" src="img/x.gif"
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
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'التحالف' : 'Alliance'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'النقاط' : 'Points'; ?></td>
		</tr>
	</thead>
	<tbody>
<?php
    while($row = mysqli_fetch_array($result))
      {
	  if($row['id']==$session->alliance) {
	  $place = $i;
	  }
	  if($row['id']==$session->alliance) {
	  echo "<tr class=\"own hl\">"; } else { echo "<tr>"; }
      echo "<td class=\"ra fc\">".$i++.".&nbsp;</td>";
      echo "<td class=\"pla\"><a href='allianz.php?aid=".$row['id']."'>".$row['tag']."</a></td>";
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

    if($place == "?") {
        echo "<td class=\"pla\"><a href=\"allianz.php?aid=".$row['id']."\">".$row['tag']."</a></td>";
    } else {
        echo "<td class=\"pla\">".$row['tag']."</td>";
    }

    echo "<td class=\"val lc\">".$row['ap']."</td>";
    echo "</tr>";
}
?>
         </tbody>
</table>


<?php
    for($i=1;$i<=0;$i++) {
    echo "Row ".$i;
    }
    $result = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."alidata WHERE dp > 0 ORDER BY dp DESC, id DESC Limit 10");
    $result2 = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."alidata WHERE id = '".$session->alliance."' ORDER BY dp DESC Limit 1");
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
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'التحالف' : 'Alliance'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'النقاط' : 'Points'; ?></td>
		</tr>
	</thead>
	<tbody>
<?php
    while($row = mysqli_fetch_array($result))
      {
	  if($row['id']==$session->alliance) {
	  $place1 = $i;
	  }
	  if($row['id']==$session->alliance) {
	  echo "<tr class=\"own hl\">"; } else { echo "<tr>"; }
      echo "<td class=\"ra fc\">".$i++.".&nbsp;</td>";
	  echo "<td class=\"pla\"><a href='allianz.php?aid=".$row['id']."'>".$row['tag']."</a></td>";
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

    if($place1 == "?") {
        echo "<td class=\"pla\"><a href=\"allianz.php?aid=".$row['id']."\">".$row['tag']."</a></td>";
    } else {
        echo "<td class=\"pla\">".$row['tag']."</td>";
    }

    echo "<td class=\"val lc\">".$row['dp']."</td>";
    echo "</tr>";
}
?>
         </tbody>
</table>
	
<?php
    for($i=1;$i<=0;$i++) {
    echo "Row ".$i;
    }
    $result = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."alidata WHERE clp > 0 ORDER BY clp DESC, id DESC Limit 10");
    $result2 = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."alidata WHERE id = '".$session->alliance."' ORDER BY clp DESC Limit 1");
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
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'التحالف' : 'Alliance'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'السكان' : 'Population'; ?></td>
		</tr>
	</thead>
	<tbody>
<?php
    while($row = mysqli_fetch_array($result))
      {
	  if($row['id']==$session->alliance) {
	  $place2 = $i;
	  }
	  if($row['id']==$session->alliance) {
	  echo "<tr class=\"own hl\">"; } else { echo "<tr>"; }
      echo "<td class=\"ra fc\">".$i++.".&nbsp;</td>";
      echo "<td class=\"pla\"><a href='allianz.php?aid=".$row['id']."'>".$row['tag']."</a></td>";
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
        echo "<td class=\"pla\"><a href=\"allianz.php?aid=".$row['id']."\">".$row['tag']."</a></td>";
    } else {
        echo "<td class=\"pla\">".$row['tag']."</td>";
    }

    echo "<td class=\"val lc\">".$row['clp']."</td>";
    echo "</tr>";
}
?>
         </tbody>
</table>
<?php
    for($i=1;$i<=0;$i++) {
    echo "Row ".$i;
    }
    $result = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."alidata WHERE (RR - Rc) > 0 ORDER BY (RR - Rc) DESC, id DESC Limit 10");
    $result2 = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."alidata WHERE id = '".$session->alliance."' ORDER BY (RR - Rc) DESC Limit 1");
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
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'التحالف' : 'Alliance'; ?></td>
			<td><?php echo (defined('LANG') && LANG === 'ar') ? 'الموارد' : 'Resources'; ?></td>
		</tr>
	</thead>
	<tbody>
<?php
    while($row = mysqli_fetch_array($result))
      {
	  if(($row['RR'] - $row['Rc']) > 0) {
	  if($row['id']==$session->alliance) {
	  $place3 = $i;
	  }
	  if($row['id']==$session->alliance) {
	  echo "<tr class=\"own hl\">"; } else { echo "<tr>"; }
      echo "<td class=\"ra fc\">".$i++.".&nbsp;</td>";
      echo "<td class=\"pla\"><a href='allianz.php?aid=".$row['id']."'>".$row['tag']."</a></td>";
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
        echo "<td class=\"pla\"><a href=\"allianz.php?aid=".$row['id']."\">".$row['tag']."</a></td>";
    } else {
        echo "<td class=\"pla\">".$row['tag']."</td>";
    }

    echo "<td class=\"val lc\">".($row['RR'] - $row['Rc'])."</td>";
    echo "</tr>";
}
	  
	//mysqli_close($con);
?>
         </tbody>
</table>