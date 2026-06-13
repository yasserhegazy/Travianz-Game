<?php
include "GameEngine/Database.php";
$database->query("ALTER TABLE " . TB_PREFIX . "raidlist ADD COLUMN sort_order INT(11) NOT NULL DEFAULT 0;");
echo "Column added successfully.";
?>
