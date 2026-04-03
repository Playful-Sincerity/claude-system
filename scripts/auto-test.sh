#!/usr/bin/env bash
# auto-test.sh — Stop hook: detect and run project tests when Claude finishes.
# Silent if no test runner found. Always exits 0 (informational, never blocks).

# Detection functions — first match wins

detect_npm_test() {
  [ -f "package.json" ] || return 1
  python3 -c "
import json, sys
d = json.load(open('package.json'))
s = d.get('scripts', {}).get('test', '')
sys.exit(0 if s and 'Error' not in s else 1)
" 2>/dev/null
}

detect_pytest() {
  [ -f "pytest.ini" ] && return 0
  [ -f "pyproject.toml" ] && grep -q '\[tool\.pytest' "pyproject.toml" 2>/dev/null && return 0
  [ -f "setup.cfg" ] && grep -q '\[tool:pytest\]' "setup.cfg" 2>/dev/null && return 0
  return 1
}

detect_unittest() {
  ls test_*.py >/dev/null 2>&1 || ls *_test.py >/dev/null 2>&1
}

detect_makefile() {
  [ -f "Makefile" ] && grep -q '^test:' Makefile 2>/dev/null
}

# Detection cascade
RUNNER=""
RUNNER_CMD=""

if detect_npm_test; then
  RUNNER="npm"
  RUNNER_CMD="npm test"
elif detect_pytest; then
  RUNNER="pytest"
  RUNNER_CMD="python3 -m pytest --tb=short -q"
elif detect_unittest; then
  RUNNER="unittest"
  RUNNER_CMD="python3 -m unittest discover -s . -p 'test_*.py' -v"
elif detect_makefile; then
  RUNNER="make"
  RUNNER_CMD="make test"
fi

# No runner found — exit silently
if [ -z "$RUNNER" ]; then
  exit 0
fi

# Run tests, cap output to avoid flooding context
echo "-- Auto-Test ($RUNNER) --"
eval "$RUNNER_CMD" 2>&1 | tail -20
echo "-- End Auto-Test --"

exit 0
