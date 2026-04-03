# Memory Index

This file is automatically loaded into every conversation. Each entry should be one line, under ~150 characters.
Keep this under 200 lines — it's an index, not storage. Actual memory content lives in individual files.

## How to Use

Memory files use this frontmatter format:
```markdown
---
name: Short name
description: One-line description used to decide relevance
type: user | feedback | project | reference
---
Content here...
```

Types:
- **user** — Who the user is, their role, preferences, expertise
- **feedback** — Corrections and confirmations about how to work
- **project** — Ongoing work, goals, initiatives, decisions
- **reference** — Pointers to external resources and systems

## Entries

(Add your memory entries here as they accumulate)
