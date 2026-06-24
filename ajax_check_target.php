<?php
include_once("GameEngine/Village.php");

header('Content-Type: application/json; charset=UTF-8');

$x = isset($_POST['x']) ? (int)$_POST['x'] : 0;
$y = isset($_POST['y']) ? (int)$_POST['y'] : 0;

if($x == 0 && $y == 0){
    echo json_encode(array(
        'status' => 'error',
        'message' => 'أدخل الإحداثيات أولاً.'
    ));
    exit;
}

$qTarget = $database->query("
    SELECT id, fieldtype
    FROM ".TB_PREFIX."wdata
    WHERE x = ".$x." AND y = ".$y."
    LIMIT 1
");

$targetId = 0;


if($qTarget && mysqli_num_rows($qTarget)){
    $rTarget = mysqli_fetch_assoc($qTarget);
    $targetId = (int)$rTarget['id'];
	$targetC = (int)$rtarget['fieldtype'];
}

if($targetId <= 0){
    echo json_encode(array(
        'status' => 'error',
        'message' => 'لم يتم العثور على هدف بهذه الإحداثيات.'
    ));
    exit;
}

/* قرية لاعب */
$q = $database->query("
    SELECT v.wref, v.name, v.owner, v.capital, u.username
    FROM ".TB_PREFIX."vdata v
    LEFT JOIN ".TB_PREFIX."users u ON u.id = v.owner
    WHERE v.wref = ".$targetId."
    LIMIT 1
");

if($q && mysqli_num_rows($q)){
    $r = mysqli_fetch_assoc($q);

    $villageName = $r['name'];
    if((int)$r['capital'] == 1){
        $villageName .= ' (العاصمة)';
    }

    echo json_encode(array(
        'status' => 'ok',
        'type' => 'village',
        'owner' => $r['username'],
        'owner_id' => (int)$r['owner'],
        'village' => $villageName,
        'id' => (int)$r['wref'],
        'url' => 'karte.php?d='.(int)$r['wref'].'&c='.$generator->getMapCheck((int)$r['wref'])
		
    ));
    exit;
}

/* واحة */
if($database->isVillageOases($targetId)){
    $oasisOwnerVillage = (int)$database->getOasisField($targetId, "conqured");

    if($oasisOwnerVillage > 0){
        $ownerId = (int)$database->getVillageField($oasisOwnerVillage, "owner");
        $ownerName = $database->getUserField($ownerId, "username", 0);

        echo json_encode(array(
    'status' => 'ok',
    'type' => 'oasis',
    'owner' => $ownerName,
    'owner_id' => $ownerId,
    'village' => 'واحة مملوكة',
    'id' => $targetId,
    'url' => 'karte.php?d='.$targetId.'&c='.$generator->getMapCheck($targetId)
));
exit;
    }

    echo json_encode(array(
    'status' => 'ok',
    'type' => 'oasis',
    'owner' => '',
    'owner_id' => 0,
    'village' => 'واحة غير مملوكة',
    'id' => $targetId,
    'url' => 'karte.php?d='.$targetId.'&c='.$generator->getMapCheck($targetId)
));
exit;
}

echo json_encode(array(
    'status' => 'error',
    'message' => 'هذا الهدف غير معروف.'
));
exit;
?>