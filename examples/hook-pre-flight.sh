#!/usr/bin/env bash
# pre-flight.sh — SessionStart hook: quick environment checks.
# Quiet-unless-flagged: outputs only for issues found.
# If all checks pass, outputs a single confirmation line.

# Only run checks inside a git repo (i.e., a project context)
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  exit 0
fi

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
FLAGS=0

# Check 1: Uncommitted changes
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
  echo "Pre-flight: uncommitted changes in $(basename "$PROJECT_ROOT")"
  FLAGS=$((FLAGS + 1))
fi

# Check 2: .gitignore covers secrets
if [ ! -f "$PROJECT_ROOT/.gitignore" ]; then
  echo "Pre-flight: no .gitignore found"
  FLAGS=$((FLAGS + 1))
elif ! grep -qE '\.env|\.pem|\.key' "$PROJECT_ROOT/.gitignore" 2>/dev/null; then
  echo "Pre-flight: .gitignore may not cover secrets (.env, *.pem, *.key)"
  FLAGS=$((FLAGS + 1))
fi

# Check 3: CLAUDE.md exists
if [ ! -f "$PROJECT_ROOT/CLAUDE.md" ]; then
  echo "Pre-flight: no CLAUDE.md in project root"
  FLAGS=$((FLAGS + 1))
fi

# Summary
if [ "$FLAGS" -eq 0 ]; then
  echo "Pre-flight: all clear"
fi

exit 0
