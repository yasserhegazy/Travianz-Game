<?php
$files = glob("Templates/a2b/units_*.tpl");
foreach ($files as $file) {
    $content = file_get_contents($file);
    // <img class="unit u1" src="img/x.gif" title="Legionnaire" onclick="..." alt="Legionnaire">
    $content = preg_replace_callback('/class="unit u(\d+)"([^>]*?)title="[^"]*"([^>]*?)alt="[^"]*"/', function($matches) {
        $u_num = $matches[1];
        return 'class="unit u' . $u_num . '"' . $matches[2] . 'title="<?php echo U' . $u_num . '; ?>"' . $matches[3] . 'alt="<?php echo U' . $u_num . '; ?>"';
    }, $content);
    // some might only have title and alt without other stuff in between or similar
    // Also try general replacement: if there's class="unit u1", replace title and alt in that tag.
    $content = preg_replace_callback('/<img[^>]+class="unit u(\d+)"[^>]+>/', function($matches) {
        $tag = $matches[0];
        $u_num = $matches[1];
        $tag = preg_replace('/title="[^"]+"/', 'title="<?php echo U' . $u_num . '; ?>"', $tag);
        $tag = preg_replace('/alt="[^"]+"/', 'alt="<?php echo U' . $u_num . '; ?>"', $tag);
        return $tag;
    }, $content);
    
    file_put_contents($file, $content);
    echo "Processed $file\n";
}
