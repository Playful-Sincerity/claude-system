# Multi-Session Decomposition

When facing work that exceeds a single conversation's capacity — or that has independent streams that would benefit from parallel execution — consider decomposing into **session briefs**: self-contained markdown files that each drive a separate conversation.

## When to Suggest This

- The work has 3+ independent streams that don't need to share conversation context
- The total work would consume most of a conversation's context window
- Speed matters — parallel conversations finish faster than sequential work in one session
- The work has a natural phase structure (research, verify, build, test, review)
- A `/plan-deep` assessment yields "Very Complex" or the meta-plan has 5+ largely independent sections

Don't suggest this for:
- Work that fits comfortably in one session
- Highly coupled tasks where every step depends on the previous one
- Simple parallelism that subagents within a single conversation can handle

## Session Brief Format

Each brief is a standalone markdown file (e.g., `plan-session-[name].md`) that a fresh conversation can pick up cold:

```markdown
# Session Brief: [NAME] — [One-Line Description]

## Prerequisites
[Which other session briefs must complete first, or "None — can start immediately"]
[Files to read from completed prerequisite sessions]

## Context
[What this project is, where it lives, enough for a cold start]

Read these files first:
- [CLAUDE.md path]
- [Key files needed for this stream]

## Task
[Clear, specific instructions for what this conversation should accomplish]
[Structured sub-tasks with enough detail to execute without asking questions]

## Output Format
[Exactly where to save results and in what structure]
[File naming conventions, directory paths]

## Success Criteria
[Specific, measurable criteria for "done"]
[Quality bar — what's good enough vs. what's not]
```

### Key Properties

- **Self-contained**: Includes all context needed. No "see the conversation where we discussed this."
- **Cold-startable**: A fresh Claude instance reads this file and knows exactly what to do.
- **Output-specified**: Results go to specific files/directories so other sessions can find them.
- **Dependency-aware**: Prerequisites are explicit, with pointers to the output files they produce.

## Dependency Patterns

When creating session briefs, map the dependency graph:

```
[Independent]     [Independent]     [Independent]
  EXPLORE            VERIFY            SEARCH
     \                 |                 /
      \                |                /
       \               |               /
        ---------> RESTRUCTURE <------
                       |
                    DEBATE
```

- **Independent sessions** can run in parallel conversations immediately
- **Dependent sessions** specify which outputs they need and wait for those files to exist
- Flag which sessions are on the **critical path** (blocking downstream work)

## Within Each Session

Each conversation still uses parallel subagents internally. The decomposition is:
1. **Across conversations**: session briefs handle independent streams
2. **Within conversations**: subagents handle parallelizable subtasks within a stream

## How to Offer This

When the complexity threshold is met, suggest it naturally:

> "This has [N] independent streams — [names]. I can create session briefs so you can run them in parallel conversations. Want me to decompose it?"

If the user agrees, create all the session brief files, present the dependency graph, and indicate which can start immediately.
