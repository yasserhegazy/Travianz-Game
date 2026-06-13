import os
import re

directory = r'C:\Users\MSI-PC\OneDrive\Documents\freelancing\TravianZ-master\Templates\a2b'
files = ['units_1.tpl', 'units_2.tpl', 'units_3.tpl', 'units_4.tpl', 'units_5.tpl']

pattern = re.compile(r'>\("\.\$village->unitarray\[\'([^\']+)\'\]\."\)</a></td>";')
replacement = r'>(".number_format($village->unitarray['\''\g<1>'\'']).")</a></td>";'

for filename in files:
    filepath = os.path.join(directory, filename)
    if os.path.exists(filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        new_content = pattern.sub(replacement, content)
        
        if new_content != content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f'Processed {filename}')
        else:
            print(f'No changes for {filename}')
    else:
        print(f'File not found: {filename}')
