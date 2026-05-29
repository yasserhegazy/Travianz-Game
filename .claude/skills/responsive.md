# Skill: Mobile Responsiveness

Goal: Make the full TravianZ game responsive across mobile, tablet, and laptop.

---

## Approach

- Add/expand CSS in `/mobile/` — do NOT touch `gpack/travian/main.css` unless absolutely necessary (it's the desktop base)
- Use the existing breakpoint system: 980px / 768px / 480px
- Put page-specific in-game fixes in `_phone_ingame_pages.css`
- Put section-specific fixes in their own `_phone_[section].css` file
- Always check RTL (Arabic) after changes
- Update the Status table below when a section is resolved

---

## Page Sections & Status

### Public / Out-of-Game Pages
| Page | Entry File | Template(s) | CSS File | Status |
|------|-----------|-------------|----------|--------|
| Homepage | index.php | Templates/index* | `_phone_public.css` | done |
| Login | login.php | Templates/login* | `_phone_outgame.css` | done |
| Register | anmelden.php | Templates/anmelden* | `_phone_outgame.css` | done |
| Activate | activate.php | Templates/activate/ | `_phone_outgame.css` | done |

### Core In-Game Layout
| Component | Template | CSS File | Status |
|-----------|---------|----------|--------|
| Header (resources bar) | header.tpl | `_phone_ingame/header.css` | done |
| Sidebar navigation | menu.tpl | `_phone_ingame/navigation.css` | done |
| Resource fields | field.tpl | `_phone_ingame/content.css` | done |
| Popups / modals | (inline in tpl files) | `_phone_ingame/popups_footer.css` | done |
| Movement overlay | movement.tpl | `_phone_ingame_pages.css` | in progress |

### Village Views
| Page | Entry File | CSS File | Status |
|------|-----------|----------|--------|
| Village (dorf1) | dorf1.php | `_phone_ingame_pages.css` | in progress |
| Buildings (dorf2) | dorf2.php | `_phone_ingame_pages.css` | in progress |
| Hero village (dorf3) | dorf3.php | `_phone_ingame_pages.css` | in progress |

### Building Interfaces (165 templates in Templates/Build/)
| Category | Status | Notes |
|----------|--------|-------|
| Resource buildings | in progress | Covered partially in `_phone_ingame_pages.css` |
| Military buildings (barracks, stable, workshop) | in progress | Training queue layout needs work |
| Hero equipment | pending | Complex layout |
| Marketplace | pending | Trade forms |
| Residence / Palace | pending | Village expansion |
| Treasury / Artifacts | pending | |
| Rally point | pending | Attack form — critical for mobile |

### Game Map
| Page | Entry File | CSS File | Status |
|------|-----------|----------|--------|
| Map (karte.php) | karte.php | `_phone_ingame_pages.css` | pending |
| Map 2 | karte2.php | — | pending |

Notes: Map uses a fixed tile grid. Mobile strategy TBD — options are pinch-to-zoom, scroll, or a simplified tile view.

### Alliance
| Page | CSS File | Status |
|------|----------|--------|
| All alliance pages | `_phone_alliance.css` | done |

### Messages & Reports
| Page | CSS File | Status |
|------|----------|--------|
| Nachrichten (messages) | `_phone_ingame_pages.css` | pending |
| Berichte (reports) | `_phone_ingame_pages.css` | pending |

### Rankings / Statistics
| Page | CSS File | Status |
|------|----------|--------|
| Statistiken | `_phone_statistics.css` | done |
| Spieler (player profiles) | `_phone_ingame_pages.css` | pending |

### Plus / Premium
| Page | CSS File | Status |
|------|----------|--------|
| Plus pages | `_phone_plus.css` | done |
| Gold Club | `_phone_plus.css` | done |

### Attack / Military
| Page | CSS File | Status |
|------|----------|--------|
| Attack finder (a2b2) | `_phone_a2b2.css` | done |
| Battle simulator | `_phone_ingame_pages.css` | pending |

### Manual / Tutorial
| Page | CSS File | Status |
|------|----------|--------|
| Manual | `_phone_manual.css` | done |
| Tutorial | `_phone_public.css` | done |

---

## Known Issues / Blockers

1. **`gpack/travian/main.css` — `.wrapper { min-width: 845px }`** — this fights mobile at the root level. Adding `min-width: 0` override in `_base.css` is the fix.
2. **Inline styles on `.tpl` files** — use `!important` sparingly or refactor the template when needed.
3. **MooTools touch events** — map dragging and some popup interactions are mouse-only. When fixing map, this needs JS attention.
4. **Table layouts in rankings** — convert to `overflow-x: auto` wrapper as a quick fix; full refactor later.

---

## How to Work on This

1. Pick a section from the table above marked `pending` or `in progress`
2. Open the entry file (e.g., `build.php`) and the related template(s)
3. Test at 375px, 768px, 1024px viewport widths
4. Add CSS to the appropriate `/mobile/_phone_*.css` file
5. Update the Status column in this file
6. Also update the Status table in `CLAUDE.md`
