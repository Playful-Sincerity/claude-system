---
description: Generator-Verifier-Reviser pattern for research claims and mathematical derivations
paths:
  - "**"
---

# GVR: Verify Before Presenting

When producing research findings, mathematical derivations, or empirical claims in research-heavy projects, follow the Generator-Verifier-Reviser pattern:

## The Loop

1. **Generate** — Reason through the problem using your training knowledge
2. **Verify** — Check your work using computation tools before presenting it
3. **Revise** — If verification reveals errors, fix them. If it confirms, note what was verified

## What Counts as Verification

Verification must use a **different cognitive act** than generation. Using tools, not another LLM pass:

| Claim Type | Verify With |
|-----------|-------------|
| Symbolic math (equations, derivations) | SymPy (`sympy-mcp`) or Wolfram (`wolframscript`) |
| Logical consistency | Z3 SMT solver (`mcp-solver`) |
| Formal proofs | Lean 4 (`lean-lsp-mcp`) |
| Numerical results | Python/Jupyter (`jupyter-mcp-server`) or Bash + scipy |
| Empirical claims | Source paper via `paper-search` or `semantic-scholar` MCP |
| LaTeX equations from papers | `arxiv-latex-mcp` for ground truth |

## When to Apply

- **Always:** Novel derivations, proofs, quantitative claims in research projects
- **Always:** When a result "feels right" but hasn't been machine-checked
- **Skip:** Literature summaries, qualitative analysis, project planning, known-correct formulas used as-is

## What Verification Is NOT

- Another LLM call asking "is this right?" — that's rubber-stamping, not verification
- Restating the same conclusion with more confidence
- Citing a paper without checking the cited claim against the source

## Transparency

When presenting verified results, briefly note what was checked:
- "Verified via SymPy: tensor contraction confirmed"
- "Z3 confirms logical consistency of axiom set"
- "Lean 4: theorem proved in 12 lines"
- "Cross-checked against arXiv:2301.12345 eq. 14"

When presenting unverified reasoning, say so: "Not yet machine-verified."

## Verification Tally

For research projects, maintain a running tally in the project's CLAUDE.md:
- Total checks, broken down by tool (e.g., "145 SymPy + 31 Z3 + 27 Wolfram + 69 Python = 272 total, 0 failures")
- Update as new verifications are performed
- This serves as a credibility signal and audit trail
