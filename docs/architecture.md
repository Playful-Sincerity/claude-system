# Claude Code Meta-System — Three-Layer Architecture

A systematic approach to Claude Code configuration, inspired by the pattern: **identity first, capabilities second, project-specific last.**

## Layer 1: Foundations (Identity, Guardrails, Behavioral Substrate)

What the system *is* — the non-negotiable substrate everything else builds on.

| Component | Location | Purpose |
|-----------|----------|---------|
| Global CLAUDE.md | `~/.claude/CLAUDE.md` | Ecosystem map — your projects, relationships, and context. Auto-loads every conversation |
| Rules | `rules/` | Path-scoped behavioral constraints (safety, workflow, methodology) |
| Settings hooks | `~/.claude/settings.json` | Hook scripts triggered by events (session start, tool use, response) |
| Permissions | `~/.claude/settings.local.json` | Allow/deny patterns for tool use |

**What it provides:** Safety, consistency, identity. These load automatically and shape every interaction without explicit invocation.

## Layer 2: Methods (Capabilities, Patterns, Accumulated Knowledge)

How the system *operates* — learned patterns and executable capabilities.

| Component | Location | Purpose |
|-----------|----------|---------|
| Skills | `skills/` | Executable capabilities invoked via /command |
| Patterns | `knowledge/patterns/` | Reusable methodology patterns (planning, research, etc.) |
| Knowledge base | `knowledge/claude-code-practices.md` | Living best-practices reference |
| Debate protocol | `knowledge/debate-protocol.md` | Multi-agent adversarial analysis framework |
| GH Scout system | `knowledge/gh-scout/` | External pattern discovery + security vetting |
| Hook scripts | `scripts/` | Automated behaviors (tips, fallbacks, context recovery, auto-test, pre-flight) |
| Memory system | `~/.claude/projects/*/memory/` | Per-project and global memory files |

**What it provides:** Growing capability. Skills are explicitly invoked; hooks run automatically; the knowledge base accumulates over time.

## Layer 3: Domains (Project-Specific, Compositional)

What the system *works on* — context-specific agents and configurations.

| Component | Location | Purpose |
|-----------|----------|---------|
| Agents | `agents/` | Composite agents orchestrating multiple skills and tools |
| Per-project CLAUDE.md | `~/.claude/projects/*/CLAUDE.md` | Project-specific instructions |
| Per-project memory | `~/.claude/projects/*/memory/` | Project-specific knowledge |
| Experiments | `experiments/` | Ideas being tested before promotion to skills/agents |

**What it provides:** Specialization. Agents combine Layer 2 capabilities for complex orchestration. Projects get tailored behavior.

## Maturation Path

Components evolve upward through the layers:

```
experiment → script → skill → agent with knowledge base
```

A useful pattern starts as an experiment, gets extracted into a hook script, graduates to a slash-command skill, and eventually becomes part of a composite agent backed by accumulated knowledge.

## Why Three Layers?

The layering prevents common failure modes:
- **Without Layer 1:** Capabilities exist but no guardrails — unsafe or inconsistent behavior
- **Without Layer 2:** Identity exists but no tools — Claude Code is well-configured but not capable
- **Without Layer 3:** Generic capabilities but no project awareness — one-size-fits-all that fits nothing

Each layer depends on the one below it but not above it. You can run with just Layer 1 (rules + CLAUDE.md), add Layer 2 skills as needed, and introduce Layer 3 agents only when orchestration justifies the complexity.
