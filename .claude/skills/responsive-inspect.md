# Skill: responsive-inspect

**Usage:** `/responsive-inspect <page-name>`

Analyze a game page for responsive layout issues. **Read-only — zero file changes.**
Run this before `/responsive-implement`. Output stays in context for the next step.

---

## Step 1 — Locate all files for the page

```bash
# Find the entry file
ls /path/to/project/*.php | grep <page-name>

# Find template includes — trace require/include/$generator calls
grep -n "include\|require\|tpl\|template" <entry-file.php> | head -40

# Find all .tpl files involved
grep -rn "include.*\.tpl\|require.*\.tpl" <entry-file.php>
```

Read the entry PHP file fully. Trace every `require`, `include`, `$generator->`, and template-rendering call. Identify every `.tpl` involved (header.tpl + menu.tpl + the page-specific template(s)).

Read ALL template files found. For pages under `Build/` (165 files), only read the specific building template being worked on — not all 165.

---

## Step 2 — Understand the INTENDED visual layout first

Before looking for problems, understand what this page is supposed to look like.

Read `gpack/travian/main.css` for the primary classes on this page:
```bash
grep -n "\.class-name\|#id-name" gpack/travian/main.css
```

Then answer these questions:
- What is the visual hierarchy? What is the most important thing on this page?
- What content MUST be above the fold on mobile (375px, ~667px tall)?
- What can scroll below the fold?
- Is this page primarily action-driven (forms, buttons) or information-driven (stats, tables)?

---

## Step 3 — Audit layout structure

For each template, scan and note:

**Fixed dimensions:**
```bash
grep -n "width:[[:space:]]*[0-9]\+px\|height:[[:space:]]*[0-9]\+px\|width=\"[0-9]" <template.tpl>
```
- Fixed pixel widths that will exceed mobile viewport
- Fixed heights that clip content
- Absolute/fixed positioning anchored to desktop coordinates
- Tables used for layout (not data) — note their ID/class

**PHP/Logic — NEVER TOUCH:**
```bash
grep -n "<?php" <template.tpl> | head -20
```
- Note what each PHP block produces in HTML — understand it, don't touch it
- Dynamic inline styles from PHP (e.g., `style="<?php echo $x; ?>"`) — these cannot be CSS-overridden without `!important`
- Conditional HTML structures — understand what layouts can appear

**JavaScript:**
```bash
grep -n "addEvent\|\.style\.\|offsetWidth\|resize" <template.tpl>
```
- MooTools event handlers on layout elements — cannot conflict with CSS
- JS that sets element sizes — note these, as they override CSS
- Countdown timers and live-update elements — must remain visible

---

## Step 4 — Game-specific element audit

Travian has specific UI patterns. Identify which ones are present on this page and flag each:

### Resource Bar
The 4 resources (lumber, clay, iron, crop) + population + gold.
- Are the resource icons (`img/r/` or sprite background) paired with their number in the same container?
- Does the container have a fixed width that will overflow?
- **Rule: icon and number must never be separated on mobile — they are a unit**

### Village Field Grid (dorf1.php)
18 resource field slots in a non-linear decorative grid.
- Uses absolute positioning on a fixed-size background image
- On mobile this needs a completely different layout strategy — flag if present
- Do NOT try to make the existing absolute grid responsive; it needs a dedicated mobile view

### Building Grid (dorf2.php)
Buildings arranged in a decorative village image with positioned slots.
- Same issue as field grid — absolute positioning on a background
- Flag if present — needs a dedicated mobile strategy

### Training Queues (barracks, stable, workshop, siege)
Unit icons + count + name + queue timer.
- Are unit icons recognizable at small sizes?
- Do they have fixed-width rows?
- On mobile, each unit slot should stack or scroll horizontally

### Troop Movement Table
Troops in transit with direction arrow, destination, unit counts, arrival timer.
- The table likely has 8+ columns — will not fit on 375px
- Key columns (direction, destination, timer) must stay visible
- Secondary columns (individual unit counts) can go into overflow-x scroll

### Hero Equipment Slots
6 equipment slots in a specific grid arrangement.
- Are slots positioned absolutely?
- Slot images must maintain aspect ratio

### Attack / Send Troops Form
Unit count inputs, carry capacity, target coordinates.
- Input fields for each troop type — 10+ inputs in a row
- On mobile these need to stack 2-per-row or similar

### Map Tiles (karte.php)
Fixed 25×25 tile grid. Each tile has a background image.
- This is the hardest page — cannot be made responsive with CSS alone
- Flag as COMPLEX — needs a separate mobile strategy discussion

### Building Info Panels
Building image + name + level + production/upgrade info.
- Building image (CSS background sprite on img/x.gif) must maintain its aspect ratio
- Level badge must stay visible near the image

---

## Step 5 — Image and icon audit

For every image on the page, classify it:

| Type | How to identify | Mobile treatment needed |
|------|----------------|------------------------|
| **CSS sprite** (1px img/x.gif + background) | `src="img/x.gif"` | Scale the container, not the img |
| **Resource icon** (lumber/clay/iron/crop) | small icon near a number | Keep icon+number together; min 20px icon |
| **Building thumbnail** (in a list) | fixed-size image in a row | Uniform height container, overflow hidden |
| **Unit icon** | troop type small icon | Min 32px on mobile, aspect ratio locked |
| **Decorative panorama** | large background image on a div | `background-size: cover`, aspect ratio container |
| **Regular img tag** | `<img src="img/...">` | `max-width: 100%; height: auto` |
| **Inline background** | `style="background:url(...)"` | Cannot override — wrap and clip |

Note each image found: its type, container element, fixed dimensions (if any), and what treatment it needs.

---

## Step 6 — Check existing mobile coverage

```bash
# What's already covered for this page
grep -n "<page-name>\|<main-class-on-page>" mobile/_phone_ingame_pages.css
grep -rn "<entry-filename>" mobile/

# Find the main container class
grep -n "div#content\|div#main\|\.content" mobile/_phone_ingame/content.css | head -20
```

Note what is already handled and what is missing.

---

## Step 7 — Output the structured report

```
PAGE: [page-name]
ENTRY FILE: [file.php]
TEMPLATES: [list all .tpl files]
TARGET CSS FILE: [which /mobile/ file to edit]

VISUAL INTENT (desktop):
- Primary purpose: [what is the user doing on this page]
- Most important content above fold: [what]
- Can scroll below fold: [what]

GAME-SPECIFIC ELEMENTS FOUND:
- [element type]: [present / not present] — [any specific notes]

LAYOUT ISSUES (by severity):

[CRITICAL — breaks layout or makes content unreachable]
- Selector: [.class or #id]
  Problem: [description at 375px]
  Fix: [specific CSS to apply]

[VISUAL — layout works but looks bad or inconsistent]
- Selector: [.class or #id]
  Problem: [description]
  Fix: [specific CSS]

[POLISH — minor spacing, sizing, alignment]
- Selector: [.class or #id]
  Problem: [description]
  Fix: [specific CSS]

IMAGES:
- [container/selector]: [type] → [treatment needed]

ICON CONCERNS:
- [icon type + selector]: [size issue / pairing issue / aspect ratio issue]

PHP-DYNAMIC ELEMENTS (document, never touch):
- [description of what PHP controls and what HTML it produces]

JS TO PRESERVE:
- [element + what JS does to it]

SCOPE: small (< 30 lines) / medium (30–100 lines) / large (100+ lines)
COMPLEX FLAG: [yes/no — flag if game-specific layout needs special strategy]
```

---

## Rules

- Do NOT write any CSS
- Do NOT modify any `.tpl` or `.php` files
- If a page has village-grid or map-grid absolute positioning — flag as COMPLEX, do not attempt a generic fix
- If you see a bug unrelated to responsive layout — note it separately in the report, do not fix it
