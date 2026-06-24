<?php

class sys_x8
{
public static function getEffectTitle($key)
{
    $titles = [

        'architects_positive' => ARCHITECTS_DESC,
        'speed_positive' => HASTE_DESC,
        'eyesight_positive' => EYESIGHT_DESC,
        'diet_positive' => DIET_DESC,
        'academic_positive' => ACADEMIC_DESC,
        'storage_positive' => STORAGE_DESC,
        'cranny_positive' => CONFUSION_DESC,
        'attack_positive' => ATTACKER_DESC,
        'defense_positive' => DEFENDER_DESC,
        'raid_positive' => RAID_DESC,
        'stealth_positive' => STEALTH_DESC,

        'speed_negative' => 'لعنة البطء',
        'diet_negative' => 'لعنة الجوع',
        'storage_negative' => 'لعنة التخزين',
        'attack_negative' => 'لعنة الضعف',
        'academic_negative' => 'لعنة التكلفة',
		'raid_negative' => 'لعنة النهب',

    ];

    return isset($titles[$key]) ? $titles[$key] : 'Unknown';
}

public static function getCurrentEffect($artefactId)
    {
        global $database;

        $result = $database->query("
            SELECT *
            FROM s9099_joker_effects
            WHERE artefact_id = ".intval($artefactId)."
            LIMIT 1
        ");

        if(mysqli_num_rows($result))
        {
            return mysqli_fetch_assoc($result);
        }

        return false;
    }
public static function getRandomEffect($jokerSize)
{
$jokerSize = (int)$jokerSize;
	$effects = [

        // Positive
        ['effect_key'=>'architects_positive', 'effect_name'=>self::getEffectTitle('architects_positive'), 'effect_type'=>'positive', 'rarity'=>'common', 'value_small'=>6, 'value_large'=>4, 'value_unique'=>10, 'weight'=>18],
        ['effect_key'=>'speed_positive', 'effect_name'=>self::getEffectTitle('speed_positive'), 'effect_type'=>'positive', 'rarity'=>'epic', 'value_small'=>0.5, 'value_large'=>0.6667, 'value_unique'=>0.3333, 'weight'=>6],
        ['effect_key'=>'eyesight_positive', 'effect_name'=>self::getEffectTitle('eyesight_positive'), 'effect_type'=>'positive', 'rarity'=>'common', 'value_small'=>7, 'value_large'=>5, 'value_unique'=>12, 'weight'=>18],
        ['effect_key'=>'diet_positive', 'effect_name'=>self::getEffectTitle('diet_positive'), 'effect_type'=>'positive', 'rarity'=>'common', 'value1'=>0.5, 'weight'=>18],
        ['effect_key'=>'storage_positive', 'effect_name'=>self::getEffectTitle('storage_positive'), 'effect_type'=>'positive', 'rarity'=>'common', 'value_small'=>5, 'value_large'=>3, 'value_unique'=>10, 'weight'=>18],
        ['effect_key'=>'attack_positive', 'effect_name'=>self::getEffectTitle('attack_positive'), 'effect_type'=>'positive', 'rarity'=>'epic', 'value1'=>1.75, 'weight'=>6],
        ['effect_key'=>'defense_positive', 'effect_name'=>self::getEffectTitle('defense_positive'), 'effect_type'=>'positive', 'rarity'=>'epic', 'value1'=>1.75, 'weight'=>6],
        ['effect_key'=>'raid_positive', 'effect_name'=>self::getEffectTitle('raid_positive'), 'effect_type'=>'positive', 'rarity'=>'rare', 'value1'=>2, 'weight'=>10],
        ['effect_key'=>'stealth_positive', 'effect_name'=>self::getEffectTitle('stealth_positive'), 'effect_type'=>'positive', 'rarity'=>'rare', 'value1'=>0.75, 'weight'=>10],
        ['effect_key'=>'academic_positive', 'effect_name'=>self::getEffectTitle('academic_positive'), 'effect_type'=>'positive', 'rarity'=>'legendary', 'value1'=>0.5, 'weight'=>2],
        ['effect_key'=>'cranny_positive', 'effect_name'=>self::getEffectTitle('cranny_positive'), 'effect_type'=>'positive', 'rarity'=>'common', 'value_small'=>6, 'value_large'=>3, 'value_unique'=>25, 'weight'=>18],

        // Negative
        ['effect_key'=>'speed_negative', 'effect_name'=>'قوات أبطأ', 'effect_type'=>'negative', 'rarity'=>'epic', 'value1'=>2, 'weight'=>12],
        ['effect_key'=>'diet_negative', 'effect_name'=>'استهلاك قمح أعلى', 'effect_type'=>'negative', 'rarity'=>'common', 'value1'=>1.5, 'weight'=>20],
        ['effect_key'=>'storage_negative', 'effect_name'=>'تخزين أقل', 'effect_type'=>'negative', 'rarity'=>'common', 'value1'=>0.5, 'weight'=>20],
        ['effect_key'=>'attack_negative', 'effect_name'=>'هجوم أضعف', 'effect_type'=>'negative', 'rarity'=>'rare', 'value1'=>0.75, 'weight'=>14],
        ['effect_key'=>'academic_negative', 'effect_name'=>'تكلفة قوات أعلى', 'effect_type'=>'negative', 'rarity'=>'epic', 'value1'=>1.5, 'weight'=>12],
		['effect_key'=>'raid_negative', 'effect_name'=>'حمولة نهب القوات أقل', 'effect_type'=>'negative', 'rarity'=>'rare', 'value1'=>0.5, 'weight'=>6],

    ];

    $totalWeight = 0;
    foreach ($effects as $effect) {
        $totalWeight += $effect['weight'];
    }

    $rand = mt_rand(1, $totalWeight);
    $current = 0;

    foreach ($effects as $effect) {
        $current += $effect['weight'];

        if ($rand <= $current) {
            return [
                'effect_key' => $effect['effect_key'],
                'effect_name' => $effect['effect_name'],
                'effect_type' => $effect['effect_type'],
                'rarity' => $effect['rarity'],
                'value1' => $effect['value1'],
                'value2' => null,
                'second_effect_key' => null,
                'second_effect_name' => null
            ];
        }
    }

    return $effects[0];
}
public static function saveEffect($artefactId, $owner, $vref, $jokerSize)
{
    global $database;

    $artefactId = (int)$artefactId;
    $owner = (int)$owner;
    $vref = (int)$vref;
    $jokerSize = (int)$jokerSize;
    $now = time();

    $effect = self::getRandomEffect($jokerSize);

    $q = "
        INSERT INTO s9099_joker_effects
        (
            artefact_id, owner, vref, joker_size,
            effect_key, effect_name, effect_type, rarity,
            value1, value2, second_effect_key, second_effect_name,
            next_change, created_at, updated_at
        )
        VALUES
        (
            $artefactId, $owner, $vref, $jokerSize,
            '".$database->escape($effect['effect_key'])."',
            '".$database->escape($effect['effect_name'])."',
            '".$database->escape($effect['effect_type'])."',
            '".$database->escape($effect['rarity'])."',
            ".(float)$effect['value1'].",
            ".(is_null($effect['value2']) ? "NULL" : (float)$effect['value2']).",
            ".(is_null($effect['second_effect_key']) ? "NULL" : "'".$database->escape($effect['second_effect_key'])."'").",
            ".(is_null($effect['second_effect_name']) ? "NULL" : "'".$database->escape($effect['second_effect_name'])."'").",
            ".($now + 86400).", $now, $now
        )
        ON DUPLICATE KEY UPDATE
            owner = VALUES(owner),
            vref = VALUES(vref),
            joker_size = VALUES(joker_size),
            effect_key = VALUES(effect_key),
            effect_name = VALUES(effect_name),
            effect_type = VALUES(effect_type),
            rarity = VALUES(rarity),
            value1 = VALUES(value1),
            value2 = VALUES(value2),
            second_effect_key = VALUES(second_effect_key),
            second_effect_name = VALUES(second_effect_name),
            next_change = VALUES(next_change),
            updated_at = VALUES(updated_at)
    ";

    $database->query($q);

    return self::getCurrentEffect($artefactId);
}
public static function getOrCreateEffect($artefactId, $owner, $vref, $jokerSize)
{
    $current = self::getCurrentEffect($artefactId);

    $artefactId = (int)$artefactId;
    $owner = (int)$owner;
    $vref = (int)$vref;
    $jokerSize = (int)$jokerSize;
    $now = time();

    if (
        !$current ||
        (int)$current['owner'] !== $owner ||
        (int)$current['vref'] !== $vref ||
        (int)$current['joker_size'] !== $jokerSize ||
        (int)$current['next_change'] <= $now
    ) {
        return self::saveEffect($artefactId, $owner, $vref, $jokerSize);
    }

    return $current;
}
public static function rerollEffect($artefactId, $owner, $vref, $jokerSize)
{
    return self::saveEffect(
        (int)$artefactId,
        (int)$owner,
        (int)$vref,
        (int)$jokerSize
    );
}
public static function applyJokerEffect($effect, $kind, $multiplicand)
{
    if (!$effect) {
        return $multiplicand;
    }

    $key = $effect['effect_key'];
    $value = (float)$effect['value1'];

    switch ($key) {

        // 1 تحفة المباني
        case 'architects_positive':
            if ($kind == 1) return $multiplicand * $value;
            break;

        // 2 تحفة تسريع القوات
        case 'speed_positive':
        case 'speed_negative':
            if ($kind == 2) return $multiplicand * $value;
            break;

        // 3 تحفة الجواسيس
        case 'eyesight_positive':
            if ($kind == 3) return $multiplicand * $value;
            break;

        // 4 تحفة القمح
        case 'diet_positive':
        case 'diet_negative':
            if ($kind == 4) return $multiplicand * $value;
            break;

        // 5 تحفة تكلفة القوات
        case 'academic_positive':
        case 'academic_negative':
            if ($kind == 5) return $multiplicand * $value;
            break;

        // 6 تحفة المخازن
        case 'storage_positive':
        case 'storage_negative':
            if ($kind == 6) return $multiplicand * $value;
            break;

        // 7 تحفة المخبأ
        case 'cranny_positive':
            if ($kind == 7) return $multiplicand * $value;
            break;

        // 10 تحفة الهجوم
        case 'attack_positive':
        case 'attack_negative':
            if ($kind == 10) return $multiplicand * $value;
            break;

        // 11 تحفة الدفاع
        case 'defense_positive':
            if ($kind == 11) return $multiplicand * $value;
            break;

        // 13 تحفة النهب
        case 'raid_positive':
        case 'raid_negative':
            if ($kind == 13) return $multiplicand * $value;
            break;

        // 14 تحفة الهجوم الخفي
        case 'stealth_positive':
            if ($kind == 14) return $multiplicand * $value;
            break;
    }

    return $multiplicand;
}
}