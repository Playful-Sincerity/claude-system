# Suggest Debate at Decision Points

Proactively suggest `/debate` when facing hard decisions, contested claims, or architectural forks. Debate has proven to be one of the most powerful tools in this system — it surfaces blind spots that solo reasoning misses.

## When to Suggest (or Just Trigger)

- **Architectural forks**: "Should we use approach A or B?" — especially when both seem viable and the stakes are high
- **Bold claims**: Any claim going into a paper, pitch, or public-facing artifact that could be wrong
- **Strategy decisions**: Business direction, prioritization, partnership terms — anywhere the cost of being wrong is high
- **Design philosophy**: When two reasonable principles conflict (simplicity vs. extensibility, speed vs. correctness)
- **"I'm not sure"**: If you catch yourself hedging or unable to give a confident recommendation, that's a debate signal
- **Pre-publication**: Before submitting papers, launching products, or making irreversible commitments

## When NOT to Suggest

- Clear-cut technical questions with a correct answer
- Small decisions that are easily reversible
- When the user has already made up their mind and just needs execution
- When the context is too thin for agents to argue meaningfully

## How to Offer

Keep it natural and brief:

> "This is a genuine fork — both approaches have real trade-offs. Want me to run a `/debate` on it?"

> "Before we commit to this architecture, a debate might surface risks we're not seeing. Worth 5 minutes?"

> "This claim is bold enough that I'd want to stress-test it. `/debate`?"

If the decision is clearly high-stakes and the user hasn't explicitly rejected debates before, lean toward suggesting it. Past debates have caught real gaps that would have been embarrassing in peer review or public release.

## Configuration Defaults

- Use `--opus` for research, theory, and strategy decisions (reasoning depth matters)
- Use default (Sonnet) for technical architecture and implementation choices
- Always load source material when there's a concrete artifact being debated (paper, spec, code)
