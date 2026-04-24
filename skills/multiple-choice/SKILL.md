---
name: multiple-choice
description: Present multiple-choice questions to the user using the VS Code native UI (AskUserQuestion tool). Use when you need decisions, preferences, or clarifications — especially during planning.
user_invocable: true
arguments: "<questions in natural language, or a numbered list of questions with options>"
---

# Multiple Choice — Native VS Code Question UI

When invoked, convert the provided questions into AskUserQuestion tool calls with proper VS Code multiple-choice UI.

## How to Use

The user (or Claude itself during planning) provides questions in natural language. This skill converts them into structured AskUserQuestion calls.

### Input Formats Accepted

**Inline:** `/multiple-choice Which model size? 7B / 14B / 30B`

**Numbered list:**
```
/multiple-choice
1. Hardware available? a) M2 Air 8GB b) M5 Pro 32GB c) Both
2. Output format? a) Docs only b) Docs + prototype c) Full paper
```

**Free-form:** `/multiple-choice I need to decide on the database, testing approach, and deployment target`
(Claude will formulate the options based on context)

## Rules

1. **Always use AskUserQuestion tool** — never fall back to plain text for multiple-choice when this skill is invoked
2. **2-4 options per question** — the tool enforces this. If more options exist, group or prioritize
3. **Max 4 questions per call** — batch into multiple calls if needed
4. **Short headers** — max 12 chars, used as chip/tag labels (e.g., "Hardware", "Scope", "Model")
5. **Concise labels** — 1-5 words per option
6. **Descriptions matter** — add context about trade-offs so the user can decide quickly
7. **Use previews** for code/config/mockup comparisons — otherwise skip them
8. **Recommend when confident** — put "(Recommended)" on the best option and list it first
9. **multiSelect: true** only when choices aren't mutually exclusive

## Examples

**Simple:** `/ask Which test framework? Jest / Vitest / Bun test`
→ Single AskUserQuestion with 3 options under header "Test framework"

**Planning batch:**
```
/ask
1. Database: SQLite vs Postgres vs DuckDB
2. API style: REST vs GraphQL
3. Deploy target: Local only vs Cloud vs Both
```
→ Three questions in one AskUserQuestion call

**From context:** `/ask` (no arguments, during active planning)
→ Claude formulates questions from the current planning context and presents them
