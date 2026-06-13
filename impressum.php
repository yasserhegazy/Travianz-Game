<?php
#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Project:       TravianZ                        		       	       ##
##  Version:       01.09.2013 						       ##
##  Filename       impressum.php                                               ##
##  Developed by:  Dzoki                                                       ##
##  Fixed by:      Shadow / Skype : cata7007                                   ##
##  License:       TravianZ Project                                            ##
##  Copyright:     TravianZ (c) 2010-2013. All rights reserved.                ##
##  URLs:          http://travian.shadowss.ro 				       ##
##  Source code:   http://github.com/Shadowss/TravianZ-by-Shadow/	       ##
##                                                                             ##
#################################################################################

use App\Utils\AccessLogger;

include_once("GameEngine/config.php");
include_once("GameEngine/Database.php");
include_once("GameEngine/Lang/".LANG.".php");
AccessLogger::logRequest();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"<?php echo (defined('LANG') && LANG === 'ar') ? ' dir="rtl"' : ''; ?>>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><?php echo SERVER_NAME; ?></title>
	<link rel="stylesheet" type="text/css" href="img/tutorial/main.css"/>
	<link rel="stylesheet" type="text/css" href="img/tutorial/flaggs.css"/>
	<meta name="content-language" content="en"/>
	<meta http-equiv="imagetoolbar" content="no"/>
	<script src="mt-core.js" type="text/javascript"></script>
	<script src="new.js" type="text/javascript"></script>
	<style type="text/css" media="screen">

	</style>

	<?php if(defined('LANG') && LANG === 'ar'): ?>
<style type="text/css">
	/* Keep navigation menu in LTR order to match index.php layout */
	#navigation table.menu { direction: ltr; }

	/* Content text & images */
	body.contentPage #content p img[align="left"] { float: right; margin: 0 0 10px 15px; }
	body.contentPage #content p img[align="right"] { float: left; margin: 0 15px 10px 0; }
	
	/* Adjust specific lists */
	body.contentPage #content td li { text-align: right; }
	body.contentPage ul { padding-right: 20px; padding-left: 0; }
	body.contentPage table.culture_points { margin: 15px 110px; }
	body.contentPage .rules { margin-left: 160px; margin-right: 120px; }
</style>
	<?php endif; ?>
	<link rel="stylesheet" type="text/css" href="mobile.css?v=47" />
</head>
<body class="webkit contentPage">
<div class="wrapper">
<div id="country_select">

</div>
<div id="header">
	<h1>Welcome to <?php echo SERVER_NAME; ?></h1>
</div>

<div id="navigation">

<a href="index.php" class="home"><img src="img/x.gif" alt="Travian"/></a>

	<table class="menu">

	<tr>

		<td><a href="tutorial.php"><span><?php echo TUTORIAL; ?></span></a></td>

		<td><a href="anleitung.php"><span><?php echo $lang['index'][0][2]; ?></span></a></td>

		<td><a href="http://forum.travian.com/" target="_blank"><span><?php echo $lang['forum']; ?></span></a></td>





		<td><a href="index.php?signup"><span><?php echo $lang['register']; ?></span></a></td>

		<td><a href="index.php?login"><span><?php echo LOGIN; ?></span></a></td>

</tr>

	</table>

</div>






<div id="content">

	<div class="grit">


<h1>Impressum</h1>

<p class="submenu">

Travian Games GmbH<br />
Wilhelm-Wagenfeld-Strabe 22<br />
80807 Munchen<br />
Germany
<br /><br />
<b>jurisdiction:</b><br />
Amtsgericht Munchen, HRB 173511<br />
Ust-IdNr. DE 246258085<br />
CEO: Florian Bohn<br />
Phone: 004989/32 49 15 93 8 (not for game support)<br />
Fax: 004989/32 49 15 97 3 (plus support only)<br />
<br />
<b>Email:</b><br />
General:
<script language="JavaScript"><!--
var name = "admin";
var domain = "travian.com";
document.write("<a href=\"mailto:" + name + "@" + domain + "\"><span class=\"t\">");
document.write(name + "@" + domain + "</span></a>");
// --></script>
<br />
Support: <script language="JavaScript"><!--
var name = "support";
var domain = "travian.com";
document.write("<a href=\"mailto:" + name + "@" + domain + "\"><span class=\"t\">");
document.write(name + "@" + domain + "</span></a>");
// --></script>
<br />
Travian PLUS: <script language="JavaScript"><!--
var name = "plus";
var domain = "travian.com";
document.write("<a href=\"mailto:" + name + "@" + domain + "\"><span class=\"t\">");
document.write(name + "@" + domain + "</span></a>");
// --></script>
<br /><br />
<b>Youth protection officer:</b><br />
Rechtsanwalt Dr. Andreas Lober<br />
Schulte Riesenkampff Rechtsanwaltsgesellschaft mbH<br />
<script language="JavaScript"><!--
var name = "jugendschutz";
var domain = "traviangames.com";
document.write("<a href=\"mailto:" + name + "@" + domain + "\"><span class=\"t\">");
document.write(name + "@" + domain + "</span></a>");
// --></script>
<br />
<br />
<b>Data protection officer:</b><br />
Robin Houben<br />
<script language="JavaScript"><!--
var name = "privacy";
var domain = "traviangames.com";
document.write("<a href=\"mailto:" + name + "@" + domain + "\"><span class=\"t\">");
document.write(name + "@" + domain + "</span></a>");
// --></script>
<br /><br />
<b>Please don't forget Username + Game-Server when you write to support</b>
<br /><br />
All rights to texts, graphics and source codes are held by Travian Games GmbH.
Travian is a registered trade mark of Travian Games GmbH.

</p>

<div class="footer"></div>

</div>

</div>

<div id="iframe_layer" class="overlay">



<div class="mask closer"></div>







<div class="overlay_content">

<a href="index.php" class="closer"><img class="dynamic_img" alt="Close" src="img/un/x.gif" /></a>

<h2><?php echo $lang['index'][0][2]; ?></h2>



<div id="frame_box" >

</div>

<div class="footer"></div>

</div>



</div>




</body>
</html>
