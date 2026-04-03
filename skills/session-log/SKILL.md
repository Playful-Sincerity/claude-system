---
name: session-log
description: Archive what happened in a conversation to a per-project sessions/ directory. Purely archival — no compaction, no active-context.md writes.
effort: low
---

# Session Log

You are generating a session log — an archival record of what happened in this conversation. This is NOT a compaction recovery tool. It does not write to `active-context.md` or prompt for `/compact`. It simply creates a dated record of the session's work in the project's `sessions/` directory.

## Purpose

Session logs answer "what did we work on?" weeks or months later. They create a searchable chronological history per project — useful for understanding how decisions evolved, what was tried and failed, and what the current state of a project is.

## Process

### 1. Detect the Project Root

Determine the current project root:
- If the working directory is inside a known project (check `~/.claude/CLAUDE.md` project map), use that project's root
- If a git repo, use the git root
- If ARGUMENTS specify a project path, use that
- If ambiguous, ask the user

### 2. Analyze the Conversation

Review the full conversation and identify:
- What work was done (research, design, code, debugging, planning, discussion)
- Key outcomes and artifacts produced (files created/modified, decisions made, things learned)
- Problems encountered and how they were resolved (or left unresolved)
- Important decisions and their rationale
- What's unfinished or planned for next time

### 3. Generate the Session Log

Write a markdown document with these sections:

```markdown
# Session Log — {date}

## What happened
{3-7 bullets. Focus on outcomes, not process. What was accomplished, not how many tool calls it took.}

## Key decisions
{Numbered list of decisions made during the session.
Include the rationale — WHY matters more than WHAT.
Skip this section if no meaningful decisions were made.}

## Artifacts
{List of files created, modified, or deleted. Use absolute paths with ~ expansion.
Group by action: Created / Modified / Deleted.
Skip this section if no files were changed.}

## Open threads
{Things left unfinished, questions raised but not answered, planned next steps.
Skip this section if everything was wrapped up cleanly.}

## Session context
{1-3 sentences of framing. What was the user's goal coming into this session?
What's the broader context this work fits into?
This helps future readers understand WHY this session happened.}
```

### 4. Write the Session Log

Write the log to:

```
{project-root}/sessions/{date}-session.md
```

Create the `sessions/` directory if it doesn't exist.

If ARGUMENTS contain a label or suffix (e.g., `/session-log auth-refactor`), append it:
```
{project-root}/sessions/{date}-session-auth-refactor.md
```

If a session log already exists for today's date (same filename), append a sequence number:
```
{project-root}/sessions/{date}-session-2.md
```

### 5. Confirm

After writing, tell the user where the log was saved and give a one-line summary of what it captured.

## Rules

- Keep the total log under 60 lines. Concise but complete.
- Never include raw code — point to file paths instead.
- Use absolute paths with `~` expansion so files can be found from any working directory.
- Omit empty sections entirely rather than writing "N/A" or "None."
- The tone is **descriptive and archival**, not prescriptive. This tells a future reader what happened, not what to do.
- If the conversation had no meaningful work yet, say so — don't fabricate content.
- If ARGUMENTS contain a message or note, incorporate it as context (e.g., `/session-log focus on the n8n debugging` should emphasize that aspect).
- Do NOT write to `~/.claude/active-context.md` — that's `/carryover`'s job.
- Do NOT prompt for `/compact` — that's `/carryover`'s job.

## Relationship to /carryover

`/carryover` is **prescriptive** — it tells post-compaction Claude what to re-read and what framing to use. It writes to `active-context.md` for automatic re-injection.

`/session-log` is **descriptive** — it records what happened for future human or AI reference. It writes to the project's `sessions/` directory for long-term archival.

They can be used together: `/session-log` to archive, then `/carryover` before compacting. But neither depends on the other.

## Examples

**`/session-log`** — Generate a session log for the current project
**`/session-log auth-refactor`** — Generate a session log with a label suffix
**`/session-log ~/my-project/`** — Log to a specific project path
