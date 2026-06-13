const fs = require('fs');
const path = require('path');

const dir = 'Templates/Manual';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.tpl'));

const translations = {
    '<b>Costs</b> and <b>construction time</b> for level 1': '<b><?php echo (defined("LANG") && LANG === "ar") ? "التكاليف" : "Costs"; ?></b> <?php echo (defined("LANG") && LANG === "ar") ? "و" : "and"; ?> <b><?php echo (defined("LANG") && LANG === "ar") ? "وقت البناء" : "construction time"; ?></b> <?php echo (defined("LANG") && LANG === "ar") ? "للمستوى 1" : "for level 1"; ?>',
    '<b>Costs</b> and <b>construction time</b> for level 1:': '<b><?php echo (defined("LANG") && LANG === "ar") ? "التكاليف" : "Costs"; ?></b> <?php echo (defined("LANG") && LANG === "ar") ? "و" : "and"; ?> <b><?php echo (defined("LANG") && LANG === "ar") ? "وقت البناء" : "construction time"; ?></b> <?php echo (defined("LANG") && LANG === "ar") ? "للمستوى 1:" : "for level 1:"; ?>',
    'Costs</b> and <b>construction time</b> for level 1': 'Costs</b> <?php echo (defined("LANG") && LANG === "ar") ? "و" : "and"; ?> <b><?php echo (defined("LANG") && LANG === "ar") ? "وقت البناء" : "construction time"; ?></b> <?php echo (defined("LANG") && LANG === "ar") ? "للمستوى 1" : "for level 1"; ?>',
    '<b>Costs</b> and <b>construction time</b>': '<b><?php echo (defined("LANG") && LANG === "ar") ? "التكاليف" : "Costs"; ?></b> <?php echo (defined("LANG") && LANG === "ar") ? "و" : "and"; ?> <b><?php echo (defined("LANG") && LANG === "ar") ? "وقت البناء" : "construction time"; ?></b>',
    'Costs and construction time for level 1': '<?php echo (defined("LANG") && LANG === "ar") ? "التكاليف ووقت البناء للمستوى 1" : "Costs and construction time for level 1"; ?>',
    'HINTS': '<?php echo (defined("LANG") && LANG === "ar") ? "تلميحات" : "HINTS"; ?>',
    'none': '<?php echo (defined("LANG") && LANG === "ar") ? "لا شيء" : "none"; ?>'
};

let count = 0;
for (const file of files) {
    const fullPath = path.join(dir, file);
    let originalContent = fs.readFileSync(fullPath, 'utf8');
    let content = originalContent;

    for (const [en, ar] of Object.entries(translations)) {
        if (content.includes(en)) {
            content = content.split(en).join(ar);
        }
    }

    if (content !== originalContent) {
        fs.writeFileSync(fullPath, content);
        count++;
    }
}
console.log(`Updated ${count} files.`);
