# Breath — Proactive Trajectory-Level Pauses

Mid-flow, pause to check the path itself — not drift from the path, but whether the path is still right. Agents default to momentum; breath is the interruption that re-inhabits the meta-level.

## The Distinction

Nudges catch drift *from* a known-good pattern. The mirror/dream loop catches longitudinal drift over sessions. The breath catches the case where **the pattern itself is wrong for this moment**.

Not reactive. Not retrospective. A scheduled pause that asks: *am I still heading where I meant to go, and is this still the right way to get there?*

## When to Breathe

Three triggers — all legitimate:

1. **Scheduled.** The Stop hook (`breath-nudge.sh`) tracks turns and time since the last breath. If `>= 8 turns` OR `>= 30 min` since last breath, the hook emits a reminder. When you see the reminder, run `/breath` as your next action.
2. **Self-invoked.** When you sense you've been going deep for a while — or before a major transition (starting a new phase, writing a persistent artifact, ending a deliverable) — call `/breath` without waiting for the hook.
3. **Event-triggered.** Before committing to an irreversible action (publishing, sending outreach, merging to main, deploying), a breath is warranted even if scheduled and self-invoked haven't fired.

## The Content of a Breath

When you breathe, write a chronicle entry under the `Breath` category using this structure:

1. **Where am I?** — one sentence on current task and step within it.
2. **Where was I heading?** — one sentence on the intended destination.
3. **Is the path still right?** — honest check: still on trajectory, or drifted into adjacent work?
4. **What am I not seeing?** — name a blind spot. "I haven't considered X." Partial is better than skipping.
5. **What would simplify?** — could this be smaller? cheaper? what darlings should die?
6. **Continue / adjust / stop.** — one of three explicit choices before proceeding.

The value is making the choice explicit. "Continue" is a valid outcome. Breath should not manufacture churn — only surface it when warranted.

## How to Apply — Hard Checkpoint

**When you see `-- Breath Nudge --` in hook output, your NEXT message must answer the six questions inline before any tool call.** Not "I'll breathe after this Bash" — answer them first, then proceed. The nudge repeats every turn until `/breath` runs, so ignoring it just means facing the same prompt again next turn.

Two-tier response:

1. **Minimum (required every time):** Answer the six questions inline in your next message. This IS the breath — the reflection is the point, not the file write.
2. **Full (when practical):** Also run `/breath` to formalize the answers as a chronicle entry, append to the ledger, and reset the hook state. Without the reset, the nudge keeps firing.

Other triggers that don't require a hook nudge:

- **Self-invoked.** When you sense you've been deep for a while, or before a major transition (new phase, writing a persistent artifact, ending a deliverable), call `/breath` without waiting.
- **Event-triggered.** Before committing to an irreversible action (publishing, sending outreach, merging to main, deploying), breathe even if no nudge has fired.

If the breath's decision is "adjust" or "stop," act on it before the next tool call. The whole point is to intervene before momentum reasserts.

## Why This Matters

Scarlet Max's *"pause is powerful"* is the contemplative version. Agile retrospectives are the engineering version. The move is universal: periodically step outside execution to evaluate execution. Without a deterministic interruption, the entity never inhabits the meta-level explicitly — it only references its values between tasks rather than reflecting on whether the current trajectory is serving them.

## Caveats

1. **Bureaucratization.** Too-frequent breaths become overhead. Current cadence (8 turns / 30 min) is a starting point — tune down if breath volume drowns out signal, tune up if trajectory drift is slipping through.
2. **Performative breath.** A breath that looks reflective but doesn't actually interrogate the trajectory is worse than no breath. Be honest in step 4 ("what am I not seeing?") — it's the highest-value step.
3. **Flow interruption.** Breath has a real cognitive cost. That cost is the feature, not the bug: the pause is what lets the meta-level see.

## Relationship to Other Rules

- **Semantic logging** — Breath entries are a specific category within the chronicle. The chronicle rule still governs the file/format; this rule governs when a *Breath* entry specifically belongs there.
- **Stateless conversations** — Breath is the moment where "what would be lost if this ended right now?" extends to "and is this even the right thing to be doing?"
- **Suggest debate** — If a breath surfaces genuine uncertainty about direction, a `/debate` is the next tool up from a solo breath.
