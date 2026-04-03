# Scout Radar — Curated Assessment

Last updated: 2026-03-28 (comprehensive scout: Claude Code architectures, skills, hooks, memory, Agent SDK, MCP)

---

## Adopt
_Items where it would be irresponsible NOT to use them, given your setup._

### Official Anthropic (T1)
- **anthropics/skills** ([repo](https://github.com/anthropics/skills)) — 103k stars. Official skill library: `mcp-builder`, `skill-creator`, `webapp-testing`, `pdf`, `docx`, `xlsx`, and 11 more. Install via `/plugin marketplace add anthropics/skills`. These are the reference implementations for how skills should be built.

- **anthropics/claude-plugins-official** ([repo](https://github.com/anthropics/claude-plugins-official)) — 14.6k stars. 32 official plugins including: `hookify` (auto-generate behavioral rules from conversation frustration), `feature-dev` (7-phase guided development with parallel subagents), `code-review` (9-step with Haiku/Sonnet/Opus tiering), `security-guidance` (PreToolUse hook monitoring 9 injection patterns), `ralph-wiggum` (autonomous iteration loop via Stop hook), 16 LSP servers (pyright, typescript, rust-analyzer, etc.), and `plugin-dev` (7 expert skills for building plugins).

- **anthropics/claude-code** ([repo](https://github.com/anthropics/claude-code)) — 82.5k stars. The CLI itself. The `.claude/commands/` directory shows how Anthropic uses Claude Code on its own codebase: `commit.md`, `triage-issue.md` (production-grade GitHub issue triage automation).

- **anthropics/anthropic-cookbook** ([repo](https://github.com/anthropics/anthropic-cookbook)) — 36.1k stars. Agent pattern reference: prompt chaining, routing, orchestrator-subagents, evaluator-optimizer. The evaluator-optimizer pattern (cheap model evaluates, expensive model only when needed) is directly applicable.

- **anthropics/claude-agent-sdk-python** ([repo](https://github.com/anthropics/claude-agent-sdk-python)) — 5.9k stars. Official Python Agent SDK (renamed from claude-code-sdk). In-process MCP servers via `@tool` decorator eliminate IPC attack surface. `allowed_tools`/`disallowed_tools`/permission callback for least-privilege.

- **anthropics/claude-agent-sdk-typescript** ([repo](https://github.com/anthropics/claude-agent-sdk-typescript)) — 1.1k stars. Official TypeScript Agent SDK. Query/stream/full-client modes.

### MCP Servers (T1)
- **modelcontextprotocol/servers** ([repo](https://github.com/modelcontextprotocol/servers)) — 82.4k stars. 7 reference MCP implementations: Filesystem (access controls), Git, Fetch, Memory (knowledge graph), Sequential Thinking, Time, Everything (test). Educational examples.

- **github/github-mcp-server** ([repo](https://github.com/github/github-mcp-server)) — 28.3k stars. Official GitHub MCP: PR/issue automation, CI/CD intelligence, Dependabot scanning. **Toolset filtering** is a model security pattern — restricts which capabilities Claude can invoke.

### Security & Quality Gates
- **trailofbits/claude-code-config** ([repo](https://github.com/trailofbits/claude-code-config)) — 1.7k stars. Security-hardened config from professional security firm. Key insight: "Hooks fire deterministically, CLAUDE.md rules can be forgotten under context pressure." Includes rm-rf blocking hook, credential deny rules, anti-rationalization Stop hook (Haiku evaluates if work is actually done), `enableAllProjectMcpServers: false`.

- **agent-sh/agnix** ([repo](https://github.com/agent-sh/agnix)) — 114 stars. Linter with 385 rules for CLAUDE.md, SKILL.md, AGENTS.md, hooks, MCP configs. Vercel research: skills invoke at 0% with incorrect syntax. Run `npx agnix .` against your claude config to validate all skills.

### Diagram Tools
- **D2** ([repo](https://github.com/terrastruct/d2)) — Single Go binary, no Chromium, pure CLI, outputs SVG/PNG/PDF. Ideal render backend for diagram skills.

## Trial
_Real production evidence exists. We or trusted sources have used successfully._

### Hook Systems
- **disler/claude-code-hooks-mastery** ([repo](https://github.com/disler/claude-code-hooks-mastery)) — 3.4k stars. Comprehensive reference for all 13+ lifecycle hooks. Standout: UV single-file scripts give each hook its own dependency environment. Builder/Validator agent architecture where hooks enforce role boundaries Claude can't reason around.

- **karanb192/claude-code-hooks** ([repo](https://github.com/karanb192/claude-code-hooks)) — 306 stars, MIT, 262 tests. Three-tier safety levels (critical/high/strict). Auto-git-stage PostToolUse hook. Modular, copy-paste ready.

- **OthmanAdi/planning-with-files** ([repo](https://github.com/OthmanAdi/planning-with-files)) — 17.5k stars, MIT. PreToolUse hook re-reads task_plan.md before every Write/Edit/Bash. Prevents goal drift in long sessions. v2.26.1 patched content injection vuln — use current version.

### Memory
- **marciopuga/cog** ([repo](https://github.com/marciopuga/cog)) — 272 stars, MIT. Three-tier Hot/Warm/Glacier memory with L0/L1/L2 tiered loading. Self-auditing skills (/reflect, /evolve, /housekeeping). Pure markdown. **Directly applicable to existing memory system.**

### Skills
- **alirezarezvani/claude-code-skill-factory** ([repo](https://github.com/alirezarezvani/claude-code-skill-factory)) — 641 stars, MIT. Five interactive factories producing validated SKILL.md files. 7-point quality scoring. CLAUDE.md → AGENTS.md translation bridge.

### Agent Patterns
- **wshobson/agents** ([repo](https://github.com/wshobson/agents)) — 31.4k stars. 84 agents, 15 orchestrators, plugin isolation pattern. Five workflow modes. Most important practical reference for Claude Code native architecture.

- **nibzard/awesome-agentic-patterns** ([repo](https://github.com/nibzard/awesome-agentic-patterns)) — 97 patterns in 8 categories. Best theoretical reference for agent design.

- **carlrannaberg/claudekit** ([repo](https://github.com/carlrannaberg/claudekit)) — `/spec:create`→`/spec:execute`, 6-aspect parallel code review, `/research` with parallel subagents.

### Academic Research
- **openags/paper-search-mcp** ([repo](https://github.com/openags/paper-search-mcp)) — 921 stars, MIT. Multi-source academic paper search across 20+ databases (arXiv, PubMed, Semantic Scholar, OpenAlex, CrossRef, etc.) with PDF download and text extraction.

- **zongmin-yu/semantic-scholar-fastmcp** ([repo](https://github.com/zongmin-yu/semantic-scholar-fastmcp-mcp-server)) — 111 stars, MIT. 16 read-only Semantic Scholar tools: paper search, citation graphs, author lookup, recommendations. Pure API proxy, no side effects.

### MCP
- **modelcontextprotocol/registry** ([repo](https://github.com/modelcontextprotocol/registry)) — 6.6k stars. Canonical MCP discovery service. Namespace ownership verified via GitHub OAuth or DNS. More trustworthy than awesome-lists.

- **zilliztech/claude-context** ([repo](https://github.com/zilliztech/claude-context)) — 5.8k stars, MIT. Semantic code search MCP with ~40% token reduction. Requires external embedding provider — review data residency.

### Ecosystem Discovery
- **hesreallyhim/awesome-claude-code** ([repo](https://github.com/hesreallyhim/awesome-claude-code)) — 33.7k stars. Primary ecosystem directory with machine-readable CSV. Use as discovery surface for future /gh-scout runs. TTL: 14 days.

### Security
- **trailofbits/claude-code-devcontainer** ([repo](https://github.com/trailofbits/claude-code-devcontainer)) — 579 stars, Apache-2.0. Safe bypassPermissions inside devcontainer. Last commit Jan 2025 — verify compatibility.

### Diagram Tools
- **Mermaid CLI** ([repo](https://github.com/mermaid-js/mermaid-cli)) — Most widely documented LLM-to-diagram pipeline. Puppeteer/Chromium dependency.
- **Markmap** ([repo](https://github.com/markmap/markmap)) — Interactive mind maps from Markdown.
- **claude-mermaid MCP** ([repo](https://github.com/veelenga/claude-mermaid)) — MCP server with live-reload. Last commit Dec 2024 — watch for staleness.

### SDK
- **anthropics/claude-agent-sdk-demos** ([repo](https://github.com/anthropics/claude-agent-sdk-demos)) — 8 demos including research-agent (parallel subagent synthesis) and autonomous-coding (git checkpointing).

## Assess
_Worth investigating to understand impact. No production requirement._

### Hook & Rule Patterns
- **disler/claude-code-hooks-multi-agent-observability** ([repo](https://github.com/disler/claude-code-hooks-multi-agent-observability)) — 1.3k stars. Full-stack is complex but the log-to-JSONL subset is zero-cost session replay.

- **johnlindquist/claude-hooks** ([repo](https://github.com/johnlindquist/claude-hooks)) — 339 stars, MIT. TypeScript hook scaffolding with IntelliSense. Requires Bun.

- **ChristopherKahler/carl** ([repo](https://github.com/ChristopherKahler/carl)) — 255 stars, MIT. **Just-in-time rule injection** via UserPromptSubmit hook. Scans prompts for keywords, injects only matching rule domains. Directly solves CLAUDE.md bloat.

- **aviadr1/claude-meta** ([repo](https://github.com/aviadr1/claude-meta)) — MIT. Self-improving CLAUDE.md via meta-rules. Two-tier: NEVER/ALWAYS summary + detailed rationale. One-sentence trigger: Reflect → Abstract → Generalize → Document.

- **diet103/claude-code-infrastructure-showcase** — 6 months production config. UserPromptSubmit hook for deterministic skill activation. Dev-Docs pattern (plan/context/tasks per task).

### Memory Architectures
- **thedotmack/claude-mem** ([repo](https://github.com/thedotmack/claude-mem)) — 42k stars. AI-compressed memory in SQLite + Chroma vectors. Progressive disclosure (~10x token savings). **AGPL license — commercial use requires legal review.**

- **GMaN1911/claude-cognitive** ([repo](https://github.com/GMaN1911/claude-cognitive)) — 445 stars, MIT. Decay-based attention routing: files decay 0.85x per turn when not referenced. Co-activation boosts. 64-95% token savings reported.

- **obra/episodic-memory** ([repo](https://github.com/obra/episodic-memory)) — 323 stars, MIT. MCP server making Claude's own JSONL conversation history searchable with local vector embeddings (fully offline).

- **agiresearch/A-mem** ([repo](https://github.com/agiresearch/A-mem)) — NeurIPS 2025. Zettelkasten-inspired memory with construct/link/evolve. MCP server available.

### Meta-Systems & Architecture
- **SuperClaude-Org/SuperClaude_Framework** ([repo](https://github.com/SuperClaude-Org/SuperClaude_Framework)) — 22k stars, MIT. 20 cognitive personas as context-injection .md files. Patterns extractable; do not run install script.

- **affaan-m/everything-claude-code** ([repo](https://github.com/affaan-m/everything-claude-code)) — 108k stars (star anomaly, March 2025 last commit). Instincts-to-skills promotion pattern is novel. **Concepts only.**

- **agent-sh/agentsys** ([repo](https://github.com/agent-sh/agentsys)) — 666 stars, MIT. Phase-gated pipeline: agents cannot skip steps. Includes agnix linting + secret detection.

- **Dicklesworthstone/claude_code_agent_farm** ([repo](https://github.com/Dicklesworthstone/claude_code_agent_farm)) — 760 stars, MIT. Filesystem-as-coordination-bus: agents coordinate via JSON files (registry, locks, queue). Uses --dangerously-skip-permissions.

- **steipete/claude-code-mcp** ([repo](https://github.com/steipete/claude-code-mcp)) — 1.2k stars, MIT. Meta-agentic pattern: wraps Claude Code as MCP server for outer agent delegation.

### Agent & Skill Patterns
- **VoltAgent/awesome-claude-code-subagents** ([repo](https://github.com/VoltAgent/awesome-claude-code-subagents)) — 8.5k stars. 100+ subagent definitions with tool-scoping.
- **ChrisWiles/claude-code-showcase** ([repo](https://github.com/ChrisWiles/claude-code-showcase)) — 5.6k stars. Complete .claude/ directory reference with scheduled GitHub Actions.
- **travisvn/awesome-claude-skills** ([repo](https://github.com/travisvn/awesome-claude-skills)) — 7.5k stars. Curated skills with quality gates.
- **davila7/claude-code-templates** ([repo](https://github.com/davila7/claude-code-templates)) — 22.7k stars. Skills manager with monitoring dashboard.
- **lifedever/claude-rules** ([repo](https://github.com/lifedever/claude-rules)) — 145 stars, MIT. CLI that auto-detects tech stack and generates corresponding rule files.

### Diagram Tools
- **Kroki** ([repo](https://github.com/yuzutech/kroki)) — Self-hosted API for 20+ diagram formats.
- **Nomnoml** ([repo](https://github.com/skanaar/nomnoml)) — Pure Node.js, no Chromium, lightweight UML.
- **Excalidraw Diagram Skill** ([repo](https://github.com/coleam00/excalidraw-diagram-skill)) — Hand-drawn aesthetic diagrams.
- **design-doc-mermaid** ([repo](https://github.com/SpillwaveSolutions/design-doc-mermaid)) — On-demand guide loading (~80% token savings).
- **Diagrams (Python)** ([repo](https://github.com/mingrammer/diagrams)) — 40K stars. Cloud infra diagrams with rich icon sets.

## Hold
_Do not start new work with these. May be outdated, superseded, or risky._

- **ruvnet/ruflo** ([repo](https://github.com/ruvnet/ruflo)) — 28k stars, MIT. `claude-flow init` auto-generates settings.local.json granting broad MCP permissions without consent. Maintainers refused to document (Issue #395, closed "not planned"). Performance claims (352x speedup) lack benchmarks. **Security flag.**
- **Penrose** ([repo](https://github.com/penrose/penrose)) — Three-file DSL too complex for reliable LLM generation.
- **arscontexta** ([repo](https://github.com/agenticnotetaking/arscontexta)) — Broken core features, 72K context cost. Use extracted patterns instead.
