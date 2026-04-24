---
name: bypass
description: Print a copy-paste command that resumes the current session in a fresh terminal with --dangerously-skip-permissions enabled. Use when you want to continue the active conversation without permission prompts.
---

# Bypass — Hand Off the Current Session to a Bypassed Terminal

One job: print a single `claude ... --resume` command that the user can paste into a terminal to continue the exact conversation they're in, with permission prompts disabled.

## When to Use
- User asks to "bypass permissions," "yolo this," "go to terminal," or "continue in terminal without prompts"
- About to run a long autonomous task (big audit, bulk migrations, scripted sweeps) where approving every tool call is friction
- User explicitly runs `/bypass`

## Arguments
- Optional kickoff prompt. If provided, that's the text the resumed session starts on. If omitted, defaults to `continue`. Resume without a prompt fails when the prior turn ended mid-tool ("No deferred tool marker found") — always include one.

## Execution

Run this bash block. It walks the process tree to the Claude binary PID, reads the session registry, and prints the command. Also copies to macOS clipboard via `pbcopy` so the user can paste immediately.

```bash
PID=$$
while [ "$PID" -gt 1 ]; do
  if ps -p "$PID" -o comm= 2>/dev/null | grep -q "claude"; then
    CLAUDE_PID="$PID"
    break
  fi
  PID=$(ps -p "$PID" -o ppid= 2>/dev/null | tr -d ' ')
done

SESSION_JSON="$HOME/.claude/sessions/${CLAUDE_PID}.json"
if [ ! -f "$SESSION_JSON" ]; then
  echo "ERROR: No session registry at $SESSION_JSON"
  echo "This skill only works from inside a Claude Code session."
  exit 1
fi

SESSION_ID=$(python3 -c "import json; print(json.load(open('$SESSION_JSON'))['sessionId'])")

# Use provided argument as kickoff prompt, default to "continue"
PROMPT="${ARGUMENTS:-continue}"
# Escape any double quotes in the prompt
PROMPT_ESCAPED=$(printf '%s' "$PROMPT" | sed 's/"/\\"/g')

CMD="claude --dangerously-skip-permissions --resume $SESSION_ID \"$PROMPT_ESCAPED\""

# Copy to clipboard if pbcopy exists
if command -v pbcopy >/dev/null 2>&1; then
  printf '%s' "$CMD" | pbcopy
  COPIED=" (copied to clipboard)"
else
  COPIED=""
fi

echo ""
echo "Session: $SESSION_ID"
echo ""
echo "Paste into a fresh terminal$COPIED:"
echo ""
echo "  $CMD"
echo ""
```

## Output

After running the block, reply to the user with a short message:

1. The command in a code block (so it's copy-paste friendly even if clipboard copy failed)
2. A one-line reminder that bypass mode skips all permission prompts
3. Nothing else — no preamble, no explanation

Example:

```
Paste into a new terminal (already in clipboard):

  claude --dangerously-skip-permissions --resume <uuid> "continue"

Bypass mode = no permission prompts for the rest of that session.
```

## Notes
- Works from inside Claude Code CLI or the VS Code extension — both register in `~/.claude/sessions/<pid>.json`
- If the registry file is missing, the skill is being invoked outside a Claude process tree (e.g., from a subagent) — fail loudly
- The kickoff prompt can be anything; `continue` is the safest default since it's a no-op instruction that just restarts the conversation flow
- Does not modify settings.json, does not touch hooks, does not start the resumed session — only generates the command
