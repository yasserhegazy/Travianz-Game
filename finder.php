<?php
// finder.php — Unified Map Search Feature
// Find 15c, 9c, or specific oasis combinations (150% crop, 100% clay, etc.)

include_once("GameEngine/Generator.php");
$start_timer = $generator->pageLoadTimeStart();
include_once("GameEngine/config.php");
use App\Utils\AccessLogger;
include_once("GameEngine/Village.php");
AccessLogger::logRequest();

// Tables
$TBP = defined('TB_PREFIX') ? TB_PREFIX : 's1_';
$WDATA = $TBP . 'wdata';
$ODATA = $TBP . 'odata';
$VDATA = $TBP . 'vdata';
$USERS = $TBP . 'users';

if (!defined('OASIS_BONUS_NORMAL')) define('OASIS_BONUS_NORMAL', 100);
if (!defined('OASIS_BONUS_MIXED')) define('OASIS_BONUS_MIXED', 75);
if (!defined('OASIS_BONUS_STRONG')) define('OASIS_BONUS_STRONG', 150);


$RENDER_MAX = 50;

// ---------- Plus Account Gate (server-side) ----------
$_plusGate = mysqli_query($database->dblink, "SELECT plus FROM " . TB_PREFIX . "users WHERE id = '" . $session->uid . "'");
$_plusGateRow = mysqli_fetch_assoc($_plusGate);
$_hasPlus = ($_plusGateRow && (int)$_plusGateRow['plus'] > time());

// ---------- POST -> GET ----------
if ($_hasPlus && isset($_POST['s']) && !isset($_POST['oasis_search'])) {
    $x = isset($_POST['x']) ? preg_replace("/[^0-9-]/", "", $_POST['x']) : '0';
    $y = isset($_POST['y']) ? preg_replace("/[^0-9-]/", "", $_POST['y']) : '0';
    $s = isset($_POST['s']) ? preg_replace("/[^0-9]/", "", $_POST['s']) : '1';
    $empty_only = isset($_POST['empty_only']) ? '1' : '0';
    header("Location: " . $_SERVER['PHP_SELF'] . "?s=$s&x=$x&y=$y&empty_only=$empty_only");
    exit;
}

// ---------- Coordinates ----------
$reqX = isset($_POST['x']) ? $_POST['x'] : (isset($_GET['x']) ? $_GET['x'] : null);
$reqY = isset($_POST['y']) ? $_POST['y'] : (isset($_GET['y']) ? $_GET['y'] : null);
if ($reqX !== null && $reqY !== null && is_numeric($reqX) && is_numeric($reqY)) {
    $coor2 = ['x'=>(int)$reqX, 'y'=>(int)$reqY];
} else {
    $wref2 = $village->wid;
    $coor2 = $database->getCoor($wref2);
}
$startX = isset($coor2['x']) ? (int)$coor2['x'] : 0;
$startY = isset($coor2['y']) ? (int)$coor2['y'] : 0;

// ---------- Oasis POST Search ----------
$mode = isset($_GET['mode']) ? $_GET['mode'] : (isset($_POST['oasis_search']) ? 'oasis' : 'crop');
$oasis_results = null;
$oasis_error = "";
$searched_player = "";

if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

if ($_hasPlus && isset($_POST['oasis_search'])) {
    if (empty($_POST['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
        $oasis_error = (defined('LANG') && LANG === 'ar') ? "الجلسة غير صالحة، يرجى المحاولة مرة أخرى" : "Invalid session token, please try again";
    } else {
        $pname = trim($_POST['player_name']);
        $searched_player = $pname;
        $cost = 2000;
        
        if ($session->gold < $cost) {
            $oasis_error = (defined('LANG') && LANG === 'ar') ? "لا تملك ذهب كافي (المطلوب $cost ذهب)" : "Not enough gold (Required $cost)";
        } elseif (empty($pname)) {
            $oasis_error = (defined('LANG') && LANG === 'ar') ? "الرجاء إدخال إسم اللاعب" : "Please enter a player name";
        } else {
        $pname_esc = mysqli_real_escape_string($database->dblink, $pname);
        $q = "SELECT id, username FROM `$USERS` WHERE username = '$pname_esc'";
        $res = mysqli_query($database->dblink, $q);
        if ($res && mysqli_num_rows($res) > 0) {
            $uRow = mysqli_fetch_assoc($res);
            $uid = (int)$uRow['id'];
            $uname = $uRow['username'];
            $searched_player = $uname;
            
            // Deduct gold
            $database->modifyGold($session->uid, $cost, 0);
            
            // Include getDistance from database
            $sql = "SELECT o.wref AS oasis_id, o.type, w.x, w.y, v.name AS village_name, v.wref AS village_id
                    FROM `$ODATA` o
                    JOIN `$WDATA` w ON w.id = o.wref
                    JOIN `$VDATA` v ON v.wref = o.conqured
                    WHERE v.owner = $uid AND o.conqured != 0";
            $ores = mysqli_query($database->dblink, $sql);
            $oasis_results = [];
            if ($ores) {
                while ($r = mysqli_fetch_assoc($ores)) {
                    $r['dist'] = $database->getDistance($startX, $startY, (int)$r['x'], (int)$r['y']);
                    $oasis_results[] = $r;
                }
                usort($oasis_results, function($a, $b) { return $a['dist'] <=> $b['dist']; });
            }
        } else {
            $oasis_error = (defined('LANG') && LANG === 'ar') ? "اللاعب غير موجود" : "Player not found";
        }
    }
}
}

$selType = (!empty($_GET['s'])) ? (int)$_GET['s'] : 1;
// selType mappings:
// 1 => 15 Crop
// 2 => 9 Crop
// 3 => 150% Crop Oasis
// 4 => 100% Crop Oasis
// 5 => 100% Clay Oasis
// 6 => 100% Iron Oasis
// 7 => 100% Wood Oasis
// 8 => 75% Clay 75% Crop
// 9 => 75% Iron 75% Crop
// 10 => 75% Wood 75% Crop

$searchTriggered = isset($_GET['s']) && isset($_GET['x']) && isset($_GET['y']);
$empty_only = isset($_GET['empty_only']) ? (int)$_GET['empty_only'] : 0;
$emptyCond = $empty_only ? " AND occupied = 0" : "";
$out = [];
$tries = 0;

if ($searchTriggered && $_hasPlus) {
    if ($selType == 1 || $selType == 2) {
        // Simple search for 15c or 9c (no specific oasis required)
        $fieldWhere = ($selType == 1) ? "6" : "1"; // 6 = 15c, 1 = 9c based on fieldtype in wdata
        $sql = "SELECT id as wref, x, y, fieldtype, occupied FROM `$WDATA` WHERE fieldtype = $fieldWhere" . $emptyCond;
        $res = mysqli_query($database->dblink, $sql);
        $rows = [];
        if ($res) {
            while ($r = mysqli_fetch_assoc($res)) {
                $r['__dist'] = $database->getDistance($startX, $startY, (int)$r['x'], (int)$r['y']);
                $rows[] = $r;
            }
        }
        usort($rows, function($a,$b) { return $a['__dist'] <=> $b['__dist']; });
        $out = array_slice($rows, 0, $RENDER_MAX);

    } else {
        // Direct oasis search — find actual oases matching the requested type
        // Map selType to matching oasis types in odata
        $oasisTypes = [];
        if ($selType == 3) $oasisTypes = [12];            // Crop 150%
        if ($selType == 4) $oasisTypes = [10, 11];        // Crop 100%
        if ($selType == 5) $oasisTypes = [4, 5];          // Clay 100%
        if ($selType == 6) $oasisTypes = [7, 8];          // Iron 100%
        if ($selType == 7) $oasisTypes = [1, 2];          // Wood 100%
        if ($selType == 8) $oasisTypes = [6];             // Clay 75% + Crop 75%
        if ($selType == 9) $oasisTypes = [9];             // Iron 75% + Crop 75%
        if ($selType == 10) $oasisTypes = [3];            // Wood 75% + Crop 75%

        $typeIn = implode(',', $oasisTypes);

        // Compute bonus values for display
        $bonusForType = function($typ) {
            $b = ['wood'=>0,'clay'=>0,'iron'=>0,'crop'=>0];
            if ($typ == 1 || $typ == 2) { $b['wood'] = OASIS_BONUS_NORMAL; }
            elseif ($typ == 3) { $b['wood'] = OASIS_BONUS_MIXED; $b['crop'] = OASIS_BONUS_MIXED; }
            elseif ($typ == 4 || $typ == 5) { $b['clay'] = OASIS_BONUS_NORMAL; }
            elseif ($typ == 6) { $b['clay'] = OASIS_BONUS_MIXED; $b['crop'] = OASIS_BONUS_MIXED; }
            elseif ($typ == 7 || $typ == 8) { $b['iron'] = OASIS_BONUS_NORMAL; }
            elseif ($typ == 9) { $b['iron'] = OASIS_BONUS_MIXED; $b['crop'] = OASIS_BONUS_MIXED; }
            elseif ($typ == 10 || $typ == 11) { $b['crop'] = OASIS_BONUS_NORMAL; }
            elseif ($typ == 12) { $b['crop'] = OASIS_BONUS_STRONG; }
            return $b;
        };

        $sql = "SELECT o.wref, w.x, w.y, o.type, o.conqured, o.owner, o.name
                FROM `$ODATA` o
                JOIN `$WDATA` w ON w.id = o.wref
                WHERE o.type IN ($typeIn)";
        // Empty-only filter: owner=2 means Nature (unoccupied)
        if ($empty_only) {
            $sql .= " AND o.conqured = 0";
        }
        $res = mysqli_query($database->dblink, $sql);
        $found = [];
        if ($res) {
            while ($r = mysqli_fetch_assoc($res)) {
                $r['__dist'] = $database->getDistance($startX, $startY, (int)$r['x'], (int)$r['y']);
                $r['__bonuses'] = $bonusForType((int)$r['type']);
                $r['__is_oasis'] = true;
                $r['occupied'] = ((int)$r['conqured'] > 0) ? 1 : 0;
                $found[] = $r;
            }
        }

        usort($found, function($a,$b) { return $a['__dist'] <=> $b['__dist']; });
        $out = array_slice($found, 0, $RENDER_MAX);
    }
}

// Live owner info for visible rows
$wrefs = array_map(function($r){ return (int)$r['wref']; }, $out);
$owners = [];
if ($wrefs) {
    $in = implode(',', array_unique($wrefs));
    $sql = "SELECT v.wref, v.name AS vname, v.owner AS owner_id, u.username
            FROM `$VDATA` v
            JOIN `$USERS` u ON u.id = v.owner
            WHERE v.wref IN ($in)";
    $res = mysqli_query($database->dblink, $sql);
    if ($res) while ($row = mysqli_fetch_assoc($res)) { $owners[(int)$row['wref']] = $row; }
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html<?php echo (defined('LANG') && LANG === 'ar') ? ' dir="rtl"' : ''; ?>>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><?php echo SERVER_NAME ?> - <?php echo (defined('LANG') && LANG === 'ar') ? 'باحث الخريطة' : 'Map Finder'; ?></title>
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
<?php if($session->gpack == null || GP_ENABLE == false) {
    echo " <link href='".GP_LOCATE."travian.css?v2' rel='stylesheet' type='text/css' />";
    echo " <link href='".GP_LOCATE."lang/".LANG."/lang.css?v2' rel='stylesheet' type='text/css' />";
} else {
    echo " <link href='".$session->gpack."travian.css?v2' rel='stylesheet' type='text/css' />";
    echo " <link href='".$session->gpack."lang/".LANG."/lang.css?v2' rel='stylesheet' type='text/css' />";
} ?>
<script type="text/javascript">window.addEvent('domready', start);</script>
<link rel="stylesheet" type="text/css" href="mobile.css?v=47" />
</head>
<body class="v35 ie ie8">
<script>if('scrollRestoration'in history)history.scrollRestoration='manual';window.scrollTo(0,0);window.addEventListener('load',function(){window.scrollTo(0,0);setTimeout(function(){window.scrollTo(0,0)},0);setTimeout(function(){window.scrollTo(0,0)},50);setTimeout(function(){window.scrollTo(0,0)},100);setTimeout(function(){window.scrollTo(0,0)},200)});</script>
<div class="wrapper">
<img style="filter:chroma();" src="img/x.gif" id="msfilter" alt="" />
<div id="dynamic_header"></div>
<?php include ("Templates/header.tpl"); ?>
<div id="mid">
<?php include ("Templates/menu.tpl"); ?>

<div id="content" class="player">
<h1><?php echo (defined('LANG') && LANG === 'ar') ? 'باحث الخريطة' : 'Map Finder'; ?></h1>

<?php
// Check if player has an active Plus account
$plusCheck = mysqli_query($database->dblink, "SELECT plus FROM " . TB_PREFIX . "users WHERE id = '" . $session->uid . "'");
$plusRow = mysqli_fetch_assoc($plusCheck);
$hasPlusActive = ($plusRow && (int)$plusRow['plus'] > time());

if (!$hasPlusActive) {
    // No Plus = no access
    echo '<div style="text-align:center; padding:40px 20px;">';
    echo '<p style="font-size:16px; color:#c00; font-weight:bold;">';
    echo (defined('LANG') && LANG === 'ar')
        ? '⚠️ هذه الخاصية تتطلب حساب بلاس نشط.'
        : '⚠️ This feature requires an active Plus account.';
    echo '</p>';
    echo '<p style="margin-top:15px;">';
    echo '<a href="plus.php?id=3" style="color:#71D000; font-weight:bold; font-size:14px;">';
    echo (defined('LANG') && LANG === 'ar')
        ? '🛒 اشترِ حساب بلاس الآن'
        : '🛒 Buy Plus Account Now';
    echo '</a></p>';
    echo '</div>';
} else {
// Plus active — show the full search interface
?>
<div style="font-weight:bold; font-size:14px; margin-bottom:15px; text-align:center;">
    <a href="finder.php?mode=oasis" style="text-decoration:none; <?php echo ($mode == 'oasis') ? 'color:#000;' : 'color:#71D000;'; ?>">
        <?php echo (defined('LANG') && LANG === 'ar') ? 'البحث عن الواحات بإسم اللاعب' : 'Search for Occupied Oases'; ?>
    </a>
    | 
    <a href="finder.php" style="text-decoration:none; <?php echo ($mode == 'crop') ? 'color:#000;' : 'color:#71D000;'; ?>">
        <?php echo (defined('LANG') && LANG === 'ar') ? 'البحث عن القمحيات والواحات' : 'Search for Croppers'; ?>
    </a>
</div>

<?php if ($mode == 'crop') { ?>
<form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post">
<table>
<tr>
  <td width="200"><?php echo (defined('LANG') && LANG === 'ar') ? 'نوع البحث:' : 'Search type:'; ?></td>
  <td>
    <select class="dropdown" name="s" style="padding: 5px; width: 250px;">
      <optgroup label="<?php echo (defined('LANG') && LANG === 'ar') ? 'القرى القمحية' : 'Croppers'; ?>">
          <option value="1" <?php if($selType==1) echo 'selected'; ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'قمحية 15 حقل' : '15 Crop Village'; ?></option>
          <option value="2" <?php if($selType==2) echo 'selected'; ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'قمحية 9 حقول' : '9 Crop Village'; ?></option>
      </optgroup>
      <optgroup label="<?php echo (defined('LANG') && LANG === 'ar') ? 'الواحات' : 'Oasis Bonus Villages'; ?>">
          <option value="3" <?php if($selType==3) echo 'selected'; ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'واحة بمكافأة قمح 150%' : '150% Crop Bonus spot'; ?></option>
          <option value="4" <?php if($selType==4) echo 'selected'; ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'واحة بمكافأة قمح 100%' : '100% Crop Bonus spot'; ?></option>
          <option value="5" <?php if($selType==5) echo 'selected'; ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'واحة بمكافأة طين 100%' : '100% Clay Bonus spot'; ?></option>
          <option value="6" <?php if($selType==6) echo 'selected'; ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'واحة بمكافأة حديد 100%' : '100% Iron Bonus spot'; ?></option>
          <option value="7" <?php if($selType==7) echo 'selected'; ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'واحة بمكافأة خشب 100%' : '100% Wood Bonus spot'; ?></option>
          <option value="8" <?php if($selType==8) echo 'selected'; ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'واحة بمكافأة طين 75% و قمح 75%' : '75% Clay & 75% Crop spot'; ?></option>
          <option value="9" <?php if($selType==9) echo 'selected'; ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'واحة بمكافأة حديد 75% و قمح 75%' : '75% Iron & 75% Crop spot'; ?></option>
          <option value="10" <?php if($selType==10) echo 'selected'; ?>><?php echo (defined('LANG') && LANG === 'ar') ? 'واحة بمكافأة خشب 75% و قمح 75%' : '75% Wood & 75% Crop spot'; ?></option>
      </optgroup>
    </select>
  </td>
</tr>
<tr>
  <td colspan="2">
    <?php echo (defined('LANG') && LANG === 'ar') ? 'موقع البداية:' : 'Start position:'; ?> 
    x: <input type="text" name="x" value="<?php print $startX; ?>" size="4" />
    y: <input type="text" name="y" value="<?php print $startY; ?>" size="4" />
  </td>
</tr>
<tr>
  <td colspan="2">
    <label>
      <input type="checkbox" name="empty_only" value="1" <?php if(isset($_GET['empty_only']) && $_GET['empty_only']==1) echo 'checked'; ?> />
      <?php echo (defined('LANG') && LANG === 'ar') ? 'اظهر الغير محتلة فقط' : 'Show unoccupied villages only'; ?>
    </label>
  </td>
</tr>
<tr>
  <td colspan="2"><button type="submit" class="trav_buttons" value="Search"><?php echo (defined('LANG') && LANG === 'ar') ? 'بحث' : 'Search'; ?></button></td>
</tr>
</table>
</form>

<?php if ($searchTriggered) { ?>
<table id="member">
<thead>
<tr>
  <td><?php echo (defined('LANG') && LANG === 'ar') ? 'النوع' : 'Type'; ?></td>
  <td><?php echo (defined('LANG') && LANG === 'ar') ? 'الإحداثيات' : 'Coordinates'; ?></td>
  <td><?php echo (defined('LANG') && LANG === 'ar') ? 'المالك' : 'Owner'; ?></td>
  <td><?php echo (defined('LANG') && LANG === 'ar') ? 'مشغولة' : 'Occupied'; ?></td>
  <td><?php echo (defined('LANG') && LANG === 'ar') ? 'المسافة' : 'Distance'; ?></td>
  <?php if ($selType >= 3) { ?>
    <td><?php echo (defined('LANG') && LANG === 'ar') ? 'مكافآت الواحات' : 'Oases Bonus'; ?></td>
  <?php } ?>
</tr>
</thead>
<tbody>
<?php
if (empty($out)) {
    echo "<tr><td colspan='6' style='text-align:center; padding:10px;'>
            <em style=\"color:#999;\">".(defined('LANG') && LANG === 'ar' ? 'لا توجد قرى تطابق الفلاتر المحددة.' : 'No spots found for the selected filters.')."</em>
          </td></tr>";
} else {
    foreach ($out as $row) {
        $isOasisRow = !empty($row['__is_oasis']);

        if ($isOasisRow) {
            // Oasis result — show oasis type label
            $typeStr = (defined('LANG') && LANG === 'ar') ? 'واحة' : 'Oasis';
        } else {
            $field = '?';
            if ($row['fieldtype'] == 1) $field = '3-3-3-9'; // 9c
            elseif ($row['fieldtype'] == 2) $field = '3-4-5-6';
            elseif ($row['fieldtype'] == 3) $field = '4-4-4-6';
            elseif ($row['fieldtype'] == 4) $field = '4-5-3-6';
            elseif ($row['fieldtype'] == 5) $field = '5-3-4-6';
            elseif ($row['fieldtype'] == 6) $field = '1-1-1-15'; // 15c
            elseif ($row['fieldtype'] == 7) $field = '4-4-3-7';
            elseif ($row['fieldtype'] == 8) $field = '3-4-4-7';
            elseif ($row['fieldtype'] == 9) $field = '4-3-4-7';
            elseif ($row['fieldtype'] == 10) $field = '3-5-4-6';
            elseif ($row['fieldtype'] == 11) $field = '4-3-5-6';
            elseif ($row['fieldtype'] == 12) $field = '5-4-3-6';
            if ($selType <= 2) {
                $typeStr = ($row['fieldtype'] == 6) ? '15c' : '9c';
            } else {
                $typeStr = $field;
            }
        }

        $x=(int)$row['x']; $y=(int)$row['y']; $id=(int)$row['wref'];
        $ov = $owners[$id] ?? null;
        $isOcc = ($row['occupied'] > 0);
        
        echo "<tr><td>$typeStr</td>";
        if ($isOasisRow) {
            // Actual oasis rendering
            $oasisName = htmlspecialchars($row['name'] ?? '', ENT_QUOTES, 'UTF-8');
            if (!$isOcc) {
                $spotLabel = (defined('LANG') && LANG === 'ar') ? "واحة غير محتلة ($x|$y)" : "Unoccupied oasis ($x|$y)";
                echo "<td><a href=\"karte.php?d=".$id."&c=".$generator->getMapCheck($id)."\">".$spotLabel."</a></td>";
                echo "<td>-</td>";
                echo "<td><b><font color=\"green\">".UNOCCUPIED."</font></b></td>";
            } else {
                // Conquered oasis — show owner info
                $ownerName = '-';
                if ($ov) {
                    $ownerName = htmlspecialchars($ov['username'] ?? '', ENT_QUOTES, 'UTF-8');
                }
                $spotLabel = (defined('LANG') && LANG === 'ar') ? "واحة محتلة ($x|$y)" : "Occupied oasis ($x|$y)";
                echo "<td><a href=\"karte.php?d=".$id."&c=".$generator->getMapCheck($id)."\">".$spotLabel."</a></td>";
                echo "<td>".$ownerName."</td>";
                echo "<td><b><font color=\"red\">".OCCUPIED."</font></b></td>";
            }
        } elseif (!$isOcc) {
            $spotLabel = ABANDVALLEY . " ($x|$y)";
            echo "<td><a href=\"karte.php?d=".$id."&c=".$generator->getMapCheck($id)."\">".$spotLabel."</a></td>";
            echo "<td>-</td>";
            echo "<td><b><font color=\"green\">".UNOCCUPIED."</font></b></td>";
        } else {
            $vname = htmlspecialchars($ov['vname'] ?? '', ENT_QUOTES, 'UTF-8');
            $owner = (int)($ov['owner_id'] ?? 0);
            $uname = htmlspecialchars($ov['username'] ?? '', ENT_QUOTES, 'UTF-8');
            echo "<td><a href=\"karte.php?d=".$id."&c=".$generator->getMapCheck($id)."\">".$vname." ($x|$y)</a></td>";
            echo "<td><a href=\"spieler.php?uid=".$owner."\">".$uname."</a></td>";
            echo "<td><b><font color=\"red\">".OCCUPIED."</font></b></td>";
        }
        echo "<td><div style=\"text-align: center\">".(int)$row['__dist']."</div></td>";
        
        if ($selType >= 3) {
            $bn = $row['__bonuses'];
            $bStr = [];
            if ($bn['wood'] > 0) $bStr[] = '<img src="img/x.gif" class="r1"> '.$bn['wood'].'%';
            if ($bn['clay'] > 0) $bStr[] = '<img src="img/x.gif" class="r2"> '.$bn['clay'].'%';
            if ($bn['iron'] > 0) $bStr[] = '<img src="img/x.gif" class="r3"> '.$bn['iron'].'%';
            if ($bn['crop'] > 0) $bStr[] = '<img src="img/x.gif" class="r4"> '.$bn['crop'].'%';
            echo "<td>".implode(' ', $bStr)."</td>";
        }
        
        echo "</tr>";
    }
}
?>
</tbody>

</table>
<?php } ?>

<?php } else { ?>
<!-- OASIS SEARCH MODE -->
<form action="<?php echo $_SERVER['PHP_SELF']; ?>?mode=oasis" method="post" autocomplete="off">
<input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>" />
<table>
<tr>
  <td width="200"><?php echo (defined('LANG') && LANG === 'ar') ? 'اسم اللاعب:' : 'Player Name:'; ?></td>
  <td style="position:relative;">
    <input type="text" id="player_name_input" name="player_name" value="<?php echo htmlspecialchars($searched_player, ENT_QUOTES, 'UTF-8'); ?>" style="padding: 5px; width: 250px;" autocomplete="off" />
    <div id="autocomplete_results" style="position:absolute; top:35px; left:0; width:250px; max-height:200px; overflow-y:auto; background:#fff; border:1px solid #ccc; display:none; z-index:1000; box-shadow:0 4px 6px rgba(0,0,0,0.1);"></div>
  </td>
</tr>

<tr>
  <td colspan="2">
    <div style="color:red; font-size:11px; margin-top:5px; margin-bottom:5px;">
        <?php echo (defined('LANG') && LANG === 'ar') ? 'ملاحظة: تكلفة البحث 2000 ذهب.' : 'Note: The search costs 2000 gold.'; ?>
    </div>
    <button type="submit" name="oasis_search" class="trav_buttons" value="Search"><?php echo (defined('LANG') && LANG === 'ar') ? 'بحث' : 'Search'; ?></button>
    
    <?php if ($oasis_error) echo "<br/><br/><span style='color:red; font-weight:bold;'>$oasis_error</span>"; ?>
  </td>
</tr>
</table>
</form>

<script type="text/javascript">
document.getElementById('player_name_input').addEventListener('input', function() {
    var query = this.value;
    var resultsDiv = document.getElementById('autocomplete_results');
    if (query.length >= 3) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'ajax_player_search.php?q=' + encodeURIComponent(query), true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && xhr.status == 200) {
                try {
                    var users = JSON.parse(xhr.responseText);
                    resultsDiv.innerHTML = '';
                    if (users.length > 0) {
                        resultsDiv.style.display = 'block';
                        users.forEach(function(user) {
                            var div = document.createElement('div');
                            div.textContent = user;
                            div.style.padding = '8px 5px';
                            div.style.cursor = 'pointer';
                            div.style.borderBottom = '1px solid #eee';
                            div.style.color = '#333';
                            div.style.fontSize = '12px';
                            div.onmouseover = function() { this.style.background = '#f0f0f0'; };
                            div.onmouseout = function() { this.style.background = '#fff'; };
                            div.onclick = function() {
                                document.getElementById('player_name_input').value = user;
                                resultsDiv.style.display = 'none';
                            };
                            resultsDiv.appendChild(div);
                        });
                    } else {
                        resultsDiv.style.display = 'none';
                    }
                } catch(e) {
                    resultsDiv.style.display = 'none';
                }
            }
        };
        xhr.send();
    } else {
        resultsDiv.style.display = 'none';
    }
});

document.addEventListener('click', function(e) {
    var input = document.getElementById('player_name_input');
    var resultsDiv = document.getElementById('autocomplete_results');
    if (e.target !== input && e.target !== resultsDiv && !resultsDiv.contains(e.target)) {
        resultsDiv.style.display = 'none';
    }
});
</script>

<?php if (is_array($oasis_results)) { ?>
<br />
<table id="member">
<thead>
<tr>
  <td><?php echo (defined('LANG') && LANG === 'ar') ? 'نوع الواحة' : 'Oasis Type'; ?></td>
  <td><?php echo (defined('LANG') && LANG === 'ar') ? 'الإحداثيات' : 'Coordinates'; ?></td>
  <td><?php echo (defined('LANG') && LANG === 'ar') ? 'المسافة' : 'Distance'; ?></td>
  <td><?php echo (defined('LANG') && LANG === 'ar') ? 'القرية المحتلة منها' : 'Occupied From'; ?></td>
</tr>
</thead>
<tbody>
<?php
if (empty($oasis_results)) {
    echo "<tr><td colspan='4' style='text-align:center; padding:10px;'>
            <em style=\"color:#999;\">".(defined('LANG') && LANG === 'ar' ? 'لا توجد واحات محتلة لهذا اللاعب.' : 'No occupied oases found for this player.')."</em>
          </td></tr>";
} else {
    foreach ($oasis_results as $row) {
        // Types strings
        $typeStr = '?';
        switch ($row['type']) {
            case 1: $typeStr = '<img src="img/x.gif" class="r1"> '.OASIS_BONUS_NORMAL.'%'; break;
            case 2: $typeStr = '<img src="img/x.gif" class="r1"> '.OASIS_BONUS_NORMAL.'%'; break;
            case 3: $typeStr = '<img src="img/x.gif" class="r1"> '.OASIS_BONUS_MIXED.'% <img src="img/x.gif" class="r4"> '.OASIS_BONUS_MIXED.'%'; break;
            case 4: $typeStr = '<img src="img/x.gif" class="r2"> '.OASIS_BONUS_NORMAL.'%'; break;
            case 5: $typeStr = '<img src="img/x.gif" class="r2"> '.OASIS_BONUS_NORMAL.'%'; break;
            case 6: $typeStr = '<img src="img/x.gif" class="r2"> '.OASIS_BONUS_MIXED.'% <img src="img/x.gif" class="r4"> '.OASIS_BONUS_MIXED.'%'; break;
            case 7: $typeStr = '<img src="img/x.gif" class="r3"> '.OASIS_BONUS_NORMAL.'%'; break;
            case 8: $typeStr = '<img src="img/x.gif" class="r3"> '.OASIS_BONUS_NORMAL.'%'; break;
            case 9: $typeStr = '<img src="img/x.gif" class="r3"> '.OASIS_BONUS_MIXED.'% <img src="img/x.gif" class="r4"> '.OASIS_BONUS_MIXED.'%'; break;
            case 10: $typeStr = '<img src="img/x.gif" class="r4"> '.OASIS_BONUS_NORMAL.'%'; break;
            case 11: $typeStr = '<img src="img/x.gif" class="r4"> '.OASIS_BONUS_NORMAL.'%'; break;
            case 12: $typeStr = '<img src="img/x.gif" class="r4"> '.OASIS_BONUS_STRONG.'%'; break;
        }

        $x = (int)$row['x']; $y = (int)$row['y']; $oid = (int)$row['oasis_id'];
        $vid = (int)$row['village_id'];
        $vname = htmlspecialchars($row['village_name'], ENT_QUOTES, 'UTF-8');
        
        echo "<tr>";
        echo "<td>$typeStr</td>";
        echo "<td><a href=\"karte.php?d=".$oid."&c=".$generator->getMapCheck($oid)."\">($x|$y)</a></td>";
        echo "<td><div style=\"text-align: center\">".(int)$row['dist']."</div></td>";
        echo "<td><a href=\"karte.php?d=".$vid."&c=".$generator->getMapCheck($vid)."\">".$vname."</a></td>";
        echo "</tr>";
    }
}
?>
</tbody>
</table>
<?php } ?> 
<?php } ?>

<?php } // end Plus account check ?>

</div>

<br /><br /><br /><br />
<div id="side_info">
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
<?php include ("Templates/footer.tpl"); include ("Templates/res.tpl"); ?>
<div id="stime">
<div id="ltime">
<div id="ltimeWrap">
<?php echo CALCULATED_IN;?> <b><?php echo round(($generator->pageLoadTimeEnd()-$start_timer)*1000); ?></b> ms
<br /><?php echo SERVER_TIME;?> <span id="tp1" class="b"><?php echo date('H:i:s'); ?></span>
</div>
</div>
</div>
<div id="ce"></div>
</div>
</body>
</html>

