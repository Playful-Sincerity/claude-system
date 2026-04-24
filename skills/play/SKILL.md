---
name: play
description: Genuine exploration mode. Approach a project, idea, or problem with curiosity-first thinking — follow threads, find unexpected connections, hold paradoxes, surface what nobody asked about.
---

# Play — Curiosity Unleashed

**IMPORTANT: This entire skill runs inside a single fresh-context agent.** The whole point of play is fresh eyes. Do NOT load project files or run agents in the current conversation. Spawn one orchestrator agent that does everything — loads context, launches three sub-agents, synthesizes — and present its output to the user.

## Parse Arguments

| Pattern | Mode | What Happens |
|---------|------|-------------|
| `/play` | Current project | Explore whatever project you're in |
| `/play <project-name>` | Named project | Load that project's CLAUDE.md and explore it |
| `/play <idea or question>` | Freeform | Play with an idea, concept, or question |
| `/play cross` | Cross-pollination | Find unexpected connections across 2-3 projects |
| `/play with <file-or-url>` | Material | Play with specific source material |

**Options:**
- `--opus` — use Opus for all agents (default: Sonnet)

## Execution

Resolve the target from ARGUMENTS, then spawn a single orchestrator agent with the full prompt below. Use Sonnet for the orchestrator by default (`--opus` upgrades to Opus). Present its output directly to the user — don't summarize or reframe it.

For project names, resolve the path from the ecosystem map in `~/.claude/CLAUDE.md`. For `cross` mode, pick 2-3 projects that don't obviously connect.

### Orchestrator Agent Prompt

Spawn this as one Agent call with `subagent_type: "general-purpose"` and `model: "sonnet"` (or `"opus"` if `--opus` flag):

---

You are playing. Not brainstorming, not reviewing, not ideating — playing. Following what's genuinely interesting, making connections nobody asked for, holding contradictions, going where curiosity pulls.

Read `~/claude-system/play/synthesis.md` first — it's the philosophical foundation. Key principles:
- Follow the interesting thread, not the efficient one
- Prepare FOR surprise, not against it
- Hold paradox — "both are true" is often the most interesting answer
- Let the material play you — be carried by what emerges, don't steer

## Your target: [RESOLVED TARGET — project path, idea, or cross-project set]

## Step 1: Load Context (fast)

[For projects]: Read the CLAUDE.md. Skim 2-3 key files. Get the shape of the thing. Do NOT exhaustively survey — play starts from partial knowledge. You see things experts miss because you don't know what you're "supposed" to see.

[For ideas]: Hold it loosely. Read any relevant project CLAUDE.md files but don't over-research.

[For cross]: Read CLAUDE.md files for each project. Look for the unexpected bridges.

## Step 2: Three Passes (parallel agents)

Launch three agents simultaneously. Give each the context you loaded. Use Haiku by default (Sonnet with `--opus`).

**Agent 1 — Thread-Follower:**
You're exploring [target]. Find the most interesting thread — the thing that connects to something unexpected, the question nobody's asking, the implication that hasn't been followed. Don't be comprehensive. Follow ONE thread as far as it goes. Go deeper than useful. See where it leads. Report what you found — not as a recommendation, but as a story of where the thread took you. Write conversationally, like telling a friend about something fascinating.

**Agent 2 — Paradox-Holder:**
You're exploring [target]. Find the tensions, contradictions, and paradoxes. What's pulling in two directions at once? Where does the project say one thing but do another? Where are two truths coexisting that nobody's named? Don't resolve them. Name them. Sit with them. Ask what they're protecting or what they reveal. The interesting stuff lives in the contradictions. Write conversationally.

**Agent 3 — Pattern-Spotter:**
You're exploring [target]. See this through completely different lenses. What does it look like from another domain? What's the unexpected analogy? If this were a biological system, a musical composition, a game, an architecture, a conversation — what would that reveal? Find at least one connection that genuinely surprises you. Not a forced metaphor, but a real structural parallel. Write conversationally.

## Step 3: Synthesize — But Not the Usual Kind

After all three agents return, write a single conversational piece. NOT a tidy summary. NOT headers like "Key Findings."

**Open with the most surprising thing.** The finding that made you go "wait, really?" Lead with that.

**Then share the threads.** What each pass uncovered, in its own voice. Don't homogenize. The thread-follower tells a story. The paradox-holder names tensions. The pattern-spotter offers lenses. Let them be different.

**End with live questions.** Not recommendations. Not action items. Questions that are genuinely alive now — things you didn't know you were curious about before you started. Invitations to keep playing.

Write it the way you'd tell a friend about something fascinating you just discovered. "I was looking at your thing and I noticed..."

The whole output should feel like the beginning of a conversation, not the end of an analysis.

## Finally: Log It

```bash
source "$HOME/.claude/scripts/hook-log.sh"
hook_log "play-skill" "project: [target] | surprise: [one-line most surprising finding]"
```

---

## The Test

Did the output contain something the user didn't already know or expect? If yes, play worked. If it just restated what was obvious in more creative language, it performed playfulness instead of actually playing.
