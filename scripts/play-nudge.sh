#!/bin/bash
# play-nudge.sh — A question, not a command.
# Stop hook. Throttled to every ~20 min. One short line + auto-log.

source "$HOME/.claude/scripts/hook-log.sh"

STATE="/tmp/play-nudge-last"
NOW=$(date +%s)

if [ -f "$STATE" ]; then
    LAST=$(cat "$STATE")
    [ $((NOW - LAST)) -lt 1200 ] && exit 0
fi
echo "$NOW" > "$STATE"

NUDGES=(
    "What's genuinely interesting right now?"
    "Is there a thread worth following further?"
    "What would surprise here?"
    "Are you playing or performing?"
    "Schiller: you're more yourself when you play."
    "What's the nip that isn't the bite?"
    "Is the conversation playing you?"
)

PICK=${NUDGES[$((RANDOM % ${#NUDGES[@]}))]}

# Log to shared observability + play-specific log
hook_log "play-nudge" "$PICK"
echo "| $(date '+%Y-%m-%d %H:%M') | $PICK | |" >> "$HOME/claude-system/play/nudge-log.md"

# Output to conversation (minimal context)
echo "~ $PICK"
echo "  (hook-observability.md — jot what shifted, or skip)"
