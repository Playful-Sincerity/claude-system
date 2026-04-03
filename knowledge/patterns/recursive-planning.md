# Recursive Hierarchical Planning Pattern

**Origin:** Internal (designed 2026-03-27, validated against ADaPT, GoalAct, Plan-and-Act research)
**Skill:** `/plan-deep`

## When to Use

Use for projects with 15+ interdependent files where you don't already have a mental model of the target architecture. Do NOT use for simple tasks — the overhead isn't justified below that threshold.

| Scale | Approach |
|---|---|
| 1-5 files | Just do it |
| 5-15 files | Single-pass plan + checklist |
| 15-50 files | 2-level: meta-plan + section plans |
| 50+ files | Full recursive with reconciliation |

## The 6-Step Pattern

```
Pre-Step: Research & Question
  Silent research, then targeted questions to user.
  Prevents planning against wrong assumptions.

Step 0: Cross-Cutting Concerns (Opus)
  Establish shared conventions BEFORE parallel decomposition.
  Tech stack, interfaces, naming, error handling, auth, TESTING CONVENTIONS.

Step 1: Meta-Plan (Opus)
  Decompose into 5-10 sections with dependency graph.
  Acceptance criteria per section (assertable, testable). Human approves.

Step 2: Parallel Section Planning (Sonnet subagents)
  Each agent reads plan.md + its section + overarching goal.
  Each returns: structured contract + reasoning narrative + "breaks if" conditions + TEST STRATEGY.
  Full reasoning written to plan-section-[name].md files.

Step 3: Reconciliation (Opus + Human)
  Compare contracts across sections for conflicts.
  Cross-reference "breaks if" conditions against sibling commitments.
  GENERATE CONTRACT TESTS for cross-section interfaces.
  Human approves before execution.

Step 4: Adaptive Execution (Sonnet) — TEST-DRIVEN
  Per task: write test first → implement → run test.
  Test failure diagnosis: implementation bug (fix code) vs plan defect (re-plan).
  Per section gate: run section tests + contract tests.
  Section complete when TESTS PASS, not when tasks are checked off.
  Drift detection: if 3+ tasks deviate, pause and re-plan.

Step 5: Verification (layered)
  Unit tests → contract tests → integration tests → acceptance tests.
  Report results per layer. Acceptance test failure = project not done.
```

## Key Principles

1. **File-based plans** — plan.md is the source of truth, not conversation context (prevents instruction centrifugation)
2. **Decompose on demand** — don't pre-decompose speculatively; only recurse where execution fails (ADaPT finding: +28-33% over flat planning)
3. **Cap at 3 levels** — meta-plan -> section -> task. Deeper hierarchies amplify errors 17x
4. **Include the "why" everywhere** — every subagent prompt contains the overarching goal (prevents subgoal misalignment)
5. **Structured reconciliation** — contracts with "breaks if" conditions make conflicts detectable without reading full reasoning chains
6. **Reasoning narratives** — subagents summarize HOW they thought, not just WHAT they decided. Preserves the journey for conflict detection.
7. **Tests as plan completion signal** — a section is done when its tests pass, not when its tasks are checked off. Test failures during execution distinguish implementation bugs (fix code, retry) from plan defects (re-plan the section).
8. **Contract tests at boundaries** — the highest-value testing investment. Generated at reconciliation from interface declarations. Both producer and consumer must satisfy the contract.

## The Structured Contract Format

Each section planner returns:

```markdown
## Section: [Name]

### Implementation Plan
[Ordered task list]

### Structured Contract
- External dependencies assumed: [...]
- Interfaces exposed: [...]
- Technology commitments: [...]

### Reasoning Narrative
[1-2 paragraphs: how the agent approached this, where it pivoted, what surprised it]

### Key Decisions
- Decision: [what] | Alternatives: [options] | Because: [why] | Breaks if: [condition]

### Surprises
[What was harder/different than expected]

### Open Questions
[Needs sibling or meta-level input]
```

## Model Routing

| Step | Model | Why |
|---|---|---|
| 0, 1, 3 | Opus | Planning requires deep reasoning, judgment about tradeoffs |
| 2 | Sonnet | Section planning is focused, benefits from speed + parallelism |
| 4 | Sonnet + Haiku | Execution is mechanical; Haiku for simple subtasks |

## Reconciliation Checklist

When comparing section contracts:
- [ ] Every "external dependency assumed" is provided by some sibling's "interfaces exposed"
- [ ] No conflicting technology commitments across sections
- [ ] No "breaks if" condition already violated by a sibling's commitment
- [ ] All "open questions" addressed or flagged to human
- [ ] Sum of section plans achieves meta-plan success criteria
- [ ] Cross-cutting concerns from Step 0 consistently applied

## Research Backing

- **ADaPT** (NAACL 2024): On-demand decomposition beats speculative. +28-33%.
- **GoalAct** (NCIIP 2025 Best Paper): Continuously-updated global plan + hierarchical execution. +12%.
- **Plan-and-Act** (ICML 2025): Hybrid plan+react beats either alone.
- **17x Error Trap**: Two-level hierarchies outperform both flat AND deep (3+) systems.
- **Instruction Centrifugation**: Plans in context drift; file-anchored plans persist.
