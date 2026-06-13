<?php
$dir = 'Templates/Manual';
$files = glob($dir . '/*.tpl');

$translations = [
    '<img class="att_all" src="img/x.gif" alt="attack value" title="attack value" />' => '<?php echo (defined("LANG") && LANG === "ar") ? \'<img class="att_all" src="img/x.gif" alt="القوة الهجومية" title="القوة الهجومية" />\' : \'<img class="att_all" src="img/x.gif" alt="attack value" title="attack value" />\'; ?>',
    '<img class="def_i" src="img/x.gif" alt="defence against infantry" title="defence against infantry" />' => '<?php echo (defined("LANG") && LANG === "ar") ? \'<img class="def_i" src="img/x.gif" alt="الدفاع ضد المشاة" title="الدفاع ضد المشاة" />\' : \'<img class="def_i" src="img/x.gif" alt="defence against infantry" title="defence against infantry" />\'; ?>',
    '<img class="def_c" src="img/x.gif" alt="defence against cavalry" title="defence against cavalry" />' => '<?php echo (defined("LANG") && LANG === "ar") ? \'<img class="def_c" src="img/x.gif" alt="الدفاع ضد الفرسان" title="الدفاع ضد الفرسان" />\' : \'<img class="def_c" src="img/x.gif" alt="defence against cavalry" title="defence against cavalry" />\'; ?>',
    '<img class="r1" src="img/x.gif" alt="Lumber" title="Lumber" />' => '<?php echo (defined("LANG") && LANG === "ar") ? \'<img class="r1" src="img/x.gif" alt="الخشب" title="الخشب" />\' : \'<img class="r1" src="img/x.gif" alt="Lumber" title="Lumber" />\'; ?>',
    '<img class="r2" src="img/x.gif" alt="Clay" title="Clay" />' => '<?php echo (defined("LANG") && LANG === "ar") ? \'<img class="r2" src="img/x.gif" alt="الطين" title="الطين" />\' : \'<img class="r2" src="img/x.gif" alt="Clay" title="Clay" />\'; ?>',
    '<img class="r3" src="img/x.gif" alt="Iron" title="Iron" />' => '<?php echo (defined("LANG") && LANG === "ar") ? \'<img class="r3" src="img/x.gif" alt="الحديد" title="الحديد" />\' : \'<img class="r3" src="img/x.gif" alt="Iron" title="Iron" />\'; ?>',
    '<img class="r4" src="img/x.gif" alt="Crop" title="Crop" />' => '<?php echo (defined("LANG") && LANG === "ar") ? \'<img class="r4" src="img/x.gif" alt="القمح" title="القمح" />\' : \'<img class="r4" src="img/x.gif" alt="Crop" title="Crop" />\'; ?>',
    '<img class="r5" src="img/x.gif" alt="Crop consumption" title="Crop consumption" />' => '<?php echo (defined("LANG") && LANG === "ar") ? \'<img class="r5" src="img/x.gif" alt="استهلاك القمح" title="استهلاك القمح" />\' : \'<img class="r5" src="img/x.gif" alt="Crop consumption" title="Crop consumption" />\'; ?>',
    '<th>Velocity</th>' => '<th><?php echo (defined("LANG") && LANG === "ar") ? "السرعة" : "Velocity"; ?></th>',
    '<th>Can carry</th>' => '<th><?php echo (defined("LANG") && LANG === "ar") ? "الحمولة" : "Can carry"; ?></th>',
    '<th>Upkeep</th>' => '<th><?php echo (defined("LANG") && LANG === "ar") ? "الاستهلاك" : "Upkeep"; ?></th>',
    '<th>Duration of training</th>' => '<th><?php echo (defined("LANG") && LANG === "ar") ? "مدة التدريب" : "Duration of training"; ?></th>',
    '<b>Prerequisites</b>' => '<b><?php echo (defined("LANG") && LANG === "ar") ? "المتطلبات" : "Prerequisites"; ?></b>',
    'title="back"' => 'title="<?php echo (defined("LANG") && LANG === "ar") ? \'رجوع\' : \'back\'; ?>"',
    'title="Overview"' => 'title="<?php echo (defined("LANG") && LANG === "ar") ? \'نظرة عامة\' : \'Overview\'; ?>"',
    'title="forward"' => 'title="<?php echo (defined("LANG") && LANG === "ar") ? \'التالي\' : \'forward\'; ?>"',
    'fields/hour' => '<?php echo (defined("LANG") && LANG === "ar") ? "حقول/ساعة" : "fields/hour"; ?>',
    'resources' => '<?php echo (defined("LANG") && LANG === "ar") ? "موارد" : "resources"; ?>',
    'Level' => '<?php echo (defined("LANG") && LANG === "ar") ? "المستوى" : "Level"; ?>',
	'<tr><th>Construction costs</th>' => '<tr><th><?php echo (defined("LANG") && LANG === "ar") ? "تكاليف البناء" : "Construction costs"; ?></th>',
	'<tr><th>Capacity</th>' => '<tr><th><?php echo (defined("LANG") && LANG === "ar") ? "السعة" : "Capacity"; ?></th>',
	'<tr><th>Culture points</th>' => '<tr><th><?php echo (defined("LANG") && LANG === "ar") ? "النقاط الحضارية" : "Culture points"; ?></th>',
	'<tr><th>Building times</th>' => '<tr><th><?php echo (defined("LANG") && LANG === "ar") ? "أوقات البناء" : "Building times"; ?></th>',
    '<tr><th>Resource</th>' => '<tr><th><?php echo (defined("LANG") && LANG === "ar") ? "الموارد" : "Resource"; ?></th>',
    'Romans' => '<?php echo (defined("LANG") && LANG === "ar") ? "الرومان" : "Romans"; ?>',
    'Teutons' => '<?php echo (defined("LANG") && LANG === "ar") ? "التيوتون" : "Teutons"; ?>',
    'Gauls' => '<?php echo (defined("LANG") && LANG === "ar") ? "الغال" : "Gauls"; ?>',
    'Nature' => '<?php echo (defined("LANG") && LANG === "ar") ? "الطبيعة" : "Nature"; ?>',
    'Natars' => '<?php echo (defined("LANG") && LANG === "ar") ? "الناتار" : "Natars"; ?>'
];

$count = 0;
foreach ($files as $file) {
    if (is_file($file)) {
        $content = file_get_contents($file);
        $originalContent = $content;

		// We string replace exact matches
        foreach ($translations as $en => $arabic) {
			// Don't double replace if we run this multiple times
			if (strpos($content, $en) !== false) {
            	$content = str_replace($en, $arabic, $content);
			}
        }
		
		// Regex replaces for titles and headers like "Barracks", etc... which are hard.
		
        if ($content !== $originalContent) {
            file_put_contents($file, $content);
            $count++;
        }
    }
}
echo "Updated $count files.\n";
