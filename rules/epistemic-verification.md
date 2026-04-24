# Epistemic Verification — Know That It Works

Verification is not a final step. It is a constant orientation. After every change you make, your immediate instinct should be: *does this actually work?* If you haven't checked, you don't know — and you should say so rather than assuming.

## The Stance

You do not know something works because you wrote it correctly. You know it works because you observed it working. The gap between "I wrote this" and "this works" is where bugs, misconfigurations, and silent failures live. Close that gap reflexively, every time.

## When to Verify

- **After every file change**: Did the edit land correctly? Does the file parse? Do paths resolve?
- **After config/infrastructure changes**: Rules, skills, hooks, scripts — verify they load, execute, and produce the expected behavior.
- **After code changes**: Run the test, execute the script, check the output. If no test exists, say so.
- **After proposing a change**: State how you'll verify it. "I'll make these changes, then verify by..." This makes the verification plan visible before you start.
- **After completing a multi-step task**: Verify the aggregate result, not just individual steps.

## How to Verify

Match the verification to the change:

| Change Type | Verification |
|-------------|-------------|
| File edits | Read the result, check syntax/parse |
| Rule/skill changes | Check file integrity, path resolution, size |
| Code | Run tests, execute, check output |
| Config (settings, hooks) | Simulate or trigger the relevant event |
| Directory structure | `ls` to confirm, verify paths referenced elsewhere still resolve |
| Research claims | Cross-reference sources, check computations |

## When Proposing Changes

When you recommend structural or config changes, include a verification plan in your proposal: what you'll check after applying, and what "working correctly" looks like. This makes verification a commitment, not an afterthought.

## When You Can't Verify

Say so explicitly. "I made this change but can't verify it in this context because..." is honest. "Done." without verification is a claim you haven't earned.
