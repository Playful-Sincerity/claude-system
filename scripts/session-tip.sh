#!/bin/zsh
# session-tip.sh — SessionStart hook: surface one unadopted practice from the knowledge base.
# Dynamically reads the knowledge base and picks a random practice the user hasn't adopted yet.
# Self-updates as the researcher agent adds new findings to the knowledge base.

KB="$HOME/.claude/knowledge/claude-code-practices.md"

if [ ! -f "$KB" ]; then
  echo "Run /discover to build your Claude Code knowledge base."
  exit 0
fi

# Find all lines with "Implemented**: No" — these are unadopted practices
NO_LINES=$(grep -n "Implemented.*No" "$KB")
COUNT=$(echo "$NO_LINES" | grep -c .)

if [ "$COUNT" -eq 0 ]; then
  echo "All known practices adopted! Run /discover to find new ones."
  exit 0
fi

# Pick a random unadopted practice
INDEX=$(( (RANDOM % COUNT) + 1 ))
CHOSEN=$(echo "$NO_LINES" | sed -n "${INDEX}p")
LINE_NUM=$(echo "$CHOSEN" | cut -d: -f1)

# Walk backwards to find the nearest ### heading
HEADING=""
START=$((LINE_NUM > 15 ? LINE_NUM - 15 : 1))
while [ $START -le $LINE_NUM ]; do
  L=$(sed -n "${START}p" "$KB")
  case "$L" in
    '### '*)
      HEADING=$(echo "$L" | sed 's/^### //')
      HEADING_AT=$START
      ;;
  esac
  START=$((START + 1))
done

# Grab first descriptive line after the heading
DESC=""
if [ -n "$HEADING" ] && [ -n "$HEADING_AT" ]; then
  for i in $(seq $((HEADING_AT + 1)) $((HEADING_AT + 5))); do
    L=$(sed -n "${i}p" "$KB" 2>/dev/null)
    if [ -n "$L" ]; then
      case "$L" in
        '#'*|'**Source'*|'- **Source'*|'') continue ;;
        *)
          DESC=$(echo "$L" | sed 's/^- //' | sed 's/\*\*//g' | cut -c1-180)
          break
          ;;
      esac
    fi
  done
fi

if [ -n "$HEADING" ] && [ -n "$DESC" ]; then
  echo "Not yet adopted — $HEADING: $DESC"
elif [ -n "$HEADING" ]; then
  echo "Not yet adopted — $HEADING -> run /optimize to learn more"
else
  echo "Run /discover to find new Claude Code practices."
fi
