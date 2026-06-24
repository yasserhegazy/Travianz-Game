<?php
include_once("GameEngine/Village.php");

header('Content-Type: application/json; charset=UTF-8');

$ownerId = isset($_POST['owner_id']) ? (int)$_POST['owner_id'] : 0;

if($ownerId <= 0){
    echo json_encode(array());
    exit;
}

$sql = "SELECT v.wref AS id, v.name, v.capital, w.x, w.y
        FROM ".TB_PREFIX."vdata v
        LEFT JOIN ".TB_PREFIX."wdata w ON w.id = v.wref
        WHERE v.owner = ".$ownerId."
        ORDER BY v.capital DESC, v.name ASC";

$result = $database->query($sql);

$list = array();

if($result){
    while($row = mysqli_fetch_assoc($result)){

        $name = $row['name'];

        if((int)$row['capital'] == 1){
            $name .= ' (العاصمة)';
        }

        $list[] = array(
            'id' => (int)$row['id'],
            'name' => $name,
            'x' => (int)$row['x'],
            'y' => (int)$row['y']
        );
    }
}

echo json_encode($list);
exit;
?>