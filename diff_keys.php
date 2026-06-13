<?php
$enCode = file_get_contents('GameEngine/Lang/en.php');
preg_match_all("/define\s*\(\s*'([^']+)'/i", $enCode, $enMatches);
$enKeys = array_unique($enMatches[1]);

$arCode = '';
for ($i=1; $i<=5; $i++) {
    $arCode .= file_get_contents('GameEngine/Lang/ar/part'.$i.'.php');
}
preg_match_all("/define\s*\(\s*'([^']+)'/i", $arCode, $arMatches);
$arKeys = array_unique($arMatches[1]);

$diff = array_diff($enKeys, $arKeys);

// Check array keys
preg_match_all("/\\\$lang\['([^']+)'\]/i", $enCode, $enArrMatches);
$enArrKeys = array_unique($enArrMatches[1]);

preg_match_all("/\\\$lang\['([^']+)'\]/i", $arCode, $arArrMatches);
$arArrKeys = array_unique($arArrMatches[1]);

$diffArr = array_diff($enArrKeys, $arArrKeys);

echo "Missing define keys:\n";
print_r($diff);

echo "Missing lang array keys:\n";
print_r($diffArr);
