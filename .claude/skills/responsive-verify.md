# Skill: responsive-verify

**Usage:** `/responsive-verify <page-name>`

Verify a page in a real browser at multiple viewport widths.
**"Works" is not the bar — the layout must be correct, the icons must be clear, and the game must feel like itself on mobile.**
Do not mark anything done until every checkpoint below passes.

---

## Step 1 — Boot the server

```bash
docker-compose ps
```

If the PHP container (`travian_php` or equivalent) is not running:
```bash
cd "/home/yasser/afnan projects/Last-version" && docker-compose up -d
```

Wait for healthy, then confirm the game loads at **http://localhost:8082**.

---

## Step 2 — Take the desktop reference screenshot first

Before testing mobile, capture what the page looks like at full desktop width (1440px).
This is your **visual reference** — mobile must feel like the same game, not a stripped-down version.

```bash
# Using puppeteer (if installed)
node -e "
const puppeteer = require('puppeteer');
(async () => {
  const b = await puppeteer.launch();
  const p = await b.newPage();
  await p.setViewport({width:1440, height:900});
  await p.goto('http://localhost:8082/<page-url>');
  await p.screenshot({path:'/tmp/ref_desktop.png', fullPage:true});
  await b.close();
})();"

# Or using chromium directly
chromium-browser --headless --screenshot=/tmp/ref_desktop.png \
  --window-size=1440,900 "http://localhost:8082/<page-url>" 2>/dev/null

# Or use the built-in /run skill to open the browser, then screenshot manually
```

If no headless tool is available, describe the desktop layout from reading the templates and CSS — but always prefer an actual screenshot.

---

## Step 3 — Test at each viewport width

| Width | Device | Priority |
|-------|--------|---------|
| **375px** | iPhone SE / small Android | Critical |
| **390px** | iPhone 14 / most common phone | Critical |
| **768px** | iPad portrait | Critical |
| **1024px** | iPad landscape / small laptop | Important |
| **1440px** | Desktop | Regression only |

Take a screenshot at each width:
```bash
chromium-browser --headless --screenshot=/tmp/test_375.png \
  --window-size=375,812 "http://localhost:8082/<page-url>" 2>/dev/null
```

---

## Step 4 — Structural checklist (at every viewport)

Run through these at each width — these are pass/fail:

**Page structure:**
- [ ] No horizontal scrollbar on `<body>` — the page fits its width
- [ ] All content sections are visible (nothing clipped, nothing escaped its container)
- [ ] No elements overlap each other unintentionally
- [ ] The page is scrollable vertically if content exceeds viewport height

**Navigation:**
- [ ] At ≤768px: hamburger icon is visible and tappable (min 44×44px target)
- [ ] Hamburger opens the sidebar nav correctly
- [ ] Nav links are readable and tappable
- [ ] Sidebar closes when the backdrop is tapped

**Header and resources:**
- [ ] Resource bar is fully visible — all 4 resources + pop + gold shown
- [ ] Each resource icon is paired with its number (not split across lines)
- [ ] Village name / server name visible
- [ ] Navigation row (dorf1 / dorf2 / map / stats) is accessible

**Content area:**
- [ ] Main content fills the available width — not floating or indented
- [ ] Tables that exceed viewport width have horizontal scroll (do not break the page)
- [ ] Forms: all inputs are full-width and tall enough to tap (min 40px height)
- [ ] Buttons are at least 44px tall and full-width on mobile

**Text:**
- [ ] All text is readable without pinch-zooming (effective size ≥ 14px)
- [ ] Long text wraps — does not overflow its container
- [ ] Numbers (resource counts, timers, coordinates) are legible

---

## Step 5 — Visual quality checklist (at every viewport)

These are the game-specific checks. A page can pass structural checks and still look broken. Check each:

**Icons and images:**
- [ ] Resource icons (lumber/clay/iron/crop) are recognizable — not too small, not pixelated
- [ ] Building images/thumbnails maintain their original aspect ratio — not squashed or stretched
- [ ] Unit icons in training queues are recognizable at their mobile size (≥ 32px)
- [ ] CSS sprites (img/x.gif with background) render correctly — background not cut off or misaligned
- [ ] Decorative panorama images fill their container without tiling or gaps
- [ ] No broken image icons (missing `src`)

**Layout intent:**
- [ ] The most important content (the thing the user came to this page to do) is visible above the fold
- [ ] Sections feel balanced — not one giant block on top and tiny fragments below
- [ ] Card-style elements (building info, unit info) have consistent sizing across the page
- [ ] There is breathing room (padding/margin) — content does not touch the screen edge

**Game aesthetic:**
- [ ] The medieval/wood theme is preserved — no alien white boxes, no generic flat styling
- [ ] Colors match the desktop version (no unexpected color changes from layout shifts)
- [ ] Decorative borders and backgrounds that are part of the game's style are still visible
- [ ] The page feels like the Travian game, not a generic mobile website

**Specific game elements (check only if present on this page):**
- [ ] Resource bar icons and amounts stay together as pairs
- [ ] Training queue unit icons are in a scrollable row, not collapsed
- [ ] Movement table shows direction + destination + timer as the primary columns
- [ ] Building upgrade buttons are clearly visible and tappable
- [ ] Hero equipment slots display as a grid, not a vertical list
- [ ] Attack form unit inputs are in a 2-column grid and legible

---

## Step 6 — RTL / Arabic check

Switch to Arabic layout (change language setting in-game or append `?lang=ar` if supported).

- [ ] Page layout mirrors — sidebar on right, content on left
- [ ] Text is right-aligned throughout
- [ ] No elements collide from direction reversal
- [ ] Resource bar still shows correctly in RTL order
- [ ] Hamburger nav works in RTL mode
- [ ] Icons that are direction-sensitive (arrows, directional indicators) point the correct way

---

## Step 7 — Write the verify report

```
VERIFY REPORT: [page-name]
Date: [today]
Tested by: [agent session]

REFERENCE: Desktop looks like [brief description from screenshot or reading]

375px  ─── PASS / FAIL
  Structural: [any failures]
  Visual:     [any failures]

390px  ─── PASS / FAIL
  Structural: [any failures]
  Visual:     [any failures]

768px  ─── PASS / FAIL
  Structural: [any failures]
  Visual:     [any failures]

1024px ─── PASS / FAIL
  Structural: [any failures]
  Visual:     [any failures]

1440px ─── PASS / FAIL (regression)
  [any desktop regressions introduced by the mobile CSS]

RTL    ─── PASS / FAIL
  [any failures]

OVERALL: PASS / FAIL
```

---

## Step 8 — Fix failures inline

For each failure:
1. Identify the exact CSS selector from the screenshot or DOM
2. Open the correct `/mobile/` file
3. Add the targeted fix — follow all rules from `/responsive-implement`
4. Re-screenshot at the failing width
5. Confirm it passes before moving to the next failure
6. Never introduce a fix that creates a new problem at another width — re-check after each fix

---

## Step 9 — Mark done

Only after OVERALL: PASS:
1. Update `.claude/skills/responsive.md` — status → `done` for this page
2. Update `CLAUDE.md` status table
3. Report to user: "**[Page-name] verified ✓** — all viewport sizes and RTL pass."

If the page remains FAIL after reasonable fixes, report what is blocking and why (e.g., complex absolute grid that needs a template change — flag for discussion, do not guess at a solution).
