#!/bin/zsh
# context-reinject.sh — Outputs session carryover after compaction, clears on new sessions.
# Wired to both SessionStart and Notification hooks.
# SessionStart provides a `source` field: "startup", "resume", "clear", or "compact".

ACTIVE_CTX="$HOME/.claude/active-context.md"

# Read stdin JSON (hooks receive context via stdin)
INPUT=$(cat)
SOURCE=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('source',''))" 2>/dev/null)
EVENT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('hook_event_name',''))" 2>/dev/null)

has_carryover() {
  [ -f "$ACTIVE_CTX" ] && ! grep -q "^(none" "$ACTIVE_CTX"
}

if [ "$EVENT" = "SessionStart" ]; then
  if [ "$SOURCE" = "compact" ]; then
    # Post-compaction: inject the carryover so Claude recovers context
    if has_carryover; then
      cat "$ACTIVE_CTX"
    fi
  else
    # New session (startup/resume/clear): clear stale carryover from previous sessions
    if has_carryover; then
      cat > "$ACTIVE_CTX" << 'TEMPLATE'
# Active Context

<!-- This file is written by /carryover and read by context-reinject.sh.
     It is auto-cleared on new session starts. Only lives between /carryover and next fresh session.
     The permanent record is the dated archive copy in the project directory. -->

## Current Task
(none — run /carryover before compacting to populate this)

## Modified Files
(none)

## Key Decisions
(none)

## Test Command
(none)
TEMPLATE
    fi
    echo "No active context set. If resuming work, re-read MEMORY.md and relevant project files."
  fi
else
  # Notification hook (fires during session, e.g. after compaction completes)
  if has_carryover; then
    cat "$ACTIVE_CTX"
  fi
fi
