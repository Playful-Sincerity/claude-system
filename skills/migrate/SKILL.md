---
name: migrate
description: Create a context migration prompt that jumpstarts a new conversation with the right memory, files, and conclusions from the current one.
effort: low
---

# Context Migration

You are creating a context handoff — a compact prompt that the user can paste into a new conversation to pick up a thread without losing momentum or carrying stale context.

## What to Capture

Analyze the current conversation and produce a migration prompt with these sections:

### 1. Thread Summary (3-5 bullets max)
What was discussed, what was decided, what was concluded.
Only include conclusions and decisions — not the journey to get there.
If code was written or files were modified, name the specific files and what changed.

### 2. Next Action
What the user wants to do next — the thing that triggered the migration.
State it as a clear task or question.
If the user provided a description via the ARGUMENTS, use that as the next action.

### 3. Relevant Memory
List the memory files from `~/.claude/projects/*/memory/MEMORY.md` that the new conversation should load.
Only include memories that are directly relevant to the next action — not everything.
Format as a bullet list of filenames.

### 4. Key Files
List any files the new conversation will need to read or edit.
Include file paths and a one-line note on why each matters.

### 5. Active Decisions
Any decisions made in this conversation that the new conversation needs to honor.
Things like: "We decided to use X approach, not Y" or "The user approved this structure."

## Output Format

Produce the migration as a single fenced code block that the user can copy-paste as an opening prompt:

```
Here's context from a previous conversation:

**What we concluded:**
- [bullet 1]
- [bullet 2]
- [bullet 3]

**Relevant memory to load:**
- [memory_file.md]
- [memory_file_2.md]

**Key files:**
- [/path/to/file.md] — [why]
- [/path/to/other.md] — [why]

**Decisions to honor:**
- [decision 1]
- [decision 2]

**What I'd like to do next:**
[The next action, stated clearly]
```

## Prior Thread (Outside the Paste Block)

After the fenced migration prompt, add a separate section that is NOT part of the copy-paste block.
This captures what the conversation was working on *before* the migration topic came up — the thread the user will want to return to in the current conversation.

Format it as:

---

**Prior thread (not part of migration):**
You were working on [brief description of what was happening before the migration topic arose].
[1-2 sentences of context to resume that thread if desired.]

This helps the user return to the original conversation thread after pasting the migration elsewhere.
If the migration topic WAS the only thread (no prior work), skip this section.

## Rules

- Keep the total migration under 30 lines. Brevity is the point — if you need more, you're carrying too much.
- Never include raw code or large excerpts. Just point to file paths.
- If the conversation had no meaningful conclusions yet, say so — don't fabricate context.
- The migration should be self-contained: a new Claude session with no prior context should understand it fully.
- If ARGUMENTS are provided, treat them as the "next action" description.
- **Inline migration**: If `/migrate` appears in the same message as a question, task, or request, that question/task IS the next action. Do NOT answer it here — package the context needed to answer it in a new conversation. The migration should set up the new conversation to handle that question with full context. Example: "Can you explain RAG? /migrate" → the migration's "What I'd like to do next" should be "Explain RAG in the context of [relevant project context]", not an answered question with an old-thread migration.
