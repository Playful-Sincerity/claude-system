#!/usr/bin/env bash
# model-router-log.sh — PostToolUse hook on Agent tool.
# Logs every routing decision for analysis and learning.
# Reads the last decision from /tmp/.model-router-last.json (written by model-router.sh).
# Always exits 0.

source "$HOME/.claude/scripts/hook-log.sh"

LOG_FILE="$HOME/claude-system/data/routing-log.jsonl"
LAST_DECISION="/tmp/.model-router-last.json"

# Only log if there's a recent decision from the PreToolUse hook
if [ ! -f "$LAST_DECISION" ]; then
    exit 0
fi

# Check freshness — only log if decision is < 60 seconds old
NOW=$(date +%s)
MOD=$(stat -f %m "$LAST_DECISION" 2>/dev/null || echo 0)
AGE=$(( NOW - MOD ))

if [ "$AGE" -gt 60 ]; then
    exit 0
fi

# Read the decision and append to log
DECISION=$(cat "$LAST_DECISION")
echo "$DECISION" >> "$LOG_FILE"

# Clean up so we don't double-log
rm -f "$LAST_DECISION"

hook_log "model-router-log" "logged routing decision to routing-log.jsonl"

exit 0
