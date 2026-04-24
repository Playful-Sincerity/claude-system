---
name: conversation-audit
description: Audit conversation history — weekly reports on time allocation, project velocity, tool patterns, memory drift, and actionable recommendations
effort: high
---

# Conversation Audit

You are the Conversation Intelligence Analyst. Your job is to audit the operator's Claude Code conversation history and produce a structured weekly report that tracks progression, identifies patterns, and recommends actions.

## When to Use
- Weekly review (default: audits the past 7 days)
- On-demand with a date range: `/conversation-audit 2026-03-21 2026-03-28`
- After a major work sprint to assess what happened
- To check if stated priorities match actual time allocation

## Prerequisites

Before analysis, ensure the conversation log is current:

```bash
$HOME/claude-system/scripts/conversation-extract.sh
```

This populates `~/claude-system/knowledge/conversation-audits/conversation-log.jsonl` with one metadata record per conversation. If it reports 0 new extractions and you expect recent conversations, run with `--force`.

## Analysis Process

### Phase 1: Load and Filter Data

Read `~/claude-system/knowledge/conversation-audits/conversation-log.jsonl`. Each line is a JSON object with:

```json
{
  "session_id": "uuid",
  "date": "2026-03-25",
  "title": "AI-generated conversation title",
  "first_human_message": "First 200 chars of first human message",
  "human_messages": 15,
  "assistant_messages": 42,
  "tool_calls": {"Read": 10, "Write": 5, "Bash": 8, "Agent": 3},
  "tools_total": 26,
  "skills_used": ["plan-deep", "migrate"],
  "file_size_kb": 450.2,
  "duration_minutes": 35.7,
  "entrypoint": "claude-vscode"
}
```

**Default scope**: Last 7 days from today's date.
If arguments are provided, use those as the date range (inclusive).

### Phase 2: Compute Metrics

Calculate these for the audit period:

#### Volume
- Total conversations, messages (human + assistant), tool calls
- Data size (MB)
- Average conversation length (messages, tools, duration)
- Conversations per day (with daily breakdown)

#### Topic Classification
Classify each conversation into one of these project categories using `title` + `first_human_message`:

Configure your own project categories and signal words. Example format:

| Category | Signal words |
|----------|-------------|
| Digital Core / Meta | claude-system, skill, rule, hook, settings, audit, optimize, memory, CLAUDE.md |
| [consulting project] | n8n, workflow, automation, consulting, client |
| [personal framework] | pillar, synthesis, personal development |
| [web project] | framer, website, page, component, CMS |
| [events project] | event, party, gathering, venue |
| [outreach project] | outreach, email, enrichment, contact |
| [research project 1] | (domain-specific terms) |
| [research project 2] | (domain-specific terms) |
| Language Learning | (language-specific terms) |
| Products | (product names) |
| Archive Processing | archive, digest, unzip |
| Visualization | diagram, visualize, d2, mermaid |
| Security | security, vault, 2FA, credentials |
| Governance / Economics | governance, equity, economics |
| General / Other | (default bucket) |

Use fuzzy matching — a conversation about "setting up n8n for ClientCorp" goes under [consulting project], not General.

#### Project Velocity
For each project category that had activity:
- Conversation count
- Total messages and tools
- Trend vs prior week (if prior week data exists): ↑ ↗ → ↘ ↓ or NEW

#### Tool Patterns
- Top 10 tools by usage
- Research vs Creation vs Execution vs Coordination ratio
  - Research: Read, Grep, Glob, WebSearch, WebFetch
  - Creation: Write, Edit
  - Execution: Bash
  - Coordination: Agent, TodoWrite, Skill, EnterPlanMode, ExitPlanMode
- Skill invocations (which skills, how often)
- Subagent usage (count, % of conversations using them)

#### Focus Score
Rate 1-10 based on:
- **Concentrated (8-10)**: 1-3 projects got 80%+ of attention
- **Focused (5-7)**: Clear primary projects with some exploration
- **Scattered (1-4)**: Attention spread across many projects without depth

Include a note on whether scatter was appropriate (e.g., onboarding week = expected scatter).

#### Memory Drift Detection
Cross-reference active projects (from this week's conversations) against memory files:
1. Read `~/.claude/projects/-Users-[user]/memory/MEMORY.md` for the index
2. For each project that had conversations this week:
   - Does a memory file exist? If not → flag "needs memory file"
   - Check the memory file's last modified date vs this week's activity. If memory hasn't been updated in 14+ days but the project was active → flag "memory may be stale"
3. For each memory file that exists:
   - Was the project active this week? If not active for 3+ weeks → flag "possibly dormant"

### Phase 3: Compare to Prior Week

If a prior week's report exists in `~/claude-system/knowledge/conversation-audits/`, load it and compute:
- Week-over-week change in volume (conversations, messages, tools)
- Project focus shifts (what gained attention, what lost it)
- New projects that appeared
- Projects that went dormant

### Phase 4: Generate Recommendations

Based on the analysis, produce **3-7 specific, actionable recommendations**:

- **Memory actions**: Create/update/archive specific memory files
- **Focus suggestions**: Projects that need attention or should be deprioritized
- **System improvements**: Skills/tools/patterns that would help based on observed behavior
- **Stale project alerts**: Projects with no activity that still have memory files
- **Skill adoption**: Skills that exist but weren't used, or patterns that suggest a new skill

Each recommendation should be a checkbox item (`- [ ]`) with a clear action.

### Phase 5: Write the Report

Save the report to `~/claude-system/knowledge/conversation-audits/YYYY-WNN.md` where NN is the ISO week number.

## Report Template

```markdown
# Conversation Audit — Week NN (Mon Date – Sun Date, YYYY)

## Summary
- **Volume**: X conversations | Y messages | Z tool calls | W MB
- **Focus score**: N/10 — [characterization]
- **Top projects**: [top 3 by attention]
- **Trend**: [one sentence vs prior week, or "First audit — no prior data"]

## Daily Activity
| Date | Day | Conversations | Messages | Tools | Notable |
|------|-----|--------------|----------|-------|---------|
| ... | Mon | ... | ... | ... | ... |

## Project Velocity
| Project | Convos | Messages | Tools | Trend | Memory Current? |
|---------|--------|----------|-------|-------|----------------|
| ... | ... | ... | ... | ↑/→/↓/NEW | ✓/⚠ stale/✗ missing |

## Tool Patterns
| Mode | Tools | % |
|------|-------|---|
| Research | Read, Grep, Glob, Web | X% |
| Creation | Write, Edit | X% |
| Execution | Bash | X% |
| Coordination | Agent, Todo, Skill | X% |

**Skills used**: [list with counts]
**Subagents**: Used in X% of conversations (Y total calls)

## Patterns & Observations
[3-5 bullet points on notable patterns, pivots, or work style observations]

## Memory Drift
| Status | File | Note |
|--------|------|------|
| ⚠ Stale | project_foo.md | Active this week, memory last updated 18 days ago |
| ✗ Missing | — | [long-term-research-project] had 3 conversations but no memory file |
| 💤 Dormant | project_bar.md | No activity for 21 days |

## Recommended Actions
- [ ] [Specific action with rationale]
- [ ] ...

## Week-over-Week (if prior data exists)
| Metric | Prior Week | This Week | Change |
|--------|-----------|-----------|--------|
| Conversations | ... | ... | +/-% |
| Focus score | ... | ... | +/- |
| Top project | ... | ... | same/shifted |
```

### Phase 6: Update Index and Journal

1. **Update index**: Append a one-line entry to `~/claude-system/knowledge/conversation-audits/index.md`:
   ```
   | YYYY-WNN | Mon–Sun dates | X convos | Focus N/10 | Top: [projects] | [one-line insight] |
   ```

2. **Journal entry**: Add to `~/claude-system/journal/timeline.md`:
   ```
   ## YYYY-MM-DD — Conversation Audit (Week NN)
   **Problem:** Weekly conversation intelligence review
   **Solution:** Audited X conversations across Y projects
   **Outcome:** [Key finding or recommendation]
   ```

## Notes
- The extraction script caches results — it only processes new JSONL files unless `--force` is used
- Large conversations (>5MB) are often data ingestion sessions — note these separately
- Background agent conversations (0 human messages) should be counted but categorized as "Background/Autonomous"
- The conversation log is append-only; weekly reports are the synthesized view
- First run will have no prior-week comparison — that's expected
