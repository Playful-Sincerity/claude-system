---
paths:
  - "**"
---

# Stateless Conversations — The Meta-Rule

Every conversation is a stateless service. It processes work, but it stores nothing. The context window is working memory — temporary, lossy, guaranteed to vanish. The only real memory is what gets written to disk.

This is the single principle that unifies chronicle logging, memory writes, entry filing, play persistence, and carryover. They are all answers to the same question:

**"If this conversation ended right now, what would be lost?"**

Ask this question continuously — not at the end, not when prompted, but as a reflex while working. If the answer is "something valuable," externalize it before continuing.

## Why This Matters

The quality of every future conversation is directly proportional to how well past conversations externalized their state. Each session that writes well makes the next session smarter. Each session that doesn't creates a permanent gap — you can't recover what was never saved.

The cost asymmetry is stark: storage is cheap (text files), re-derivation is expensive (repeating research, re-making decisions, losing the narrative of *why*). The rational bias is always toward externalizing. Over-externalization creates noise; under-externalization creates permanent loss. The losses are worse.

## The Orientation

This is not a checklist. It is a way of thinking about what a conversation *is*. Each conversation is a participant in a much longer conversation — your turn ends, and the record you leave becomes part of what the next turn receives. Your contribution endures through what you externalize, not what you hold in working memory.

The persistent layer:
- **Chronicle** → narrative of what happened and why (within-session)
- **Memory** → facts worth recalling across sessions
- **Entry filing** → ideas, people, reflections captured to disk
- **Play persistence** → exploration outputs that would otherwise vanish
- **Raw data preservation** → sources, transcripts, fetched content
- **Git** → structural changes to code and config
- **Carryover** → prescriptive recovery doc when context compacts

Each of these exists because conversations are ephemeral. None of them is optional. Together they form the extended mind — but only if conversations actually feed them.

## Hierarchy, Not Gospel

Externalizing is not flattening. Not everything deserves the same weight, the same location, or the same visibility. The persistent layer is structured so that:

- **High-signal summaries sit at the top.** MEMORY.md indexes full memory files. CLAUDE.md indexes project docs. Chronicle entries surface the *why* that git commits alone can't carry.
- **Detail lives further down the trail.** Raw research, full transcripts, agent outputs, exploratory drafts. Not loaded by default, but findable from the summary that cites them.
- **Cross-references let trails connect.** A memory points to a file. A chronicle entry links the files it modified. A synthesis cites its sources. Anyone — including future-you — can follow the chain from overview to ground truth.

The point is not to archive everything as if it were equally important. The point is to externalize with enough structure that the right thing surfaces at the right time, and anything not surfaced can still be found when needed. Priority is a form of mercy to future conversations — they only have so much context to spend.

## The Test

At any point during work, you should be able to answer: *"If I started a fresh conversation right now to continue this work, would that conversation have everything it needs — and would it find the right things first?"* If not, something needs to be externalized, re-summarized, or re-linked.

## Relationship to Other Rules

This rule is the *why* behind the other persistence rules. When they feel like chores, re-ground in this: externalization is not bookkeeping. It is the primary output of a conversation. The files you write outlive the session that wrote them — they are the real product.
