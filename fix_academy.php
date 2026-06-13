<?php
$files = glob('C:/Users/MSI-PC/OneDrive/Documents/freelancing/TravianZ-master/Templates/Build/22_*.tpl');
foreach($files as $file) {
    if(!is_file($file)) continue;
    $content = file_get_contents($file);
    
    // Replace hardcoded unit names inside <a> tags
    // e.g. <a onclick="return Popup(2, 1);" href="#">Praetorian</a>
    $content = preg_replace('/<a onclick="return Popup\((\d+),\s*1\);" href="#">([^<]+)<\/a>/i', '<a onclick="return Popup($1, 1);" href="#">".constant(\'U\'.$1)."</a>', $content);
    
    // Replace hardcoded alt text in images, setting it to the constant too
    // e.g. <img class="unit u2" title="".U2."" alt="Praetorian" src="img/x.gif"/>
    $content = preg_replace('/<img class="unit u(\d+)" title="([^"]+)" alt="[^"]+" src="img\/x\.gif"\/>/i', '<img class="unit u$1" title="$2" alt="".constant(\'U\'.$1)."" src="img/x.gif"/>', $content);
    
    // Replace "Academy </a>"
    $content = preg_replace('/>\s*Academy\s*<\/a>/i', '>".ACADEMY." </a>', $content);
    
    file_put_contents($file, $content);
    echo "Processed $file\n";
}
