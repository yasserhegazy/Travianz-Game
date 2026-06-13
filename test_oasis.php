<?php
include("GameEngine/Database.php");

$q = "SELECT count(*) as c FROM " . TB_PREFIX . "wdata WHERE fieldtype = 0 AND oasistype = 0";
$res = mysqli_query($database->dblink, $q);
$row = mysqli_fetch_assoc($res);
echo "fieldtype = 0 AND oasistype = 0: " . $row['c'] . "\n";

$q = "SELECT count(*) as c FROM " . TB_PREFIX . "wdata WHERE fieldtype = 0 AND image NOT LIKE 'o%'";
$res = mysqli_query($database->dblink, $q);
$row = mysqli_fetch_assoc($res);
echo "fieldtype = 0 AND image NOT LIKE 'o%': " . $row['c'] . "\n";

$q = "SELECT count(*) as c FROM " . TB_PREFIX . "odata LEFT JOIN " . TB_PREFIX . "wdata ON " . TB_PREFIX . "odata.wref = " . TB_PREFIX . "wdata.id WHERE " . TB_PREFIX . "wdata.id IS NULL";
$res = mysqli_query($database->dblink, $q);
$row = mysqli_fetch_assoc($res);
echo "odata without wdata: " . $row['c'] . "\n";

$q = "SELECT count(*) as c FROM " . TB_PREFIX . "wdata LEFT JOIN " . TB_PREFIX . "odata ON " . TB_PREFIX . "odata.wref = " . TB_PREFIX . "wdata.id WHERE " . TB_PREFIX . "wdata.oasistype != 0 AND " . TB_PREFIX . "odata.wref IS NULL";
$res = mysqli_query($database->dblink, $q);
$row = mysqli_fetch_assoc($res);
echo "wdata oasistype != 0 without odata: " . $row['c'] . "\n";
?>
