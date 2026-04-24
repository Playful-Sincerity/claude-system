#!/usr/bin/env bash
# routing-nudge.sh — Stop hook: periodic model routing summary.
# Shows cost savings estimate based on routing decisions.
# Throttled to fire every 30 minutes max.
# Always exits 0 (informational, never blocking).

source "$HOME/.claude/scripts/hook-log.sh"

TODAY=$(date +%Y-%m-%d)
NOW_EPOCH=$(date +%s)
THROTTLE_MINUTES=30

LOG_FILE="$HOME/claude-system/data/routing-log.jsonl"
NUDGE_STATE="/tmp/.routing-nudge-${TODAY}"

# Throttle check
if [ -f "$NUDGE_STATE" ]; then
    LAST_NUDGE=$(cat "$NUDGE_STATE" 2>/dev/null || echo 0)
    ELAPSED=$(( NOW_EPOCH - LAST_NUDGE ))
    if [ "$ELAPSED" -lt $(( THROTTLE_MINUTES * 60 )) ]; then
        exit 0
    fi
fi

# No log file = nothing to report
if [ ! -f "$LOG_FILE" ]; then
    exit 0
fi

# Count today's routing decisions by model
STATS=$(python3 -c "
import json, sys
from datetime import date

today = date.today().isoformat()
haiku = sonnet = opus = other = 0
mismatches = 0
total = 0

with open('$LOG_FILE', 'r') as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        try:
            d = json.loads(line)
            if not d.get('ts', '').startswith(today):
                continue
            total += 1
            rec = d.get('recommended', 'sonnet')
            chosen = d.get('chosen', 'sonnet')
            # Count by what was recommended (what SHOULD have been used)
            if rec == 'haiku': haiku += 1
            elif rec == 'opus': opus += 1
            else: sonnet += 1
            if rec != chosen and chosen != 'inherited':
                mismatches += 1
        except:
            continue

if total == 0:
    sys.exit(0)

# Cost savings estimate vs all-sonnet baseline
# Haiku = 0.04x, Sonnet = 0.2x (1.0x baseline), Opus = 1.0x
actual_cost = haiku * 0.04 + sonnet * 0.2 + opus * 1.0
baseline_cost = total * 0.2  # all-sonnet
savings = ((baseline_cost - actual_cost) / baseline_cost) * 100 if baseline_cost > 0 else 0

print(f'Routing today: {total} subagents ({haiku} Haiku, {sonnet} Sonnet, {opus} Opus). ~{savings:.0f}% savings vs all-Sonnet.')
if mismatches > 0:
    print(f'({mismatches} override(s) where chosen model differed from recommendation)')
" 2>/dev/null)

# Only output if we got stats
if [ -n "$STATS" ]; then
    echo "-- Routing Summary --"
    echo "$STATS"
    echo "-- End Routing Summary --"
    echo "$NOW_EPOCH" > "$NUDGE_STATE"
    hook_log "routing-nudge" "$STATS"
fi

exit 0
