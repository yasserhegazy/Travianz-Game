<?php
include("GameEngine/Database.php");
// If image is o1-o12 but oasistype is 0, fix it!
$res = mysqli_query($database->dblink, "SELECT id, image, fieldtype, oasistype FROM s1_wdata WHERE image LIKE 'o%' AND oasistype = 0");
$count = 0;
while($row = mysqli_fetch_assoc($res)) {
    $oasistype = intval(str_replace('o', '', $row['image']));
    if ($oasistype > 0 && $oasistype <= 12) {
        mysqli_query($database->dblink, "UPDATE s1_wdata SET oasistype = $oasistype, fieldtype = 0 WHERE id = " . $row['id']);
        $count++;
    }
}
echo "Fixed $count tiles with image starting with 'o'.\n";

// What if image is t... but oasistype > 0?
$res = mysqli_query($database->dblink, "SELECT id, image, fieldtype, oasistype FROM s1_wdata WHERE image LIKE 't%' AND oasistype > 0");
$count2 = 0;
while($row = mysqli_fetch_assoc($res)) {
    // If oasistype > 0, fieldtype should be 0, and image should be o...
    $oasistype = $row['oasistype'];
    mysqli_query($database->dblink, "UPDATE s1_wdata SET image = 'o$oasistype', fieldtype = 0 WHERE id = " . $row['id']);
    $count2++;
}
echo "Fixed $count2 tiles with oasistype > 0 but wrong image.\n";
?>
