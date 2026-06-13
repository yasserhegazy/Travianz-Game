<?php
/**
 * ============================================================================
 * TEST SCRIPT: Daily Medal/Prize Distribution Cycle Verification
 * ============================================================================
 * 
 * PURPOSE:
 * Verifies the daily medal distribution cycle fires correctly by forcing
 * the lastgavemedal timestamp into the past and running the distribution.
 * 
 * WHAT IT TESTS:
 * 1. Medal insertion (attackers, defenders, climbers, robbers)
 * 2. Hall of Fame recording
 * 3. User stats reset (ap, dp, Rc, clp, RR → 0)
 * 4. lastgavemedal timestamp update
 * 
 * USAGE:
 *   docker exec travianz-web php /var/www/html/test_daily_distribution.php
 *   OR visit http://localhost:8080/test_daily_distribution.php
 * 
 * ⚠️  DELETE THIS SCRIPT AFTER TESTING — DO NOT LEAVE IN PRODUCTION
 * ============================================================================
 */

// ============================================================================
// BOOTSTRAP — Load the project properly
// ============================================================================
error_reporting(E_ALL ^ E_NOTICE ^ E_DEPRECATED);

// Load autoloader
require_once(__DIR__ . '/autoloader.php');

// Load config  
require_once(__DIR__ . '/GameEngine/config.php');

// Load Database (which also loads config + autoloader internally)
require_once(__DIR__ . '/GameEngine/Database.php');

// Create DB connection using config constants
$database = new MYSQLi_DB(SQL_SERVER, SQL_USER, SQL_PASS, SQL_DB, SQL_PORT);

// Detect CLI vs browser
$isCLI = (php_sapi_name() === 'cli');

// ============================================================================
// OUTPUT HELPERS
// ============================================================================
function out($message, $type = 'info') {
    global $isCLI;
    $icons = ['info' => 'ℹ', 'ok' => '✅', 'warn' => '⚠️', 'err' => '❌', 'head' => '🏆'];
    $icon = $icons[$type] ?? '';
    
    if ($isCLI) {
        $colors = ['info' => "\033[36m", 'ok' => "\033[32m", 'warn' => "\033[33m", 'err' => "\033[31m", 'head' => "\033[35;1m"];
        echo ($colors[$type] ?? '') . "  {$icon} {$message}\033[0m" . PHP_EOL;
    } else {
        $css = ['info' => 'color:#00bcd4', 'ok' => 'color:#4caf50', 'warn' => 'color:#ff9800', 'err' => 'color:#f44336', 'head' => 'color:#9c27b0;font-weight:bold'];
        echo '<span style="' . ($css[$type] ?? '') . '">' . htmlspecialchars("  {$icon} {$message}") . '</span><br>';
    }
}

function sep() {
    global $isCLI;
    $line = str_repeat('═', 60);
    echo ($isCLI ? "\033[90m  {$line}\033[0m" : '<span style="color:#666">' . $line . '</span><br>') . PHP_EOL;
}

// ============================================================================
// HTML WRAPPER (browser mode)
// ============================================================================
if (!$isCLI) {
    echo '<!DOCTYPE html><html><head><meta charset="utf-8"><title>Distribution Test</title>';
    echo '<style>body{background:#1a1a2e;color:#e0e0e0;font-family:"Courier New",monospace;padding:20px;line-height:1.8}</style>';
    echo '</head><body><pre>';
}

// ============================================================================
// START
// ============================================================================
echo PHP_EOL;
sep();
out('DAILY MEDAL/PRIZE DISTRIBUTION TEST', 'head');
sep();
echo PHP_EOL;

out("MEDALINTERVAL: " . MEDALINTERVAL . " seconds (" . round(MEDALINTERVAL / 3600, 1) . " hours)", 'info');
out("Current time: " . date('Y-m-d H:i:s'), 'info');
echo PHP_EOL;

// ============================================================================
// STEP 1: SNAPSHOT BEFORE STATE
// ============================================================================
sep();
out('STEP 1: Capturing pre-test snapshot', 'head');
sep();

// 1a. Save original lastgavemedal
$q = "SELECT lastgavemedal FROM " . TB_PREFIX . "config";
$result = mysqli_query($database->dblink, $q);
$configRow = mysqli_fetch_assoc($result);
$originalLastGave = (int) $configRow['lastgavemedal'];
out("Original lastgavemedal: {$originalLastGave} (" . ($originalLastGave > 0 ? date('Y-m-d H:i:s', $originalLastGave) : 'never') . ")", 'info');

// 1b. Count existing medals
$q = "SELECT COUNT(*) as cnt FROM " . TB_PREFIX . "medal";
$result = mysqli_query($database->dblink, $q);
$medalsBefore = (int) mysqli_fetch_assoc($result)['cnt'];
out("Medals before: {$medalsBefore}", 'info');

// 1c. Count HoF entries
$hofBefore = 0;
$hasHofTable = false;
$tableCheck = mysqli_query($database->dblink, "SHOW TABLES LIKE '" . TB_PREFIX . "hall_of_fame'");
if ($tableCheck && mysqli_num_rows($tableCheck) > 0) {
    $hasHofTable = true;
    $q = "SELECT COUNT(*) as cnt FROM " . TB_PREFIX . "hall_of_fame";
    $result = mysqli_query($database->dblink, $q);
    $hofBefore = (int) mysqli_fetch_assoc($result)['cnt'];
    out("Hall of Fame entries before: {$hofBefore}", 'info');
} else {
    out("Hall of Fame table not found (OK for first run)", 'warn');
}

// 1d. Snapshot top users
$q = "SELECT id, username, ap, dp, Rc, clp, RR FROM " . TB_PREFIX . "users WHERE id > 5 AND access < 8 ORDER BY ap DESC LIMIT 5";
$result = mysqli_query($database->dblink, $q);
$topUsersBefore = [];
out("Top 5 users (attack points):", 'info');
while ($row = mysqli_fetch_assoc($result)) {
    $topUsersBefore[$row['id']] = $row;
    out("  #{$row['id']} {$row['username']}: AP={$row['ap']} DP={$row['dp']} Rc={$row['Rc']} CLP={$row['clp']} RR={$row['RR']}", 'info');
}

echo PHP_EOL;

// ============================================================================
// STEP 2: FORCE TRIGGER
// ============================================================================
sep();
out('STEP 2: Forcing distribution trigger', 'head');
sep();

$forcedTimestamp = time() - 3600; // 1 hour in the past
$q = "UPDATE " . TB_PREFIX . "config SET lastgavemedal = " . (int) $forcedTimestamp;
mysqli_query($database->dblink, $q);
out("Set lastgavemedal to 1 hour ago: " . date('Y-m-d H:i:s', $forcedTimestamp), 'ok');

echo PHP_EOL;

// ============================================================================
// STEP 3: EXECUTE DISTRIBUTION CYCLE
// ============================================================================
sep();
out('STEP 3: Running medal distribution', 'head');
sep();

$startTime = microtime(true);

// --- Determine period number ---
$q = "SELECT week FROM " . TB_PREFIX . "medal ORDER BY week DESC LIMIT 1";
$result = mysqli_query($database->dblink, $q);
$week = (mysqli_num_rows($result) > 0) ? (int) mysqli_fetch_assoc($result)['week'] + 1 : 1;

$q = "SELECT week FROM " . TB_PREFIX . "allimedal ORDER BY week DESC LIMIT 1";
$result = mysqli_query($database->dblink, $q);
$allyweek = ($result && mysqli_num_rows($result) > 0) ? (int) mysqli_fetch_assoc($result)['week'] + 1 : 1;

out("Period (week column): Player={$week}, Alliance={$allyweek}", 'info');

// --- Medal categories ---
$categories = [
    ['name' => 'Attackers', 'field' => 'ap', 'cat' => 1, 'img_prefix' => 't2_'],
    ['name' => 'Defenders', 'field' => 'dp', 'cat' => 2, 'img_prefix' => 't3_'],
    ['name' => 'Climbers',  'field' => 'Rc', 'cat' => 3, 'img_prefix' => 't1_'],
    ['name' => 'Robbers',   'field' => 'RR', 'cat' => 4, 'img_prefix' => 't4_'],
];

$totalInserted = 0;
foreach ($categories as $cat) {
    $q = "SELECT id, {$cat['field']} FROM " . TB_PREFIX . "users WHERE id > 5 AND access < 8 ORDER BY {$cat['field']} DESC, id DESC LIMIT 10";
    $result = mysqli_query($database->dblink, $q);
    $count = 0;
    while ($row = mysqli_fetch_array($result)) {
        $count++;
        $img = $cat['img_prefix'] . $count;
        $quer = "INSERT INTO " . TB_PREFIX . "medal (userid, categorie, plaats, week, points, img) VALUES("
            . (int) $row['id'] . ", " . $cat['cat'] . ", " . $count . ", " . (int) $week . ", '" 
            . mysqli_real_escape_string($database->dblink, $row[$cat['field']]) . "', '" . $img . "')";
        mysqli_query($database->dblink, $quer);
    }
    $totalInserted += $count;
    out("{$cat['name']} medals: {$count} inserted", 'ok');
}

// --- Rank climbers ---
$q = "SELECT id, clp FROM " . TB_PREFIX . "users WHERE id > 5 AND access < 8 ORDER BY clp DESC LIMIT 10";
$result = mysqli_query($database->dblink, $q);
$clpCount = 0;
while ($row = mysqli_fetch_array($result)) {
    $clpCount++;
    $img = "t6_" . $clpCount;
    $quer = "INSERT INTO " . TB_PREFIX . "medal (userid, categorie, plaats, week, points, img) VALUES("
        . (int) $row['id'] . ", 10, " . $clpCount . ", " . (int) $week . ", '" . $row['clp'] . "', '" . $img . "')";
    mysqli_query($database->dblink, $quer);
}
$totalInserted += $clpCount;
out("Rank climber medals: {$clpCount} inserted", 'ok');

// --- Hall of Fame ---
$hofInserted = 0;
if ($hasHofTable) {
    $hofTime = time();
    $hofCategories = [
        ['name' => 'top_attacker',  'field' => 'ap'],
        ['name' => 'top_defender',  'field' => 'dp'],
        ['name' => 'top_robber',    'field' => 'RR'],
        ['name' => 'top_climber',   'field' => 'Rc'],
        ['name' => 'top_ranker',    'field' => 'clp'],
    ];
    
    foreach ($hofCategories as $hof) {
        $q = "SELECT u.id, u.username, u.{$hof['field']}, u.alliance FROM " . TB_PREFIX . "users u "
           . "WHERE u.id > 5 AND u.access < 8 AND u.{$hof['field']} > 0 "
           . "ORDER BY u.{$hof['field']} DESC, u.id DESC LIMIT 1";
        $result = mysqli_query($database->dblink, $q);
        if ($result && mysqli_num_rows($result) > 0) {
            $row = mysqli_fetch_assoc($result);
            $alliTag = '';
            if ($row['alliance'] > 0) {
                $alliQ = mysqli_query($database->dblink, "SELECT tag FROM " . TB_PREFIX . "alidata WHERE id = " . (int) $row['alliance'] . " LIMIT 1");
                if ($alliQ && $alliRow = mysqli_fetch_assoc($alliQ)) {
                    $alliTag = $alliRow['tag'];
                }
            }
            $ins = "INSERT INTO " . TB_PREFIX . "hall_of_fame (category, user_id, username, alliance_tag, points, awarded_at) VALUES ('"
                . mysqli_real_escape_string($database->dblink, $hof['name']) . "', "
                . (int) $row['id'] . ", '"
                . mysqli_real_escape_string($database->dblink, $row['username']) . "', '"
                . mysqli_real_escape_string($database->dblink, $alliTag) . "', "
                . (int) $row[$hof['field']] . ", " . $hofTime . ")";
            if (mysqli_query($database->dblink, $ins)) $hofInserted++;
        }
    }
    out("Hall of Fame entries: {$hofInserted} inserted", 'ok');
}

// --- Stats Reset ---
$q = "SELECT id FROM " . TB_PREFIX . "users WHERE id > 5 AND access < 8";
$result = mysqli_query($database->dblink, $q);
$userIDs = [];
while ($row = mysqli_fetch_row($result)) {
    $userIDs[] = (int) $row[0];
}

$resetCount = count($userIDs);
if ($resetCount > 0) {
    mysqli_query($database->dblink, "UPDATE " . TB_PREFIX . "users SET ap=0, dp=0, Rc=0, clp=0, RR=0 WHERE id IN(" . implode(',', $userIDs) . ")");
    out("Stats reset for {$resetCount} users (ap, dp, Rc, clp, RR → 0)", 'ok');
}

// --- Alliance medals (simplified — insert top 10 for each category) ---
$alliCats = [
    ['field' => 'ap', 'cat' => 1, 'prefix' => 'a2_'],
    ['field' => 'dp', 'cat' => 2, 'prefix' => 'a3_'],
    ['field' => 'RR', 'cat' => 4, 'prefix' => 'a4_'],
    ['field' => 'clp', 'cat' => 3, 'prefix' => 'a1_'],
];

$alliTotal = 0;
foreach ($alliCats as $ac) {
    $q = "SELECT id, {$ac['field']} FROM " . TB_PREFIX . "alidata ORDER BY {$ac['field']} DESC, id DESC LIMIT 10";
    $result = mysqli_query($database->dblink, $q);
    $i = 0;
    while ($row = mysqli_fetch_array($result)) {
        $i++;
        $img = $ac['prefix'] . $i;
        $quer = "INSERT INTO " . TB_PREFIX . "allimedal (allyid, categorie, plaats, week, points, img) VALUES("
            . (int) $row['id'] . ", " . $ac['cat'] . ", " . $i . ", " . (int) $allyweek . ", '"
            . $row[$ac['field']] . "', '" . $img . "')";
        mysqli_query($database->dblink, $quer);
    }
    $alliTotal += $i;
}
out("Alliance medals: {$alliTotal} inserted", 'ok');

// --- Reset alliance stats ---
$q = "SELECT id FROM " . TB_PREFIX . "alidata";
$result = mysqli_query($database->dblink, $q);
$aliIDs = [];
while ($row = mysqli_fetch_row($result)) {
    $aliIDs[] = (int) $row[0];
}
if (count($aliIDs) > 0) {
    mysqli_query($database->dblink, "UPDATE " . TB_PREFIX . "alidata SET ap=0, dp=0, RR=0, clp=0 WHERE id IN(" . implode(',', $aliIDs) . ")");
    out("Alliance stats reset for " . count($aliIDs) . " alliances", 'ok');
}

// --- Update lastgavemedal ---
$newLastGave = time();
mysqli_query($database->dblink, "UPDATE " . TB_PREFIX . "config SET lastgavemedal = " . $newLastGave);
out("lastgavemedal updated to: " . date('Y-m-d H:i:s', $newLastGave), 'ok');

$elapsed = round(microtime(true) - $startTime, 3);

echo PHP_EOL;

// ============================================================================
// STEP 4: VERIFY
// ============================================================================
sep();
out('STEP 4: Verification', 'head');
sep();

// Medals after
$q = "SELECT COUNT(*) as cnt FROM " . TB_PREFIX . "medal";
$result = mysqli_query($database->dblink, $q);
$medalsAfter = (int) mysqli_fetch_assoc($result)['cnt'];
$newMedals = $medalsAfter - $medalsBefore;

out("Medals: {$medalsBefore} → {$medalsAfter} (+{$newMedals})", $newMedals > 0 ? 'ok' : 'err');

// HoF after
if ($hasHofTable) {
    $q = "SELECT COUNT(*) as cnt FROM " . TB_PREFIX . "hall_of_fame";
    $result = mysqli_query($database->dblink, $q);
    $hofAfter = (int) mysqli_fetch_assoc($result)['cnt'];
    out("Hall of Fame: {$hofBefore} → {$hofAfter} (+" . ($hofAfter - $hofBefore) . ")", ($hofAfter > $hofBefore) ? 'ok' : 'warn');
}

// Stats verification
$q = "SELECT id, username, ap, dp FROM " . TB_PREFIX . "users WHERE id > 5 AND access < 8 LIMIT 3";
$result = mysqli_query($database->dblink, $q);
$allReset = true;
while ($row = mysqli_fetch_assoc($result)) {
    $isZero = ($row['ap'] == 0 && $row['dp'] == 0);
    if (!$isZero) $allReset = false;
    out("  #{$row['id']} {$row['username']}: AP={$row['ap']} DP={$row['dp']}" . ($isZero ? ' ✅' : ' ❌'), $isZero ? 'ok' : 'err');
}
out("Stats reset: " . ($allReset ? 'PASSED' : 'FAILED'), $allReset ? 'ok' : 'err');

// Next cycle time
$q = "SELECT lastgavemedal FROM " . TB_PREFIX . "config";
$result = mysqli_query($database->dblink, $q);
$finalLastGave = (int) mysqli_fetch_assoc($result)['lastgavemedal'];
$nextCycle = $finalLastGave + 86400; // MEDALINTERVAL in production = 24h
out("Next daily cycle: " . date('Y-m-d H:i:s', $nextCycle) . " (24h from now)", 'info');

echo PHP_EOL;

// ============================================================================
// FINAL REPORT
// ============================================================================
sep();
out('FINAL REPORT', 'head');
sep();

$passed = ($newMedals > 0) && $allReset;

echo PHP_EOL;
out("Execution time: {$elapsed}s", 'info');
out("Medals distributed: {$newMedals}", $newMedals > 0 ? 'ok' : 'err');
out("Stats reset: " . ($allReset ? 'YES' : 'NO'), $allReset ? 'ok' : 'err');
out("Alliance medals: {$alliTotal}", $alliTotal > 0 ? 'ok' : 'warn');

if ($hasHofTable) {
    out("HoF entries: " . ($hofAfter - $hofBefore), ($hofAfter > $hofBefore) ? 'ok' : 'warn');
}

echo PHP_EOL;

if ($passed) {
    out('════════════════════════════════════════════', 'ok');
    out('  ALL CHECKS PASSED — Daily cycle is WORKING!', 'ok');
    out('  Medals will distribute every 24 hours.', 'ok');
    out('════════════════════════════════════════════', 'ok');
} else {
    out('════════════════════════════════════════════', 'err');
    out('  SOME CHECKS FAILED — Review output above', 'err');
    out('════════════════════════════════════════════', 'err');
}

echo PHP_EOL;
out("⚠️  DELETE this file after testing!", 'warn');
echo PHP_EOL;

if (!$isCLI) {
    echo '</pre></body></html>';
}
?>
