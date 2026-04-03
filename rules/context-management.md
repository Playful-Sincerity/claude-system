---
paths:
  - "**"
---

# Context Management Rules

## Subagent Delegation
- Use subagents for any exploration that requires reading 5+ files
- Use subagents for code review tasks (separate context, focused lens)
- Route simple lookups and searches to Haiku model when possible
- Report subagent findings as concise summaries, not raw dumps

## Context Hygiene
- After completing a task, if the next task is unrelated, suggest `/clear` to the user
- When context is getting heavy (lots of file reads, long conversation), prefer subagents
- For large refactors, break into phases — complete and verify each before starting the next
- For quick lookups mid-task, suggest `/btw` — it answers without entering conversation history.

## MCP Server Awareness
- Each connected MCP server adds tool definitions to every message, even when idle — typically 8-30% of context.
- Periodically suggest checking `/mcp` and disabling servers not needed for the current task.

## Compaction Awareness
- Suggest compacting proactively at ~60% context usage — don't wait for auto-compact at 80% when quality has already degraded.
- If compaction occurs, re-read any files you were actively editing
- Preserve: file paths being modified, test commands, key decisions made
- After compaction, briefly restate what you're working on to maintain coherence
