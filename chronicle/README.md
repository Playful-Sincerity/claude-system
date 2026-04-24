# Chronicle — Continuous Semantic Log

The chronicle is where the Digital Core records its own evolution. Not a changelog (git handles that), not a todo list (those live in active work), not a journal (less structured). A chronicle captures the *why* behind changes, the *trajectory* of a project, and the *context* that would otherwise be lost when the conversation ends.

## Structure

```
chronicle/
├── README.md                  # this file
├── YYYY-MM-DD.md              # daily files, append-only
└── ...
```

One file per day. Entries within a day are timestamped and categorized. See `rules/semantic-logging.md` for the stance that makes this load-bearing and `scripts/chronicle-nudge.sh` for the Stop hook that enforces it.

## Entry Format

```markdown
## HH:MM — [Category]

**What:** One-line summary of what happened.
**Why:** The reasoning, trigger, or context behind it.
**Means:** What this implies — connections, consequences, evolution.
**Branch:** `main` | `feature-branch-name`
**Files:** Key files created/modified/deleted (if applicable)

[Optional: 2-5 lines of additional detail, quotes, or narrative when the entry is significant enough to warrant it.]

---
```

## Categories

Use these tags to make chronicles searchable:

- **Decision** — chose one approach over another
- **Discovery** — learned something new or unexpected
- **Infrastructure** — changed skills, rules, hooks, agents, scripts, config
- **Implementation** — built or modified functionality
- **Research** — findings from investigation or exploration
- **Connection** — linked ideas across projects or domains
- **Pivot** — changed approach after hitting a wall
- **Architecture** — structural changes to how things are organized
- **Insight** — realization about the work, the system, or the user's intent
- **Breath** — proactive trajectory-check pause (see `rules/breath.md`)

## Session Boundaries

At the start of each session's logging in a chronicle file, add:

```markdown
# Session — YYYY-MM-DD HH:MM
**Project:** <project name>
**Context:** <1-line description of what this session is about>
```

This makes it easy to see session boundaries when scanning a day's chronicle.

## What Makes a Good Entry

Good: *"Decided to implement semantic logging as a rule rather than a hook because rules change the model's thinking patterns while hooks can only run shell scripts. The rule loads into every conversation context automatically."*

Bad: *"Added semantic-logging.md"*

The chronicle captures the **story** — the reasoning, the evolution, the "why behind the what." Git captures the file changes. The chronicle captures the thinking.

## Why This Matters

Every conversation is stateless. What isn't written is lost. The chronicle is the primary bulwark against that loss — a running narrative that next week's session can read and pick up from. Memory (across the broader `memory/` system) holds discrete facts; the chronicle holds the *arc*.

See `rules/stateless-conversations.md` for the meta-principle this sits inside.

## Sample Entries

A sanitized sample day is included in this repo as `chronicle/2026-04-22-sample.md` so you can see the format in action. Rename it, clear it, or keep it — it's an illustration, not a real chronicle from the public system's operation (which doesn't have one).
