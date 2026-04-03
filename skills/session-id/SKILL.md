---
name: session-id
description: Find current session ID instantly, or search past sessions by title. Uses ~/.claude/sessions/ PID registry.
effort: low
---

# Session ID Lookup

Identify the current conversation's session ID, or search past sessions by title.

## Method

### Finding the current session

Walk up the process tree to find the Claude binary PID, then read its session registry file:

```bash
# Walk up process tree to find Claude PID
PID=$$
while [ "$PID" -gt 1 ]; do
  if ps -p "$PID" -o comm= 2>/dev/null | grep -q "claude"; then
    CLAUDE_PID="$PID"
    break
  fi
  PID=$(ps -p "$PID" -o ppid= 2>/dev/null | tr -d ' ')
done

# Read session registry (instant — no file scanning)
SESSION_JSON="$HOME/.claude/sessions/${CLAUDE_PID}.json"
if [ -f "$SESSION_JSON" ]; then
  SESSION_ID=$(python3 -c "import json; print(json.load(open('$SESSION_JSON'))['sessionId'])")
else
  echo "ERROR: No session file at $SESSION_JSON"
  exit 1
fi

# Find the JSONL and extract metadata
JSONL_FILE=$(find ~/.claude/projects/ -name "${SESSION_ID}.jsonl" -maxdepth 2 2>/dev/null | head -1)
TITLE=$(grep -m1 '"ai-title"' "$JSONL_FILE" 2>/dev/null | python3 -c "import sys,json; d=json.loads(sys.stdin.readline()); print(d.get('aiTitle','(no title)'))" 2>/dev/null || echo "(no title)")
SLUG=$(grep -m1 '"slug"' "$JSONL_FILE" 2>/dev/null | python3 -c "import sys,json; d=json.loads(sys.stdin.readline()); print(d.get('slug','(no slug)'))" 2>/dev/null || echo "(no slug)")
START=$(head -1 "$JSONL_FILE" 2>/dev/null | python3 -c "import sys,json; d=json.loads(sys.stdin.readline()); print(d.get('timestamp','unknown'))" 2>/dev/null || echo "unknown")
PROJECT_DIR=$(basename "$(dirname "$JSONL_FILE")")

echo "SESSION_ID=$SESSION_ID"
echo "SLUG=$SLUG"
echo "TITLE=$TITLE"
echo "START=$START"
echo "PROJECT=$PROJECT_DIR"
echo "FILE=$JSONL_FILE"
```

### Searching past sessions (when ARGUMENTS are provided)

If the user provides a search term, search session titles and slugs:

```bash
QUERY="<the search term from ARGUMENTS>"

echo "Searching sessions for: $QUERY"
echo "---"

for f in ~/.claude/projects/*/*.jsonl; do
  # Check ai-title
  TITLE=$(grep -m1 '"ai-title"' "$f" 2>/dev/null | python3 -c "import sys,json; d=json.loads(sys.stdin.readline()); print(d.get('aiTitle',''))" 2>/dev/null)
  SLUG=$(grep -m1 '"slug"' "$f" 2>/dev/null | python3 -c "import sys,json; d=json.loads(sys.stdin.readline()); print(d.get('slug',''))" 2>/dev/null)

  if echo "$TITLE $SLUG" | grep -qi "$QUERY"; then
    SID=$(basename "$f" .jsonl)
    START=$(head -1 "$f" 2>/dev/null | python3 -c "import sys,json; d=json.loads(sys.stdin.readline()); print(d.get('timestamp','unknown')[:10])" 2>/dev/null || echo "?")
    SIZE=$(wc -c < "$f" 2>/dev/null | tr -d ' ')
    echo "$START | $SID | $TITLE | $SLUG | ${SIZE}B"
  fi
done
```

## Output

### Current session (no arguments):
```
**Current Session**
- **ID:** `<UUID>`
- **Slug:** <slug>
- **Title:** <title>
- **Started:** <timestamp>
- **Project:** <project directory>
- **Log file:** `<full path>`
```

### Search results (with arguments):
Present as a table with date, ID, title, and slug.

## How It Works

1. `~/.claude/sessions/{PID}.json` maps each Claude process PID to its session ID — instant lookup, no scanning
2. Walk the process tree (`$$ → ... → claude binary`) to find the right PID
3. Search mode greps `ai-title` and `slug` fields across JSONL files
4. Every session has an auto-generated slug (e.g., "polished-drifting-river") and ai-title (e.g., "Build session ID lookup skill")

## Notes

- Search scans all JSONL files so it takes a few seconds with many sessions. For the current session, lookup is instant.
- Not all sessions have ai-titles (only ~19% based on current data), but all have slugs.
- macOS-specific process tree walking. The `~/.claude/sessions/` registry is cross-platform.
