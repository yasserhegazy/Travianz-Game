<?php
function updateButtons() {
    $css_file = 'mobile.css';
    $css_content = file_get_contents($css_file);
    if (strpos($css_content, 'npc-trade-btn') === false) {
        $css_addition = "\n\n/* NPC Trade Button */\na.npc-trade-btn {\n    display: block;\n    width: 100%;\n    margin-top: 8px;\n    padding: 8px;\n    background-color: #69a531;\n    color: #fff;\n    text-align: center;\n    border-radius: 5px;\n    font-weight: bold;\n    text-decoration: none;\n    box-sizing: border-box;\n    box-shadow: 0 2px 4px rgba(0,0,0,0.2);\n}\na.npc-trade-btn:hover {\n    background-color: #79bf39;\n}\n";
        file_put_contents($css_file, $css_addition, FILE_APPEND);
    }

    $modified_count = 0;
    
    $iter = new RecursiveIteratorIterator(
        new RecursiveDirectoryIterator('Templates/Build', RecursiveDirectoryIterator::SKIP_DOTS),
        RecursiveIteratorIterator::SELF_FIRST,
        RecursiveIteratorIterator::CATCH_GET_CHILD
    );

    $files = [];
    foreach ($iter as $path => $dir) {
        if ($dir->isFile() && pathinfo($path, PATHINFO_EXTENSION) === 'tpl') {
            $files[] = $path;
        }
    }

    foreach ($files as $filepath) {
        $content = file_get_contents($filepath);
        $original = $content;

        // Pattern 1 for regular units training, etc.
        $pattern1 = '/\|<a\s+href="([^"]*build\.php\?gid=17&t=3[^\"]*)"\s*title="NPC trade">\s*<img\s+class="npc"[^>]*>\s*<\/a>/i';
        $content = preg_replace($pattern1, '<br/><a class="npc-trade-btn" href="$1">".((defined(\'LANG\') && LANG == \'ar\') ? \'تاجر المبادلة\' : \'NPC Trade\')."</a>', $content);

        // Pattern 2 for buildings upgrade
        $pattern2 = '/<div class="res-npc-wrap">\s*<a href="([^"]*build\.php\?gid=17&t=3[^\"]*)"\s*(?:class="res-npc-btn"\s*)?title="(?:NPC trade|[^"]*)">\s*<img\s+class="npc"\s*[^>]*>\s*<\/a>\s*<\/div>/is';
        $content = preg_replace($pattern2, '<div style="clear:both;"></div><br/><a class="npc-trade-btn" href="$1">".((defined(\'LANG\') && LANG == \'ar\') ? \'تاجر المبادلة\' : \'NPC Trade\')."</a>', $content);

        // Pattern 3 for specific cases where | is missing or structure varies
        $pattern3 = '/<a href="([^"]*build\.php\?gid=17&t=3[^\"]*)"[^>]*>\s*<img\s+class="npc"[^>]*>\s*<\/a>/i';
        $content = preg_replace($pattern3, '<br/><a class="npc-trade-btn" href="$1">".((defined(\'LANG\') && LANG == \'ar\') ? \'تاجر المبادلة\' : \'NPC Trade\')."</a>', $content);

        if ($content !== $original) {
            file_put_contents($filepath, $content);
            $modified_count++;
            echo "Updated {$filepath}\n";
        }
    }

    echo "Modified {$modified_count} files.\n";
}
updateButtons();
