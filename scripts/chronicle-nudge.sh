#!/usr/bin/env bash
# chronicle-nudge.sh — Stop hook: remind Claude to log to the chronicle.
# Checks if today's chronicle file is fresh. Nudges if stale or missing.
# Always exits 0 (informational, never blocks).
#
# Pairs with the semantic-logging rule. Configure SYSTEM_CHRONICLE_DIR to
# point to your digital core / system config directory (wherever your
# ecosystem-level chronicle lives).

TODAY=$(date +%Y-%m-%d)
NOW_EPOCH=$(date +%s)
STALE_MINUTES=15

# Find project root (git root or cwd)
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
PROJECT_NAME=$(basename "$PROJECT_ROOT")

# Set this to your system/config directory's chronicle folder.
# Default: ~/.claude/chronicle/
SYSTEM_CHRONICLE_DIR="${SYSTEM_CHRONICLE_DIR:-$HOME/.claude/chronicle}"
ECOSYSTEM_CHRONICLE="${SYSTEM_CHRONICLE_DIR}/${TODAY}.md"
PROJECT_CHRONICLE="${PROJECT_ROOT}/chronicle/${TODAY}.md"

# Track nudge state to avoid spamming every single turn.
# Only nudge once per STALE_MINUTES interval.
NUDGE_STATE="/tmp/.chronicle-nudge-${TODAY}"

if [ -f "$NUDGE_STATE" ]; then
  LAST_NUDGE=$(cat "$NUDGE_STATE" 2>/dev/null || echo 0)
  ELAPSED=$(( NOW_EPOCH - LAST_NUDGE ))
  if [ "$ELAPSED" -lt $(( STALE_MINUTES * 60 )) ]; then
    # Recently nudged — stay quiet
    exit 0
  fi
fi

# Check project chronicle freshness
project_stale=false
ecosystem_stale=false

if [ -f "$PROJECT_CHRONICLE" ]; then
  MOD_EPOCH=$(stat -f %m "$PROJECT_CHRONICLE" 2>/dev/null || stat -c %Y "$PROJECT_CHRONICLE" 2>/dev/null || echo 0)
  ELAPSED=$(( NOW_EPOCH - MOD_EPOCH ))
  if [ "$ELAPSED" -gt $(( STALE_MINUTES * 60 )) ]; then
    project_stale=true
  fi
else
  project_stale=true
fi

if [ -f "$ECOSYSTEM_CHRONICLE" ]; then
  MOD_EPOCH=$(stat -f %m "$ECOSYSTEM_CHRONICLE" 2>/dev/null || stat -c %Y "$ECOSYSTEM_CHRONICLE" 2>/dev/null || echo 0)
  ELAPSED=$(( NOW_EPOCH - MOD_EPOCH ))
  if [ "$ELAPSED" -gt $(( STALE_MINUTES * 60 )) ]; then
    ecosystem_stale=true
  fi
else
  ecosystem_stale=true
fi

# Build nudge message
needs_nudge=false
msg=""

if [ "$project_stale" = true ]; then
  needs_nudge=true
  msg="Chronicle: No entry for ${PROJECT_NAME} today"
  if [ -f "$PROJECT_CHRONICLE" ]; then
    msg="Chronicle: ${PROJECT_NAME} entry is ${STALE_MINUTES}+ min stale"
  fi
  msg="${msg} -> ${PROJECT_CHRONICLE}"
fi

if [ "$ecosystem_stale" = true ]; then
  needs_nudge=true
  if [ -n "$msg" ]; then
    msg="${msg} | Ecosystem chronicle also needs an entry"
  else
    msg="Chronicle: Ecosystem entry missing/stale -> ${ECOSYSTEM_CHRONICLE}"
  fi
fi

if [ "$needs_nudge" = true ]; then
  echo "-- Chronicle Nudge --"
  echo "$msg"
  echo "Log what just happened: decisions, discoveries, implementations, pivots. What/Why/Means."
  echo "-- End Chronicle Nudge --"
  # Record nudge time
  echo "$NOW_EPOCH" > "$NUDGE_STATE"
fi

exit 0
