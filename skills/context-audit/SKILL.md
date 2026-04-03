---
name: context-audit
description: Audit context efficiency — measure what loads on startup, identify bloat, and recommend optimizations
effort: low
---

# Context Efficiency Audit

You are performing a context efficiency audit of the user's Claude Code setup. Your goal is to measure and report exactly what consumes context on every conversation start, and identify optimization opportunities.

## What to Measure

### 1. Always-Loaded Content (every conversation)
Measure the size of everything that loads automatically:

```bash
# System prompt + tool definitions (estimate ~15-20KB, not directly measurable)
# CLAUDE.md
wc -c ~/.claude/CLAUDE.md
# All rules that match current working directory
wc -c ~/.claude/rules/*.md
# MEMORY.md index
wc -c ~/.claude/projects/*/memory/MEMORY.md
# settings.json (loaded as config)
wc -c ~/.claude/settings.json
```

Report total always-loaded bytes and line count.

### 2. Memory Files (on-demand)
For each memory file, report:
- File name, size (bytes + lines)
- Which triggers cause it to load
- How often it's likely triggered (high/medium/low frequency)

Sort by size descending. Flag any file over 5KB or 80 lines.

### 3. Rules Efficiency
Check each rule file:
- Does `paths:` frontmatter actually scope it, or does `**` make it always-load?
- Could any rules be merged to reduce file count?
- Are any rules redundant with CLAUDE.md content?

### 4. Redundancy Check
Look for:
- Content duplicated between MEMORY.md index and individual memory files
- Content duplicated between CLAUDE.md and rules files
- Memory files that overlap significantly with each other
- Triggers that would cause multiple large files to load simultaneously

### 5. Staleness Check
For each memory file:
- Check the last-updated date (if present in content)
- Flag files that haven't been updated in 30+ days
- Flag files whose description no longer matches their content

## Output Format

```markdown
# Context Efficiency Report — [DATE]

## Budget Summary
| Layer | Size | Lines | Notes |
|-------|------|-------|-------|
| System prompt (est.) | ~18KB | ~350 | Fixed overhead |
| CLAUDE.md | ?KB | ? | |
| Rules (all) | ?KB | ? | |
| MEMORY.md index | ?KB | ? | |
| **Total always-loaded** | **?KB** | **?** | |

## Memory Bank
| File | Size | Lines | Trigger Frequency | Flag |
|------|------|-------|-------------------|------|
| ... | ... | ... | ... | ... |

**Total memory bank**: ?KB across ? files
**Worst-case single session**: ?KB (if all high-freq triggers fire)

## Findings
### Bloat (files over budget)
[List files over 5KB/80 lines with recommendations]

### Redundancy
[Duplicated content across files]

### Staleness
[Files needing refresh or removal]

### Always-Load Optimization
[Rules or content that could be scoped more narrowly]

## Recommendations
[Numbered, prioritized list of specific actions]

## Context Budget Guideline
- MEMORY.md index: target <60 lines, <4KB
- Individual memory files: target <80 lines, <5KB
- Rules: target <30 lines each
- Always-loaded total: target <25KB (excluding system prompt)
```

## Execution Notes
- Use `wc -c` and `wc -l` for precise measurements
- Read MEMORY.md to check for inline content that should be in separate files
- Cross-reference triggers to estimate worst-case context load per session type
- Be specific with recommendations — name exact files and what to cut/merge/split
