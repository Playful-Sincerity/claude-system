# Architecture — Three-Layer Model

Inspired by PSSO's Foundations/Methods/Domains structure.
See `psso-mapping.md` for the full pillar-by-pillar parallel.

## Layer 1: Foundations (Identity, Guardrails, Behavioral Substrate)

What the system *is* — the non-negotiable substrate everything else builds on.

| Component | Location | Purpose |
|-----------|----------|---------|
| Global CLAUDE.md | `~/.claude/CLAUDE.md` | Identity, workflow defaults, anti-patterns |
| Rules | `rules/` (13 files) | Path-scoped behavioral constraints |
| Settings hooks | `~/.claude/settings.json` | Security enforcement (block secret writes), quality (auto-format) |
| Permissions | `~/.claude/settings.local.json` | Deny destructive operations, allow safe ones |
| Security baseline | `~/.claude/security-baseline.json` | SHA256 integrity tracking for instruction files |

**PSSO parallel:** Universal Identity (who you are), Regulation (self-governance), Content Inaction (when NOT to act), Self-Worth (integrity of the system itself).

## Layer 2: Methods (Capabilities, Patterns, Accumulated Knowledge)

How the system *operates* — learned patterns and executable capabilities.

| Component | Location | Purpose |
|-----------|----------|---------|
| Skills | `skills/` (12 skills) | Executable capabilities invoked via /command |
| Patterns | `knowledge/patterns/` | Internally-developed reusable patterns |
| Knowledge base | `knowledge/claude-code-practices.md` | Living best-practices reference |
| GH Scout system | `knowledge/gh-scout/` | External pattern discovery + security vetting |
| Hook scripts | `scripts/` (5 scripts) | Automated behaviors (tips, fallbacks, context reinject, auto-test, pre-flight) |
| Memory system | `~/.claude/projects/*/memory/` | Per-project and global memory files |

**PSSO parallel:** Habituation (memory/patterns), Normalization (session-tip making practices natural), Aspirational Positivity (knowledge base as aspirational target), Authenticity (consistent voice rules).

## Layer 3: Domains (Project-Specific, Compositional)

What the system *works on* — context-specific agents and configurations.

| Component | Location | Purpose |
|-----------|----------|---------|
| Agents | `agents/` (2 agents) | Composite agents orchestrating multiple skills |
| Per-project CLAUDE.md | `~/.claude/projects/*/CLAUDE.md` | Project-specific instructions |
| Per-project memory | `~/.claude/projects/*/memory/` | Project-specific knowledge |
| Experiments | `experiments/` | Ideas being tested before promotion to skills/agents |

**PSSO parallel:** Integrated System (agents combining capabilities), Priority (triage across projects), Social Architecture (how agents compose and collaborate).

## Maturation Path

Components evolve upward through the layers:

```
experiment → script → skill → agent with knowledge base
```

Example: The optimizer started as a conversation idea, became three separate skills (/audit, /discover, /optimize), then unified into the @optimizer agent with a shared knowledge base, then grew the GH Scout subsystem for external intelligence.

Track this evolution in `journal/timeline.md`.
