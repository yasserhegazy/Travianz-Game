<?php
/**
 * Plus Feature: 24-Hour Gold Protection
 * Base Cost: 1000 gold, doubles each activation (1000 → 2000 → 4000 → 8000...)
 * Requires password verification + CSRF token
 * Does NOT apply to villages with artifacts
 * Duration: 24 hours (86400 seconds)
 */
$PROTECTION_BASE_COST = 1000;
$PROTECTION_DURATION = 86400; // 24 hours

if (isset($_POST['activate_protection']) && isset($_POST['password'])) {

    // --- CSRF Validation ---
    if (
        !isset($_POST['csrf_token']) ||
        !isset($_SESSION['csrf_token']) ||
        !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])
    ) {
        header("Location: plus.php?id=3&error=csrf");
        exit;
    }
    // Rotate token after use
    unset($_SESSION['csrf_token']);

    $password = $_POST['password'];
    
    // Verify password via prepared statement
    $stmt = mysqli_prepare($database->dblink, "SELECT password, gold, gold_protect, gold_protect_count, is_bcrypt FROM " . TB_PREFIX . "users WHERE `id`=?");
    mysqli_stmt_bind_param($stmt, 'i', $session->uid);
    mysqli_stmt_execute($stmt);
    $userRow = mysqli_stmt_get_result($stmt);
    $userData = mysqli_fetch_array($userRow);
    mysqli_stmt_close($stmt);

    if (!$userData) {
        header("Location: plus.php?id=3&error=user");
        exit;
    }
    
    // Password verification
    $passwordValid = false;
    if ($userData['is_bcrypt'] == 1) {
        $passwordValid = password_verify($password, $userData['password']);
    } else {
        $passwordValid = (md5($password) === $userData['password']);
    }
    
    if (!$passwordValid) {
        header("Location: plus.php?id=3&error=password");
        exit;
    }
    
    // Check if already under protection
    if ($userData['gold_protect'] > time()) {
        header("Location: plus.php?id=3&error=already_protected");
        exit;
    }
    
    // Calculate cost: base_cost * 2^count
    $activationCount = (int)$userData['gold_protect_count'];
    $currentCost = $PROTECTION_BASE_COST * pow(2, $activationCount);
    
    // Check gold
    if ($userData['gold'] < $currentCost) {
        header("Location: plus.php?id=3&error=gold");
        exit;
    }
    
    // Check if any village has an artifact - if so, that village is excluded from protection
    // But the protection itself can still be activated for non-artifact villages
    // We store the protection at user level, enforcement checks artifact at village level
    
    if ($session->sit == 0) {
        // Activate protection
        $protectUntil = time() + $PROTECTION_DURATION;
        $newCount = $activationCount + 1;
        $newGold = $userData['gold'] - $currentCost;
        
        // Wrap both queries in a transaction for atomicity
        mysqli_begin_transaction($database->dblink);
        try {
            // Update user protection status
            $stmtUpdate = mysqli_prepare($database->dblink, "UPDATE " . TB_PREFIX . "users SET gold_protect = ?, gold_protect_count = ?, gold = ? WHERE `id` = ?");
            mysqli_stmt_bind_param($stmtUpdate, 'iiii', $protectUntil, $newCount, $newGold, $session->uid);
            if (!mysqli_stmt_execute($stmtUpdate)) {
                throw new Exception(mysqli_stmt_error($stmtUpdate));
            }
            mysqli_stmt_close($stmtUpdate);

            // Log gold transaction
            $logMsg = "24h Protection ($currentCost gold, activation #$newCount)";
            $stmtLog = mysqli_prepare($database->dblink, "INSERT INTO " . TB_PREFIX . "gold_fin_log (wid, log) VALUES (?, ?)");
            mysqli_stmt_bind_param($stmtLog, 'is', $village->wid, $logMsg);
            if (!mysqli_stmt_execute($stmtLog)) {
                throw new Exception(mysqli_stmt_error($stmtLog));
            }
            mysqli_stmt_close($stmtLog);

            mysqli_commit($database->dblink);
        } catch (Exception $e) {
            mysqli_rollback($database->dblink);
            error_log("Gold Protection Error: " . $e->getMessage());
            header("Location: plus.php?id=3&error=db");
            exit;
        }
        
        header("Location: plus.php?id=3&success=protection");
        exit;
    } else {
        // Sitter account cannot activate protection
        header("Location: plus.php?id=3&error=sit_active");
        exit;
    }
} elseif (isset($_POST['remove_protection']) && isset($_POST['password'])) {

    // --- CSRF Validation ---
    if (
        !isset($_POST['csrf_token']) ||
        !isset($_SESSION['csrf_token']) ||
        !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])
    ) {
        header("Location: plus.php?id=3&error=csrf");
        exit;
    }
    unset($_SESSION['csrf_token']);

    $password = $_POST['password'];
    
    // Verify password
    $stmt = mysqli_prepare($database->dblink, "SELECT password, is_bcrypt FROM " . TB_PREFIX . "users WHERE `id`=?");
    mysqli_stmt_bind_param($stmt, 'i', $session->uid);
    mysqli_stmt_execute($stmt);
    $userRow = mysqli_stmt_get_result($stmt);
    $userData = mysqli_fetch_array($userRow);
    mysqli_stmt_close($stmt);

    if (!$userData) {
        header("Location: plus.php?id=3&error=user");
        exit;
    }
    
    // Password verification
    $passwordValid = false;
    if ($userData['is_bcrypt'] == 1) {
        $passwordValid = password_verify($password, $userData['password']);
    } else {
        $passwordValid = (md5($password) === $userData['password']);
    }
    
    if (!$passwordValid) {
        header("Location: plus.php?id=3&error=password_remove");
        exit;
    }

if ($session->sit == 0) {
    // Remove gold/manual protection
    $stmtUpdate = mysqli_prepare($database->dblink, "UPDATE " . TB_PREFIX . "users SET gold_protect = 0, protect = 0 WHERE id = ?");
    mysqli_stmt_bind_param($stmtUpdate, 'i', $session->uid);
    mysqli_stmt_execute($stmtUpdate);
    mysqli_stmt_close($stmtUpdate);

    header("Location: plus.php?id=3&success=protection_removed");
    exit;
} else {
    header("Location: plus.php?id=3&error=sit_active");
    exit;
}
}
?>
