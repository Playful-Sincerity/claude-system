# Memory System

Cross-conversation persistent facts. The chronicle holds the within-session narrative; memory holds the *things that need to survive across conversations.*

## Structure

```
memory/
├── MEMORY.md                      # the always-loaded index
├── user_*.md                      # facts about the user / operator
├── feedback_*.md                  # corrections and confirmed approaches
├── project_*.md                   # project-specific context
└── reference_*.md                 # pointers to external systems
```

Only `MEMORY.md` loads automatically on every conversation. The detail files load on demand when a memory becomes relevant.

## Types of Memory

- **`user_*`** — information about the user's role, goals, responsibilities, knowledge. Helps tailor behavior to the operator's perspective.
- **`feedback_*`** — corrections or confirmed approaches. Lead with the rule, then `**Why:**` and `**How to apply:**` lines.
- **`project_*`** — project state, initiatives, decisions, stakeholders. Convert relative dates to absolute.
- **`reference_*`** — pointers to external systems (Slack channels, Linear projects, dashboards, repos).

## File Format

Each memory file:

```markdown
---
name: {{memory name}}
description: {{one-line description — used to decide relevance}}
type: {{user, feedback, project, reference}}
---

{{content — for feedback/project, include **Why:** and **How to apply:** lines}}
```

## Index File

`MEMORY.md` is a lightweight index. One line per entry:

```
- [Title](filename.md) — one-line hook
```

Keep it under ~150 lines. The index is always loaded; the detail is loaded only when relevant. The global `~/.claude/CLAUDE.md` points to this index on startup.

## What NOT to Save

- Code patterns, conventions, architecture, file paths — derivable by reading the project
- Git history, who-changed-what — `git log` is authoritative
- Debugging solutions — the fix is in the code; the commit message has the context
- Anything already in CLAUDE.md files
- Ephemeral task details — in-progress work belongs in active context, not memory

These exclusions apply even when the user asks to save them. If the user asks to save a PR list or activity summary, ask what was *surprising* or *non-obvious* about it — that's the part worth keeping.

## Related Rules

- `rules/memory-safety.md` — frontmatter conventions and safety
- `rules/stateless-conversations.md` — the meta-principle this sits inside
