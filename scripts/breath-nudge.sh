#!/usr/bin/env bash
# breath-nudge.sh — Stop hook: remind Claude to take a trajectory-level breath.
# Increments turn counter every Stop. Nudges when threshold crossed, but
# snoozes between fires so it doesn't spam every turn.
# Always exits 0 (informational, never blocks).

if [ -f "$HOME/.claude/scripts/hook-log.sh" ]; then
  source "$HOME/.claude/scripts/hook-log.sh"
fi

NOW_EPOCH=$(date +%s)
THRESHOLD_TURNS=8
THRESHOLD_SECONDS=$((30 * 60))
SNOOZE_SECONDS=$((10 * 60))  # After firing, don't re-fire for 10 min

STATE_FILE="/tmp/.breath-state"              # epoch of last /breath (counter reset)
COUNTER_FILE="/tmp/.breath-turn-counter"     # turns since last /breath
LAST_NUDGE_FILE="/tmp/.breath-last-nudge"    # epoch of last nudge emission
LEDGER="$HOME/claude-system/logs/breath-nudges.jsonl"

mkdir -p "$HOME/claude-system/logs"
[ -f "$STATE_FILE" ] || echo "$NOW_EPOCH" > "$STATE_FILE"
[ -f "$COUNTER_FILE" ] || echo 0 > "$COUNTER_FILE"

# Always increment turn counter, even when snoozing
TURNS=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
TURNS=$((TURNS + 1))
echo "$TURNS" > "$COUNTER_FILE"

LAST_BREATH=$(cat "$STATE_FILE" 2>/dev/null || echo "$NOW_EPOCH")
ELAPSED=$(( NOW_EPOCH - LAST_BREATH ))
MINUTES=$(( ELAPSED / 60 ))

# Threshold check
needs_nudge=false
reason=""
if [ "$TURNS" -ge "$THRESHOLD_TURNS" ]; then
  needs_nudge=true
  reason="${TURNS} turns"
fi
if [ "$ELAPSED" -ge "$THRESHOLD_SECONDS" ]; then
  needs_nudge=true
  if [ -n "$reason" ]; then reason="${reason}, ${MINUTES} min"; else reason="${MINUTES} min"; fi
fi

# Snooze check — even if threshold crossed, skip if we fired recently
if [ "$needs_nudge" = true ] && [ -f "$LAST_NUDGE_FILE" ]; then
  LAST_NUDGE=$(cat "$LAST_NUDGE_FILE" 2>/dev/null || echo 0)
  SINCE_LAST=$(( NOW_EPOCH - LAST_NUDGE ))
  if [ "$SINCE_LAST" -lt "$SNOOZE_SECONDS" ]; then
    needs_nudge=false
  fi
fi

if [ "$needs_nudge" = true ]; then
  echo "-- Breath Nudge --"
  echo "Trajectory check overdue (${reason}). Before your next tool call, answer inline:"
  echo "1. Where am I? 2. Where was I heading? 3. Still the right path? 4. What am I not seeing? 5. What would simplify? 6. Continue | Adjust | Stop."
  echo "If Adjust or Stop, act on it before any tool call. Run /breath (if available) to reset."
  echo "-- End Breath Nudge --"

  echo "$NOW_EPOCH" > "$LAST_NUDGE_FILE"

  if declare -f hook_log > /dev/null; then
    hook_log "breath-nudge" "Fired (${reason} since last breath)"
  fi

  printf '{"ts":"%s","epoch":%d,"turns":%d,"minutes":%d,"reason":"%s","source":"stop"}\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$NOW_EPOCH" "$TURNS" "$MINUTES" "$reason" \
    >> "$LEDGER"
fi

exit 0
