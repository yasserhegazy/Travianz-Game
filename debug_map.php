<?php
/**
 * debug_map.php — Map & Oasis Diagnostic Tool
 * 
 * Usage: Navigate to debug_map.php in browser to run diagnostics.
 * Checks for data integrity issues in wdata/odata tables that cause
 * oasis tiles to show "Abandoned Valley" instead of oasis info.
 */

include_once("GameEngine/Generator.php");
include_once("GameEngine/config.php");
include_once("GameEngine/Village.php");

$TBP = defined('TB_PREFIX') ? TB_PREFIX : 's1_';

echo "<html><head><meta charset='utf-8'><title>Map Debug</title>";
echo "<style>body{font-family:monospace;padding:20px;background:#1a1a2e;color:#e0e0e0;}";
echo "table{border-collapse:collapse;margin:10px 0;}td,th{border:1px solid #555;padding:5px 10px;text-align:left;}";
echo "th{background:#16213e;color:#0f0;}h2{color:#e94560;}h3{color:#0f0;}.warn{color:#ff0;}.err{color:#f00;}.ok{color:#0f0;}</style></head><body>";

// ==========================================
// TEST 1: Check for oasis tiles with wrong fieldtype
// ==========================================
echo "<h2>TEST 1: Oasis tiles with fieldtype != 0 (should ALL be 0)</h2>";
$q1 = "SELECT w.id, w.x, w.y, w.fieldtype, w.oasistype, w.occupied, w.image
       FROM {$TBP}wdata w
       WHERE w.oasistype > 0 AND w.fieldtype != 0
       LIMIT 50";
$r1 = mysqli_query($database->dblink, $q1);
$broken_oasis_count = 0;
if ($r1 && mysqli_num_rows($r1) > 0) {
    echo "<p class='err'>⚠️ FOUND broken oasis tiles! These have oasistype>0 but fieldtype is NOT 0:</p>";
    echo "<table><tr><th>ID</th><th>X</th><th>Y</th><th>fieldtype</th><th>oasistype</th><th>occupied</th><th>image</th></tr>";
    while ($row = mysqli_fetch_assoc($r1)) {
        echo "<tr><td>{$row['id']}</td><td>{$row['x']}</td><td>{$row['y']}</td>";
        echo "<td class='err'>{$row['fieldtype']}</td><td>{$row['oasistype']}</td>";
        echo "<td>{$row['occupied']}</td><td>{$row['image']}</td></tr>";
        $broken_oasis_count++;
    }
    echo "</table>";
} else {
    echo "<p class='ok'>✅ All oasis tiles have fieldtype=0. This is correct.</p>";
}

// Count total oasis
$q1b = "SELECT COUNT(*) as cnt FROM {$TBP}wdata WHERE oasistype > 0";
$r1b = mysqli_query($database->dblink, $q1b);
$total_oasis = mysqli_fetch_assoc($r1b)['cnt'];
echo "<p>Total oasis tiles in wdata: <b>{$total_oasis}</b></p>";

// ==========================================
// TEST 2: odata rows without matching wdata oasis
// ==========================================
echo "<h2>TEST 2: odata rows where wdata.oasistype = 0 (orphans)</h2>";
$q2 = "SELECT o.wref, o.type, o.conqured, o.owner, w.fieldtype, w.oasistype
       FROM {$TBP}odata o
       JOIN {$TBP}wdata w ON w.id = o.wref
       WHERE w.oasistype = 0
       LIMIT 20";
$r2 = mysqli_query($database->dblink, $q2);
if ($r2 && mysqli_num_rows($r2) > 0) {
    echo "<p class='err'>⚠️ FOUND orphan odata rows (wdata.oasistype=0):</p>";
    echo "<table><tr><th>wref</th><th>odata.type</th><th>conqured</th><th>owner</th><th>wdata.fieldtype</th><th>wdata.oasistype</th></tr>";
    while ($row = mysqli_fetch_assoc($r2)) {
        echo "<tr><td>{$row['wref']}</td><td>{$row['type']}</td><td>{$row['conqured']}</td>";
        echo "<td>{$row['owner']}</td><td>{$row['fieldtype']}</td><td class='err'>{$row['oasistype']}</td></tr>";
    }
    echo "</table>";
} else {
    echo "<p class='ok'>✅ All odata rows match wdata oasis tiles correctly.</p>";
}

// ==========================================
// TEST 3: wdata oasis without odata row
// ==========================================
echo "<h2>TEST 3: wdata oasis tiles missing odata entry</h2>";
$q3 = "SELECT w.id, w.x, w.y, w.oasistype
       FROM {$TBP}wdata w
       LEFT JOIN {$TBP}odata o ON o.wref = w.id
       WHERE w.oasistype > 0 AND o.wref IS NULL
       LIMIT 20";
$r3 = mysqli_query($database->dblink, $q3);
if ($r3 && mysqli_num_rows($r3) > 0) {
    echo "<p class='err'>⚠️ FOUND wdata oasis tiles with NO odata entry:</p>";
    echo "<table><tr><th>wdata.id</th><th>X</th><th>Y</th><th>oasistype</th></tr>";
    while ($row = mysqli_fetch_assoc($r3)) {
        echo "<tr><td>{$row['id']}</td><td>{$row['x']}</td><td>{$row['y']}</td><td>{$row['oasistype']}</td></tr>";
    }
    echo "</table>";
} else {
    echo "<p class='ok'>✅ All wdata oasis tiles have matching odata entries.</p>";
}

// ==========================================
// TEST 4: Sample a valid oasis and trace the click flow
// ==========================================
echo "<h2>TEST 4: Sample oasis click-flow trace</h2>";
$q4 = "SELECT w.id, w.x, w.y, w.fieldtype, w.oasistype, w.occupied,
              o.type as odata_type, o.conqured, o.owner as odata_owner
       FROM {$TBP}wdata w
       JOIN {$TBP}odata o ON o.wref = w.id
       WHERE w.oasistype > 0
       LIMIT 5";
$r4 = mysqli_query($database->dblink, $q4);
if ($r4) {
    echo "<table><tr><th>wdata.id</th><th>X</th><th>Y</th><th>fieldtype</th><th>oasistype</th><th>occupied</th><th>odata.type</th><th>conqured</th><th>odata.owner</th><th>Map Link</th><th>getMInfo test</th></tr>";
    while ($row = mysqli_fetch_assoc($r4)) {
        $id = $row['id'];
        $check = $generator->getMapCheck($id);
        $link = "karte.php?d={$id}&c={$check}";
        
        // Test getMInfo
        $minfo = $database->getMInfo($id);
        $minfo_status = '';
        if (!$minfo) {
            $minfo_status = "<span class='err'>NULL!</span>";
        } else {
            $ft = $minfo['fieldtype'] ?? '?';
            $ot = $minfo['oasistype'] ?? '?';
            $occ = $minfo['occupied'] ?? '?';
            $minfo_status = "ft={$ft}, ot={$ot}, occ={$occ}";
            if ($ft != 0) $minfo_status = "<span class='err'>{$minfo_status}</span>";
            else $minfo_status = "<span class='ok'>{$minfo_status}</span>";
        }
        
        echo "<tr><td>{$id}</td><td>{$row['x']}</td><td>{$row['y']}</td>";
        echo "<td>" . ($row['fieldtype'] != 0 ? "<span class='err'>{$row['fieldtype']}</span>" : "<span class='ok'>{$row['fieldtype']}</span>") . "</td>";
        echo "<td>{$row['oasistype']}</td><td>{$row['occupied']}</td>";
        echo "<td>{$row['odata_type']}</td><td>{$row['conqured']}</td><td>{$row['odata_owner']}</td>";
        echo "<td><a href='{$link}' style='color:#0af;'>{$link}</a></td>";
        echo "<td>{$minfo_status}</td></tr>";
    }
    echo "</table>";
}

// ==========================================
// TEST 5: Specific ID debug (if ?id= is provided)
// ==========================================
if (isset($_GET['id'])) {
    $debugId = (int)$_GET['id'];
    echo "<h2>TEST 5: Specific tile debug for ID={$debugId}</h2>";
    
    $wdata = mysqli_fetch_assoc(mysqli_query($database->dblink, "SELECT * FROM {$TBP}wdata WHERE id = {$debugId}"));
    $odata = mysqli_fetch_assoc(mysqli_query($database->dblink, "SELECT * FROM {$TBP}odata WHERE wref = {$debugId}"));
    $minfo = $database->getMInfo($debugId);
    
    echo "<h3>wdata row:</h3><pre>" . print_r($wdata, true) . "</pre>";
    echo "<h3>odata row:</h3><pre>" . print_r($odata, true) . "</pre>";
    echo "<h3>getMInfo result:</h3><pre>" . print_r($minfo, true) . "</pre>";
    
    $expectedCheck = $generator->getMapCheck($debugId);
    echo "<h3>Map check code: <span class='ok'>{$expectedCheck}</span></h3>";
    echo "<p>Expected URL: karte.php?d={$debugId}&c={$expectedCheck}</p>";
    
    // vilview.tpl logic trace
    echo "<h3>vilview.tpl logic trace:</h3>";
    if ($minfo) {
        if ($minfo['fieldtype'] != 0) {
            echo "<p class='warn'>fieldtype={$minfo['fieldtype']} (!=0) → enters VILLAGE/VALLEY branch</p>";
            if (!$minfo['occupied']) {
                echo "<p class='err'>occupied=0 → Shows ABANDVALLEY (وادي مهجور) ← THIS IS THE BUG</p>";
            } else {
                echo "<p>occupied=1 → Shows village name</p>";
            }
        } else {
            echo "<p class='ok'>fieldtype=0 → enters OASIS branch correctly</p>";
            if ($odata) {
                echo "<p>" . (!$odata['conqured'] ? "conqured=0 → UNOCCUOASIS" : "conqured={$odata['conqured']} → OCCUOASIS") . "</p>";
            }
        }
    }
}

// ==========================================
// TEST 6: Map link generation validation
// ==========================================
echo "<h2>TEST 6: Map check code validation (random sample)</h2>";
$q6 = "SELECT id, x, y, fieldtype, oasistype FROM {$TBP}wdata ORDER BY RAND() LIMIT 5";
$r6 = mysqli_query($database->dblink, $q6);
echo "<table><tr><th>ID</th><th>X</th><th>Y</th><th>fieldtype</th><th>oasistype</th><th>md5(id)</th><th>getMapCheck</th><th>Link works?</th></tr>";
while ($row = mysqli_fetch_assoc($r6)) {
    $id = $row['id'];
    $md5 = md5($id);
    $check = $generator->getMapCheck($id);
    $expected = substr($md5, 5, 2);
    $match = ($check === $expected) ? "<span class='ok'>✅ YES</span>" : "<span class='err'>❌ NO</span>";
    echo "<tr><td>{$id}</td><td>{$row['x']}</td><td>{$row['y']}</td>";
    echo "<td>{$row['fieldtype']}</td><td>{$row['oasistype']}</td>";
    echo "<td>...{$expected}...</td><td>{$check}</td><td>{$match}</td></tr>";
}
echo "</table>";

echo "<hr><p style='color:#888;'>Tip: Add ?id=XXXX to URL to debug a specific tile ID</p>";
echo "</body></html>";
