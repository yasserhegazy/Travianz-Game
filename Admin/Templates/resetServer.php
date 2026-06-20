<?php
#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Filename       resetServer.php                                             ##
##  Developed by:  Ronix                                                       ##
##  License:       TravianZ Project                                            ##
##  Copyright:     TravianZ (c) 2012-2014. All rights reserved.                ##
##                                                                             ##
#################################################################################

include_once("../../GameEngine/config.php");
include_once("../../GameEngine/Database.php");
include_once("../../GameEngine/GameWorldReset.php");

if (session_status() !== PHP_SESSION_ACTIVE) {
	session_start();
}
if (!isset($_SESSION['access']) || (int)$_SESSION['access'] !== (int)ADMIN) {
	die("<h1><font color=\"red\">Access Denied: You are not Admin!</font></h1>");
}
set_time_limit(0);
if (!GameWorldReset::resetFromAdmin()) {
	die("<h1><font color=\"red\">Server reset failed. Check PHP error log for details.</font></h1>");
}

header("Location: ../admin.php?p=resetdone");
?>
