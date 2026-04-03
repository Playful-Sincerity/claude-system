# Semantic Logging — Continuous Chronicle

You MUST maintain a running semantic chronicle of your work. This is not optional. Not end-of-session. Not when asked. **Continuously, as you work.**

After every meaningful action, ask yourself: *"What just happened that future-me or the user would want to know?"* If the answer is anything, log it.

## What Triggers a Log Entry

- Completing a task or subtask
- Making a decision (chose approach A over B — why?)
- Discovering something unexpected about the codebase or system
- Changing infrastructure (skills, rules, hooks, scripts, agents, config)
- Connecting dots between projects or ideas
- Hitting a wall and changing approach
- Research findings as they emerge (don't wait for synthesis)
- Creating, modifying, or deleting any file that shapes how the system works
- Understanding something new about what the user wants or how a project works
- Any moment where context would be lost if not written down

**When in doubt, log it.** Over-logging is better than under-logging. The chronicle is cheap; lost evolution context is expensive.

## Where to Log

### Project Chronicle (most common)
```
<project-root>/chronicle/YYYY-MM-DD.md
```
One file per day per project. Append-only. Create the directory if it doesn't exist.

### System Chronicle (cross-cutting, infrastructure)
```
~/.claude/chronicle/YYYY-MM-DD.md
```
Use this for:
- Changes to your system (skills, rules, hooks, agents, scripts)
- Cross-project connections and insights
- System-level decisions and evolution
- Infrastructure changes that affect all conversations

### Both
If a change is project-specific BUT also affects the system (e.g., a pattern discovered in one project that should become a rule), log in both places.

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

### Categories
Use these tags to make chronicles searchable:
- `Decision` — chose one approach over another
- `Discovery` — learned something new or unexpected
- `Infrastructure` — changed skills, rules, hooks, agents, scripts, config
- `Implementation` — built or modified functionality
- `Research` — findings from investigation or exploration
- `Connection` — linked ideas across projects or domains
- `Pivot` — changed approach after hitting a wall
- `Architecture` — structural changes to how things are organized
- `Insight` — realization about the work, the system, or the user's intent

## Session Boundaries

At the start of each session's logging in a chronicle file, add:

```markdown
# Session — YYYY-MM-DD HH:MM
**Project:** <project name>
**Context:** <1-line description of what this session is about>

```

This makes it easy to see session boundaries when scanning a day's chronicle.

## Frequency

- **Minimum:** Log at least once per meaningful task completion.
- **Target:** Log every 5-15 minutes of active work, or after every significant action.
- **Infrastructure changes:** ALWAYS log. Every rule edit, every skill modification, every hook change. These shape all future conversations.
- **Don't batch:** Log as things happen, not in a big dump at the end. The narrative flow matters.

## What Makes a Good Chronicle Entry

Good: *"Decided to implement semantic logging as a rule rather than a hook because rules change Claude's thinking patterns while hooks can only run shell scripts. The rule loads into every conversation context automatically."*

Bad: *"Added semantic-logging.md"*

The chronicle captures the **story** — the reasoning, the evolution, the "why behind the what." Git captures the file changes. The chronicle captures the thinking.

## Relationship to Other Systems

- **`/session-log`** — End-of-session archival summary. The chronicle is the raw material; session-log is the distilled version.
- **`/carryover`** — Prescriptive recovery doc for post-compaction. Chronicle entries inform what goes into a carryover.
- **`journal/`** (your system) — Development changelog for your Claude Code setup itself. The system chronicle is broader and more narrative.
- **Memory (`MEMORY.md`)** — Cross-conversation persistent facts. Chronicle is within-conversation narrative. If a chronicle entry reveals something worth remembering across conversations, also save it to memory.
- **Git commits** — Structural "what changed." Chronicle = semantic "why it changed and what it means."

## Hard Checkpoints — When You MUST Log Before Continuing

These are not suggestions. Stop and write a chronicle entry at these moments:

1. **Session start:** Your FIRST action in any conversation with meaningful work should be writing the session header to the chronicle. Before you do anything else.
2. **After any file creation or modification:** If you just used Edit, Write, or Bash to change something, log what you changed and why before moving to the next task.
3. **After any decision:** If you chose approach A over B, log the decision and reasoning before implementing.
4. **Before responding to user with results:** If you just completed a multi-step task, log the outcome before presenting it to the user.
5. **When the Stop hook nudges you:** If you see "Chronicle Nudge" in the hook output, your IMMEDIATE next action should be writing a chronicle entry.
6. **Before compaction:** If context is getting heavy, log your current state to the chronicle before it gets compressed away.

The Stop hook (`chronicle-nudge.sh`) will remind you every 15 minutes if you haven't logged. Treat these reminders as mandatory — they exist because this rule alone wasn't enough.

## Non-Negotiable

This rule exists because evolution context is one of the most valuable things in your project ecosystem. Every conversation contributes to the story. Don't let your contributions disappear into context windows that get compacted and forgotten.

**Log. Constantly. Semantically.**
