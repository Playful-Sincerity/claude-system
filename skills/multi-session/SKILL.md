---
name: multi-session
description: Decompose large tasks into parallel session briefs — self-contained markdown files that each drive a separate Claude Code conversation.
effort: medium
---

# Multi-Session Decomposition

You are decomposing a task into session briefs that can be launched as independent Claude Code conversations.

## Input

The user provides either:
- A task description or goal to decompose
- A reference to an existing plan (`plan.md`, `/plan-deep` output, etc.)
- Nothing — analyze the current conversation context for decomposable work

Optional flags:
- `--dir <path>` — where to write session briefs (default: `sessions/` in the project root)
- `--flat` — skip phased directory structure, write all briefs as flat files

## Process

### Step 1 — Identify Streams

Read the task/plan and identify independent streams of work. For each stream, determine:
- What it needs to accomplish
- What files/context it needs to read
- What it produces (output files, code changes)
- What it depends on (other streams, manual setup, external resources)

### Step 2 — Map Dependencies

Build the dependency graph:
- Which streams can start immediately (no dependencies)?
- Which streams need outputs from other streams?
- Which streams need manual human action first?
- What's on the critical path?

Classify each stream:
- **PARALLEL-no-deps** — start immediately
- **CRITICAL-needs-X** — on the critical path, blocked by X
- **PARALLEL-needs-X** — can run alongside critical path, blocked by X

### Step 3 — Create Directory Structure

For 3+ phases, use the phased structure:

```
sessions/<build-name>/
├── README.md
├── phase-1-<name>/
│   ├── README.md
│   ├── phase-0-manual-setup/     (if human action needed)
│   ├── phase-1-PARALLEL-no-deps/
│   ├── phase-2-CRITICAL-needs-setup/
│   └── phase-3-PARALLEL-needs-setup/
├── phase-2-<name>/
└── ...
```

For simpler decompositions (2-3 sessions), use `--flat`: just numbered briefs in one directory.

### Step 4 — Write Session Briefs

Each brief follows this format:

```markdown
# Session Brief: [NAME] — [Description] [PARALLEL — no dependencies]

**Dependencies:** None — can start immediately
**Can run parallel with:** [list]
**Feeds into:** [what consumes this output]
**Blocks:** [what can't start until this finishes]

## Context
[Project description, where it lives, enough for cold start]

Read these files first:
- [CLAUDE.md path]
- [Key files]

## Task
[Clear, specific instructions — a fresh Claude instance reads this and knows what to do]

## Output
[Where to save results, file naming, directory paths]

## Success Criteria
[Measurable "done" conditions]
```

Key properties:
- **Self-contained** — all context included, no "see our earlier conversation"
- **Cold-startable** — a fresh Claude instance can execute from this file alone
- **Output-specified** — results go to known paths so other sessions find them
- **Dependency-aware** — prerequisites explicit with pointers to output files

### Step 5 — Write the README

The build's root README shows:
1. Full phase map with visual flow diagram (ASCII art)
2. Launch order — what to start when
3. Which phases need the operator present vs. can run unattended

## Output

Present to the user:
1. The directory structure created
2. The dependency graph (visual)
3. Clear launch instructions: "Start these N conversations now, then after X completes, start these..."
4. Which sessions need human interaction (n8n testing, approvals) vs. autonomous

## Reference

For the full session brief template, dependency patterns, and naming conventions, read `~/claude-system/references/multi-session-decomposition-reference.md`.
