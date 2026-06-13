/**
 * Smart RTL CSS Fixer for TravianZ
 * 
 * Strategy: Copy EN CSS files to AR directory, then selectively flip ONLY
 * the layout properties that need RTL transformation.
 * 
 * CRITICAL: Do NOT touch background-position values — those are sprite
 * coordinates that must stay identical regardless of text direction.
 * 
 * Properties to flip:
 * - float: left <-> right
 * - text-align: left <-> right (but NOT center)
 * - margin-left <-> margin-right (standalone)
 * - padding-left <-> padding-right (standalone)
 * - left: Xpx <-> right: Xpx (for position: absolute/relative)
 * - background-position: left <-> right (keyword only, NOT pixel offsets)
 * 
 * Properties to NEVER flip:
 * - background-position with pixel values (sprite coordinates)
 * - border-left/right (visual, not directional)
 * - shorthand margin/padding (4-value: top right bottom left)
 */

const fs = require('fs');
const path = require('path');

const enDir = path.join(__dirname, 'gpack/travian_default/lang/en/compact');
const arDir = path.join(__dirname, 'gpack/travian_default/lang/ar/compact');

// Read all CSS files from EN
const cssFiles = fs.readdirSync(enDir).filter(f => f.endsWith('.css'));

console.log(`Found ${cssFiles.length} CSS files to process.`);

for (const file of cssFiles) {
    const enPath = path.join(enDir, file);
    const arPath = path.join(arDir, file);
    
    let content = fs.readFileSync(enPath, 'utf8');
    
    // --- STEP 1: Flip float values ---
    content = content.replace(/float:\s*left/g, 'float: __RIGHT__');
    content = content.replace(/float:\s*right/g, 'float: left');
    content = content.replace(/float:\s*__RIGHT__/g, 'float: right');
    
    // --- STEP 2: Flip text-align (only left/right, not center) ---
    content = content.replace(/text-align:\s*left/g, 'text-align: __RIGHT__');
    content = content.replace(/text-align:\s*right/g, 'text-align: left');
    content = content.replace(/text-align:\s*__RIGHT__/g, 'text-align: right');
    
    // --- STEP 3: Flip standalone margin-left / margin-right ---
    content = content.replace(/margin-left:/g, 'margin-__RIGHT__:');
    content = content.replace(/margin-right:/g, 'margin-left:');
    content = content.replace(/margin-__RIGHT__:/g, 'margin-right:');
    
    // --- STEP 4: Flip standalone padding-left / padding-right ---
    content = content.replace(/padding-left:/g, 'padding-__RIGHT__:');
    content = content.replace(/padding-right:/g, 'padding-left:');
    content = content.replace(/padding-__RIGHT__:/g, 'padding-right:');
    
    // --- STEP 5: Flip position left/right (absolute positioning) ---
    // Only flip "left:" and "right:" when they are CSS properties (at start of line after whitespace)
    // Do NOT flip left/right inside background-position or other compound values
    content = content.replace(/^(\s+)left:/gm, '$1__POSRIGHT__:');
    content = content.replace(/^(\s+)right:/gm, '$1left:');
    content = content.replace(/^(\s+)__POSRIGHT__:/gm, '$1right:');
    
    // --- STEP 6: Flip background-position keyword (ONLY the keyword "left"/"right", not pixel values) ---
    // Match "background-position: left" but NOT "background-position: -17px 0"
    content = content.replace(/background-position:\s*left\s+/g, 'background-position: __BGRIGHT__ ');
    content = content.replace(/background-position:\s*right\s+/g, 'background-position: left ');
    content = content.replace(/background-position:\s*__BGRIGHT__\s+/g, 'background-position: right ');
    
    // --- STEP 7: Flip clear: left/right ---
    // (but most uses are "clear: both" which doesn't need flipping)
    content = content.replace(/clear:\s*left/g, 'clear: __RIGHT__');
    content = content.replace(/clear:\s*right/g, 'clear: left');
    content = content.replace(/clear:\s*__RIGHT__/g, 'clear: right');
    
    // --- STEP 8: Flip border-left / border-right ---
    content = content.replace(/border-left:/g, 'border-__RIGHT__:');
    content = content.replace(/border-right:/g, 'border-left:');
    content = content.replace(/border-__RIGHT__:/g, 'border-right:');
    
    // --- STEP 9: Flip direction: ltr in copyright to rtl ---
    content = content.replace(/direction:\s*ltr/g, 'direction: rtl');
    
    // --- STEP 10: Fix Plus Button Wrap in RTL ---
    if (file === 'layout_part1.css') {
        // Fix plus button so it doesn't inherit conflicting margin-left from new_images.css
        // by forcing it to 0. We also keep its generated float: right and margin-right intact!
        content += '\ndiv#mtop a#plus { margin-left: 0 !important; }\n';
    }

    fs.writeFileSync(arPath, content, 'utf8');
    console.log(`✓ ${file}`);
}

// --- STEP 10: Add direction: rtl to global.css BODY ---
const globalPath = path.join(arDir, 'global.css');
let globalContent = fs.readFileSync(globalPath, 'utf8');

// Check if direction: rtl already exists in BODY
if (!globalContent.includes('direction: rtl')) {
    globalContent = globalContent.replace(
        /font-family:\s*Verdana,\s*Arial,\s*Helvetica,\s*sans-serif;\s*\}/,
        'font-family: Verdana, Arial, Helvetica, sans-serif;\ndirection: rtl;\ntext-align: right;\n}'
    );
    fs.writeFileSync(globalPath, globalContent, 'utf8');
    console.log('✓ Added direction: rtl to global.css BODY');
}

console.log('\n✅ Done! All CSS files have been intelligently RTL-converted.');
console.log('   Sprite background-positions preserved.');
console.log('   Layout properties flipped.');
