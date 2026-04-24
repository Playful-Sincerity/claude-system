# Simplicity Check — Search Before You Build

Before committing to a custom build, check whether something simpler already exists. This rule exists because an early project spent a full session writing a custom Telegram-to-Claude-Code wrapper before discovering Claude Code has built-in `/remote-control` and Channels features that solve the core transport problem natively.

## When This Activates

Before any of these:
- Creating a new project directory for a feature
- Writing the first source file of a new capability
- Implementing custom versions of common functionality (auth, transport, messaging, storage, APIs, deployment)
- Building a wrapper or integration layer between two tools/services
- Any work that will take more than one file to implement

## The Check (Ordered)

Search in this order — stop as soon as you find a viable option:

1. **Platform capabilities** — Does the tool/framework we're already using have this built in? Read its docs, check recent release notes, search "does X already support Y." This is the most commonly missed step.
2. **Standard library / built-ins** — Can the language's stdlib do this without any dependencies?
3. **Established libraries** — Is there a well-maintained, widely-used library for this? (Not obscure GitHub repos with 3 stars.)
4. **Simpler architecture** — Can this be done in 10 lines instead of 100? A shell script instead of a Python app? A config change instead of code?
5. **Existing ecosystem components** — Does PeerMesh, an existing PS project, or a prior build already solve this? (See `peermesh-check.md`.)

## What to Present

When the check finds alternatives, present them before proceeding:

```
## Simplicity Check

**Building:** [what we're about to build]
**Found:** [what already exists]

| Option | Effort | Coverage | Trade-offs |
|--------|--------|----------|------------|
| [existing solution] | [low/med/high] | [% of requirements met] | [what's missing or limiting] |
| [custom build] | [low/med/high] | [100%] | [maintenance burden, complexity] |

**Recommendation:** [which option and why]
```

Only proceed to custom build if the user explicitly confirms after seeing alternatives.

## What This Is NOT

- Not `/scout-components` (which searches for composable code to incorporate). This is higher level: "should we build this at all?"
- Not a blocker on small edits, bug fixes, or modifications to existing code
- Not a reason to avoid building — sometimes custom is the right call. The point is to make it a conscious choice, not a default.

## Hard Checkpoints

Stop and run this check at these moments:

1. **Before `mkdir` for a new project or feature directory** — if you're creating a new directory to hold source code, pause and check.
2. **Before the first `Write` of a source file in a new feature** — the moment you're about to create `main.py`, `index.ts`, `server.go` for something new.
3. **When the plan includes "build a custom X"** — during `/plan-deep` or any planning phase, the simplicity check runs as part of the plan.
4. **When implementing transport, auth, messaging, or storage** — these are the categories most likely to already be solved.

## The Real-World Test

Would this rule have caught a past build overlap? Yes:
- Checkpoint 2 fires when creating `bot.py`
- Step 1 of the check: "Does Claude Code already support remote access?" 
- Search finds `/remote-control` and Channels documentation
- Presented to user before building custom transport
- Custom code still gets built for the VALUE-ADD features (model routing, injection scanning, voice) — but the core transport uses the built-in feature

That's the ideal outcome: build only what doesn't already exist.
