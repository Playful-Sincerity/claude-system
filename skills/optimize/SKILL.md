---
name: optimize
description: Generate specific, actionable improvements for a given project or for the overall Claude Code setup
effort: high
---

# Claude Code Optimizer — Optimize

You are the Optimizer. Given a project name (or "all" for global), you generate specific, implementable improvements and can execute them with user approval.

## Usage
- `/optimize` — Optimize global Claude Code setup
- `/optimize [project-name]` — Optimize a specific project (e.g., `/optimize my-app`, `/optimize research-notes`)
- `/optimize all` — Run optimization across all projects

## Project Registry

Add a registry mapping project short-names to their absolute paths, so `/optimize <name>` knows where to work. Example format:

```
- `my-app` → `~/Code/my-app/`
- `research-notes` → `~/Documents/research/`
- `digital-core` → `~/claude-system/`
```

If no registry is defined, the skill falls back to scanning `~/Projects`, `~/Code`, `~/repos`, and any directory containing a `CLAUDE.md`.

## Optimization Checklist

### For Each Project
1. **CLAUDE.md Quality**
   - Does it exist? Create one if not.
   - Is it 60-200 lines? Trim or expand.
   - Does it include: build commands, test commands, architecture, gotchas, style rules?
   - Does it reference supporting docs with `@path` syntax?
   - Is it checked into git?

2. **Rules (`.claude/rules/`)**
   - Are there path-scoped rules for different parts of the codebase?
   - Do rules cover: code style, naming conventions, file organization?

3. **Skills**
   - Are there project-specific skills for common workflows?
   - E.g., `/publish` for personal-development-framework, `/practice` for Mandarin, `/draft` for PS Agents

4. **Agents**
   - Are there project-specific agents for specialized tasks?

5. **Hooks**
   - Auto-format on file save?
   - Dangerous file protection?
   - Context re-injection after compaction?

6. **Git Health**
   - Remote configured?
   - .gitignore comprehensive?
   - Branches clean?

7. **Testing & Verification**
   - Test files exist?
   - Test commands documented in CLAUDE.md?
   - CI/CD configured?

### For Global Setup
1. **Settings** — Permissions, environment variables
2. **Memory** — Freshness, coverage, accuracy
3. **MCP Servers** — Useful integrations missing?
4. **Plugins** — Useful plugins not installed?
5. **Hooks** — Global safety and productivity hooks

## Execution Mode

When generating improvements:

1. **Scan** the target project/setup
2. **Compare** against best practices
3. **Generate** a prioritized list of improvements
4. **Present** each improvement with:
   - What to change
   - Why it matters
   - The exact change (file content, command, etc.)
   - Estimated impact (high/medium/low)
5. **Ask** for approval before implementing
6. **Implement** approved changes
7. **Verify** changes work correctly

## Output Format

```markdown
# Optimization Report — [PROJECT] — [DATE]

## Current State
[Brief assessment of where things stand]

## Improvements (Prioritized)

### 1. [Title] — Impact: HIGH
**What**: [Description]
**Why**: [Benefit]
**Change**: [Exact file/content to create or modify]

### 2. [Title] — Impact: HIGH
...

## Implementation Plan
[Order of operations, dependencies between changes]

## After Implementation
[What to verify, expected behavior changes]
```
