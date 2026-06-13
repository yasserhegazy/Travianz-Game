const fs = require('fs');
const path = require('path');

let modifiedCount = 0;

function walkDir(dir) {
    let results = [];
    if (!fs.existsSync(dir)) return results;
    const list = fs.readdirSync(dir);
    list.forEach(file => {
        const filePath = path.join(dir, file);
        const stat = fs.statSync(filePath);
        if (stat && stat.isDirectory()) {
            results = results.concat(walkDir(filePath));
        } else {
            if (filePath.endsWith('.tpl')) {
                results.push(filePath);
            }
        }
    });
    return results;
}

const files = walkDir('Templates/Build');

files.forEach(filepath => {
    let content = fs.readFileSync(filepath, 'utf8');
    let original = content;

    // Type 1: |<a href=\"build.php?gid=17&t=3...\" title=\"NPC trade\"><img class=\"npc\" src=\"img/x.gif\" alt=\"NPC trade\" title=\"NPC trade\" /></a>
    content = content.split('|<a href=\\"build.php?gid=17&t=3').join('<br/><a class=\\"npc-trade-btn\\" href=\\"build.php?gid=17&t=3');
    
    // Type 2: <div class=\"res-npc-wrap\"><a href=\"build.php?gid=17&t=3...\" title=\"NPC trade\"><img class=\"npc\" src=\"img/x.gif\" alt=\"NPC trade\" title=\"NPC trade\" /></a></div>
    content = content.split('<div class=\\"res-npc-wrap\\"><a href=\\"build.php?gid=17&t=3').join('<div style="clear:both;"></div><br/><a class=\\"npc-trade-btn\\" href=\\"build.php?gid=17&t=3');

    // Type 3: <div class=\"res-npc-wrap\"><a href=\"build.php?gid=17&t=3...\" title=\"...\" class=\"res-npc-btn\"><img class=\"npc\" src=\"img/x.gif\" alt=\"...\" title=\"...\" /></a></div>
    content = content.split(' class=\\"res-npc-btn\\"><img class=\\"npc\\" src=\\"img/x.gif\\" alt=\\"".((defined(\'LANG\') && LANG == \'ar\') ? \'تاجر المبادلة (NPC)\' : \'NPC trade\')."\\" title=\\"".((defined(\'LANG\') && LANG == \'ar\') ? \'تاجر المبادلة (NPC)\' : \'NPC trade\')."\\" /></a></div>').join('>\".((defined(\'LANG\') && LANG == \'ar\') ? \'تاجر المبادلة\' : \'NPC Trade\').\"</a>');
    
    // End replacement for Type 1 and Type 2 (without class="res-npc-btn")
    content = content.split('\\" title=\\"NPC trade\\"><img class=\\"npc\\" src=\\"img/x.gif\\" alt=\\"NPC trade\\" title=\\"NPC trade\\" /></a></div>').join('\\">\".((defined(\'LANG\') && LANG == \'ar\') ? \'تاجر المبادلة\' : \'NPC Trade\').\"</a>');
    content = content.split('\\" title=\\"NPC trade\\"><img class=\\"npc\\" src=\\"img/x.gif\\" alt=\\"NPC trade\\" title=\\"NPC trade\\" /></a>').join('\\">\".((defined(\'LANG\') && LANG == \'ar\') ? \'تاجر المبادلة\' : \'NPC Trade\').\"</a>');

    if (content !== original) {
        fs.writeFileSync(filepath, content, 'utf8');
        modifiedCount++;
        console.log(`Updated ${filepath}`);
    }
});

console.log(`Modified ${modifiedCount} files.`);
