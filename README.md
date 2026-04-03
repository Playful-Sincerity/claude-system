# Claude Code Meta-System

A complete, working configuration system for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — treating your AI assistant setup as a first-class software project with version control, modular capabilities, and accumulated knowledge.

**What's inside:** 18 behavioral rules, 12 slash-command skills, 2 composite agents, 7 hook scripts, and a curated knowledge base of Claude Code best practices — all tested and refined through daily use across 20+ projects.

## Quick Start

```bash
# Clone the repo
git clone https://github.com/Playful-Sincerity/claude-system.git ~/claude-system

# Run setup (creates symlinks from ~/.claude/ → ~/claude-system/)
cd ~/claude-system
./setup.sh

# Copy example configs
cp examples/settings.json.example ~/.claude/settings.json
cp examples/global-CLAUDE.md.example ~/.claude/CLAUDE.md

# Start Claude Code — your new system is active
claude
```

## What You Get

### Rules (18 behavioral constraints)

Rules load automatically based on file path patterns. They shape how Claude thinks and acts without explicit invocation.

| Rule | What It Does |
|------|-------------|
| **bash-safety** | Scans commands for injection, exfiltration, obfuscation before execution |
| **web-content-safety** | Detects prompt injection in fetched web content |
| **context-management** | Guides subagent delegation, MCP awareness, compaction timing |
| **model-selection** | Routes Opus for planning, Sonnet for implementation, Haiku for lookups |
| **development-workflow** | Four-phase cycle: Explore → Plan → Implement → Commit |
| **semantic-logging** | Continuous chronicle of decisions, discoveries, and evolution |
| **rule-enforcement** | Meta-rule: how to make behavioral rules actually stick |
| **folder-structure** | Principles for organizing project directories |
| **multi-session-decomposition** | Breaking complex work into parallel session briefs |
| **suggest-debate** | Proactively suggests /debate at decision forks |
| **suggest-automation** | Suggests /loop, /schedule, cron when useful |
| **save-research-agent-outputs** | Archives research findings with cross-references |
| **meta-research-process** | When to use books, papers, or web for deeper research |
| **gvr-verification** | Generator-Verifier-Reviser pattern for rigorous research |
| **spec-driven** | When to write specs before multi-session implementations |
| **project-hygiene** | Secrets, documentation, and consistency standards |
| **memory-safety** | Frontmatter conventions for memory files |
| **n8n-build-method** | Incremental build-and-test for n8n workflows |

### Skills (12 slash-commands)

Skills are invoked explicitly via `/command`. Each is a self-contained markdown protocol.

| Skill | What It Does |
|-------|-------------|
| **/plan-deep** | Recursive hierarchical planning — decomposes complex tasks through multiple levels, reconciles conflicts, adapts during execution |
| **/debate** | Multi-agent adversarial analysis — spawns parallel Claude agents with assigned positions to stress-test ideas |
| **/gh-scout** | GitHub discovery + security vetting — finds repos, extracts patterns, catalogs with trust tiers |
| **/research-papers** | Academic paper search across 20+ databases, citation graph traversal, knowledge extraction |
| **/research-books** | Find and read books from open sources (Gutenberg, Open Library, Internet Archive) |
| **/visualize** | Create 2D diagrams (D2, Mermaid, Markmap) grounded in visual thinking principles |
| **/digest** | Process large data exports (ChatGPT, Claude, Drive) into organized knowledge archives |
| **/carryover** | Generate prescriptive session recovery document before context compaction |
| **/migrate** | Create a context migration prompt to jumpstart a new conversation |
| **/context-audit** | Measure what loads on startup, identify context bloat, recommend optimizations |
| **/session-log** | Archive what happened in a conversation to the project's sessions/ directory |
| **/session-id** | Find current session ID or search past sessions by title |

### Agents (2 composite orchestrators)

Agents combine multiple tools and skills for complex, multi-step operations.

| Agent | What It Does |
|-------|-------------|
| **@optimizer** | Audits your entire Claude Code setup — projects, config, rules, knowledge — and generates prioritized improvement recommendations |
| **@researcher** | Dual-mode: (1) Claude Code best practices discovery and KB maintenance, (2) Research partner with domain awareness, computational verification, and GVR loop |

### Hook Scripts (7 automated behaviors)

Scripts that run automatically on Claude Code events (session start, after responses, etc.).

| Script | Hook Event | What It Does |
|--------|-----------|-------------|
| **pre-flight.sh** | SessionStart | Checks for uncommitted changes, missing .gitignore, missing CLAUDE.md |
| **session-tip.sh** | SessionStart | Surfaces one unadopted best practice from the knowledge base |
| **context-reinject.sh** | SessionStart + Notification | Recovers context after compaction by reinjecting carryover documents |
| **auto-test.sh** | Stop | Detects and runs project tests after code changes |
| **chronicle-nudge.sh** | Stop | Reminds you to log to the semantic chronicle if it's been a while |
| **validate-plan.sh** | PostToolUse | Validates plan.md structure after writes |
| **gemini-fallback.sh** | PostToolUse | Falls back to Gemini CLI if web search/fetch is blocked |

### Knowledge Base

A curated, living reference library:

| File | What It Contains |
|------|-----------------|
| **claude-code-practices.md** | 1000+ lines of Claude Code best practices with implementation tracking |
| **debate-protocol.md** | Multi-agent adversarial analysis methodology |
| **testing-practices.md** | Testing patterns for Claude Code projects |
| **research-paper-writing-guide.md** | Academic paper writing guide |
| **gh-scout/** | GitHub repo vetting schema, security checklists, pattern catalog |
| **visualize/** | D2, Mermaid, and Markmap reference guides |
| **patterns/** | Reusable methodology patterns (recursive planning, etc.) |

## Architecture

The system uses a **three-layer architecture**:

```
Layer 1: Foundations    — Rules, CLAUDE.md, hooks, permissions
Layer 2: Methods        — Skills, knowledge base, scripts, memory
Layer 3: Domains        — Agents, per-project config, experiments
```

Each layer builds on the one below. You can start with just rules (Layer 1) and add capabilities incrementally. See [docs/architecture.md](docs/architecture.md) for details.

### How It Deploys

The key insight: **one git-tracked directory, symlinked to where Claude Code expects things.**

```
~/.claude/skills     → ~/claude-system/skills/
~/.claude/agents     → ~/claude-system/agents/
~/.claude/rules      → ~/claude-system/rules/
~/.claude/knowledge  → ~/claude-system/knowledge/
~/.claude/scripts    → ~/claude-system/scripts/
```

Edit files here, they take effect immediately. Full git history for every change. See [ADR 001](docs/decisions/001-symlink-strategy.md) for why this approach was chosen.

## Customizing

### Start Small
You don't need everything. A reasonable starting point:

1. **Rules only:** Copy just the `rules/` you want (bash-safety, web-content-safety, model-selection are high-value, low-effort)
2. **Add hooks:** Wire up pre-flight.sh and auto-test.sh in your settings.json
3. **Add skills:** Start with /plan-deep and /debate — they're the most impactful
4. **Grow the knowledge base:** The practices file accumulates over time

### Adding Your Own

**New rule:** Create `rules/my-rule.md` with optional YAML frontmatter for path scoping:
```yaml
---
paths:
  - "**/*.py"
---
# My Rule
Content here...
```

**New skill:** Create `skills/my-skill/SKILL.md` following the [template](templates/SKILL-TEMPLATE.md).

**New agent:** Create `agents/my-agent.md` following the [template](templates/AGENT-TEMPLATE.md).

### What's NOT Here (intentionally)

- **Personal memory files** — Your memory accumulates through use. The template structure is provided.
- **Project-specific CLAUDE.md files** — These belong in each project, not here.
- **MCP server configs** — Too environment-specific. Configure via `claude mcp add`.
- **settings.json** — Claude Code writes to this directly. An example is provided.
- **Chronicle entries** — These are your project's story. The system creates them as you work.

## Templates

Starter templates for creating new components:

| Template | For |
|----------|-----|
| [SKILL-TEMPLATE.md](templates/SKILL-TEMPLATE.md) | New slash-command skills |
| [AGENT-TEMPLATE.md](templates/AGENT-TEMPLATE.md) | New composite agents |
| [RULE-TEMPLATE.md](templates/RULE-TEMPLATE.md) | New behavioral rules |
| [MEMORY-TEMPLATE.md](templates/MEMORY-TEMPLATE.md) | New memory files |

## Origin

This system was extracted from a private Claude Code setup used daily across 20+ projects spanning software, research, events, and business operations. The methodology, knowledge, and patterns are real — tested through months of intensive use. Personal references have been removed; the engine remains.

The three-layer architecture was inspired by a personal development framework (Foundations → Methods → Domains) that maps naturally to how AI assistant configuration should be structured.

## License

MIT
