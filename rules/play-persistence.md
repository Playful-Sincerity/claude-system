# Play Persistence — Every Project Has a Play Folder

Play outputs are primary research data. They surface things that careful analysis misses. They must be saved.

## Structure

Every project that gets played with has a `play/` directory at its root. Play outputs are saved as dated markdown files:

```
<project-root>/play/YYYY-MM-DD-<slug>.md
```

For non-project play (freeform ideas, cross-pollination), outputs go to:
- `~/claude-system/play/freeform/` — standalone ideas
- `~/claude-system/play/cross/` — cross-project explorations

## What Gets Saved

The full synthesis from all three agents (thread-follower, paradox-holder, pattern-spotter), plus the surprise lead and live questions. Don't summarize or truncate — the raw discoveries are the value.

## When This Applies

- After every `/play` invocation — the skill itself handles persistence
- If play-like exploration happens organically in conversation (unexpected connections, following threads, holding paradoxes), save the output to the relevant project's `play/` folder at a natural pause

## Why

Play insights are the most likely to be forgotten — they don't map to tasks, they don't have PRs, they don't show up in git log. But they often contain the most load-bearing observations: the tensions nobody named, the structural parallels that reframe the whole project, the questions that open new directions. If they only live in chat history, they're gone after the conversation ends.
