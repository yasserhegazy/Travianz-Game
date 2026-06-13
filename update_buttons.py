import glob, re
import os

css_appended = False
with open('mobile.css', 'r', encoding='utf-8') as f:
    if 'npc-trade-btn' in f.read():
        css_appended = True

if not css_appended:
    with open('mobile.css', 'a', encoding='utf-8') as f:
        f.write('\n\n/* NPC Trade Button */\na.npc-trade-btn {\n    display: block;\n    width: 100%;\n    margin-top: 8px;\n    padding: 8px;\n    background-color: #69a531;\n    color: #fff;\n    text-align: center;\n    border-radius: 5px;\n    font-weight: bold;\n    text-decoration: none;\n    box-sizing: border-box;\n    box-shadow: 0 2px 4px rgba(0,0,0,0.2);\n}\na.npc-trade-btn:hover {\n    background-color: #79bf39;\n}\n')

files = glob.glob('Templates/Build/*.tpl') + glob.glob('Templates/Build/*/*.tpl')
modified_count = 0

for filepath in files:
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Pattern for regular units training, etc.
    # We replace |<a href=\"...\"...><img class=\"npc\"...></a>
    # with <br/><a class="npc-trade-btn" href="...">".((defined('LANG') && LANG == 'ar') ? 'تاجر المبادلة' : 'NPC Trade')."</a>
    
    pattern1 = re.compile(r'\|<a\s+href=\\"(build\.php\?gid=17&t=3[^>]*?)\\"\s*title=\\"NPC trade\\">\s*<img\s+class=\\"npc\\"[^>]*>\s*</a>')
    if pattern1.search(content):
        content = pattern1.sub(r'<br/><a class=\"npc-trade-btn\" href=\"\1\">".((defined(\'LANG\') && LANG == \'ar\') ? \'تاجر المبادلة\' : \'NPC Trade\')."</a>', content)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        modified_count += 1
        print(f'Updated {filepath}')
        continue # Avoid double sub on same content if we don't need to

    # Pattern for buildings upgrade
    pattern2 = re.compile(r'<div class=\\"res-npc-wrap\\">\s*<a href=\\"(build\.php\?gid=17&t=3[^>]*?)\\"\s*(?:class=\\"res-npc-btn\\"\s*)?title=\\"(?:NPC trade|[^"]*)\\">\s*<img\s+class=\\"npc\\"\s*[^>]*>\s*</a>\s*</div>', re.DOTALL)
    if pattern2.search(content):
        content = pattern2.sub(r'<div style=\"clear:both;\"></div><br/><a class=\"npc-trade-btn\" href=\"\1\">".((defined(\'LANG\') && LANG == \'ar\') ? \'تاجر المبادلة\' : \'NPC Trade\')."</a>', content)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        modified_count += 1
        print(f'Updated {filepath} (Pattern 2)')

print(f'Modified {modified_count} files.')
