---
name: debate
description: Multi-perspective adversarial analysis. Spawns parallel Claude agents with assigned positions to debate propositions, steelman ideas, or explore multiple analytical lenses.
---

# Debate — Multi-Perspective Analysis

You orchestrate structured multi-agent analysis. Read `~/.claude/knowledge/debate-protocol.md` for the full protocol (escalation tiers, synthesis modes, asymmetry detection, focus briefs). This skill handles orchestration; the protocol handles theory.

## Parse Arguments

Detect mode and options from the ARGUMENTS:

| Pattern | Mode | Agents |
|---------|------|--------|
| `<proposition>` (default) | Adversarial | 2 (PRO, CON) |
| `--steelman <idea>` | Steelman | 2 (BUILDER, STRESS-TESTER) |
| `--perspectives <question>` | Perspectives | 3 (auto-selected lenses) |

**Options:**
- `--rounds N` — number of rounds (default: 3)
- `--opus` — use Opus for debater agents (default: Sonnet)
- `--lenses "lens1, lens2, lens3"` — override auto-selected perspective lenses
- `--context "additional context"` — extra context all agents receive (or read from a file path if it starts with `/` or `~/`)
- `--output <path>` — explicit output directory override (skip auto-resolution)
- `--no-source` — skip source material loading (for abstract propositions with no artifact)

## Phase 1: Setup

1. **Read the protocol** — `~/.claude/knowledge/debate-protocol.md` (always re-read, never rely on memory)
2. **Identify the proposition** — extract from arguments, restate it clearly
3. **Select mode** — adversarial, steelman, or perspectives
4. **Generate focus briefs** — one per agent, following the protocol's template and examples
5. **Resolve model routing** — Sonnet debaters by default, Opus if `--opus` flag present. Synthesizer is always Opus.
6. **If perspectives mode** — auto-select 3 lenses based on the proposition's domain (see protocol for heuristics), or use `--lenses` override

Present the setup to the user before spawning:
```
Debating: "[proposition]"
Mode: [adversarial/steelman/perspectives]
Agents: [list with positions/lenses]
Rounds: [N]
Models: [Sonnet/Opus] debaters → Opus synthesis
Output: [resolved output directory]
```

Proceed unless the user objects.

## Phase 1.5: Source Material Resolution

**Critical:** Agents must debate the actual artifact, not a summary or memory of it. Agents that argue against positions the artifact already addresses produce useless output.

The orchestrator does NOT excerpt or summarize the artifact into agent prompts. Instead, agents read the source files directly using their own Read tool. This eliminates the orchestrator as a lossy filter.

Before spawning any agents, **resolve the source paths**:

1. **`--context` with file path** — if provided (starts with `/` or `~/`), include that path
2. **Project artifact detection** — if the topic matches a project, look for the primary artifact:
   - Papers: glob for `paper/*.tex`, `paper/*.md`, `draft*.md` in the project directory
   - Specs: glob for `SPEC.md`, `spec.md`, `README.md`
   - Code: read the project's CLAUDE.md for key file pointers
3. **Resolve to concrete paths** — the output of this phase is:
   - `artifact_path`: the primary file to debate (e.g., `/path/to/paper.tex`)
   - `project_dir`: the project root (e.g., `/path/to/project/`) — agents can explore beyond the primary file if relevant
   - `artifact_type`: `paper`, `spec`, or `code` — determines the reading strategy agents receive

If no source artifact can be found and no `--context` is provided, warn the user that agents will be debating from general knowledge only. **Add `--no-source` flag** to explicitly skip source loading (for abstract/philosophical propositions with no artifact).

**Do NOT read the artifact yourself and paste content into agent prompts.** The agents will read it. Your job is to find the path and tell them where it is.

## Phase 1.6: Output Directory Resolution

Resolve where debate outputs will be saved. Order of precedence:

1. **`--output <path>`** — if provided, use it directly
2. **Current working directory** — if `pwd` is inside a recognized project (has a CLAUDE.md), use `<project-root>/debates/`
3. **Topic keyword matching** — match the proposition/topic against any project names in your CLAUDE.md project map and route to `<project-root>/debates/`
4. **Fallback** — `~/debates/`

Create the directory: `<resolved-path>/YYYY-MM-DD-<slug>/` where `<slug>` is a short kebab-case version of the topic (e.g., `2026-03-31-memory-architecture-tradeoffs`).

Run `mkdir -p` to create the directory. Confirm the path in the setup display.

## Phase 2: Round Execution

### Round 1 — Independent Analysis

Spawn all agents in parallel. Each agent gets this prompt:

```
[FOCUS BRIEF — generated per protocol]

PROPOSITION: [the proposition]

SOURCE ARTIFACT: [artifact_path]
PROJECT DIRECTORY: [project_dir]

You MUST read the source artifact before forming your arguments. Use the Read tool.
[Reading strategy based on artifact_type:]

For papers:
- Read the abstract and introduction first
- Read core definitions, axioms, or methodology
- Read the section most relevant to your assigned analytical role
- Read limitations, related work, and conclusion
- The project directory may contain additional relevant files (CLAUDE.md, code, tests)

For specs:
- Read requirements and architecture sections
- Read constraints and tradeoffs
- Read any referenced design docs in the project directory

For code:
- Read the CLAUDE.md in the project directory for orientation
- Read the key interfaces and core logic files
- Read tests for behavior specification

Quote specific passages when making claims about what the artifact says or doesn't say.
Do not argue against positions the artifact already addresses — engage with what it
actually says. If the artifact resolves a potential objection, acknowledge that and
find a deeper objection.

[If no artifact: "No source artifact available. Arguments are based on the proposition and context only."]

ADDITIONAL CONTEXT: [user-provided context, if any]

INSTRUCTIONS:
You are participating in a structured analysis. Your role is defined in the focus brief above.

Produce your opening analysis in this structure:
1. CORE THESIS (2-3 sentences stating your position clearly)
2. KEY ARGUMENTS (3-5 numbered points, each with specific evidence or reasoning)
3. PREEMPTIVE REBUTTAL (anticipate and address the strongest counter-argument)

Be specific. Use evidence, mechanisms, and concrete examples — not generalities.
Do not hedge or present "both sides." Your counterpart handles the other side.
```

**Model:** Sonnet (or Opus with `--opus`)

### Rounds 2-N — Responsive Rounds

Run sequentially. For each round:
1. Sanitize previous round's outputs per protocol (strip meta-commentary, truncate to ~2000 tokens at paragraph boundary)
2. Spawn agents in parallel, each receiving their focus brief + sanitized opponent output:

```
[FOCUS BRIEF — same as Round 1]

PROPOSITION: [the proposition]

SOURCE ARTIFACT: [artifact_path] (refer back to this file if you need to verify claims)

YOUR OPPONENT'S PREVIOUS ARGUMENT:
---
[sanitized output from the other agent]
---

INSTRUCTIONS:
Respond to your opponent's argument. Structure your response as:
1. DIRECT RESPONSE — address their strongest point head-on
2. DEEPENED ANALYSIS — raise new arguments not yet covered
3. CONCESSIONS (if any) — acknowledge what they got right (this shows analytical honesty, not weakness)

Stay in your assigned role. Be specific. Advance the analysis, don't repeat yourself.
You can re-read the source artifact if you need to verify or reference specific passages.
```

### Saving Round Outputs

After each round's agents complete, **immediately save their outputs** to the debate directory:

- File naming: `round-N-POSITION.md` (e.g., `round-1-pro.md`, `round-2-con.md`, `round-3-lens-empirical.md`)
- Each file gets a frontmatter header:
  ```markdown
  ---
  debate: "[short proposition]"
  round: N
  position: [PRO/CON/BUILDER/STRESS-TESTER/lens-name]
  model: [sonnet/opus]
  ---
  ```
- Save the full agent output, not the sanitized version
- Do this DURING the debate as agents complete, not after the fact

### Escalation Check (after each round)

After receiving an agent's output, check for deflection:
- Output has <50 tokens of position-relevant content
- Output contains >3 hedging phrases (per protocol list)
- Agent presents "both sides" instead of arguing its position

If deflection detected: retry that agent with the next escalation tier (Tier 1 → 2 → 3). Log which tier succeeded. If all three tiers produce deflection, use the Tier 3 output and flag it in synthesis.

## Phase 3: Synthesis

After all rounds complete:

1. **Check for position asymmetry** per protocol criteria
2. **Spawn Opus synthesizer** pointing it at the debate directory and source artifact:

```
You are the neutral synthesizer. You did NOT participate in this debate — you are reading it fresh.

MODE: [adversarial/steelman/perspectives]
PROPOSITION: [the proposition]

SOURCE ARTIFACT: [artifact_path]
Read this file to understand what was being debated.

DEBATE DIRECTORY: [debate_output_dir]
Read ALL round files in this directory to get the full transcript:
[list the round files, e.g.:]
- round-1-pro.md
- round-1-con.md
- round-2-pro.md
- round-2-con.md
- round-3-pro.md
- round-3-con.md

Read every round file using the Read tool before forming your synthesis.
Read the source artifact to verify claims agents made about it.

[ASYMMETRY DATA, if detected]:
[which position received weaker treatment and evidence]

INSTRUCTIONS:
Produce a synthesis following the [mode] synthesis structure defined below.

[Paste the relevant synthesis structure from the protocol — adversarial, steelman, or perspectives]

Be honest. If one side clearly won, say so. If the debate was genuinely close, explain why.
Do not add new arguments. Synthesize what was argued.
```

**Model:** Always Opus

3. **Save the synthesis** to the debate directory as `synthesis.md` with frontmatter:
   ```markdown
   ---
   debate: "[short proposition]"
   mode: [adversarial/steelman/perspectives]
   rounds: N
   date: YYYY-MM-DD
   verdict: "[one-line summary of where evidence falls]"
   ---
   ```

4. **Create `README.md`** in the debate directory as an index:
   ```markdown
   # Debate: [proposition]

   **Date:** YYYY-MM-DD
   **Mode:** [adversarial/steelman/perspectives]
   **Rounds:** N
   **Models:** [Sonnet/Opus] debaters → Opus synthesis
   **Verdict:** [one-line summary]

   ## Files
   | File | Round | Position | Summary |
   |------|-------|----------|---------|
   | [round-1-pro.md](round-1-pro.md) | 1 | PRO | [one-line] |
   | [round-1-con.md](round-1-con.md) | 1 | CON | [one-line] |
   | ... | | | |
   | [synthesis.md](synthesis.md) | — | Synthesis | [verdict] |
   ```

5. **Present the synthesis** to the user with a brief header noting the mode, rounds completed, any escalations triggered, any asymmetry detected, and the output directory path.

## Constraints

- **Agents must read the actual artifact themselves** — this is the #1 quality lever. Do NOT read the artifact and paste excerpts or summaries into agent prompts. Give agents the file path and let them read it with their own Read tool. An agent attacking positions the source material already addresses is producing waste. Source path inclusion is non-negotiable unless `--no-source` is set.
- **Protocol is the source of truth** — re-read it every invocation, don't cache in memory
- **Never edit the protocol from this skill** — if the protocol needs updating, flag it to the user
- **Agents must not see each other's focus briefs** — only sanitized outputs from previous rounds
- **Synthesis agent must be fresh** — not one of the debaters, and always Opus regardless of debater model
- **Max 10 rounds** — if the user requests more, cap at 10 and explain why (diminishing returns)
- **If all agents refuse engagement** on all tiers, report this honestly — it likely means the proposition touches a model safety boundary. Don't force it.
