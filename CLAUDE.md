# CLAUDE.md — TravianZ Game Project

Auto-loaded by Claude Code. Keep this file updated as work progresses.

---

## What This Project Is

PHP-based Travian browser strategy game (ZravianX / TravianZ fork), Saudi open-source.
Players build villages, train troops, attack others, join alliances. Arabic (RTL) and English supported.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | Plain PHP (procedural + some OOP, PSR-4 autoloader) |
| Templates | `.tpl` files = PHP includes with HTML mixed in (no Smarty/Blade/Twig) |
| JavaScript | MooTools 1.x (legacy ~2011) — `mt-core.js`, `mt-full.js`, `unx.js` |
| CSS | Static CSS (`gpack/travian/main.css`) + modular mobile CSS (`mobile/`) |
| DB | MySQLi via `GameEngine/Database.php` |
| RTL | `dir="rtl"` applied when `LANG === 'ar'` in `html` tag |

---

## Directory Map (Key Paths)

```
/                          — 49 PHP entry points (dorf1.php, login.php, karte.php, etc.)
/Templates/                — 488 .tpl template files (PHP+HTML)
  /Templates/Build/        — 165 files, one per building type + variants
  /Templates/Manual/       — 131 files, in-game tutorials
  /Templates/Plus/         — 31 files, premium/Gold Club
  /Templates/Simulator/    — 24 files, battle simulator
  /Templates/Ranking/      — 17 files, leaderboards
  /Templates/Alliance/     — 16 files, alliance management
  /Templates/Profile/      — 10 files, player profiles
  /Templates/Message/      — 9 files, private messages
  /Templates/a2b/          — 9 files, attack finder
  /Templates/Map/          — 3 files, map display
  (+ header.tpl, footer.tpl, menu.tpl, field.tpl, Building.tpl, movement.tpl at root)
/GameEngine/               — Backend logic (Battle.php, Village.php, Units.php, etc.)
/gpack/travian/main.css    — Core CSS (1033 lines, desktop-first, fixed widths)
/mobile/                   — Modular responsive CSS (see Responsive section below)
/mobile.css                — Master aggregator that @imports all mobile/ files
/responsive_blocks.css     — Standalone responsive component styles
/img/                      — Game images (8.6 MB)
/gpack/                    — Swappable graphic themes (travian, travian_default, travian_t4)
/src/                      — Modern namespaced classes (Database/, Entity/, Utils/)
/Admin/                    — Admin panel (separate CSS/assets)
```

---

## Responsive CSS Architecture

### Breakpoints
- `> 980px` — Desktop (original fixed-width design)
- `≤ 980px` — Tablet (`_tablet.css`)
- `≤ 768px` — Phone (`_phone_*.css`)
- `≤ 480px` — Small phone (`_small_phone.css`)

### Mobile CSS Files (`/mobile/` folder)

| File | Breakpoint | Scope | Lines | Status |
|------|-----------|-------|-------|--------|
| `_base.css` | global | Hide/show helpers, global defaults | 152 | done |
| `_tablet.css` | ≤980px | Remove fixed widths, flex layout start | 183 | done |
| `_phone_public.css` | ≤768px | Public pages: index, tutorials, hamburger sidebar | 516 | done |
| `_phone_outgame.css` | ≤768px | Login, signup, activation forms | 510 | done |
| `_phone_ingame.css` | ≤768px | In-game shell (imports `_phone_ingame/` submodules) | 10 | done |
| `_phone_ingame/global.css` | ≤768px | In-game common rules | — | done |
| `_phone_ingame/header.css` | ≤768px | Mobile header | — | done |
| `_phone_ingame/navigation.css` | ≤768px | Sidebar nav | — | done |
| `_phone_ingame/content.css` | ≤768px | Main content area | — | done |
| `_phone_ingame/popups_footer.css` | ≤768px | Overlays, modals, footer | — | done |
| `_phone_ingame_pages.css` | ≤768px | Per-page in-game overrides (buildings, map, etc.) | 1034 | in progress |
| `_phone_alliance.css` | ≤768px | Alliance pages | 188 | done |
| `_phone_plus.css` | ≤768px | Plus/Gold Club pages | 648 | done |
| `_phone_a2b2.css` | ≤768px | Attack finder (a2b2) | 303 | done |
| `_phone_statistics.css` | ≤768px | Statistics / rankings | 742 | done |
| `_phone_manual.css` | ≤768px | In-game manual/guide | 204 | done |
| `_small_phone.css` | ≤480px | Final tightening for narrow screens | 108 | done |

### What Still Needs Work
- `_phone_ingame_pages.css` — the largest file, covers per-page building/map overrides, still growing
- Build/ templates (165 files) — many building-specific layouts not yet fully responsive
- `gpack/travian/main.css` — base has `min-width:845px` and many fixed widths; needs audit
- Simulator pages — battle simulator layout not fully mobile-tested
- Map (`karte.php`) — tile-based map is the hardest to make responsive
- Admin panel — out of scope for now

### Known Pain Points
- `gpack/travian/main.css` is desktop-first with hardcoded `845px` minimum width
- Heavy inline `style=""` in many `.tpl` files makes CSS overrides harder
- MooTools has no touch event support — some UI interactions break on mobile
- Table-based layouts in ranking and statistics pages
- Game map (`karte.php`) uses a fixed tile grid — needs a separate mobile strategy

---

## Hamburger Menu Pattern

Pure CSS, no JS required:
```html
<input type="checkbox" id="mobile-nav-toggle" style="display:none;" />
<label for="mobile-nav-toggle" class="mobile-hamburger">☰</label>
```
Defined in `_phone_public.css` and `_phone_ingame/navigation.css`.

---

## RTL Notes

- `<html dir="rtl">` applied when `LANG === 'ar'`
- Language-specific CSS in `gpack/*/lang/` directories
- When adding responsive CSS, test both LTR and RTL layouts

---

## Skills Being Developed

| Skill | Goal | Status |
|-------|------|--------|
| Mobile Responsiveness | Full mobile/tablet/laptop support for all game pages | in progress |

### Workflow (always follow this order)

```
/responsive-inspect <page>   →   /responsive-implement <page>   →   /responsive-verify <page>
```

1. **`/responsive-inspect`** — Read-only audit of a page: find all templates, list layout issues, identify images, flag PHP logic (never touch it), output a structured report.
2. **`/responsive-implement`** — Apply CSS to the correct `/mobile/` file following best practices. Never touch `.tpl` PHP logic. Never touch `gpack/travian/main.css`. Handle images via containers, not the `<img>` tag itself.
3. **`/responsive-verify`** — Boot the app (`localhost:8082`), screenshot at 375px / 390px / 768px / 1024px / 1440px, run the checklist, fix failures, only mark done when all viewports pass including RTL.

Full skill specs:
- `.claude/skills/responsive-inspect.md`
- `.claude/skills/responsive-implement.md`
- `.claude/skills/responsive-verify.md`
- `.claude/skills/responsive.md` — master status tracker (update after every verify pass)
