# PSSO → Agent Architecture Mapping

A living document mapping PSSO's 18 pillars to agent architecture concepts.
This isn't decoration — it's a design tool for thinking about what the system needs.

## Three-Layer Mapping

| PSSO Layer | Agent Layer | Components |
|------------|-------------|------------|
| Foundations | Identity & Guardrails | CLAUDE.md, rules, security hooks, permissions |
| Methods | Capabilities & Knowledge | Skills, KB, scout, scripts, memory |
| Domains | Project-Specific Agents | @optimizer, @researcher, per-project config |

## Pillar-by-Pillar

### Foundations

| # | PSSO Pillar | Agent Parallel | Current Implementation | Gap? |
|---|-------------|---------------|----------------------|------|
| 1 | **Regulation** | Self-governance: when to act, when to stop | Rules, deny lists, pre-tool-use guards | Could be more systematic |
| 2 | **Content Inaction** | Knowing when NOT to act | Anti-patterns in CLAUDE.md | No active evaluation layer |
| 5a | **Universal Identity** | Coherent identity across all agents/skills | Global CLAUDE.md | Agents don't deeply reference shared identity |
| 7 | **Self-Worth** | System integrity, not degrading own quality | security-baseline.json, audit scoring | Audit could track quality trends |

### Methods

| # | PSSO Pillar | Agent Parallel | Current Implementation | Gap? |
|---|-------------|---------------|----------------------|------|
| 3 | **Aspirational Positivity** | Knowledge base as aspirational target | claude-code-practices.md with adoption tracking | Working well |
| 6 | **Authenticity** | Consistent voice and behavior | playful-sincerity-voice rule | Only scoped to PS projects |
| 8 | **Emotivation** | Motivation through emotional resonance | Session tips surfacing practices | Could be more targeted |
| 10a | **Habituation** | Memory: learning patterns over time | Per-project memory files, knowledge base | No spaced repetition |
| 10b | **Normalization** | Making the unusual feel natural | Session-start tip system | Brilliant existing design |
| 10c | **Manifestation** | Turning intention into reality | /optimize generating implementable changes | Working |
| 14 | **Integrated System** | Whole > parts: composite agents | @optimizer combining audit+discover+optimize | Model for future agents |
| 15 | **Priority** | Triage intelligence across projects | /audit scoring | No cross-project prioritization |

### Domains

| # | PSSO Pillar | Agent Parallel | Current Implementation | Gap? |
|---|-------------|---------------|----------------------|------|
| 4 | **Integrated Sexuality** | Creative production energy | /visualize, /digest — output skills | Underexplored |
| 5b | **Gravity Consciousness** | Awareness of the whole system | /context-audit, architecture docs | This project helps |
| 9 | **Simulation Management** | Managing mental models vs reality | Web content safety rules | Could extend to self-model accuracy |
| 11 | **Masculine/Feminine** | Structure (M) vs flow (F) balance | Rules (structure) vs memory (flow) | Worth exploring |
| 12 | **Pleasure Baseline** | System health baseline | Audit scores, but no trend tracking | Add trend tracking |
| 13 | **Social Architecture** | How agents compose and collaborate | Currently loose coupling | Agent orchestration patterns needed |

## The Full Pinch as Agent Taxonomy

| Quadrant | Element | Agent Role | Examples |
|----------|---------|------------|----------|
| **Patterning** | Air/Mind | Research & analysis | @researcher, /gh-scout, /discover |
| **Participation** | Water/Heart | Memory & connection | Memory system, context-reinject, journal |
| **Production** | Fire/Sexuality | Creation & output | /optimize, /visualize, /digest |
| **Provisioning** | Earth/Body | Infrastructure & maintenance | Hooks, scripts, settings, /audit |

## Design Principles Derived from PSSO

1. **Regulation before capability** — Don't add skills without guardrails
2. **Identity is foundational** — All agents should share core identity from CLAUDE.md
3. **Habituation requires repetition** — Session tips, audit cycles, periodic discovery
4. **Normalization > instruction** — Make good practices feel natural, not imposed
5. **Track maturation** — Components evolve (script → skill → agent); track this in the journal
6. **Priority is a skill** — The system should know what needs attention most
7. **Integration over isolation** — Prefer composite agents over standalone tools

## Open Questions
- How to implement Content Inaction as an active evaluation layer (not just anti-patterns)?
- Should agents have a shared "identity preamble" beyond what CLAUDE.md provides?
- How to add cross-project prioritization to /audit?
- What would "spaced repetition" look like for the session-tip system?

*Update this document when new parallels emerge or when gaps get filled.*
