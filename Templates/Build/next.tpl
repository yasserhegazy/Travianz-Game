<?php
	$loopsame = count($database->getBuildingByField($village->wid, $id));
	$doublebuild = 0;
	$master = count($database->getMasterJobsByField($village->wid,$id));
?>
