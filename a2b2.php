<?php
include_once("GameEngine/Generator.php");
$start_timer = $generator->pageLoadTimeStart();

#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Filename       a2b2.php                                                    ##
##  Developed by:  Dzoki                                                       ##
##  License:       TravianX Project                                            ##
##  Copyright:     TravianX (c) 2010-2011. All rights reserved.                ##
##                                                                             ##
#################################################################################

use App\Utils\AccessLogger;

include_once("GameEngine/Village.php");
AccessLogger::logRequest();

$amount = isset($_SESSION['amount']) ? $_SESSION['amount'] : 0;
if(isset($_GET['newdid'])) {
	$_SESSION['wid'] = $_GET['newdid'];
	header("Location: ".$_SERVER['PHP_SELF']);
	exit;
}
else $building->procBuild($_GET);
?>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html<?php echo (defined('LANG') && LANG === 'ar') ? ' dir="rtl"' : ''; ?>>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><?php echo SERVER_NAME . ((defined('LANG') && LANG === 'ar') ? ' - سجلات الحساب' : ' - Account transactions'); ?></title>
	<link rel="shortcut icon" href="favicon.ico"/>
	<meta http-equiv="cache-control" content="max-age=0" />
	<meta http-equiv="pragma" content="no-cache" />
	<meta http-equiv="expires" content="0" />
	<meta http-equiv="imagetoolbar" content="no" />
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<script src="mt-full.js?0faab" type="text/javascript"></script>
	<script src="unx.js?g5c8m" type="text/javascript"></script>
	<script src="new.js?0faab" type="text/javascript"></script>
	<link href="<?php echo GP_LOCATE; ?>lang/<?php echo LANG; ?>/lang.css?f4b7d" rel="stylesheet" type="text/css" />
	<link href="<?php echo GP_LOCATE; ?>lang/<?php echo LANG; ?>/compact.css?v2" rel="stylesheet" type="text/css" />
	<?php
	if($session->gpack == null || GP_ENABLE == false) {
	echo "
	<link href='".GP_LOCATE."travian.css?v2' rel='stylesheet' type='text/css' />
	<link href='".GP_LOCATE."lang/".LANG."/lang.css?v2' rel='stylesheet' type='text/css' />";
	} else {
	echo "
	<link href='".$session->gpack."travian.css?v2' rel='stylesheet' type='text/css' />
	<link href='".$session->gpack."lang/".LANG."/lang.css?v2' rel='stylesheet' type='text/css' />";
	}
	?>
	<script type="text/javascript">

		window.addEvent('domready', start);
	</script>

	<?php if(defined('LANG') && LANG === 'ar'): ?>
	
	<?php endif; ?>
	<link rel="stylesheet" type="text/css" href="mobile.css?v=47" />
</head>
<body class="v35 ie ie8">
<script>if('scrollRestoration'in history)history.scrollRestoration='manual';window.scrollTo(0,0);window.addEventListener('load',function(){window.scrollTo(0,0);setTimeout(function(){window.scrollTo(0,0)},0);setTimeout(function(){window.scrollTo(0,0)},50);setTimeout(function(){window.scrollTo(0,0)},100);setTimeout(function(){window.scrollTo(0,0)},200)});</script>
<div class="wrapper">
<img style="filter:chroma();" src="img/x.gif" id="msfilter" alt="" />
<div id="dynamic_header">
	</div>
<?php include("Templates/header.tpl"); ?>
<div id="mid">
<?php include("Templates/menu.tpl"); ?>
<?php include("Templates/Plus/pmenu.tpl"); ?>
<h1><?php echo (defined('LANG') && LANG === 'ar') ? 'سجلات الحساب' : 'Account transactions'; ?></h1>
<div id="products">
<?php
if ($amount == 199) {
// Statement retrieve Gold Package A
$MyGold = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$golds = mysqli_fetch_array($MyGold);
$goldnow = $golds['6'] + 60; 
mysqli_query($database->dblink,"UPDATE ".TB_PREFIX."users set gold = '".$goldnow."' where `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$MyGold = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$golds1 = mysqli_fetch_array($MyGold);
?><p><?php echo (defined('LANG') && LANG === 'ar') ? 'شكراً لشرائك من ' : 'Thank you for your purchase here at '; ?><?php echo SERVER_NAME ?></p><p><?php echo (defined('LANG') && LANG === 'ar') ? 'أدناه يمكنك رؤية سجل الإدخال. من خلاله يمكنك ملاحظة رصيد حسابك القديم والجديد.' : 'Below you see the entry record.  Out of it, you can observe your old as well as your new account balance.'; ?></p> 
<table class="plusFunctions" cellpadding="1" cellspacing="1">
		<thead>
			<tr>

				<th colspan="5" height="20"><?php echo (defined('LANG') && LANG === 'ar') ? 'سجل بتاريخ ' : 'Record of '; ?><?php echo date('d.m.Y'); ?></th>
			</tr>
			<tr>
				<td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'الوصف' : 'Description'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'العملية' : 'Action'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'التاريخ' : 'Date'; ?></td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="desc"><b>&nbsp;&nbsp;<?php echo (defined('LANG') && LANG === 'ar') ? 'رصيد الحساب (القديم)' : 'Account Balance (old)'; ?></b></td>
				<td class="desc"><div style="text-align: center"><?php echo $golds['6']; ?></div></td>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
                <td class="act"><div style="text-align: center">&nbsp;</div></td>
             </tr>
             <tr>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
				<td class="desc"><div style="text-align: center"><b><font color="#71D000"><?php echo (defined('LANG') && LANG === 'ar') ? 'الحزمة' : 'Package'; ?></font></b></div></td>
				<td class="desc"><div style="text-align: center">60 <?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?></div></td>
                <td class="act"><div style="text-align: center">&nbsp;</div></td>
			</tr>
            <tr>
				<td class="desc"><b>&nbsp;&nbsp;<?php echo (defined('LANG') && LANG === 'ar') ? 'رصيد الحساب (الجديد)' : 'Account Balance (new)'; ?></b></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center"><?php echo $golds1['6']; ?></div></td>
                <td class="act"><div style="text-align: center"><?php echo date('d.m.Y H:i:s'); ?></div></td>
			</tr>
             </tbody></table>
            <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى التحقق من المعلومات.<br />سيساعدنا ذلك في معرفة ما إذا كانت البيانات غير صحيحة.' : 'Please verify the information.<br />It will let us know if the data is incorrect.'; ?></p>
            <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى إرسال اسم المستخدم، الحزمة، وقت الطلب، والبريد الإلكتروني المستخدم إلى <a href="mailto:<?php echo (defined(\'PAYPAL_EMAIL\') ? PAYPAL_EMAIL : \'novgorodschi@icloud.com\') ?>">' : 'Please mail your username, package, order time and email used to <a href="mailto:<?php echo (defined(\'PAYPAL_EMAIL\') ? PAYPAL_EMAIL : \'novgorodschi@icloud.com\') ?>">'; ?><?php echo (defined('LANG') && LANG === 'ar') ? 'عنوان الفواتير الخاص بنا' : 'our billing address'; ?></a>.</p>
          
<?php

}
if ($amount == 499) {
// Statement retrieve Gold Package B
$MyGold = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$golds = mysqli_fetch_array($MyGold);
$goldnow = $golds['6'] + 120; 
mysqli_query($database->dblink,"UPDATE ".TB_PREFIX."users set gold = '".$goldnow."' where `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$MyGold = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$golds1 = mysqli_fetch_array($MyGold);
?><p><?php echo (defined('LANG') && LANG === 'ar') ? 'شكراً لشرائك من ' : 'Thank you for your purchase here at '; ?><?php echo SERVER_NAME ?>.</p><p><?php echo (defined('LANG') && LANG === 'ar') ? 'أدناه يمكنك رؤية سجل الإدخال. من خلاله يمكنك ملاحظة رصيد حسابك القديم والجديد.' : 'Below you see the entry record.  Out of it, you can observe your old as well as your new account balance.'; ?></p> 
<table class="plusFunctions" cellpadding="1" cellspacing="1">
		<thead>
			<tr>

				<th colspan="5" height="20"><?php echo (defined('LANG') && LANG === 'ar') ? 'سجل بتاريخ ' : 'Record of '; ?><?php echo date('d.m.Y'); ?></th>
			</tr>
			<tr>
				<td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'الوصف' : 'Description'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'العملية' : 'Action'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'التاريخ' : 'Date'; ?></td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="desc"><b>&nbsp;&nbsp;<?php echo (defined('LANG') && LANG === 'ar') ? 'رصيد الحساب (القديم)' : 'Account Balance (old)'; ?></b></td>
				<td class="desc"><div style="text-align: center"><?php echo $golds['6']; ?></div></td>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
                <td class="act"><div style="text-align: center">&nbsp;</div></td>
             </tr>
             <tr>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
				<td class="desc"><div style="text-align: center"><b><font color="#71D000"><?php echo (defined('LANG') && LANG === 'ar') ? 'الحزمة' : 'Package'; ?></font></b></div></td>
				<td class="desc"><div style="text-align: center">60 <?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?></div></td>
                <td class="act"><div style="text-align: center">&nbsp;</div></td>
			</tr>
            <tr>
				<td class="desc"><b>&nbsp;&nbsp;<?php echo (defined('LANG') && LANG === 'ar') ? 'رصيد الحساب (الجديد)' : 'Account Balance (new)'; ?></b></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center"><?php echo $golds1['6']; ?></div></td>
                <td class="act"><div style="text-align: center"><?php echo date('d.m.Y H:i:s'); ?></div></td>
			</tr>
             </tbody></table>
                      <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى التحقق من المعلومات.<br />سيساعدنا ذلك في معرفة ما إذا كانت البيانات غير صحيحة.' : 'Please verify the information.<br />It will let us know if the data is incorrect.'; ?></p>
            <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى إرسال اسم المستخدم، الحزمة، وقت الطلب، والبريد الإلكتروني المستخدم إلى <a href="mailto:<?php echo (defined(\'PAYPAL_EMAIL\') ? PAYPAL_EMAIL : \'novgorodschi@icloud.com\') ?>">' : 'Please mail your username, package, order time and email used to <a href="mailto:<?php echo (defined(\'PAYPAL_EMAIL\') ? PAYPAL_EMAIL : \'novgorodschi@icloud.com\') ?>">'; ?><?php echo (defined('LANG') && LANG === 'ar') ? 'عنوان الفواتير الخاص بنا' : 'our billing address'; ?></a>.</p>
<?php

}
if ($amount == 999) {
// Statement retrieve Gold Package C
$MyGold = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$golds = mysqli_fetch_array($MyGold);
$goldnow = $golds['6'] + 360; 
mysqli_query($database->dblink,"UPDATE ".TB_PREFIX."users set gold = '".$goldnow."' where `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$MyGold = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$golds1 = mysqli_fetch_array($MyGold);
?><p><?php echo (defined('LANG') && LANG === 'ar') ? 'شكراً لشرائك من ' : 'Thank you for your purchase here at '; ?><?php echo SERVER_NAME ?>.</p><p><?php echo (defined('LANG') && LANG === 'ar') ? 'أدناه يمكنك رؤية سجل الإدخال. من خلاله يمكنك ملاحظة رصيد حسابك القديم والجديد.' : 'Below you see the entry record.  Out of it, you can observe your old as well as your new account balance.'; ?></p>
<table class="plusFunctions" cellpadding="1" cellspacing="1">
		<thead>
			<tr>

				<th colspan="5" height="20"><?php echo (defined('LANG') && LANG === 'ar') ? 'سجل بتاريخ ' : 'Record of '; ?><?php echo date('d.m.Y'); ?></th>
			</tr>
			<tr>
				<td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'الوصف' : 'Description'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'العملية' : 'Action'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'التاريخ' : 'Date'; ?></td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="desc"><b>&nbsp;&nbsp;<?php echo (defined('LANG') && LANG === 'ar') ? 'رصيد الحساب (القديم)' : 'Account Balance (old)'; ?></b></td>
				<td class="desc"><div style="text-align: center"><?php echo $golds['6']; ?></div></td>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
                <td class="act"><div style="text-align: center">&nbsp;</div></td>
             </tr>
             <tr>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
				<td class="desc"><div style="text-align: center"><b><font color="#71D000"><?php echo (defined('LANG') && LANG === 'ar') ? 'الحزمة' : 'Package'; ?></font></b></div></td>
				<td class="desc"><div style="text-align: center">60 <?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?></div></td>
                <td class="act"><div style="text-align: center">&nbsp;</div></td>
			</tr>
            <tr>
				<td class="desc"><b>&nbsp;&nbsp;<?php echo (defined('LANG') && LANG === 'ar') ? 'رصيد الحساب (الجديد)' : 'Account Balance (new)'; ?></b></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center"><?php echo $golds1['6']; ?></div></td>
                <td class="act"><div style="text-align: center"><?php echo date('d.m.Y H:i:s'); ?></div></td>
			</tr>
             </tbody></table>
                       <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى التحقق من المعلومات.<br />سيساعدنا ذلك في معرفة ما إذا كانت البيانات غير صحيحة.' : 'Please verify the information.<br />It will let us know if the data is incorrect.'; ?></p>
            <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى إرسال اسم المستخدم، الحزمة، وقت الطلب، والبريد الإلكتروني المستخدم إلى <a href="mailto:<?php echo (defined(\'PAYPAL_EMAIL\') ? PAYPAL_EMAIL : \'novgorodschi@icloud.com\') ?>">' : 'Please mail your username, package, order time and email used to <a href="mailto:<?php echo (defined(\'PAYPAL_EMAIL\') ? PAYPAL_EMAIL : \'novgorodschi@icloud.com\') ?>">'; ?><?php echo (defined('LANG') && LANG === 'ar') ? 'عنوان الفواتير الخاص بنا' : 'our billing address'; ?></a>.</p>
<?php

}
if ($amount == 1999) {
// Statement retrieve Gold Package D
$MyGold = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$golds = mysqli_fetch_array($MyGold);
$goldnow = $golds['6'] + 1000; 
mysqli_query($database->dblink,"UPDATE ".TB_PREFIX."users set gold = '".$goldnow."' where `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$MyGold = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$golds1 = mysqli_fetch_array($MyGold);
?><p><?php echo (defined('LANG') && LANG === 'ar') ? 'شكراً لشرائك من ' : 'Thank you for your purchase here at '; ?><?php echo SERVER_NAME ?>.</p><p><?php echo (defined('LANG') && LANG === 'ar') ? 'أدناه يمكنك رؤية سجل الإدخال. من خلاله يمكنك ملاحظة رصيد حسابك القديم والجديد.' : 'Below you see the entry record.  Out of it, you can observe your old as well as your new account balance.'; ?></p>
<table class="plusFunctions" cellpadding="1" cellspacing="1">
		<thead>
			<tr>

				<th colspan="5" height="20"><?php echo (defined('LANG') && LANG === 'ar') ? 'سجل بتاريخ ' : 'Record of '; ?><?php echo date('d.m.Y'); ?></th>
			</tr>
			<tr>
				<td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'الوصف' : 'Description'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'العملية' : 'Action'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'التاريخ' : 'Date'; ?></td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="desc"><b>&nbsp;&nbsp;<?php echo (defined('LANG') && LANG === 'ar') ? 'رصيد الحساب (القديم)' : 'Account Balance (old)'; ?></b></td>
				<td class="desc"><div style="text-align: center"><?php echo $golds['6']; ?></div></td>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
                <td class="act"><div style="text-align: center">&nbsp;</div></td>
             </tr>
             <tr>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
				<td class="desc"><div style="text-align: center"><b><font color="#71D000"><?php echo (defined('LANG') && LANG === 'ar') ? 'الحزمة' : 'Package'; ?></font></b></div></td>
				<td class="desc"><div style="text-align: center">60 <?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?></div></td>
                <td class="act"><div style="text-align: center">&nbsp;</div></td>
			</tr>
            <tr>
				<td class="desc"><b>&nbsp;&nbsp;<?php echo (defined('LANG') && LANG === 'ar') ? 'رصيد الحساب (الجديد)' : 'Account Balance (new)'; ?></b></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center"><?php echo $golds1['6']; ?></div></td>
                <td class="act"><div style="text-align: center"><?php echo date('d.m.Y H:i:s'); ?></div></td>
			</tr>
             </tbody></table>
                        <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى التحقق من المعلومات.<br />سيساعدنا ذلك في معرفة ما إذا كانت البيانات غير صحيحة.' : 'Please verify the information.<br />It will let us know if the data is incorrect.'; ?></p>
            <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى إرسال اسم المستخدم، الحزمة، وقت الطلب، والبريد الإلكتروني المستخدم إلى <a href="cata7007@gmail.com">' : 'Please mail your username, package, order time and email used to <a href="cata7007@gmail.com">'; ?><?php echo (defined('LANG') && LANG === 'ar') ? 'عنوان الفواتير الخاص بنا' : 'our billing address'; ?></a>.</p>
<?php

}
if ($amount == 4999) {
// Statement retrieve Gold Package E
$MyGold = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$golds = mysqli_fetch_array($MyGold);
$goldnow = $golds['6'] + 2000; 
mysqli_query($database->dblink,"UPDATE ".TB_PREFIX."users set gold = '".$goldnow."' where `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$MyGold = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
$golds1 = mysqli_fetch_array($MyGold);
?><p><?php echo (defined('LANG') && LANG === 'ar') ? 'شكراً لشرائك من ' : 'Thank you for your purchase here at '; ?><?php echo SERVER_NAME ?>.</p><p><?php echo (defined('LANG') && LANG === 'ar') ? 'أدناه يمكنك رؤية سجل الإدخال. من خلاله يمكنك ملاحظة رصيد حسابك القديم والجديد.' : 'Below you see the entry record.  Out of it, you can observe your old as well as your new account balance.'; ?></p>
<table class="plusFunctions" cellpadding="1" cellspacing="1">
		<thead>
			<tr>

				<th colspan="5" height="20"><?php echo (defined('LANG') && LANG === 'ar') ? 'سجل بتاريخ ' : 'Record of '; ?><?php echo date('d.m.Y'); ?></th>
			</tr>
			<tr>
				<td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'الوصف' : 'Description'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'العملية' : 'Action'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'التاريخ' : 'Date'; ?></td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="desc"><b>&nbsp;&nbsp;<?php echo (defined('LANG') && LANG === 'ar') ? 'رصيد الحساب (القديم)' : 'Account Balance (old)'; ?></b></td>
				<td class="desc"><div style="text-align: center"><?php echo $golds['6']; ?></div></td>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
                <td class="act"><div style="text-align: center">&nbsp;</div></td>
             </tr>
             <tr>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
				<td class="desc"><div style="text-align: center"><b><font color="#71D000"><?php echo (defined('LANG') && LANG === 'ar') ? 'الحزمة' : 'Package'; ?></font></b></div></td>
				<td class="desc"><div style="text-align: center">60 <?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?></div></td>
                <td class="act"><div style="text-align: center">&nbsp;</div></td>
			</tr>
            <tr>
				<td class="desc"><b>&nbsp;&nbsp;<?php echo (defined('LANG') && LANG === 'ar') ? 'رصيد الحساب (الجديد)' : 'Account Balance (new)'; ?></b></td>
				<td class="desc"><div style="text-align: center">&nbsp;</div></td>
				<td class="desc"><div style="text-align: center"><b>&nbsp;</b></div></td>
				<td class="desc"><div style="text-align: center"><?php echo $golds1['6']; ?></div></td>
                <td class="act"><div style="text-align: center"><?php echo date('d.m.Y H:i:s'); ?></div></td>
			</tr>
             </tbody></table>
                        <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى التحقق من المعلومات.<br />سيساعدنا ذلك في معرفة ما إذا كانت البيانات غير صحيحة.' : 'Please verify the information.<br />It will let us know if the data is incorrect.'; ?></p>
            <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى إرسال اسم المستخدم، الحزمة، وقت الطلب، والبريد الإلكتروني المستخدم إلى <a href="mailto:<?php echo (defined(\'PAYPAL_EMAIL\') ? PAYPAL_EMAIL : \'novgorodschi@icloud.com\') ?>">' : 'Please mail your username, package, order time and email used to <a href="mailto:<?php echo (defined(\'PAYPAL_EMAIL\') ? PAYPAL_EMAIL : \'novgorodschi@icloud.com\') ?>">'; ?><?php echo (defined('LANG') && LANG === 'ar') ? 'عنوان الفواتير الخاص بنا' : 'our billing address'; ?></a>.</p>
<?php
}
				if ($amount == 0) 
				{
				$MyGold = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."users WHERE `id`='".$session->uid."'") or die(mysqli_error($database->dblink));
				$golds = mysqli_fetch_array($MyGold);	
					 ?>
                
<p><?php echo (defined('LANG') && LANG === 'ar') ? 'هنا يمكنك رؤية كشف حسابك الحالي.' : 'Here you can see your current account statement.'; ?></p> 
<table class="plusFunctions" cellpadding="1" cellspacing="1">
		<thead>
			<tr>

				<th colspan="5" height="20"><?php echo (defined('LANG') && LANG === 'ar') ? 'سجل بتاريخ ' : 'Record of '; ?><?php echo date('d.m.Y'); ?></th>
			</tr>
			<tr>
				<td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'الوصف' : 'Description'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td align="center"><?php echo (defined('LANG') && LANG === 'ar') ? 'العملية' : 'Action'; ?></td><td align="center"><img src="img/x.gif" class="gold" alt="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'ذهب' : 'Gold'; ?>" /></td><td><?php echo (defined('LANG') && LANG === 'ar') ? 'التاريخ' : 'Date'; ?></td></tr>
		</thead>
		<tbody>
			<tr>
				<td class="desc"><b><?php echo (defined('LANG') && LANG === 'ar') ? 'رصيد الحساب الحالي' : 'Current account balance'; ?></b></td>
				<td class="desc"><div style="text-align: center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td>
				<td class="desc"><div style="text-align: center"><b><?php echo (defined('LANG') && LANG === 'ar') ? 'استعلام عن الحساب' : 'Account inquiry'; ?></b></div></td>
				<td class="desc"><div style="text-align: center"><?php echo $golds['6']; ?></div></td>
                <td class="act"><div style="text-align: center"><?php echo date('d.m.Y H:i:s'); ?></div></td>
             </tr>
             </tbody></table>
                       <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى التحقق من المعلومات.<br />سيساعدنا ذلك في معرفة ما إذا كانت البيانات غير صحيحة.' : 'Please verify the information.<br />It will let us know if the data is incorrect.'; ?></p>
            <p><?php echo (defined('LANG') && LANG === 'ar') ? 'يرجى إرسال اسم المستخدم، الحزمة، وقت الطلب، والبريد الإلكتروني المستخدم إلى <a href="mailto:<?php echo (defined(\'PAYPAL_EMAIL\') ? PAYPAL_EMAIL : \'novgorodschi@icloud.com\') ?>">' : 'Please mail your username, package, order time and email used to <a href="mailto:<?php echo (defined(\'PAYPAL_EMAIL\') ? PAYPAL_EMAIL : \'novgorodschi@icloud.com\') ?>">'; ?><?php echo (defined('LANG') && LANG === 'ar') ? 'عنوان الفواتير الخاص بنا' : 'our billing address'; ?></a>.</p>
				<?php
				
				}

?>
<?php $_SESSION['amount'] = 0; ?>

</div>
</div>
<br /><br /><br /><br /><div id="side_info">
<?php
include("Templates/multivillage.tpl");
include("Templates/quest.tpl");
include("Templates/news.tpl");
if(!NEW_FUNCTIONS_DISPLAY_LINKS) {
	echo "<br><br><br><br>";
	include("Templates/links.tpl");
}
?>
</div>
<div class="clear"></div>
</div>
<div class="footer-stopper"></div>
<div class="clear"></div>

<?php
include("Templates/footer.tpl");
include("Templates/res.tpl");
?>
<div id="stime">
<div id="ltime">
<div id="ltimeWrap">
<?php echo CALCULATED_IN;?> <b><?php
echo round(($generator->pageLoadTimeEnd()-$start_timer)*1000);
?></b> ms

<br /><?php echo SERVER_TIME;?> <span id="tp1" class="b"><?php echo date('H:i:s'); ?></span>
</div>
	</div>
</div>

<div id="ce"></div>
</body>
</html>

