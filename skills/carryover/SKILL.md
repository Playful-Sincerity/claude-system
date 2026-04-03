---
name: carryover
description: Generate a prescriptive session carryover document before compaction — AI decides what future-Claude needs to re-read and think about.
effort: low
---

# Session Carryover

You are generating a session carryover document — a prescriptive context recovery file that tells your post-compaction self what to re-read, what decisions to honor, and what framing to use.

This is NOT a summary. It is **instructions to your future self** after context compaction erases the conversation history.

**This skill is MANUAL ONLY.** Never auto-generate carryovers via hooks, auto-compaction events, or transcript parsing. The user decides when context is worth preserving.

## Process

### 1. Analyze the Conversation

Review the full conversation and identify:
- What work was done (research, design, code, debugging, planning)
- How thinking evolved during the session (pivots, reframings, escalations)
- Key decisions and corrections made
- What the user cares about most right now
- What's unfinished or blocked

### 2. Generate the Carryover Document

Write a markdown document with these sections:

```markdown
# Session Carryover — {date}
## For post-compaction context recovery

### What happened this session
{3-5 bullets. Focus on outcomes and evolution, not play-by-play.}

### Key decisions and corrections
{Numbered list. Things the post-compaction conversation MUST honor.
Include WHY each matters — not just what was decided.}

### Current direction
{1-2 sentences. Where the work is heading right now.
What the user's immediate next intent is.}

### Biggest open question or gap
{The most important unresolved thing. What needs attention next.}

### Files to re-read after compaction
{Numbered list with paths and WHY each matters.
These are instructions — post-compaction Claude should actually read these.
Order by importance. Include:
- Project CLAUDE.md (always first if working in a project)
- Files that were actively edited or discussed
- Design docs or specs that inform the current direction
- Any file where context would be lost without re-reading}

### Active framing
{If there's a specific way to frame, describe, or think about the work
that was established during the conversation, state it here.
This prevents post-compaction Claude from reverting to generic framing.}
```

### 3. Write the Carryover

**IMPORTANT:** You MUST read `~/.claude/active-context.md` with the Read tool BEFORE writing to it. The Write tool requires reading existing files first.

Write the carryover document to **both** locations:

1. **`~/.claude/active-context.md`** — Read it first, then overwrite. This is a **transient buffer**: `context-reinject.sh` injects it only after compaction (`source: "compact"`), and auto-clears it when a new session starts. It does NOT leak into other conversations.

2. **Project archive** (always) — Save a dated copy at `{project-root}/sessions/session-carryover-{date}.md` (create the `sessions/` directory if needed). This is the **permanent record** — it persists even after `active-context.md` is cleared by the next session.

### 4. Prompt for Compaction

`/compact` is a client-side built-in command that Claude cannot invoke programmatically. After writing the carryover, always tell the user:

> **Carryover saved. Run `/compact` when ready — it will be re-injected automatically via `context-reinject.sh`.**

If ARGUMENTS include "only" or "no-compact", skip the compaction prompt.

## Rules

- Keep the total carryover under 50 lines. It needs to fit in a system reminder.
- Never include raw code — point to file paths instead.
- The "Files to re-read" section is the most valuable part. Be specific and selective (3-8 files). Order by importance.
- If the conversation had no meaningful work yet, say so — don't fabricate context.
- The carryover should be **prescriptive**: tell future-Claude what to DO, not just what happened.
- Include absolute paths (with `~` expansion) so files can be found from any working directory.
- If ARGUMENTS contain a message or note, incorporate it into the carryover (e.g., `/carryover focus on the auth refactor` should emphasize auth context).

## Examples

**`/carryover`** — Generate carryover, then prompt user to run `/compact`
**`/carryover only`** — Generate carryover without compaction prompt
**`/carryover focus on round 4 corrections`** — Generate carryover with emphasis on specific topic
