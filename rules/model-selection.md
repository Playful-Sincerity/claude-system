---
paths:
  - "**"
---

# Model Selection Guidance

## When to Use Each Model
- **Opus**: Planning, architecture, security review, ambiguous requirements, complex multi-step reasoning.
- **Sonnet**: Daily driver for 90% of implementation. Default unless a reason to deviate.
- **Haiku**: Bounded mechanical work — grep, validation, simple lookups, format conversions.

## The OpusPlan Pattern
Use Opus to plan (deep reasoning), Sonnet to execute (fast, cheap).
This gives Opus-quality thinking where it matters most, at Sonnet-level cost for the bulk.

## Subagent Model Routing
- Default subagents to Haiku unless the task requires judgment or creativity.
- Explicitly specify `model: "haiku"` or `model: "sonnet"` when delegating.
