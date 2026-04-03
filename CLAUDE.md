# Claude Code Meta-System — Project Instructions

This is a git-tracked Claude Code configuration system.
`~/.claude/` directories (skills, agents, rules, knowledge, scripts) are symlinks pointing here.

## What This Project Contains
- **skills/** — 12 slash-command skills (/carryover, /context-audit, /debate, /digest, /gh-scout, /migrate, /plan-deep, /research-books, /research-papers, /session-id, /session-log, /visualize)
- **agents/** — 2 standalone agents (@optimizer, @researcher)
- **rules/** — 18 behavioral rules (safety, workflow, methodology, research)
- **knowledge/** — Best practices KB, GH Scout subsystem, debate protocol, visualization references
- **scripts/** — 7 hook scripts (pre-flight, session-tip, context-reinject, auto-test, chronicle-nudge, validate-plan, gemini-fallback)
- **docs/** — Architecture documentation and decision records
- **templates/** — Starter templates for creating new skills, agents, rules
- **examples/** — Example settings.json and global CLAUDE.md
- **memory/** — Memory system template

## Working on This Project

### Adding a New Skill
1. Create `skills/<name>/SKILL.md`
2. Follow patterns in existing skills (plan-deep or gh-scout for complex ones)
3. Update this CLAUDE.md to list it
4. Update `docs/architecture.md` to place it in the three-layer model

### Adding a New Rule
1. Create `rules/<name>.md` with YAML frontmatter specifying `paths:`
2. Update this CLAUDE.md to list it
3. Test that it loads in the right contexts

### Modifying Scripts
Scripts are referenced by `~/.claude/settings.json` hooks via `$HOME/.claude/scripts/`.
The symlink makes this transparent — edit here, takes effect immediately.
Keep scripts executable (`chmod +x`).

### Config Changes
`~/.claude/settings.json` lives in `~/.claude/` (not symlinked — Claude Code modifies it directly).
After intentional changes, keep a reference copy for version control.

## Architecture
See `docs/architecture.md` for the three-layer model.
See `docs/decisions/` for architecture decision records.

## Key Constraints
- NEVER commit secrets, API keys, or credentials
- Skills and agents reference `~/.claude/` paths in their instructions — this resolves through symlinks
- The global `~/.claude/CLAUDE.md` is a SEPARATE file from this one
- `~/.claude/settings.json` is NOT symlinked (Claude Code modifies it directly)
