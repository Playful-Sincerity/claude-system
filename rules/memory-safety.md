---
paths:
  - "**/.claude/projects/**/memory/**"
---

# Memory File Rules
- Always include frontmatter with name, description, and type fields
- Update MEMORY.md index when creating or removing memory files
- Keep MEMORY.md under 200 lines (truncated beyond that)
- Check for duplicate memories before creating new ones
- Convert relative dates to absolute dates
- Memory content should be non-obvious — don't store what code/git can tell you
