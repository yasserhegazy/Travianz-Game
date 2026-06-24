<div id="textmenu"> 
   <a href="build.php?id=<?php echo $id; ?>"<?php if(!isset($_GET['t'])) { echo "class=\"selected\""; } ?>"><?php echo SEND_RESOURCES;?></a> 
 | <a href="build.php?id=<?php echo $id; ?>&amp;t=1" <?php if(isset($_GET['t']) && $_GET['t'] == 1) { echo "class=\"selected\""; } ?>><?php echo BUY;?></a> 
 | <a href="build.php?id=<?php echo $id; ?>&amp;t=2" <?php if(isset($_GET['t']) && $_GET['t'] == 2) { echo "class=\"selected\""; } ?>>بيع</a>
 <?php if($session->gold > 2) {
 ?>
 | <a href="build.php?id=<?php echo $id; ?>&amp;t=3" <?php if(isset($_GET['t']) && $_GET['t'] == 3) { echo "class=\"selected\""; } ?>>تاجر المبادلة</a>
 <?php
 }
 ?>
 <?php if($session->goldclub == 1 && count($database->getProfileVillages($session->uid)) > 1) {
 ?>
 | <a href="build.php?id=<?php echo $id; ?>&amp;t=4" <?php if(isset($_GET['t']) && $_GET['t'] == 4) { echo "class=\"selected\""; } ?>>قائمة التجارة</a> 
 <?php
 }
 ?>
</div> 
