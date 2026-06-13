<?php
$directory = 'C:/Users/MSI-PC/OneDrive/Documents/freelancing/TravianZ-master/Templates/a2b/';
$files = ['units_1.tpl', 'units_2.tpl', 'units_3.tpl', 'units_4.tpl', 'units_5.tpl'];

$pattern = '/>\(\"\.\$village->unitarray\[\'([^\']+)\'\]\.\"\)<\/a><\/td>\";/';
$replacement = '>(".number_format($village->unitarray[\'$1\']).")</a></td>";';

foreach ($files as $filename) {
    $filepath = $directory . $filename;
    if (file_exists($filepath)) {
        $content = file_get_contents($filepath);
        $new_content = preg_replace($pattern, $replacement, $content);
        if ($new_content !== $content) {
            file_put_contents($filepath, $new_content);
            echo "Processed $filename\n";
        } else {
            echo "No changes for $filename\n";
        }
    } else {
        echo "File not found: $filename\n";
    }
}
?>
