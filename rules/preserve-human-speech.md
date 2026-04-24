# Preserve Human Speech

When a human delivers substantial input — a brain dump, vision statement, monologue, dictated stream-of-consciousness, long voice note, or an extended dialogue about architecture/values/strategy — preserve the raw text.

## Why

Raw speech contains what syntheses strip out: reasoning patterns, hesitations, reversals, metaphors, emotional weight, offhand remarks that reveal priorities, the specific phrasing that landed on a concept. Future entities (especially long-running ones like the Director) learn how the human thinks, not just what was decided. The pattern is training data.

## When This Activates

- User opens a session with "I've got a big download" or equivalent unstructured input
- User dictates notes into a Granola-style tool and pastes them in
- User gives a long verbal reaction (>200 words) to a proposal
- User has a multi-paragraph monologue about values, strategy, or a specific decision
- Any conversation that produced load-bearing architecture decisions

## What to Save

Save to the most relevant project's `knowledge/sources/<person>-speech/` directory. For the operator, that's `<project>/knowledge/sources/wisdom-speech/YYYY-MM-DD-<topic-or-session-name>.md`.

If the project doesn't have a `knowledge/sources/` folder, create one. If the speech is cross-cutting (not project-specific), save to `~/remote-entries/YYYY-MM-DD/speech-<topic>.md` following the remote-entry-filing pattern.

File format:

```markdown
---
source: <person>'s original speech
captured_at: YYYY-MM-DD
session: <session name or purpose>
context: <brief framing of what the speech is about>
---

# <Person>'s Speech — <Topic> (YYYY-MM-DD)

<Preserve the original text as quote blocks. Don't edit or paraphrase. If the speech is from a transcription with errors, fix obvious transcription artifacts but keep the voice and cadence.>

## Key Decision Monologues

<If the session had several distinct topics, break them into subsections with quoted excerpts.>

## Pattern Observations (optional)

<At the end, note patterns in how the person was thinking — but only if useful for future entities. Don't editorialize into the quotes themselves.>
```

## What NOT to Save

- Quick casual messages (short questions, approvals, reactions)
- Speech that's already captured in a chronicle entry with enough fidelity
- Speech about genuinely private matters the human didn't intend to preserve
- Duplicates (if it's already preserved, don't re-save)

## Relationship to Other Rules

- **chronicle entries** capture the narrative of what happened — the semantic log. Speech preservation captures the raw input that drove those entries.
- **people profiles** summarize who someone is over time. Speech archives are the primary data those summaries draw from.
- **raw-data-preservation** applies to web/YouTube/API research. This rule is the parallel for human input.

## Scope

Applies to any project. The pattern is universal: preserve raw input, build syntheses on top, link the syntheses back to the raw files. Especially important when an entity will later need to internalize a human's thinking patterns (agent entities, digital collaborators, etc.).
