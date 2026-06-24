<?php
include_once("GameEngine/Village.php");

header('Content-Type: application/json; charset=UTF-8');

$q = isset($_POST['q']) ? trim($_POST['q']) : '';

if(strlen($q) < 2){
    echo json_encode(array());
    exit;
}

$qSafe = $database->escape($q);

$sql = "SELECT id, username 
        FROM ".TB_PREFIX."users
        WHERE username LIKE '%".$qSafe."%'
        AND id > 0
        ORDER BY username ASC
        LIMIT 10";

$result = $database->query($sql);

$list = array();

if($result){
    while($row = mysqli_fetch_assoc($result)){
        $list[] = array(
            'id' => (int)$row['id'],
            'name' => $row['username']
        );
    }
}

echo json_encode($list);
exit;
?>