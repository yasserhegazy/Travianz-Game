<?php

#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Filename       ww.tpl                                                      ##
##  Developed by:  Dixie                                                       ##
##  Edited by:     Dzoki                                                       ##
##  License:       TravianX Project                                            ##
##  Copyright:     TravianX (c) 2010-2011. All rights reserved.                ##
##                                                                             ##
#################################################################################
	$loopsame = count($database->getBuildingByField($village->wid, $id));
	$doublebuild = 0;
	$master = count($database->getMasterJobsByField($village->wid, $id));
?>

<div id="build" class="gid40"><a href="#" onClick="return Popup(40,4);" class="build_logo">
	<img class="building g40" src="img/x.gif" alt="World Wonder" title="<?php echo WORLD_WONDER;?>" />
</a>
<h1><?php echo WONDER;?> <br /><span class="level"><?php echo LEVEL;?> <?php echo $village->resarray['f'.$id];?></span></h1>
<p class="build_desc"><?php echo WONDER_DESC;?></p>

<?php
include("wwupgrade.tpl");
?>
</p></div>
