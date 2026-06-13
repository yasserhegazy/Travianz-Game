const fs = require('fs');
const path = require('path');

function replaceCacheBuster(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            if (file === 'node_modules' || file === '.git') continue;
            replaceCacheBuster(fullPath);
        } else if (file.endsWith('.php') || file.endsWith('.tpl')) {
            let content = fs.readFileSync(fullPath, 'utf8');
            if (content.includes('e21d2')) {
                content = content.replace(/e21d2/g, 'v2');
                fs.writeFileSync(fullPath, content, 'utf8');
                console.log(`Updated ${fullPath}`);
            }
        }
    }
}

replaceCacheBuster(__dirname);
console.log('Cache buster replaced in all files!');
