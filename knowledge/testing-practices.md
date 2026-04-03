# Testing Practices

## Every Project With Code Should Have Tests

At minimum, smoke tests that verify:
- Core modules import without error
- Key functions return expected types
- Config files parse correctly
- CLI entry points run without crashing

## Test Commands in CLAUDE.md

Every project with tests must document the run command in its CLAUDE.md:
```
## Run Tests
python3 -m pytest tests/ -v
```

The `auto-test.sh` Stop hook auto-detects and runs tests — but only if tests follow standard patterns.

## Preferred Frameworks

| Language | Framework | Test Pattern |
|----------|-----------|-------------|
| Python | pytest | `test_*.py` or `*_test.py` |
| Python (stdlib only) | unittest | `test_*.py` |
| TypeScript/JavaScript | vitest | `*.test.ts` / `*.test.tsx` |
| Lean 4 | Lean compiler | Proof compilation = test pass |

## auto-test.sh Detection Order

The Stop hook checks for test runners in this order:
1. `npm test` (if package.json exists with test script)
2. `python3 -m pytest` (if pytest is installed)
3. `python3 -m unittest discover` (fallback)
4. `make test` (if Makefile exists)

Tests must be discoverable by at least one of these patterns.

## Testing Philosophy

- **Smoke tests first** — prove the basics work before testing edge cases
- **Test what matters** — core logic, data transformations, external interfaces
- **Don't test framework behavior** — trust that React renders, trust that Express routes
- **Tests should run fast** — if a test takes >5 seconds, it's probably testing too much
