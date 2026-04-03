# Rule Enforcement — Making Rules Actually Work

A rule that isn't followed is just a wish. This meta-rule defines how to ensure behavioral rules get real compliance.

## The Pattern

**Rule alone = intent. Rule + enforcement = behavior.**

Discovered via the semantic logging system: a well-written rule hit 12% adoption. Adding a Stop hook nudge + hard checkpoints brought it to near-100% in one day. This pattern generalizes.

## When a Rule Needs Enforcement

Not every rule needs a hook. Enforcement is warranted when:
- The rule requires **proactive action** (not just "don't do X" but "do X regularly")
- The rule is easy to forget during focused work
- Non-compliance is invisible (no error, no failure — just missing output)
- The rule has been in place but compliance is low

Rules that DON'T need enforcement:
- Safety/blocking rules (already enforced by PreToolUse hooks)
- Simple constraints ("prefer X over Y")
- Rules where non-compliance is immediately visible

## The Enforcement Stack

### Level 1: Rule Only
Write a clear behavioral rule with specific triggers. Monitor compliance.

### Level 2: Rule + Hard Checkpoints
Add explicit "MUST stop and do X before continuing" interrupt points within the rule. Tie them to natural workflow moments (after file changes, before presenting results, at session start).

### Level 3: Rule + Hook Nudge
Add a hook script that checks compliance state and outputs a reminder. The Stop hook is best for proactive-action rules — it fires after every response and the nudge appears in the next turn's context.

**Hook design principles:**
- Use a `/tmp` state file to throttle nudges (every 15-20 min, not every turn)
- Check freshness of the expected output (file modification time)
- Keep the nudge short — 3 lines max. Name what's missing and where it should go
- Always exit 0 — nudges are informational, never blocking

### Level 4: Rule + Blocking Hook (nuclear option)
A PreToolUse hook that blocks Edit/Write until compliance is met. Only for rules where non-compliance has real consequences. Not yet used in this system — reserve for extreme cases.

## How to Apply

When you create a new behavioral rule that requires proactive action:

1. **Start at Level 1.** Write the rule, deploy it.
2. **Audit after a few sessions.** Check if conversations are actually following it.
3. **If compliance is low, escalate.** Add checkpoints (Level 2) and/or a hook (Level 3).
4. **Log the enforcement.** Chronicle the compliance problem and the fix — this meta-evolution is valuable context.

## Current Enforced Rules

| Rule | Enforcement Level | Mechanism |
|------|------------------|-----------|
| `semantic-logging.md` | Level 3 | `chronicle-nudge.sh` Stop hook + 6 hard checkpoints |

Update this table as new rules get enforcement mechanisms.
