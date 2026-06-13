<?php
include("GameEngine/Database.php");
$res = mysqli_query($database->dblink, "SHOW COLUMNS FROM " . TB_PREFIX . "users");
while($row = mysqli_fetch_assoc($res)) {
    echo $row['Field'] . "<br>";
}
?>
