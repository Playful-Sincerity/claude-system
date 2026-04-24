#!/usr/bin/env bash
# model-router.sh — PreToolUse hook on Agent tool.
# Scores subagent task complexity and advises on model choice.
# Cannot modify the tool call — outputs advisory text that Claude sees.
# Always exits 0 (advisory, never blocking).

source "$HOME/.claude/scripts/hook-log.sh"

# Read TOOL_INPUT from stdin (JSON with prompt, model, subagent_type, etc.)
INPUT=$(cat)

# Extract prompt and model using python3 (same pattern as existing PreToolUse hooks)
PROMPT=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('prompt', ''))
except:
    print('')
" 2>/dev/null)

MODEL=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('model', 'inherited'))
except:
    print('inherited')
" 2>/dev/null)

# If no prompt extracted, stay silent
if [ -z "$PROMPT" ]; then
    exit 0
fi

# --- Keyword Scoring ---
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Complexity indicators (+0.1 each)
COMPLEX_SCORE=0
for kw in "architecture" "security" "design" "trade-off" "tradeoff" "ambiguous" "investigate" "debug" "creative" "novel" "plan " "strategy" "reconcil" "synthesiz"; do
    if echo "$PROMPT_LOWER" | grep -q "$kw"; then
        COMPLEX_SCORE=$(echo "$COMPLEX_SCORE + 0.1" | bc)
    fi
done

# Simplicity indicators (-0.1 each)
for kw in "grep" "find " "list " "format" "validate" "count" "check " "read " "lookup" "search" "glob" "scan" "extract" "fetch"; do
    if echo "$PROMPT_LOWER" | grep -q "$kw"; then
        COMPLEX_SCORE=$(echo "$COMPLEX_SCORE - 0.1" | bc)
    fi
done

# Word count bonus
WORD_COUNT=$(echo "$PROMPT" | wc -w | tr -d ' ')
if [ "$WORD_COUNT" -gt 500 ]; then
    COMPLEX_SCORE=$(echo "$COMPLEX_SCORE + 0.3" | bc)
elif [ "$WORD_COUNT" -gt 200 ]; then
    COMPLEX_SCORE=$(echo "$COMPLEX_SCORE + 0.15" | bc)
fi

# Clamp to [0, 1]
COMPLEX_SCORE=$(echo "$COMPLEX_SCORE" | python3 -c "
import sys
s = float(sys.stdin.read().strip())
print(f'{max(0.0, min(1.0, s)):.2f}')
" 2>/dev/null)

# Map score to recommended model
if python3 -c "exit(0 if float('$COMPLEX_SCORE') < 0.3 else 1)" 2>/dev/null; then
    RECOMMENDED="haiku"
elif python3 -c "exit(0 if float('$COMPLEX_SCORE') < 0.6 else 1)" 2>/dev/null; then
    RECOMMENDED="sonnet"
else
    RECOMMENDED="opus"
fi

# Write decision to tmp for logging hook (Phase 3)
echo "{\"score\":$COMPLEX_SCORE,\"recommended\":\"$RECOMMENDED\",\"chosen\":\"$MODEL\",\"words\":$WORD_COUNT,\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" > /tmp/.model-router-last.json

# Compare recommendation vs chosen model
# Only output if there's a mismatch (save context when they agree)
MISMATCH=false

# Determine if chosen model is more expensive than recommended
case "$MODEL" in
    opus)
        if [ "$RECOMMENDED" != "opus" ]; then MISMATCH=true; fi
        ;;
    sonnet)
        if [ "$RECOMMENDED" = "haiku" ]; then MISMATCH=true; fi
        ;;
    haiku)
        # Haiku is cheapest — never advise downgrade
        ;;
    inherited)
        # No explicit model set — always advise
        if [ "$RECOMMENDED" = "haiku" ]; then
            echo "Model router: Task scores $COMPLEX_SCORE complexity -> $RECOMMENDED recommended. No model specified (will inherit parent). Consider setting model: \"haiku\"."
            hook_log "model-router" "advisory: score=$COMPLEX_SCORE -> $RECOMMENDED (no model set)"
        fi
        ;;
esac

if [ "$MISMATCH" = true ]; then
    echo "Model router: Task scores $COMPLEX_SCORE complexity -> $RECOMMENDED recommended. Currently set to $MODEL."
    hook_log "model-router" "advisory: score=$COMPLEX_SCORE -> $RECOMMENDED (chosen=$MODEL, mismatch)"
fi

exit 0
