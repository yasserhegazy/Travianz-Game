<?php
include("GameEngine/Database.php");

// Ensure paid_gold column exists
try { @mysqli_query($database->dblink, "ALTER TABLE " . TB_PREFIX . "users ADD COLUMN paid_gold INT(9) NOT NULL DEFAULT 0"); } catch (\Exception $e) {}

// Test: Lots of FREE gold, ZERO paid gold
$freeGold = 100000;
$paidGold = 100000;
$totalGold = $freeGold + $paidGold;

mysqli_query($database->dblink, "UPDATE " . TB_PREFIX . "users SET gold = $totalGold, paid_gold = $paidGold");

// Reset crop (never touch pop — it overwrites real village populations)
mysqli_query($database->dblink, "UPDATE " . TB_PREFIX . "vdata SET crop = 500000");

echo "<h2>Paid Gold Test - ZERO Paid Gold</h2>";
echo "<b>Total gold shown to player:</b> " . number_format($totalGold) . "<br>";
echo "<b>Free gold (in code):</b> " . number_format($freeGold) . "<br>";
echo "<b>Paid gold (in code):</b> " . number_format($paidGold) . "<br>";
echo "<br>";
echo "<b>What should happen:</b><br>";
echo "- Buy Resources: DISABLED (paid_gold = 0, should show 'insufficient paid gold' message)<br>";
echo "- Crop Refill: DISABLED (paid_gold = 0, should show 'insufficient paid gold' message)<br>";
echo "<br>";
echo "<a href='plus.php?id=3'>Go test Plus Features page</a>";
?>
