# Hallucination Tracking

Where the Digital Core logs false claims it made, so the same mistakes get limited over time.

## Files

- **`ledger.md`** — Running log of hallucinations, most recent first. Each entry: what was claimed, what was true, how caught, likely cause, what prevents repeat.

## When to log

Any time a false claim surfaces and is caught:
- The operator (or another party) flags something the system said as untrue
- The system realizes mid-session that it stated something it couldn't verify
- A downstream consequence (wrong file path, broken reference, incorrect attribution) reveals an earlier claim was wrong

## What to log

See `ledger.md` for the entry template. Minimum fields:
- **What was claimed** — the exact false statement, verbatim
- **What was actually true** — the correction
- **How it was caught** — operator flag, downstream failure, self-check
- **Likely cause** — what produced the hallucination (pattern-matching from training? over-confident synthesis? stale memory?)
- **What prevents repeat** — a concrete future check, or a change to a rule, or a new entry in the research catalog

Cross-reference to the chronicle entry of the session where the claim was made, and to any file where a correction was applied.

## How to use the ledger

**Before citing examples, provenance, or any factual claim with a source:** check the ledger for prior false claims in the same category. If the system has hallucinated about something before, the ledger should flag it as a category to handle carefully.

**Periodically:** scan for patterns. If the same category of claim keeps appearing (e.g. "exact URL of a paper I remember reading" or "specific quote from a book I read months ago"), that category needs a structural fix — probably a rule that forces a tool call before such a claim lands.

## Why this matters

Hallucinations are not random. They cluster around specific failure modes — confident pattern-matching from training, inference from adjacent examples, synthesis that smooths over real gaps. A ledger makes the clusters visible. Without one, every hallucination feels like a fresh surprise; with one, the category becomes a known risk to plan around.

This is the practice equivalent of `rule-enforcement.md` at the epistemic level: honest self-tracking is what turns "don't hallucinate" from intent into behavior.
