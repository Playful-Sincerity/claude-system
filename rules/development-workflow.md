---
paths:
  - "**/*.py"
  - "**/*.js"
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.jsx"
---

# Development Workflow Rules (Auto-Enforced)

## Before Implementation
- Read the files you're about to change FIRST. Never propose changes to code you haven't read.
- For changes spanning 3+ files, write a brief plan and confirm before coding.
- Check for existing tests. If they exist, run them before AND after your changes.

## Test-Driven Development
- For bug fixes: write a failing test that reproduces the bug BEFORE fixing it.
- For new functions: write test cases first, confirm they fail, then implement.
- Always run tests after implementation. Don't mark work as done until tests pass.

## Debugging Protocol
- Reproduce first (failing test or minimal reproduction)
- Add logging to isolate — don't guess at the fix
- Identify root cause BEFORE implementing a fix
- Validate fix with the reproduction test
- Check for regressions
- Two-Correction Rule: if two correction attempts haven't fixed the issue, suggest `/clear` and a rewritten prompt — continued corrections poison context with competing wrong approaches.

## Verification (Non-Negotiable)
- Python files: must pass `python3 -m py_compile` (auto-checked by hook)
- All code: must have at least one verification step (test, type check, or manual validation)
- If no test framework exists, validate by running the code and checking output

## Writer/Reviewer Pattern
- For changes spanning 5+ files or touching critical paths, suggest reviewing in a fresh session.
- Provide a review prompt the user can paste into Session B: what changed, which files, what to verify.
- Fresh context catches mistakes that in-session self-review misses due to anchoring bias.
