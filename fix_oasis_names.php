<?php
/**
 * One-time fix: Update existing English text in DB to Arabic
 * Run once, then delete this file.
 */
include_once("GameEngine/config.php");

$conn = new mysqli(SQL_SERVER, SQL_USER, SQL_PASS, SQL_DB, defined('SQL_PORT') ? SQL_PORT : 3306);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$prefix = TB_PREFIX;
$total = 0;

// 1. Fix oasis names in odata table
$q = "UPDATE `{$prefix}odata` SET `name` = 'واحة محتلة' WHERE `name` = 'Occupied Oasis'";
$conn->query($q);
echo "odata Occupied Oasis: " . $conn->affected_rows . " rows<br>";
$total += $conn->affected_rows;

$q = "UPDATE `{$prefix}odata` SET `name` = 'واحة غير محتلة' WHERE `name` = 'Unoccupied Oasis'";
$conn->query($q);
echo "odata Unoccupied Oasis: " . $conn->affected_rows . " rows<br>";
$total += $conn->affected_rows;

// 2. Fix report topics - replace all English fragments
$replacements = [
    'Occupied Oasis' => 'واحة محتلة',
    'Unoccupied Oasis' => 'واحة غير محتلة',
    ' attacks ' => ' يهجم على ',
];

foreach ($replacements as $en => $ar) {
    $q = "UPDATE `{$prefix}ndata` SET `topic` = REPLACE(`topic`, '" . $conn->real_escape_string($en) . "', '" . $conn->real_escape_string($ar) . "') WHERE `topic` LIKE '%" . $conn->real_escape_string($en) . "%'";
    $conn->query($q);
    echo "ndata '$en': " . $conn->affected_rows . " rows<br>";
    $total += $conn->affected_rows;
}

echo "<br><b>Total: $total rows updated. Delete this file now.</b>";
$conn->close();
