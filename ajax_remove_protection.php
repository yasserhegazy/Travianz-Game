<?php
include("GameEngine/Village.php");

if(!$session || !$session->uid) {
    echo "غير مصرح.";
    exit;
}

$password = isset($_POST['password']) ? $_POST['password'] : '';

if($password == '') {
    echo "كلمة المرور مطلوبة.";
    exit;
}

$stmt = mysqli_prepare($database->dblink, "SELECT password, is_bcrypt FROM ".TB_PREFIX."users WHERE id=?");
mysqli_stmt_bind_param($stmt, "i", $session->uid);
mysqli_stmt_execute($stmt);
$res = mysqli_stmt_get_result($stmt);
$user = mysqli_fetch_assoc($res);

$ok = false;

if($user) {
    if(!empty($user['is_bcrypt'])) {
        $ok = password_verify($password, $user['password']);
    } else {
        $ok = ($user['password'] == md5($password) || $user['password'] == $password);
    }
}

if(!$ok) {
    echo "كلمة المرور غير صحيحة.";
    exit;
}

mysqli_query($database->dblink, "UPDATE ".TB_PREFIX."users SET protect = 0, gold_protect = 0 WHERE id = ".(int)$session->uid);

echo "OK";
exit;
?>