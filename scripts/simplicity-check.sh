#!/usr/bin/env bash
# simplicity-check.sh — Stop hook: nudge Claude to check for simpler alternatives
# before committing to a custom build.
#
# Detects recent source file creation as a signal of active building.
# If no simplicity check marker exists for the project, nudges once per interval.
# Always exits 0 (informational, never blocks).

source "$HOME/.claude/scripts/hook-log.sh"

TODAY=$(date +%Y-%m-%d)
NOW_EPOCH=$(date +%s)
STALE_MINUTES=20

# Find project root
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
PROJECT_NAME=$(basename "$PROJECT_ROOT")

# Marker: touched when a simplicity check has been performed for this project
MARKER="/tmp/.simplicity-check-${PROJECT_NAME}-${TODAY}"

# If marker exists and is fresh, the check was already done — stay silent
if [ -f "$MARKER" ]; then
  exit 0
fi

# Throttle: don't nudge more than once per interval
NUDGE_STATE="/tmp/.simplicity-nudge-${PROJECT_NAME}"
if [ -f "$NUDGE_STATE" ]; then
  LAST_NUDGE=$(cat "$NUDGE_STATE" 2>/dev/null || echo 0)
  ELAPSED=$(( NOW_EPOCH - LAST_NUDGE ))
  if [ "$ELAPSED" -lt $(( STALE_MINUTES * 60 )) ]; then
    exit 0
  fi
fi

# Detect signals of active building: new source files created in last 15 min
NEW_FILES=$(find "$PROJECT_ROOT" -maxdepth 4 \
  \( -name "*.py" -o -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \
     -o -name "*.go" -o -name "*.rs" -o -name "*.rb" -o -name "*.swift" \) \
  -newer /tmp/.simplicity-check-epoch 2>/dev/null | head -5)

# Create/refresh the epoch file if missing (first run)
if [ ! -f /tmp/.simplicity-check-epoch ]; then
  touch -t "$(date -v-15M +%Y%m%d%H%M.%S)" /tmp/.simplicity-check-epoch 2>/dev/null || \
  touch /tmp/.simplicity-check-epoch
fi

# Also check: are we in a new project directory (no git history, few files)?
FILE_COUNT=$(find "$PROJECT_ROOT/src" "$PROJECT_ROOT/code" "$PROJECT_ROOT/app" \
  -maxdepth 2 -type f 2>/dev/null | wc -l | tr -d ' ')

NEW_PROJECT=false
if [ "$FILE_COUNT" -lt 5 ] 2>/dev/null; then
  NEW_PROJECT=true
fi

# Only nudge if there are signals of building
if [ -n "$NEW_FILES" ] || [ "$NEW_PROJECT" = true ]; then
  echo "-- Simplicity Check --"
  echo "Building detected in ${PROJECT_NAME}. Have you checked for simpler alternatives?"
  echo "Before custom code: platform built-ins > stdlib > libraries > simpler architecture"
  echo "Touch ${MARKER} after checking (or run the check from simplicity-check.md)."
  echo "-- End Simplicity Check --"

  echo "$NOW_EPOCH" > "$NUDGE_STATE"
  hook_log "simplicity-check" "Nudged: building detected in ${PROJECT_NAME}, no check marker found"
fi

# Refresh the epoch marker for next cycle
touch /tmp/.simplicity-check-epoch

exit 0
