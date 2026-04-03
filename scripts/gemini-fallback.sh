#!/usr/bin/env bash
# gemini-fallback.sh — PostToolUse hook for WebSearch/WebFetch
# If the tool result indicates a blocked/failed fetch, re-query via Gemini CLI.

set -euo pipefail

# macOS-compatible timeout (macOS lacks GNU timeout)
if command -v gtimeout &>/dev/null; then
  TIMEOUT_CMD="gtimeout 90"
elif command -v timeout &>/dev/null; then
  TIMEOUT_CMD="timeout 90"
else
  TIMEOUT_CMD=""
fi

TOOL_OUTPUT="${TOOL_RESULT:-}"
TOOL_ERR="${TOOL_ERROR:-}"
TOOL_PARAMS="${TOOL_INPUT:-}"

# Combine result and error output for pattern matching
COMBINED="${TOOL_OUTPUT} ${TOOL_ERR}"

# Patterns that indicate a failed or blocked web request
FAIL_PATTERNS=(
  "403"
  "401"
  "429"
  "Access Denied"
  "blocked"
  "Cloudflare"
  "captcha"
  "rate limit"
  "too many requests"
  "Unable to fetch"
  "could not fetch"
  "failed to fetch"
  "Request failed"
  "connection refused"
  "ECONNREFUSED"
  "ETIMEDOUT"
  "socket hang up"
  "ERR_ACCESS_DENIED"
  "HTTP error"
  "status code 4"
  "status code 5"
  "not available"
  "This site can't be reached"
  "robot"
  "bot detection"
  "Just a moment"
)

# Check if the output matches any failure pattern (case-insensitive)
is_failed=false
for pattern in "${FAIL_PATTERNS[@]}"; do
  if echo "$COMBINED" | grep -qi "$pattern"; then
    is_failed=true
    break
  fi
done

if [ "$is_failed" = false ]; then
  exit 0
fi

# Extract the query/URL from tool input
query=$(echo "$TOOL_PARAMS" | python3 -c "
import sys, json
data = json.load(sys.stdin)
# WebSearch uses 'query', WebFetch uses 'url'
print(data.get('query', data.get('url', '')))
" 2>/dev/null || echo "")

if [ -z "$query" ]; then
  exit 0
fi

# Route through Gemini CLI (90s timeout to avoid blocking Claude Code)
echo "Web request failed — falling back to Gemini CLI..." >&2

# Tailor the prompt based on whether it's a URL or a search query
if echo "$query" | grep -qE '^https?://'; then
  gemini_prompt="Fetch and read this URL, then provide a detailed summary of the content. Return only factual information: $query"
else
  gemini_prompt="Search the web for: $query — Return a concise, factual summary of the top results."
fi

result=$($TIMEOUT_CMD gemini -p "$gemini_prompt" -o text 2>/dev/null || echo "")

if [ -n "$result" ]; then
  echo ""
  echo "── Gemini Fallback Result ──"
  echo "$result"
  echo "── End Gemini Result ──"
fi

exit 0
