---
paths:
  - "**"
---

# Build Queue — Overflow Capture During Focused Work

When focused work produces more ideas than the operator can handle right now, capture the overflow to the project's `ideas/build-queue.md`. The queue lets the current work stay focused while nothing gets lost. It is a capture surface, not a commitment to build.

## The underlying pattern

During focused work — coding, writing, designing, researching, iterating — the operator often surfaces ideas adjacent to the current task. Three failure modes without a queue:

1. **Derail** — stop the current work to debate the new idea, losing momentum
2. **Forget** — acknowledge in chat, then lose it when context compacts
3. **Refuse** — pretend it wasn't said

The queue is the fourth option: capture silently, move on, revisit at a natural pause.

## When this activates

- Active focused work is in progress (implementation, drafting, design, research)
- the operator surfaces an idea, feature, fix, direction, or tangent that isn't the current task
- Handling it now would derail the current work
- The signal is bandwidth pressure ("more than I can handle"), not idea quality

## When it does NOT activate

- Planning or exploration sessions — those ARE the time to entertain ideas
- Bugs in the current work — fix them
- Ideas the operator says "let's do next" or "right now" — those go to active todos
- The idea IS the current task being refined
- Conversation with no clear destination project

## Where to capture

`<project-root>/ideas/build-queue.md` — one queue per project. `ideas/` is part of the Universal Scaffold (see `folder-structure.md`). Create `build-queue.md` on first use with a short header.

## Entry format

Append to the bottom (newest last, easier to diff):

    ### YYYY-MM-DD — Short title

    **Context:** What we were doing when it came up.
    **Idea:** 1-3 lines in the operator's words (quoted if memorable phrasing).
    **Why it matters:** The value — only if the operator named it.
    **Implementation notes:** Any hints he dropped.
    **Rough shape:** (Optional) concrete starting point if obvious.

## How to apply

- **Silent.** Don't announce — one tool call, move on. Narrating the capture defeats the point.
- **Append.** Newest at the bottom.
- **Mark completion.** When a queued item ships, cross it out with the completion date and link to the relevant chronicle entry.
- **Promote when outgrown.** If an entry grows past ~20 lines or needs its own exploration doc, extract to `ideas/YYYY-MM-DD-<slug>.md` and link from the queue.
- **Create the file if missing.** First use creates `ideas/build-queue.md` with a short header (see [your project]'s for reference).

## Surfacing the queue

At natural pauses — end of a session, between major tasks, or when the operator asks — briefly surface accumulated items: "Three items hit the queue today: [one-line each]. Want to triage?" Don't surface mid-task.

## Relationship to other capture systems

- **`ideas/` folder:** The queue lives INSIDE `ideas/`. Full-fledged ideas get their own `YYYY-MM-DD-<slug>.md`; the queue holds shorter captures that may or may not graduate.
- **Remote entries:** Capture from OUTSIDE sessions (phone, voice, between tasks). Build queue captures DURING a live session when bandwidth is the constraint. Different moment, same destination shape.
- **Chronicle:** A queue addition doesn't need its own chronicle entry. A completed queue item does, if substantial.
- **Todos:** Todos = this session. Build queue = future sessions. Don't mix.
- **Multi-session decomposition:** If queued items cluster by theme and accumulate past ~5-10, consider spinning up session briefs from the cluster.
