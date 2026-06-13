<?php
use App\Utils\AccessLogger;

#################################################################################
##                                                                             ##
##              -= YOU MUST NOT REMOVE OR CHANGE THIS NOTICE =-                ##
##                                                                             ##
## --------------------------------------------------------------------------- ##
##                                                                             ##
##  Project:       ZravianX                                                    ##
##  Version:       2011.11.30                                                  ##
##  Filename:      index.php                            					   ##
##  Developed by:  Dzoki & Advocaite & Donnchadh                               ##
##  Reworked by:   ZZJHONS                                                     ##
##  License:       Creative Commons BY-NC-SA 3.0                               ##
##  Copyright:     ZravianX (c) 2011 - All rights reserved                     ##
##  URLs:          http://zravianx.zzjhons.com                                 ##
##  Source code:   http://www.github.com/ZZJHONS/ZravianX                      ##
##                                                                             ##
#################################################################################

if(!file_exists('var/installed') && @opendir('install')) {
    header("Location: install/");
    exit;
}

include_once("GameEngine/config.php");
/*
if($_SERVER['HTTP_HOST'] != '.SERVER.')
{
    header('location: '.SERVER.'');
    exit;
}
*/

// delete the /* and the */ if you not use localhost.

error_reporting(E_ALL || E_NOTICE);

if(file_exists('Security/Security.class.php'))
{
    require 'Security/Security.class.php';
    Security::instance();
}
else
{
    die('Security: Please activate security class!');
}

include_once "GameEngine/Database.php";
include_once "GameEngine/Lang/".LANG.".php";

AccessLogger::logRequest();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"<?php echo (defined('LANG') && LANG === 'ar') ? ' dir="rtl"' : ''; ?>>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><?php echo SERVER_NAME; ?></title>
	<link rel="shortcut icon" href="favicon.ico" />
	<link rel="stylesheet" type="text/css" href="gpack/travian/main.css" />
	<link rel="stylesheet" type="text/css" href="gpack/travian/flaggs.css" />
	<link rel="stylesheet" type="text/css" href="gpack/travian/main_en.css" />
	<meta name="content-language" content="<?php echo LANG; ?>" />
	<meta http-equiv="imagetoolbar" content="no" />
	<script src="mt-core.js" type="text/javascript"></script>
	<script src="new.js?22102017" type="text/javascript"></script>
	<script src="new2.js?22102017" type="text/javascript"></script>
	<style type="text/css">
		<!-- li.c4 {background-image:url('img/en/welten/en1_big.jpg');} -->
		<!-- li.c3 {background-image:url('img/en/welten/en1_big_g.jpg');} -->
		div.c2 {left:237px;}
		ul.c1 {position:absolute; left:0px; width: 686px;}
		.grit {
			display: flex;
			justify-content: center;
		}
		.grit .infobox {
			float: none !important;
			margin: 0 auto !important;
			width: 600px !important;
			background: white !important;
			border-radius: 10px !important;
			box-shadow: 0 4px 20px rgba(0,0,0,0.15) !important;
			min-height: auto !important;
			padding: 30px !important;
			text-align: center !important;
		}
		.grit .infobox div {
			padding: 0 !important;
		}
		#what_is_travian h2 {
			font-size: 24px;
			margin-bottom: 10px;
		}
		#what_is_travian p {
			font-size: 14px;
			color: #333;
		}
		.play_now .signup_link {
			display: inline-block;
			background: linear-gradient(180deg, #d30000 0%, #aa0000 100%);
			color: white !important;
			padding: 12px 40px;
			border-radius: 30px;
			font-weight: bold;
			text-decoration: none;
			font-size: 18px;
			margin-top: 15px;
			box-shadow: 0 4px 10px rgba(170,0,0,0.3);
			transition: all 0.2s ease;
			border: 1px solid #880000;
		}
		.play_now .signup_link:hover {
			background: linear-gradient(180deg, #ff1111 0%, #cc0000 100%);
			box-shadow: 0 6px 15px rgba(170,0,0,0.4);
			transform: scale(1.05);
		}
		.stats-premium {
			display: grid;
			grid-template-columns: repeat(3, 1fr);
			gap: 15px;
			margin: 30px 0;
			padding: 20px;
			background: #f8f9fa;
			border-radius: 15px;
			box-shadow: inset 0 2px 5px rgba(0,0,0,0.03);
			border: 1px solid #e9ecef;
			direction: rtl;
		}
		.stat-item {
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			padding: 15px 10px;
			background: white;
			border-radius: 12px;
			box-shadow: 0 4px 10px rgba(0,0,0,0.04);
			transition: transform 0.3s ease, box-shadow 0.3s ease;
			border: 1px solid #f1f1f1;
		}
		.stat-item:hover {
			transform: translateY(-5px);
			box-shadow: 0 8px 16px rgba(0,0,0,0.08);
		}
		.stat-item .stat-value {
			font-size: 28px;
			font-weight: 900;
			color: #aa0000;
			margin-bottom: 5px;
		}
		.stat-item .stat-label {
			font-size: 13px;
			color: #666;
			font-weight: 700;
			text-align: center;
		}
		#about_the_game {
			margin-top: 25px;
			text-align: right;
			background: #ffffff;
			padding: 20px;
			border-radius: 12px;
			border: 1px solid #eee;
			box-shadow: 0 2px 8px rgba(0,0,0,0.03);
		}
		#about_the_game h2 {
			text-align: right;
			margin-bottom: 15px;
			font-size: 18px;
			color: #333;
			border-bottom: 2px solid #aa0000;
			display: inline-block;
			padding-bottom: 5px;
		}
		#about_the_game ul {
			list-style-type: none;
			padding-right: 0;
			margin: 0;
		}
		#about_the_game li {
			margin-bottom: 12px;
			font-size: 15px;
			color: #444;
			position: relative;
			padding-right: 25px;
		}
		#about_the_game li::before {
			content: "■";
			color: #aa0000;
			font-size: 12px;
			position: absolute;
			right: 5px;
			top: 5px;
		}

		/* Tips Section Styles */
		#tips_section {
			margin-top: 25px;
			text-align: right;
			background: #ffffff;
			padding: 20px;
			border-radius: 12px;
			border: 1px solid #eee;
			box-shadow: 0 4px 15px rgba(0,0,0,0.04);
		}
		#tips_section h2 {
			text-align: right;
			margin-bottom: 15px;
			font-size: 18px;
			color: #333;
			border-bottom: 2px solid #27ae60;
			display: inline-block;
			padding-bottom: 5px;
		}
		#tips_section ul {
			list-style-type: none;
			padding-right: 0;
			margin: 0;
		}
		#tips_section li {
			margin-bottom: 12px;
			font-size: 15px;
			color: #444;
			position: relative;
			padding-right: 25px;
		}
		#tips_section li::before {
			content: "★";
			color: #f39c12;
			font-size: 14px;
			position: absolute;
			right: 5px;
			top: 2px;
		}

		/* Screenshots Premium UI */
		#premium_screenshots {
			margin-top: 25px;
			background: #ffffff;
			border-radius: 12px;
			border: 1px solid #eee;
			box-shadow: 0 4px 15px rgba(0,0,0,0.04);
			padding: 20px;
			text-align: center;
			position: relative;
			overflow: hidden;
		}
		#premium_screenshots h2 {
			text-align: right;
			margin-bottom: 15px;
			font-size: 18px;
			color: #333;
			border-bottom: 2px solid #2980b9;
			display: inline-block;
			float: right;
			padding-bottom: 5px;
		}
		
		#premium_screenshots_preview {
			overflow: hidden;
			width: 100%;
			clear: both;
			margin: 15px 0 0 0;
			padding: 10px 0;
		}
		#premium_screenshot_list {
			list-style: none;
			margin: 0;
			padding: 0;
			display: flex;
			gap: 15px;
			justify-content: center;
			flex-wrap: wrap;
		}
		#premium_screenshot_list li { display: inline-block; }
		#premium_screenshot_list img {
			width: 110px;
			height: 85px;
			border-radius: 8px;
			box-shadow: 0 4px 10px rgba(0,0,0,0.15);
			transition: transform 0.3s ease, border-color 0.3s ease;
			border: 2px solid transparent;
		}
		#premium_screenshot_list img:hover {
			transform: scale(1.1) translateY(-5px);
			border-color: #aa0000;
		}
		#premium_screenshots .navi { display: none !important; }
	</style>

	<?php if(defined('LANG') && LANG === 'ar'): ?>
	
	<?php endif; ?>
	<link rel="stylesheet" type="text/css" href="mobile.css?v=47" />

	<!-- Premium Mobile Overrides -->
	<style type="text/css">
		/* Fix double horizontal/vertical scrollbars on mobile */
		html { overflow-y: auto !important; height: auto !important; }
		body { height: auto !important; overflow: visible !important; }
		.wrapper { overflow-x: hidden !important; overflow-y: visible !important; min-height: 100vh; }

		/* Override ugly green from mobile.css and make it look premium */
		body.indexPage #content .grit {
			background: transparent !important;
			border: none !important;
			box-shadow: none !important;
			padding: 10px !important;
			display: flex;
			flex-direction: column;
			align-items: center;
		}
		
		/* Bring back our premium white box */
		body.indexPage .infobox {
			background: rgba(255, 255, 255, 0.95) !important;
			border-radius: 16px !important;
			box-shadow: 0 8px 30px rgba(0,0,0,0.12) !important;
			border: 1px solid rgba(255, 255, 255, 0.8) !important;
			backdrop-filter: blur(10px);
			padding: 40px !important;
			width: 600px !important;
			max-width: 95% !important;
			margin: 20px auto !important;
		}

		/* Play Now Button - Force Premium Red Gradient */
		.play_now .signup_link {
			background: linear-gradient(135deg, #d30000 0%, #aa0000 100%) !important;
			border: 1px solid #880000 !important;
			color: #fff !important;
			box-shadow: 0 4px 15px rgba(170,0,0,0.4) !important;
			text-transform: uppercase;
			letter-spacing: 1px;
		}

		/* Responsive Grid for Stats & Mobile UI Restructuring */
		@media (max-width: 768px) {
			/* Kill blank spacing at very top from wrapper/body */
			html, body { margin: 0 !important; padding: 0 !important; }
			body.indexPage .wrapper { margin: 0 !important; padding: 0 !important; }

			/* Make the Header Village Artwork act as a top background image */
			body.indexPage #header {
				position: absolute !important;
				top: 0 !important;
				left: 0 !important;
				right: 0 !important;
				width: 100% !important;
				height: 500px !important;
				padding-top: 0 !important;
				background-image: url('img/mobile_bg_no_ui.webp') !important;
				background-size: cover !important;
				background-position: center top !important;
				z-index: 1 !important;
			}
			
			/* Push the content box down so it overlaps the bottom of the village image beautifully */
			body.indexPage #content {
				position: relative !important;
				z-index: 10 !important;
				margin-top: 360px !important;
				width: 100% !important;
			}
			
			/* Remove the hamburger menu, mobile navbar, and redundant top green register button */
			#navigation table.menu, 
			label.public-hamburger, 
			#public-nav-toggle, 
			.public-sidebar-backdrop,
			#register_now {
				display: none !important;
				visibility: hidden !important;
			}

			.stats-premium {
				grid-template-columns: 1fr !important;
				gap: 12px !important;
				padding: 15px !important;
			}
			body.indexPage .infobox {
				padding: 25px 15px !important;
				margin: 0 auto 30px auto !important;
			}
			#what_is_travian h2 {
				font-size: 20px !important;
			}
			.stat-item .stat-value {
				font-size: 24px !important;
			}

			/* Remove flex-column from wrapper to allow absolute positioning of header to work correctly */
			body.indexPage .wrapper {
				display: block !important;
			}
		}
	</style>
</head>

<body class="presto indexPage">
	<div class="wrapper">
		<div id="country_select">
			<div id="flags"></div>
			<script src="flaggen.js?a" type="text/javascript"></script>
			<script type="text/javascript">
			var region_list = new Array('Europe','America','Asia','Middle East','Africa','Oceania');
			show_flags('', '', region_list);
			</script>
		</div>
		<div id="header"><h1><?php echo $lang['index'][0][1]; ?></h1></div>
		<div id="navigation">
			<a href="index.php" class="home"><img src="img/x.gif" alt="Travian" /></a>
			<input type="checkbox" id="public-nav-toggle" style="display:none;" />
			<label for="public-nav-toggle" class="public-hamburger" style="display:none;">
				<span></span>
				<span></span>
				<span></span>
			</label>
			<div class="public-sidebar-backdrop" style="display:none;"></div>
			<table class="menu">
				<tr>
					<td><a href="tutorial.php"><span><?php echo TUTORIAL; ?></span></a></td>
					<td><a href="anleitung.php"><span><?php echo $lang['index'][0][2]; ?></span></a></td>
					<td><a href="http://forum.travian.com/" target="_blank"><span><?php echo FORUM; ?></span></a></td>
					<td><a href="?signup" class="signup_link mark"><span><?php echo $lang['register']; ?></span></a></td>
					<td><a href="?login" class="login_link"><span><?php echo LOGIN; ?></span></a></td>
				</tr>
			</table>
		</div>
		<?php
		if(T4_COMING==true){
		?>
		<div id="t4play">
		<a href="notification/">
		<img src="img/t4n/Teaser_Prelandingpage_EN.png" alt="Travian 4" />
		</a>
		</div>
		<?php } ?>
		<div id="register_now">
			<a href="?signup" class="signup_link"><?php echo $lang['register']; ?></a>
			<span><?php echo PLAY_NOW; ?></span>
		</div>
		<div id="content">
			<div class="grit">
				<div class="infobox">
					<div id="what_is_travian">
						<h2><?php echo $lang['index'][0][4]; ?></h2>
						<p><?php echo $lang['index'][0][5]; ?></p>
						<p class="play_now"><a href="?signup" class="signup_link"><?php echo $lang['index'][0][6]; ?></a></p>
					</div>
					<div class="stats-premium">
						<div class="stat-item">
							<span class="stat-value"><?php
								$return = mysqli_query($link, "SELECT Count(*) as Total FROM " . TB_PREFIX . "users WHERE tribe IN(1, 2, 3)");
								echo ($users = !empty($return) ? mysqli_fetch_assoc($return)['Total'] : 0);
							?></span>
							<span class="stat-label"><?php echo $lang['index'][0][7]; ?></span>
						</div>
						<div class="stat-item">
							<span class="stat-value"><?php
								$return = mysqli_query($link,"SELECT Count(*) as Total FROM " . TB_PREFIX . "users WHERE timestamp > ".(time() - (3600*24))." AND tribe IN(1, 2, 3)");
								echo !empty($return) ? mysqli_fetch_assoc($return)['Total'] : 0;
							?></span>
							<span class="stat-label"><?php echo str_replace(':', '', $lang['index'][0][8]); ?></span>
						</div>
						<div class="stat-item">
							<span class="stat-value"><?php
								$return = mysqli_query($link,"SELECT Count(*) as Total FROM " . TB_PREFIX . "users WHERE timestamp > ".(time() - (60*10))." AND tribe IN(1, 2, 3)");
								echo ($online = !empty($return) ? mysqli_fetch_assoc($return)['Total'] : 0);
							?></span>
							<span class="stat-label"><?php echo str_replace(':', '', $lang['index'][0][9]); ?></span>
						</div>
					</div>
					<div id="about_the_game">
						<h2><?php echo $lang['index'][0][10]; ?>:</h2>
						<ul>
							<li><?php echo $lang['index'][0][11]; ?></li>
							<li><?php echo $lang['index'][0][12]; ?></li>
							<li><?php echo $lang['index'][0][13]; ?></li>
						</ul>
					</div>
					
					<!-- New Tips & Tricks Section -->
					<div id="tips_section">
						<h2><?php echo (defined('LANG') && LANG === 'ar') ? 'نصائح استراتيجية' : 'Strategic Tips'; ?></h2>
						<ul>
							<li><?php echo (defined('LANG') && LANG === 'ar') ? 'اختر قبيلتك بحكمة، فكل قبيلة تمتلك مميزات فريدة تساعدك إما في الهجوم أو الدفاع.' : 'Choose your tribe wisely, each has unique advantages for attack or defense.'; ?></li>
							<li><?php echo (defined('LANG') && LANG === 'ar') ? 'قم بتوسيع حقول الموارد الخاصة بك لضمان دخل ثابت وتمويل جيشك القوي.' : 'Expand your resource fields to ensure steady income to fund your army.'; ?></li>
							<li><?php echo (defined('LANG') && LANG === 'ar') ? 'التحالفات هي مفتاح النصر، انضم لأقوى اللاعبين وسيطروا على العالم معاً.' : 'Alliances are key to victory, join forces to dominate the world together.'; ?></li>
						</ul>
					</div>

					<!-- Screenshots Showcase -->
					<div id="premium_screenshots">
						<h2><?php echo SCREENSHOTS; ?></h2>
						<div class="clear"></div>
						<a href="#last" class="navi prev dynamic_btn"><img class="dynamic_btn" src="img/x.gif" alt="previous" /></a>
						<div id="premium_screenshots_preview">
							<ul id="premium_screenshot_list">
								<li><a href="#"><img src="img/un/s/s1s.jpg" alt="Screenshot" /></a></li>
								<li><a href="#"><img src="img/un/s/s2s.jpg" alt="Screenshot" /></a></li>
								<li><a href="#"><img src="img/un/s/s4s.jpg" alt="Screenshot" /></a></li>
								<li><a href="#"><img src="img/un/s/s3s.jpg" alt="Screenshot" /></a></li>
							</ul>
						</div>
						<a href="#next" class="navi next"><img class="dynamic_btn" src="img/x.gif" alt="next" /></a>
					</div>

				</div>

			</div>
			<div class="clear"></div>
		</div>
		<div id="footer">
			<div class="container">
				<a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/3.0/" class="logo"><img alt="Licencia Creative Commons" style="border-width:0; height:31px; width:88px;" src="https://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" class="logo_traviangames" /></a>
				<ul class="menu">
					<li><a href="anleitung.php?s=3"><?php echo FAQ; ?></a>|</li>
					<li><a href="index.php?screenshots"><?php echo SCREENSHOTS; ?></a>|</li>
					<li><a href="spielregeln.php"><?php echo SPIELREGELN; ?></a>|</li>
					<li><a href="agb.php"><?php echo AGB; ?></a>|</li>
					<li><a href="impressum.php"><?php echo IMPRINT; ?></a></li>
					<li class="copyright">&copy; 2011-<?php echo date('Y'); ?> - TravianZ - <?php echo (defined('LANG') && LANG === 'ar') ? 'جميع الحقوق محفوظة' : 'All rights reserved'; ?></li>
				</ul>
				<div style="text-align: center; margin-top: 8px; font-size: 11px; color: #999; line-height: 1.6;">
					<?php echo (defined('LANG') && LANG === 'ar') ? 'تم الإصدار بواسطة TravianZ &mdash; شكرا لاستخدامكم نسختنا' : 'Released by TravianZ &mdash; Thank you for using our version'; ?>
				</div>
			</div>
		</div>
	</div>
	<div id="login_layer" class="overlay">
		<div class="mask closer"></div>
		<div id="login_list" class="overlay_content">
			<h2><?php echo CHOOSE; ?></h2>
			<a href="#" class="closer"><img class="dynamic_img" alt="Close" src="img/un/x.gif" /></a>
			<ul class="world_list">
				<li class="w_big c3" style="background-image:url('img/en/welten/en1_big.jpg');">
					<a href="login.php"><img class="w_button" src="img/un/x.gif" alt="World" title="<?php echo $users; echo "&nbsp;"; echo PLAYERS; echo "&nbsp;|&nbsp;"; echo $active; echo "&nbsp;"; echo ACTIVE; echo "&nbsp;|&nbsp;"; echo $online; echo "&nbsp;"; echo ONLINE; ?>" /></a>
					<div class="label_players c0"><?php echo PLAYERS; ?>:</div>
					<div class="label_online c0"><?php echo ONLINE; ?>:</div>
					<div class="players c1"><?php echo $users; ?></div>
					<div class="online c1"><?php echo $online; ?></div>
				</li>
			</ul>
			<div class="footer"></div>
		</div>
	</div>
	<div id="signup_layer" class="overlay">
		<div class="mask closer"></div>
		<div id="signup_list" class="overlay_content">
			<h2><?php echo CHOOSE; ?></h2>
			<a href="#" class="closer"><img class="dynamic_img" alt="Close" src="img/un/x.gif" /></a>
			<ul class="world_list">
				<li class="w_big c4" style="background-image:url('img/en/welten/en1_big.jpg');">
					<a href="anmelden.php"><img class="w_button" src="img/un/x.gif" alt="World" title="<?php echo $users; echo "&nbsp;"; echo PLAYERS; echo "&nbsp;|&nbsp;"; echo $active; echo "&nbsp;"; echo ACTIVE; echo "&nbsp;|&nbsp;"; echo $online; echo "&nbsp;"; echo ONLINE; ?>" /></a>
					<div class="label_players c0"><?php echo PLAYERS; ?>:</div>
					<div class="label_online c0"><?php echo ONLINE; ?>:</div>
					<div class="players c1"><?php echo $users; ?></div>
					<div class="online c1"><?php echo $online; ?></div>
				</li>
			</ul>
			<div class="footer"></div>
		</div>
	</div>
	<div id="iframe_layer" class="overlay">
		<div class="mask closer"></div>
		<div class="overlay_content">
			<a href="#" class="closer"><img class="dynamic_img" alt="Close" src="img/un/x.gif" /></a>
			<h2><?php echo $lang['index'][0][2]; ?></h2>
			<div id="frame_box"></div>
			<div class="footer"></div>
		</div>
	</div>
	<div id="screenshot_layer" class="overlay">
		<div class="mask closer"></div>
		<div class="overlay_content">
			<h3><?php echo SCREENSHOTS; ?></h3>
			<a href="#" class="closer"><img class="dynamic_img" alt="Close" src="img/x.gif" /></a>
			<div class="screenshot_view">
				<h4 id="screen_hl"></h4>
				<img id="screen_view" src="img/x.gif" alt="Screenshot" name="screen_view" />
				<div id="screen_desc"></div>
			</div>
			<a href="#prev" class="navi prev" onclick="galarie.showPrev();"><img class="dynamic_img" src="img/x.gif" alt="previous" /></a>
			<a href="#next" class="navi next" onclick="galarie.showNext();"><img class="dynamic_img" src="img/x.gif" alt="next" /></a>
			<div class="footer"></div>
		</div>
	</div>
	<script type="text/javascript">
		var screenshots = [
			{'img':'img/en/s/s1.png','hl':"<?php echo $lang['screenshots']['title1']; ?>", 'desc':"<?php echo $lang['screenshots']['desc1']; ?>"},{'img':'img/en/s/s2.png','hl':"<?php echo $lang['screenshots']['title2']; ?>", 'desc':"<?php echo $lang['screenshots']['desc2']; ?>"},{'img':'img/en/s/s4.png','hl':"<?php echo $lang['screenshots']['title3']; ?>", 'desc':"<?php echo $lang['screenshots']['desc3']; ?>"},{'img':'img/en/s/s3.png','hl':"<?php echo $lang['screenshots']['title4']; ?>", 'desc':"<?php echo $lang['screenshots']['desc4']; ?>"},{'img':'img/en/s/s5.png','hl':"<?php echo $lang['screenshots']['title5']; ?>", 'desc':"<?php echo $lang['screenshots']['desc5']; ?>"},{'img':'img/en/s/s7.png','hl':"<?php echo $lang['screenshots']['title6']; ?>", 'desc':"<?php echo $lang['screenshots']['desc6']; ?>"},{'img':'img/en/s/s8.png','hl':"<?php echo $lang['screenshots']['title7']; ?>", 'desc':"<?php echo $lang['screenshots']['desc7']; ?>"}
		];
		var galarie = new Fx.Screenshots('screen_view', 'screen_hl', 'screen_desc', screenshots);
	<?php
	    if (isset($_GET['signup'])) {
	?>
		window.addEvent('domready', function() {
			$$('.signup_link').fireEvent('click');
		});
	<?php
	   }
	?>

	<?php
    	if (isset($_GET['login'])) {
	?>
		window.addEvent('domready', function() {
    		$$('.login_link').fireEvent('click');
    	});
	<?php
	   }
	?>
	</script>
</body>
</html>

