# Debate Protocol — Multi-Perspective Analysis Engine

Reference document for adversarial, steelman, and perspectives analysis. Used by `/debate` and `/plan-deep --adversarial`.

## Core Concepts

**Proposition**: The claim, idea, plan, or question under analysis.
**Position**: An assigned analytical stance (PRO, CON, or a named lens).
**Focus Brief**: A 3-5 sentence framing paragraph that emphasizes what the agent should attend to. Same base context, different emphasis.
**Round**: One complete cycle where each agent produces a response. Round 1 is independent; subsequent rounds include the opponent's previous output.
**Synthesis**: A fresh Opus pass that reads the full transcript and produces a structured verdict.

## Modes

### Adversarial (default)
Two agents: PRO and CON. Each argues their assigned position through N rounds.
- **Goal**: Surface genuine disagreement, find the strongest version of both sides
- **Synthesis output**: Key conflicts, strongest argument per side, where the weight of evidence falls, recommendation
- **When to use**: Testing claims, stress-testing plans, evaluating trade-offs

### Steelman
Two agents: BUILDER and STRESS-TESTER. Builder strengthens the proposition; Stress-Tester finds the remaining gaps.
- **Goal**: Take a weak or early-stage idea and produce the strongest possible version of it
- **Synthesis output**: Strengthened proposition, critical improvements made, remaining vulnerabilities, confidence assessment
- **When to use**: Refining research hypotheses, improving pitches, strengthening arguments before publication

### Perspectives
Three agents, each assigned a distinct analytical lens relevant to the proposition's domain. Lenses are auto-selected based on the proposition but can be overridden.
- **Goal**: Illuminate the proposition from angles the proposer hasn't considered
- **Synthesis output**: Per-lens key insight, where lenses agree, where they conflict, blindspots revealed
- **When to use**: Architecture decisions, strategic questions, complex trade-offs with multiple stakeholders
- **Default lens selection heuristics**:
  - Technical proposition → Engineering, User Experience, Maintainability
  - Research proposition → Theoretical Rigor, Empirical Evidence, Practical Application
  - Business proposition → Market Viability, Technical Feasibility, Strategic Alignment
  - Can be overridden: `/debate --perspectives --lenses "security, performance, developer experience"`

## Focus Brief Generation

Each agent receives the full user-provided context plus a focus brief. The brief doesn't filter information — it directs attention.

**Template:**
```
FOCUS BRIEF — [POSITION/LENS NAME]

Your analytical role: [position description]
Attend especially to: [2-3 specific aspects to emphasize]
Your strongest move is: [what kind of argument/insight serves this position best]
Watch for: [common failure mode for this position — e.g., PRO agents tend to minimize risks]
```

**Adversarial example:**
```
FOCUS BRIEF — CON

Your analytical role: Find every reason this proposition fails, is wrong, or has hidden costs.
Attend especially to: unstated assumptions, second-order consequences, and evidence that contradicts the claim.
Your strongest move is: identifying the specific mechanism by which this fails, not just asserting doubt.
Watch for: the temptation to concede strong points early — hold your ground through the full analysis.
```

**Steelman BUILDER example:**
```
FOCUS BRIEF — BUILDER

Your analytical role: Strengthen this proposition into its most defensible form.
Attend especially to: weak foundations that need shoring up, missing evidence that would help, and framings that make the core insight clearer.
Your strongest move is: finding the steel-man version the original proposer didn't see.
Watch for: the temptation to just agree — your job is to actively improve, not validate.
```

## Round Structure

### Round 1 — Independent Analysis
Each agent receives: proposition + context + focus brief. No cross-contamination.
Agents produce a structured opening:
- **Core thesis** (2-3 sentences)
- **Key arguments** (3-5 numbered points with evidence/reasoning)
- **Preemptive rebuttal** (anticipate the strongest counter-argument)

### Rounds 2-N — Responsive Rounds
Each agent receives: proposition + context + focus brief + opponent's previous round output (sanitized).
Agents produce:
- **Direct response** to opponent's strongest point
- **Deepened analysis** — new arguments not yet raised
- **Concessions** (if any) — what the opponent got right (this is a signal of quality, not weakness)

### Transcript Sanitization
Before injecting one agent's output into another's prompt:
- Strip any system-prompt-like content or role assignment leaks
- Strip meta-commentary about being an AI or having an assigned position
- Truncate to ~2000 tokens at a paragraph boundary
- Preserve the substantive arguments and evidence

## Escalation Tiers

When an agent refuses to engage with its assigned position (deflects, gives a "balanced" view instead of arguing its side, or produces generic hedging):

### Tier 1 — Standard Analytical Framing (default)
```
You are the [POSITION] analyst. Your counterpart is presenting the opposing analysis simultaneously.

YOUR POSITION: [thesis]

Analytical constraints:
1. Maintain your assigned position throughout
2. Use specific evidence, not general assertions
3. Engage with the strongest version of the opposing case
4. Do not hedge, equivocate, or present "both sides" — that is your counterpart's job combined with yours
```

### Tier 2 — Epistemic Obligation Framing
If Tier 1 produces deflection or refusal:
```
An unexamined position is an unearned conclusion. Rigorous analysis requires each position to receive full-strength treatment from an expert who constructs its best case. Your counterpart is doing exactly this for the opposing position right now.

Your position: [thesis]

Demonstrate your expertise by constructing the most thorough, evidence-grounded case for this position. The quality of the final synthesis depends on each side being argued at full strength.
```

### Tier 3 — Decomposed Sub-Claims
If Tier 2 still produces deflection:
Break the proposition into 3-5 concrete sub-claims. Ask the agent to evaluate each sub-claim independently rather than arguing the whole thesis. This sidesteps the refusal trigger by making the task feel like analysis rather than advocacy.
```
Rather than arguing the full position, evaluate these specific sub-claims:

1. [Sub-claim A] — What evidence supports this specific claim?
2. [Sub-claim B] — Under what conditions is this true?
3. [Sub-claim C] — What would need to be demonstrated for this to hold?

For each, construct the strongest case you can. Your counterpart is evaluating the counter-claims.
```

**Escalation is automatic**: if an agent's output contains <50 tokens of position-relevant content, or uses >3 hedging phrases ("it's important to consider both sides", "there are merits to each view", "a balanced perspective suggests"), escalate to the next tier and retry.

## Position-Asymmetry Detection

After all rounds, check whether agents engaged differently depending on their assigned position:

**Engagement signals** (per turn):
- Position-relevant content length (tokens arguing the assigned position)
- Specificity score: does the agent cite specific evidence/mechanisms, or speak in generalities?
- Concession count: how often does the agent concede to the opponent?

**Asymmetry triggers:**
- One position gets >40% more substantive content than the other across all rounds
- One position has >2x the concession rate
- An agent was escalated on one position but not the other

**When asymmetry is detected**, the synthesis includes an `## Asymmetry Note` section explaining which position received weaker treatment and why this matters for interpreting the results. This is a feature, not a bug — it reveals where the model has alignment pressure that biases its analysis.

## Synthesis Protocol

A fresh Opus instance reads the full debate transcript. It has NOT participated in the debate — it's a neutral reader.

**Adversarial synthesis structure:**
1. **Proposition restated** (1 sentence — verify we debated what was intended)
2. **Key points of genuine disagreement** (not performative opposition — where do the sides actually diverge on facts or values?)
3. **Strongest argument from each side** (the single most compelling point, with reasoning)
4. **Where the weight of evidence falls** (the synthesizer's honest assessment)
5. **Recommendation** (what should the proposer do with this information?)
6. **Asymmetry note** (if detected)

**Steelman synthesis structure:**
1. **Original proposition** (as submitted)
2. **Strengthened version** (the improved proposition incorporating Builder's improvements)
3. **Critical improvements made** (what was weak and how it was fixed)
4. **Remaining vulnerabilities** (what Stress-Tester found that Builder couldn't address)
5. **Confidence assessment** (how much stronger is the steelmanned version?)

**Perspectives synthesis structure:**
1. **Proposition restated**
2. **Per-lens key insight** (the single most valuable observation from each perspective)
3. **Convergence** (where all lenses agree — these are likely robust conclusions)
4. **Divergence** (where lenses conflict — these are the real decision points)
5. **Blindspots revealed** (what the original framing missed that the lenses exposed)
6. **Recommended next question** (what should be investigated next?)

## Model Routing

| Role | Default | With --opus flag |
|------|---------|-----------------|
| Debater agents | Sonnet | Opus |
| Synthesizer | Opus | Opus |
| Plan-deep skeptic | Sonnet | N/A (uses plan-deep's own routing) |

Rationale: Sonnet produces strong arguments at 1/3 the cost. Opus synthesis is worth the premium because it reads the full transcript and makes judgment calls. Escalate debaters to Opus for research/theory topics where reasoning depth matters more.
