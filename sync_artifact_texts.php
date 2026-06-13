<?php

include __DIR__ . '/GameEngine/Config.php';

foreach (glob(__DIR__ . '/GameEngine/Lang/ar/*.php') as $langFile) {
    include_once $langFile;
}

include __DIR__ . '/GameEngine/Database.php';

global $database;

function esc($text) {
    global $database;
    return mysqli_real_escape_string($database->dblink, $text);
}

$types = [
    1 => [
        1 => [ARCHITECTS_SMALL, ARCHITECTS_DESC, '(4x)', ARCHITECTS_SMALLVILLAGE],
        2 => [ARCHITECTS_LARGE, ARCHITECTS_DESC, '(3x)', ARCHITECTS_LARGEVILLAGE],
        3 => [ARCHITECTS_UNIQUE, ARCHITECTS_DESC, '(5x)', ARCHITECTS_UNIQUEVILLAGE],
    ],
    2 => [
        1 => [HASTE_SMALL, HASTE_DESC, '(2x)', HASTE_SMALLVILLAGE],
        2 => [HASTE_LARGE, HASTE_DESC, '(1.5x)', HASTE_LARGEVILLAGE],
        3 => [HASTE_UNIQUE, HASTE_DESC, '(3x)', HASTE_UNIQUEVILLAGE],
    ],
    3 => [
        1 => [EYESIGHT_SMALL, EYESIGHT_DESC, '(5x)', EYESIGHT_SMALLVILLAGE],
        2 => [EYESIGHT_LARGE, EYESIGHT_DESC, '(3x)', EYESIGHT_LARGEVILLAGE],
        3 => [EYESIGHT_UNIQUE, EYESIGHT_DESC, '(10x)', EYESIGHT_UNIQUEVILLAGE],
    ],
    4 => [
        1 => [DIET_SMALL, DIET_DESC, '(50%)', DIET_SMALLVILLAGE],
        2 => [DIET_LARGE, DIET_DESC, '(25%)', DIET_LARGEVILLAGE],
        3 => [DIET_UNIQUE, DIET_DESC, '(60%)', DIET_UNIQUEVILLAGE],
    ],
    5 => [
        1 => [ACADEMIC_SMALL, ACADEMIC_DESC, '50', ACADEMIC_SMALLVILLAGE],
        2 => [ACADEMIC_LARGE, ACADEMIC_DESC, '25', ACADEMIC_LARGEVILLAGE],
        3 => [ACADEMIC_UNIQUE, ACADEMIC_DESC, '50', ACADEMIC_UNIQUEVILLAGE],
    ],
    6 => [
        1 => [STORAGE_SMALL, STORAGE_DESC, '(3x)', STORAGE_SMALLVILLAGE],
        2 => [STORAGE_LARGE, STORAGE_DESC, '(2x)', STORAGE_LARGEVILLAGE],
        3 => [STORAGE_UNIQUE, STORAGE_DESC, '(4x)', STORAGE_UNIQUEVILLAGE],
    ],
    7 => [
        1 => [CONFUSION_SMALL, CONFUSION_DESC, '(200)', CONFUSION_SMALLVILLAGE],
        2 => [CONFUSION_LARGE, CONFUSION_DESC, '(100)', CONFUSION_LARGEVILLAGE],
        3 => [CONFUSION_UNIQUE, CONFUSION_DESC, '(500)', CONFUSION_UNIQUEVILLAGE],
    ],
    8 => [
        1 => [FOOL_SMALL, FOOL_DESC, '', FOOL_SMALLVILLAGE],
        2 => [FOOL_LARGE, FOOL_DESC, '', FOOL_LARGEVILLAGE],
        3 => [FOOL_UNIQUE, FOOL_DESC, '', FOOL_UNIQUEVILLAGE],
    ],
];

foreach ($types as $type => $sizes) {
    foreach ($sizes as $size => $data) {
        $name = esc($data[0]);
        $desc = esc($data[1]);
        $effect = esc($data[2]);
		$vname = esc($data[3]);

        $database->query("
            UPDATE " . TB_PREFIX . "artefacts
            SET name = '$name',
                `desc` = '$desc',
                effect = '$effect'
            WHERE type = $type AND size = $size
        ");
		$database->query("
            UPDATE " . TB_PREFIX . "vdata
            SET name = '$vname'
            WHERE wref IN (
            SELECT vref FROM " . TB_PREFIX . "artefacts
            WHERE type = $type AND size = $size
    )
");
    }
}

echo "All artifact texts synced successfully!";