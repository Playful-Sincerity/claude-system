# ADR 001: Directory-Level Symlinks for Deployment

**Date:** 2026-03-25
**Status:** Accepted

## Context
All custom Claude Code configuration lived in `~/.claude/` with no git tracking.
We needed to move it to a git-tracked project while keeping `~/.claude/` functional.

## Decision
Use directory-level symlinks: `~/.claude/skills → ~/claude-system/skills`, etc.

## Alternatives Considered
1. **File-level symlinks** — One symlink per file. Rejected: requires maintenance when adding new files.
2. **Hard copies with sync script** — Rejected: introduces drift, complexity, and a maintenance burden.
3. **Symlink settings.json** — Rejected: Claude Code writes to settings.json directly (adding MCP servers, updating hooks). Symlink would work but risks race conditions with git operations.

## Consequences
- New files added to `~/claude-system/skills/newskill/` auto-appear in `~/.claude/skills/`
- All existing path references (`$HOME/.claude/scripts/session-tip.sh`) resolve transparently
- Zero path edits needed across all scripts, skills, agents, and hooks
- `settings.json` stays in `~/.claude/` with reference copies tracked in `config/`
- The global `~/.claude/CLAUDE.md` remains a separate file from `~/claude-system/CLAUDE.md`
