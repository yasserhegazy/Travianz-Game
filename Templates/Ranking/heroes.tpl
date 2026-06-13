<?php

/** --------------------------------------------------- **\
| ********* DO NOT REMOVE THIS COPYRIGHT NOTICE ********* |
+---------------------------------------------------------+
| Released by:   Dzoki < dzoki.travian@gmail.com >        |
| Copyright:     TravianZ Project All rights reserved     |
\** --------------------------------------------------- **/
		if(!is_numeric($_SESSION['search'])) {
		?>
			<center><font color=orange size=2><p class=\"error\"><?php echo (defined('LANG') && LANG === 'ar') ? 'البطل' : 'The hero'; ?> <b>"<?php echo $_SESSION['search']; ?>"</b> <?php echo (defined('LANG') && LANG === 'ar') ? 'غير موجود.' : 'does not exist.'; ?></p></font></center>
		<?php
			$search = 0;
		} else {
        	$search = $_SESSION['search'];
        }

?>

		<table cellpadding="1" cellspacing="1" id="heroes" class="row_table_data">
			<thead>
				<tr>
					<th colspan="5">
						<?php echo (defined('LANG') && LANG === 'ar') ? 'أكثر الأبطال خبرة' : 'The most experienced heroes'; ?>											</th>
				</tr>
		<tr><td></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'البطل' : 'Hero'; ?></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'اللاعب' : 'Player'; ?></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'المستوى' : 'Level'; ?></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'الخبرة' : 'Experience'; ?></td></tr>
		</thead><tbody>
        <?php
        $rankArray = $ranking->getRank();
        if(isset($_GET['rank'])){
            $multiplier = 1;
            if(is_numeric($_GET['rank'])) {
                if($_GET['rank'] > count($rankArray)) {
                    $_GET['rank'] = count($rankArray) - 1;
                }
                
                while($_GET['rank'] > (20 * $multiplier))  $multiplier++;
                
                $start = 20 * $multiplier - 19;
            }
            else $start = ($_SESSION['start'] + 1);
        }
        else $start = ($_SESSION['start'] + 1);
        
        if(count($rankArray) > 1) {
        	for($i = $start; $i < $start + 20; $i++) {
        	    if(isset($rankArray[$i]['name']) && $rankArray[$i] != "pad") {
        			if($i == $search) echo "<tr class=\"hl \"><td class=\"ra  fc\" >";
        			else echo "<tr><td class=\"ra \" >";

        			echo $i . "</td>
                               <td class=\"hero \">
                               <img class=\"unit u" . $rankArray[$i]['unit'] . "\" alt=\"\" title=\"\" src=\"img/x.gif\"> " . $rankArray[$i]['name'] . "</td>
                               <td class=\"pla\"><center>".$database->getProtectedPlayerLink($rankArray[$i]['uid'], $rankArray[$i]['owner'])."</center></td>
                               <td class=\"lev \">" . $rankArray[$i]['level'] . "</td>
                               <td class=\"xp \">" . $rankArray[$i]['experience'] . "</td>
                               </tr>";
        		}
        	}
        }
        else echo "<td class=\"none\" colspan=\"5\">".(defined('LANG') && LANG === 'ar' ? 'لا يوجد أبطال' : 'No heros found')."</td>";

?>
 </tbody>
</table>
<?php

        include ("ranksearch.tpl");

?>