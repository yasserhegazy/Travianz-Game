<?php
// Silently ensure the column exists
try { @mysqli_query($database->dblink, "ALTER TABLE " . TB_PREFIX . "vdata ADD COLUMN crop_immunity INT(11) UNSIGNED NOT NULL DEFAULT 0"); } catch (\Exception $e) {}

// Fetch gold for this user
session_start(); // ensure session is there
if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
    header("Location: dorf1.php");
    exit;
}

$cost = 10000;

// Ensure paid_gold column exists
try { @mysqli_query($database->dblink, "ALTER TABLE " . TB_PREFIX . "users ADD COLUMN paid_gold INT(9) NOT NULL DEFAULT 0"); } catch (\Exception $e) {}

$goldQ = mysqli_query($database->dblink, "SELECT gold, paid_gold FROM " . TB_PREFIX . "users WHERE id = " . (int)$session->uid . " LIMIT 1");
$goldRow = mysqli_fetch_assoc($goldQ);
$paidGold = isset($goldRow['paid_gold']) ? (int)$goldRow['paid_gold'] : 0;

if ($paidGold < $cost) {
    // Not enough paid gold
    header("Location: plus.php?id=3&nopaid=1");
    exit;
} else {
    // Process the crop refill & protection
    $now = time();
    $village_id = $village->wid;

    // Deduct from BOTH paid_gold and gold
    mysqli_query($database->dblink, "UPDATE " . TB_PREFIX . "users SET paid_gold = paid_gold - $cost, gold = gold - $cost WHERE id = " . (int)$session->uid);

    // Set crop to max
    $maxcrop = (float)$village->maxcrop;

    // Check existing immunity — EXTEND if still active, otherwise fresh activation
    $checkQ = mysqli_query($database->dblink, "SELECT crop_immunity FROM " . TB_PREFIX . "vdata WHERE wref = " . (int)$village_id);
    $existing = mysqli_fetch_assoc($checkQ);
    $existingImmunity = isset($existing['crop_immunity']) ? (int)$existing['crop_immunity'] : 0;

    if ($existingImmunity > $now) {
        // Still active — add 1 hour on top of remaining time
        $newImmunity = $existingImmunity + 3600;
    } else {
        // Expired or never activated — fresh 1 hour from now
        $newImmunity = $now + 3600;
    }

    $q = "UPDATE " . TB_PREFIX . "vdata SET crop = $maxcrop, crop_immunity = $newImmunity WHERE wref = " . (int)$village_id;
    mysqli_query($database->dblink, $q);

    // Set a session variable to show success message on redirect
    $_SESSION['immunity_success'] = true;

    // Update session/village variables immediately
    $village->acrop = $maxcrop;
    $village->crop_immunity = $newImmunity;

    header("Location: dorf1.php");
    exit;
}
?>
