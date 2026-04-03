# Folder Structure Design

When creating, restructuring, or reviewing a project's file organization — whether during `/plan-deep`, project initialization, or any task that involves creating directories — apply these principles. This is a reasoning framework, not a rigid template.

## Core Principles

### 1. Organize by Purpose, Not by File Type
The primary axis of organization is *what it does* — not *what it is*. A folder called `brand/` containing images, specs, and docs is correct. A folder called `images/` at top level is wrong.

**Exception:** Build artifacts (`build/`, `dist/`) and tests (`tests/`) are organized by technical role because that IS their purpose.

### 2. Logical at the Top, Chronological at the Leaves
Top-level directories organize by purpose: `paper/`, `code/`, `research/`, `docs/`. Within those, entries may be dated (`2026-04-02-findings.md`) because logical names go stale as a project evolves. The deeper you go, the more temporal naming makes sense.

### 3. Separation of Concerns — One Directory, One Responsibility
Every directory should have a single, non-overlapping purpose. Source code, data, documentation, tests, and build artifacts never cohabit the same level.

- `src/` or `code/` — source code only
- `docs/` — documentation only
- `research/` — research process and findings only
- `data/raw/` vs `data/derived/` — immutable inputs vs. processed outputs

### 4. Progressive Disclosure (3-Level Depth Target)
A new reader should understand the project from the root level alone. Each level deeper serves deeper engagement. Target 3 levels of depth for daily navigation; nest only when the content at a level genuinely splits into distinct subcategories with multiple items each.

**When to create a subdirectory:** Would someone scanning this directory have to read 6+ names before finding what they want? If yes, split. A folder with one file is a smell. A folder with 50 unsorted files is also a smell.

### 5. Start with Scaffold, Grow on Evidence
Create top-level structural directories upfront — they set the contract for the project. Below that, create subdirectories only when there are 2+ concrete items that belong there. Don't pre-create empty folders for aspirational categories.

**Always scaffold:** `README.md`, `CLAUDE.md`, and the primary purpose directories.
**Grow organically:** Subcategories within those directories, as content accumulates.

### 6. No Orphan Files at Root
Every file at root level should be project-level metadata: `README.md`, `CLAUDE.md`, `LICENSE`, `.gitignore`, `package.json`, etc. Everything else belongs in a directory. If a file doesn't fit any existing directory, that's a signal a new directory is needed — not permission to leave it at root.

### 7. Archive, Don't Delete
Old phases, superseded files, and dead-end explorations live under `archive/` or `abandoned/` rather than being deleted. Past work has educational and historical value. Deletion destroys context; archiving preserves it while decluttering.

### 8. Separate Source from Output
Code that generates results lives apart from the results themselves. Verification scripts separate from verification logs. Build tools separate from build artifacts. This prevents confusion about what's hand-authored vs. machine-generated, and makes `.gitignore` cleaner.

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Directories | `lowercase-kebab-case` | `research-findings/`, `agent-outputs/` |
| Dated files | `YYYY-MM-DD` prefix | `2026-04-02-session-notes.md` |
| Numbered sequences | Zero-padded | `01-orientation/`, `02-fundamentals/` |
| No spaces or special chars | Hyphens between words | `deep-dive-unification.md` |
| Filenames | Descriptive, under 50 chars | `verify-calculus.py`, not `v.py` |
| Versions (when needed) | Suffix with `_v01`, `_v02` | `proposal_v02.md` |

## Common Directory Vocabulary

Use these names when they fit — consistency across projects aids navigation:

| Directory | Purpose | When to Use |
|-----------|---------|-------------|
| `src/` or `code/` | Source code | Any project with code |
| `docs/` | Documentation | When docs exceed a single README |
| `research/` | Research process and findings | Research-driven projects |
| `tests/` | Test code | Projects with test suites |
| `data/` | Data files (with `raw/` and `derived/` subdirs) | Data-heavy projects |
| `archive/` | Superseded or historical files | Any project that evolves |
| `sessions/` | Session logs / carryovers | Projects using session archival |
| `chronicle/` | Semantic logging entries | Projects using continuous chronicle logging |
| `phases/` or `plans/` | Phase plans and strategy docs | Multi-phase projects |
| `debates/` | Adversarial analysis transcripts | Projects using `/debate` |
| `diagrams/` | Visual artifacts | Projects with architecture/system diagrams |
| `scripts/` | Utility/build/automation scripts | When scripts aren't core source |
| `config/` | Configuration files | When configs accumulate |
| `assets/` | Static assets (images, fonts, etc.) | Projects with media |
| `findings/` | Research findings (under `research/`) | Research substructure |
| `verification/` | Verification logs and outputs (under `research/`) | Research with formal verification |
| `abandoned/` | Dead-end explorations (under relevant parent) | Research substructure |

## Decision Framework

When deciding how to structure a new project or restructure an existing one:

1. **List the types of things** the project will contain (code, docs, data, research, assets, config). Each type gets a top-level directory.
2. **Identify the primary domain axis.** Is this organized by feature, by phase, by domain, or by deliverable? Choose one primary axis for the top level.
3. **Check the depth.** If any path exceeds 4 levels, ask whether intermediate directories are earning their place. Flatten if not.
4. **Check the breadth.** If any directory has 10+ items, look for natural subcategories. If it has 1 item, consider merging up.
5. **Verify naming.** Would a newcomer understand each directory's purpose from its name alone? If not, rename or add a README.
6. **Anticipate growth.** What will this project look like at 2x its current size? The structure should accommodate growth by adding directories, not by reorganizing existing ones. But don't create those directories yet — just verify the structure won't fight them.

## When This Rule Activates

- **`/plan-deep`**: Include a "Project Structure" section in the plan.
- **New project creation**: Propose a directory scaffold before writing any files.
- **Restructuring tasks**: Apply these principles to diagnose structural problems and propose fixes.
- **Code review**: Flag structural issues (orphan files, deeply nested paths, type-based organization) as suggestions.

## What This Rule Does NOT Do

- Prescribe a single template for all projects — projects differ and their structures should reflect their actual content.
- Override existing conventions in established frameworks (React, Python packages, Rust crates have their own conventions — defer to those).
- Require restructuring working projects — if the current structure works, don't fix it. Apply these principles to new work and organic growth.
