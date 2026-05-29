# Skill: responsive-implement

**Usage:** `/responsive-implement <page-name>`

Apply responsive CSS for a page. The inspect report must be in context first.
After this skill completes, hand off to `/responsive-verify`.

---

## Non-negotiable rules — read before touching anything

1. **NEVER modify PHP logic** in any `.tpl` — not even a "small" change
2. **NEVER modify `gpack/travian/main.css`** — it is the desktop base; breaking it breaks everything
3. **NEVER add inline styles to `.tpl` files** — all CSS goes in the correct `/mobile/` file
4. **NEVER use JavaScript to control layout** — CSS media queries only
5. **NEVER distort game images or icons** — aspect ratios are locked; scale containers, not images
6. **NEVER separate a resource icon from its number** — they are a visual unit, always together
7. **NEVER change colors, fonts, or decorative borders** — preserve the game's medieval aesthetic
8. **ALWAYS keep `!important` minimal** — only use it to override a PHP-generated inline style
9. **ALWAYS handle RTL** — add a `[dir="rtl"]` block after every layout change

---

## Step 1 — Read the target CSS file before editing

Choose the correct file:

| Page type | File to edit |
|-----------|-------------|
| Homepage, tutorials, news | `mobile/_phone_public.css` |
| Login, signup, activate | `mobile/_phone_outgame.css` |
| In-game header / navigation | `mobile/_phone_ingame/` subfiles |
| In-game per-page overrides | `mobile/_phone_ingame_pages.css` |
| Alliance pages | `mobile/_phone_alliance.css` |
| Plus / Gold Club | `mobile/_phone_plus.css` |
| Statistics / rankings | `mobile/_phone_statistics.css` |
| Attack finder (a2b2) | `mobile/_phone_a2b2.css` |
| Manual / guide | `mobile/_phone_manual.css` |
| New section | Create `mobile/_phone_[section].css` + `@import url('mobile/_phone_[section].css?v=1');` in `mobile.css` |

Read the file from top to bottom first — understand its existing structure, where sections end, and where to insert.

---

## Step 2 — Section header format

Insert your CSS under a clearly labeled section:

```css
/* ──────────────────────────────────────────────────────────────────────
   PAGE NAME  (entry-file.php)
   ────────────────────────────────────────────────────────────────────── */
```

All phone rules go inside the existing `@media screen and (max-width: 768px)` block.
Tablet-only rules → `_tablet.css` under `@media screen and (max-width: 980px)`.
Small-phone polish → `_small_phone.css` under `@media screen and (max-width: 480px)`.

---

## Step 3 — General layout patterns

**Fixed widths → fluid:**
```css
.container { width: 100% !important; max-width: 100% !important; box-sizing: border-box; }
```

**Multi-column → stacked (generic):**
```css
.row { display: flex; flex-direction: column; gap: 8px; }
.col  { width: 100%; }
```

**Absolute positioning that escapes the viewport:**
```css
.anchored-element { position: relative !important; left: auto !important; top: auto !important; }
```

**Data tables — keep the table, add scroll wrapper:**
```css
.table-scroll-wrapper { overflow-x: auto; -webkit-overflow-scrolling: touch; }
table.data-table { min-width: 480px; } /* readable minimum, then scrolls */
```

**Layout tables (used as grid, not data) — collapse to blocks:**
```css
table.layout-table,
table.layout-table tr,
table.layout-table td { display: block; width: 100%; }
```

---

## Step 4 — Game-specific layout patterns

These patterns are specific to Travian's UI. Apply them whenever you encounter these elements.

### Resource Bar
The 4 resources (lumber, clay, iron, crop) + pop + gold must reflow without breaking icon-number pairs.

```css
/* Container reflows to wrap */
#res, .resourceWrapper, .resources {
  display: flex;
  flex-wrap: wrap;
  gap: 6px 12px;
  width: 100%;
  padding: 4px 8px;
  box-sizing: border-box;
}
/* Each resource (icon + number) stays as one unit — never split */
.resource, .res-item {
  display: flex;
  align-items: center;
  gap: 4px;
  white-space: nowrap;
  min-width: 0;
}
/* Resource icon minimum size */
.resource img, .res-icon {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
}
```

### Training Queues (unit rows in barracks/stable/workshop)
```css
/* Unit list wraps instead of overflowing */
.trainList, .unitList, table.train {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}
/* Each unit slot: icon above, input below */
.unitSlot, .train td {
  min-width: 56px;
  text-align: center;
}
/* Unit icons maintain aspect ratio */
.unitSlot img, .train img {
  max-width: 36px;
  height: auto;
  display: block;
  margin: 0 auto 4px;
}
```

### Troop Movement Table
```css
/* Scroll the whole table — do not stack it (order matters for comprehension) */
#movements, .movements, table.movements {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  display: block;
  width: 100%;
}
/* Priority columns stay — secondary unit counts can be narrowed */
.movements td { padding: 4px 6px; white-space: nowrap; }
/* Direction icon */
.movements .dir img { width: 20px; height: 20px; }
```

### Building Info Panel (building image + level + info)
```css
/* Panel becomes a flex row: image on left, info on right */
.buildingWrapper, .buildInfo {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  gap: 10px;
  padding: 8px;
}
/* Building image container: fixed size, never distort */
.buildingImage, .buildImg {
  flex-shrink: 0;
  width: 80px;
  height: 80px;
  overflow: hidden;
}
/* The 1px sprite img inside — do NOT scale this img tag */
.buildingImage img { display: block; }
/* Info section fills remaining space */
.buildingInfo { flex: 1; min-width: 0; }
```

### Hero Equipment Slots
```css
/* Slots in a 3×2 grid */
.heroItems, .equipment-slots {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
}
.heroSlot, .equip-slot {
  aspect-ratio: 1;
  overflow: hidden;
}
/* Equipment images maintain ratio */
.heroSlot img, .equip-slot img { width: 100%; height: auto; }
```

### Attack / Send Troops Form
```css
/* Unit inputs in a 2-per-row grid */
.sendTroops table, .units-table {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
  width: 100%;
}
.sendTroops td, .unit-cell {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}
/* Unit icon */
.sendTroops img { max-width: 36px; height: auto; }
/* Input field */
.sendTroops input[type="text"],
.sendTroops input[type="number"] {
  width: 100%;
  text-align: center;
  padding: 6px 4px;
  box-sizing: border-box;
}
```

### Village Field Grid (dorf1) — COMPLEX
The 18 resource slots use absolute positioning on a background image. This cannot be made responsive with simple CSS overrides.

The mobile strategy is a separate simplified list view, **not** adapting the absolute grid:
```css
/* Hide the decorative absolute grid on mobile */
#village_map, .villageBackground { display: none; }

/* Show a mobile-only grid replacement (must be added to the template as a PHP-rendered list) */
.mobile-field-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
  padding: 8px;
}
.mobile-field-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 8px;
  background: rgba(0,0,0,0.2);
  border-radius: 6px;
}
```
**Note:** If the mobile field list HTML does not yet exist in the template, this is a template task — flag it and skip for now. Do not add HTML to templates in this skill.

---

## Step 5 — Image treatment patterns

**CSS sprite (img/x.gif + background-image):**
```css
/* Scale the container — never the img tag itself */
.sprite-container {
  width: 100%;
  max-width: [original-width]px;
  overflow: hidden;
  /* If the background needs to scale: */
  background-size: cover; /* or contain */
}
/* img/x.gif: leave it alone */
```

**Regular game images (`<img src="img/buildings/..."`):**
```css
.image-wrapper img {
  max-width: 100%;
  height: auto;
  display: block;
}
```

**Decorative panorama / full-width background:**
```css
.panorama {
  width: 100%;
  height: 120px; /* reduced from desktop */
  background-size: cover;
  background-position: center;
}
```

**Icon minimum sizes on mobile (touch-friendly):**
```css
/* Small action icons — must be tappable */
.action-icon, .button-icon { min-width: 36px; min-height: 36px; }
/* Tiny info icons (resource, tribe) — visual only, no tap needed */
.res-icon, .tribe-icon { width: 20px; height: 20px; flex-shrink: 0; }
/* Unit icons in lists */
.unit-icon { width: 36px; height: 36px; object-fit: contain; }
```

---

## Step 6 — Spacing and visual rhythm

Maintain the game's visual feel. Do not make it feel like a generic website:

```css
/* Inner content areas: consistent breathing room */
#content, .content-box { padding: 10px 12px; }

/* Between sections */
.section + .section { margin-top: 16px; }

/* Action buttons: large and clear */
.btn, input[type="submit"], a.button {
  min-height: 44px;
  padding: 10px 16px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  box-sizing: border-box;
}

/* Don't let labels crowd inputs */
label { display: block; margin-bottom: 4px; }
input, select, textarea { width: 100%; box-sizing: border-box; }
```

---

## Step 7 — RTL block (always add after the main block)

```css
/* ── RTL ── */
[dir="rtl"] .selector { margin-left: 0; margin-right: 8px; }
[dir="rtl"] .flex-row  { flex-direction: row-reverse; }
[dir="rtl"] .float-left { float: right; }
/* Note: text-align is usually handled by dir="rtl" automatically — only override if broken */
```

---

## Step 8 — Self-review before saving

- Re-read every rule you wrote
- Every `{` has a closing `}`
- No PHP code accidentally included
- Class and ID names copied from the template — no guesses
- Sprite img tags are not targeted (only their containers)
- No colors, fonts, or decorative borders changed
- Resource icons and numbers kept together

---

## Step 9 — Update tracker and hand off

1. Update `.claude/skills/responsive.md` — mark this page `in progress` (or `done` after verify passes)
2. State clearly: "Implementation complete for [page-name]. Ready for `/responsive-verify [page-name]`."
