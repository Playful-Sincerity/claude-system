#!/bin/bash
# hook-log.sh — Shared observability for all hooks.
# Source this from any hook script to auto-log its fires.
#
# Usage (add to top of any hook script):
#   source "$HOME/.claude/scripts/hook-log.sh"
#   hook_log "hook-name" "nudge text or action taken"
#
# This appends a row to ~/claude-system/hook-observability.md
# The "Effect" column is left blank — filled in by Claude when the hook
# actually shifted behavior. Silence = no effect = data.

HOOK_OBS_LOG="$HOME/claude-system/hook-observability.md"

hook_log() {
    local HOOK_NAME="$1"
    local ACTION="$2"
    local TS
    TS=$(date "+%Y-%m-%d %H:%M")

    # Create the file with header if it doesn't exist
    if [ ! -f "$HOOK_OBS_LOG" ]; then
        cat > "$HOOK_OBS_LOG" << 'HEADER'
# Hook Observability Log

Every hook fire is auto-logged. The "Effect" column is filled in by Claude when the nudge actually changed something. Empty = no observable effect = still useful data.

Periodically audit this log to answer:
- Which hooks fire but never shift behavior? (candidates for removal or redesign)
- Which hooks consistently produce effects? (the design is working)
- Are any hooks firing too often and becoming wallpaper?
- Are any hooks not firing when they should?

| Time | Hook | Action/Nudge | Effect |
|------|------|-------------|--------|
HEADER
    fi

    echo "| $TS | $HOOK_NAME | $ACTION | |" >> "$HOOK_OBS_LOG"
}
