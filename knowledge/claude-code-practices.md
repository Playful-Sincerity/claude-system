# Claude Code Best Practices Knowledge Base
**Last updated**: 2026-04-02
**Maintained by**: Researcher Agent

---

## 1. Prompting Patterns

### The Prompt Contract Framework
Structure prompts as explicit contracts rather than vague requests:
- **Role**: What you want Claude to do
- **Success Criteria**: Specific, verifiable outcomes
- **Constraints**: Technical limits, style rules, what to avoid
- **Uncertainty Rule**: How to handle ambiguity
- **Output Format**: Exact structure of the response
- **Source**: medium.com/@rentierdigital | **Implemented**: YES — bake into global CLAUDE.md instructions

### Four Prompt Modes (Don't Mix)
1. **Explore**: "Read this codebase and summarize how X works" (read-only, Plan Mode)
2. **Debug**: "Show inputs, errors, and environment. What's the root cause?" (gather data first)
3. **Build**: "Implement [specific change]. Show the diff." (concrete, direct)
4. **Review**: "Review for edge cases, race conditions, consistency" (single focused lens)
- **Source**: Multiple community patterns | **Implemented**: YES — enforce in development-workflow rules

### When Vague vs Specific
- **Be vague** when exploring/onboarding ("What would you improve in this file?")
- **Be specific** once you've identified the problem (exact files, constraints, edge cases)
- **Use @path/to/file** instead of describing location
- **Source**: Official docs + community | **Implemented**: Partial

### Multi-Step Request Queuing
Queue related messages — Claude chains them automatically. Reduces back-and-forth.
- **Source**: Builder.io blog | **Implemented**: No

### Thinking Depth Keywords (Claude Code CLI Only)
Trigger extended reasoning by including these exact words in prompts:
- `"think"` → 4,000 token thinking budget
- `"think hard"` → 10,000 token budget
- `"think harder"` → intermediate budget
- `"ultrathink"` → 31,999 token maximum budget (per-turn override only)
These keywords ONLY work in Claude Code CLI — not in claude.ai web interface.
Ultrathink was restored in v2.1.68 (March 2026) after community pushback.
- **Source**: claudelog.com, awesomeagents.ai, findskill.ai | **Implemented**: No — add to power-user toolkit

### Plan-First-Then-Parallelize
Use plan mode to produce an implementation blueprint cheaply (~10k tokens), then hand the plan to an agent team for parallel execution. Prevents expensive mid-swarm course corrections.
- **Source**: alexop.dev | **Implemented**: Partial — plan mode used, parallel not yet

---

## 2. Development Workflows

### Four-Phase Cycle (Official Recommendation)
1. **Explore** (Plan Mode) → read-only investigation
2. **Plan** (Plan Mode) → detailed implementation plan
3. **Implement** (Normal Mode) → code against the plan
4. **Commit** → descriptive message + PR
- Skip planning if you can describe the diff in one sentence.
- **Source**: Official docs | **Implemented**: YES — bake into CLAUDE.md + development-workflow rules

### Test-Driven Development
1. Write failing tests first
2. Confirm they fail
3. Implement to pass
4. Claude self-corrects via automated test loop (10+ iterations without human input)
- **Source**: The New Stack, alexop.dev | **Implemented**: YES — enforce in CLAUDE.md + development-workflow rules

### Debugging: 4-Phase Method
1. **Reproduce**: Write a failing test
2. **Isolate**: Add logging incrementally
3. **Root Cause**: Identify before fixing ("NO FIXES WITHOUT ROOT CAUSE FIRST")
4. **Validate**: Fix + verify test passes + check regressions
- **Source**: eesel.ai | **Implemented**: YES — enforce in development-workflow rules

### Writer/Reviewer Pattern (Parallel Sessions)
- Session A: Implement feature
- Session B: Review Session A's code
- Session A: Address feedback from Session B
- **Source**: Community pattern | **Implemented**: No

### Spec-First Development
- Session 1: Claude interviews you in detail, writes SPEC.md
- Session 2 (clean context): Implement according to @SPEC.md
- **Source**: alexop.dev | **Implemented**: YES — enforce in spec-driven rules

### Recursive Hierarchical Planning (Deep Planning)
For complex projects (15+ interdependent files, unfamiliar architecture):
1. **Cross-cutting concerns** (Opus): Lock shared conventions before decomposing
2. **Meta-plan** (Opus): Decompose into 5-10 sections with dependency graph, human approves
3. **Parallel section planning** (Sonnet subagents): Each returns structured contracts with reasoning narratives + "breaks if" fragility conditions
4. **Reconciliation** (Opus + human): Compare contracts, cross-reference fragility conditions, detect conflicts
5. **Adaptive execution** (Sonnet): Execute with on-demand decomposition (ADaPT pattern — only recurse on failure)
6. **Verification**: Test against success criteria
- Key innovation: "breaks if" conditions on each decision make cross-section conflicts detectable without reading full reasoning chains
- Plan lives in plan.md (file-based, survives context compaction). Max 3 levels deep.
- Auto-routes: simple tasks get light planning, only complex projects get the full pattern.
- **Source**: Internal design, validated against ADaPT (NAACL 2024), GoalAct (NCIIP 2025), Plan-and-Act (ICML 2025) | **Implemented**: YES — `/plan-deep` skill + pattern doc at `knowledge/patterns/recursive-planning.md`

### LSP Integration (2x Speed for Code Navigation)
Claude Code has native Language Server Protocol support (released December 2025, v2.0.74).
Supports 11+ languages. Enables go-to-definition, find-references, semantic search.
Key gain: navigates codebase in 50ms instead of 45s using text search.
Distinguishes function `process` from the string "process" in comments.
Enable via the `cclsp` plugin or `lsp-mcp-server` MCP.
- **Source**: claudelog.com, karanbansal.in, github.com/ktnyt/cclsp | **Implemented**: No — high value, install soon

---

## 3. Context Management

### Key Facts
- Performance cliff in last ~20% of context window
- Auto-compaction triggers at ~75-92% capacity
- Average session cost: $6/dev/day, $100-200/month with Sonnet
- 5x multiplier on output tokens — unnecessary outputs are expensive
- MCP servers cost 8-30% of context just by being available (even unused)
- **Source**: Official docs, claudefa.st, Advent of Claude | **Implemented**: Awareness only

### Strategies
- `/clear` between unrelated tasks (fresh 200K tokens)
- `/compact <instructions>` to manually trigger with guidance
- `/context` to see token breakdown
- Subagents for verbose operations (separate context windows)
- `/btw` for side questions (doesn't enter history)
- After 2 failed corrections: `/clear` and rewrite prompt
- Remove unused MCP servers to reclaim 8-30% context budget
- **Source**: Official docs, community | **Implemented**: YES — enforce in context-management rules

### Custom Compaction Instructions
Add to CLAUDE.md: "When compacting, always preserve: modified files list, test commands, key decisions"
- **Source**: Community pattern | **Implemented**: YES — enforce in context-management rules

### Context Injection After Compaction (Hook Pattern)
Use a PostToolUse hook (or SessionStart) to auto-inject project-critical reminders after compaction events:
```bash
echo "Use Bun, not npm. Current sprint: auth refactor. Run bun test before committing."
```
This prevents context loss without relying on Claude's memory.
- **Source**: aiorg.dev hooks guide | **Implemented**: YES — `scripts/context-reinject.sh` reads an `active-context.md` file, wired to both SessionStart and Notification hooks

---

## 4. CLAUDE.md Best Practices

### The 60-200 Line Rule
- Under 60: probably missing critical info
- Over 200: Claude starts ignoring rules
- Sweet spot: 80-150 lines
- **Source**: Official docs, multiple blogs | **Implemented**: Partial (global is short, per-project varies)

### What to Include
- Exact build/test/deploy commands with flags
- Path organization rules
- Code style specifics (indentation, imports)
- Architecture decisions
- Common gotchas
- **Source**: Official docs | **Implemented**: Yes (in new CLAUDE.md files)

### What NOT to Include
- Anything Claude infers from reading code
- Standard language conventions
- Detailed API docs (link instead with @path)
- Info that changes frequently
- **Source**: Official docs | **Implemented**: Yes

### Progressive Disclosure
- Use `@path/to/file` to reference external docs (loaded on demand)
- Move topic-specific rules to `.claude/rules/` (path-scoped, loaded only when relevant)
- **Source**: Official docs, community | **Implemented**: Partial (rules created, @imports not yet)

### Per-Client/Per-Project CLAUDE.md as Knowledge Repository
Store client background, communication preferences, document templates, business terms, and writing style in per-project CLAUDE.md files.
Use auto-logging hooks to update work logs after each session.
This turns CLAUDE.md into a growing contextual brain for each client, not just a rule file.
- **Source**: mattstockton.com | **Implemented**: No — apply to per-project CLAUDE.md files

---

## 5. Configuration Patterns

### Path-Scoped Rules (`.claude/rules/`)
Rules in `.claude/rules/*.md` with YAML frontmatter `paths:` field only load when Claude works on matching files. Saves context.
- **Source**: Official docs | **Implemented**: Yes (3 rules created)

### Hook Recipes (Most Useful)
1. **Auto-format on edit**: PostToolUse + Edit|Write → prettier
2. **Block sensitive files**: PreToolUse + Edit|Write → check .env/.pem/.key
3. **Python syntax check**: PostToolUse + Edit|Write → py_compile
4. **macOS notifications**: Notification → osascript display notification
5. **Context re-injection**: SessionStart + compact → echo critical reminders
6. **Bash command logging**: PostToolUse + Bash → append to log file
7. **Config change audit**: ConfigChange → log timestamp + source + file
8. **Rate-limited tool access**: PreToolUse + count MCP calls → block if threshold exceeded
9. **Stop-gate verification**: PreSessionEnd → run tests, block exit if failing
10. **Multi-turn agent verification**: Stop hook spawns subagent for 50+ turn pre-deployment check
11. **Asymmetric trust**: Auto-approve WebSearch/WebFetch, always confirm file modifications
12. **Audit log as context**: Append all executed commands to queryable history file
- **Source**: Official docs, eesel.ai, aiorg.dev, community | **Implemented**: Partial (#2 and #3 done)

### Hook Exit Codes
- Exit 0: Action proceeds
- Exit 2: Block action (stderr becomes feedback)
- Other: Proceed, stderr logged only
- **Source**: Official docs | **Implemented**: Awareness only

### Permission Patterns (Brief Reference)
```json
"permissions": {
  "allow": ["WebSearch", "Bash(npm test)", "Bash(git *)"],
  "ask": ["Bash(npm publish)"],
  "deny": ["Bash(rm -rf)"]
}
```
- **Source**: Official docs | **Implemented**: Partial
- See full deep-dive below in "Bash Permission Management (Deep Dive)"

### Three-Layer Governance Architecture
Layer 1: Cognitive Directives (CLAUDE.md) — operating contract
Layer 2: Runtime Enforcement (Hooks) — exit codes that cannot be overridden during inference
Layer 3: Validation (native tools/Rust) — Aho-Corasick pre-filtering for secrets scanning
This pattern makes hooks serve as hard boundaries Claude cannot reason around.
- **Source**: dev.to/gabrielgadea | **Implemented**: Partial (layers 1+2 exist, layer 3 not yet)

---

## 5b. Bash Permission Management (Deep Dive)
**Research date**: 2026-03-28
**Sources**: Official docs (code.claude.com), Anthropic GitHub examples, Trail of Bits, Check Point CVE research, community

### The Permission Hierarchy (Precedence Order)
Settings are evaluated in strict descending order — a deny at any level cannot be overridden lower:
1. Managed settings (org-deployed, unoverridable)
2. CLI flags (`--allowedTools`, `--permission-mode`)
3. Local project settings (`.claude/settings.local.json`, gitignored)
4. Shared project settings (`.claude/settings.json`, committed)
5. User settings (`~/.claude/settings.json`)

Rule evaluation within a settings file: **deny → ask → allow** (first match wins, deny always beats allow).

### Permission Modes Reference
| Mode | What runs without prompts | Use case |
|---|---|---|
| `default` | Read-only file access | Standard development, sensitive work |
| `acceptEdits` | Reads + file edits | Iterating on code under review |
| `plan` | Read-only (no edits, no commands) | Codebase exploration, planning |
| `auto` | All actions via background AI classifier | Long runs, Team plan required (Sonnet 4.6 / Opus 4.6) |
| `dontAsk` | Only pre-approved tools (all else silently denied) | CI pipelines, locked environments |
| `bypassPermissions` | Everything, no checks | Containers/VMs ONLY — dangerous on host |

Set default mode in settings.json:
```json
{ "permissions": { "defaultMode": "acceptEdits" } }
```
- **Source**: code.claude.com/docs/en/permission-modes

### Bash Allowlist Syntax (Current as of 2026)
Pattern format: `Bash(command arguments)` with glob `*` support.
Space before `*` matters: `Bash(ls *)` matches `ls -la` but NOT `lsof`. `Bash(ls*)` matches both.
The legacy `:*` suffix syntax (`Bash(git:*)`) is deprecated — use space-wildcard form (`Bash(git *)`).

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(git commit *)",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(* --version)",
      "Bash(* --help *)"
    ],
    "deny": [
      "Bash(git push *)",
      "Bash(git push --force *)",
      "Bash(rm -rf *)",
      "Bash(curl *)",
      "Bash(wget *)"
    ]
  }
}
```
Shell operators (`&&`, `|`, `;`) are understood: `Bash(safe-cmd *)` does NOT authorize `safe-cmd && evil-cmd`.
- **Source**: code.claude.com/docs/en/permissions

### Official Anthropic Example Configs (from anthropics/claude-code repo)
Three canonical configurations:

**settings-lax.json** (minimal managed policy):
Disables `bypassPermissions` mode, restricts plugin marketplaces. No bash restrictions.
```json
{
  "permissions": { "disableBypassPermissionsMode": "disable" },
  "strictKnownMarketplaces": []
}
```

**settings-strict.json** (org lockdown):
All bash requires approval, no web fetch/search, managed-rules-only, managed-hooks-only, full sandbox config.
```json
{
  "permissions": {
    "disableBypassPermissionsMode": "disable",
    "ask": ["Bash"],
    "deny": ["WebSearch", "WebFetch"]
  },
  "allowManagedPermissionRulesOnly": true,
  "allowManagedHooksOnly": true
}
```

**settings-bash-sandbox.json** (isolation via OS sandbox):
Enables built-in sandbox with strict network/filesystem boundaries. Managed-rules-only without requiring ask on all bash.
```json
{
  "allowManagedPermissionRulesOnly": true,
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": false,
    "allowUnsandboxedCommands": false,
    "network": { "allowedDomains": [] }
  }
}
```
- **Source**: github.com/anthropics/claude-code/tree/main/examples/settings

### Read/Edit Deny Rules for Sensitive Files (Official Pattern)
Read/Edit deny rules apply ONLY to Claude's built-in file tools — NOT to Bash.
`Read(./.env)` blocks the Read tool but NOT `cat .env` in a bash command.
For OS-level enforcement that blocks bash too, enable the sandbox (`/sandbox`).

Recommended deny rules:
```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(~/.ssh/**)",
      "Read(~/.aws/**)",
      "Read(~/.gnupg/**)",
      "Edit(~/.zshrc)",
      "Edit(~/.bashrc)"
    ]
  }
}
```
- **Source**: code.claude.com/docs/en/permissions, petefreitag.com

### Trail of Bits Pattern: Hooks Over Allowlists
Philosophy: Use `bypassPermissions` + OS sandboxing + blocking hooks rather than granular allowlists.
Rationale: "An instruction in CLAUDE.md saying 'never use rm -rf' can be forgotten or overridden by context pressure. A PreToolUse hook that blocks rm -rf fires every single time."

Their two core PreToolUse hooks:
1. Block `rm -rf` (suggests `trash` instead) — exit code 2
2. Block direct push to main/master (requires feature branches) — exit code 2

Also: `enableAllProjectMcpServers: false` as explicit default to prevent malicious repo MCP servers.
- **Source**: github.com/trailofbits/claude-code-config

### Known Gotchas and Anti-Patterns

**Gotcha 1: Read denies don't block bash reads.**
`Read(./.env)` does not prevent `cat .env`. Only the sandbox prevents that at OS level.
Fix: combine Read deny rules with a PreToolUse hook that scans bash commands for reads of sensitive paths.

**Gotcha 2: Piped commands need separate allowlist entries.**
`Bash(printf * | msmtp *)` does NOT work. Must be two entries: `Bash(printf *)` and `Bash(msmtp *)`.
- Source: github.com/anthropics/claude-code/issues/31498

**Gotcha 3: Multi-line script approvals corrupt settings.local.json.**
Approving a multi-line bash script causes Claude Code to save each line as a separate permission pattern, which then breaks settings parsing on next launch (`:` in bash parameter expansion conflicts with pattern syntax).
Workaround: Never approve multi-line scripts with "yes, don't ask again". Use exit 0 hooks for known safe scripts instead.
- Source: github.com/anthropics/claude-code/issues/19929

**Gotcha 4: Curl allowlist bypass is easy.**
`Bash(curl http://github.com/ *)` is NOT reliable URL filtering — options order, different protocol, variables, redirects all bypass it.
Fix: Deny `Bash(curl *)` and `Bash(wget *)` entirely, then use `WebFetch(domain:example.com)` rules for approved domains.

**Gotcha 5: bypassPermissions mode can be triggered by repo settings before trust dialog (CVE-2026-33068).**
Fixed in v2.1.53. Always keep Claude Code updated. Never run claude code in untrusted repos without checking `.claude/settings.json` first.

**Gotcha 6: `Bash(ls*)` vs `Bash(ls *)` — space is a word boundary.**
`Bash(ls*)` also matches `lsof`. Always use a space before the wildcard if you want to match only the exact command prefix.

**Gotcha 7: Setting autoMode.allow or autoMode.soft_deny replaces entire default list.**
If you set even one entry in `soft_deny`, ALL built-in block rules (force push, curl|bash, production deploys) are discarded.
Fix: Always start by running `claude auto-mode defaults`, copying the full list, then editing it.
- **Source**: code.claude.com/docs/en/permissions

### Security CVEs Relevant to Permission Configuration
- **CVE-2025-59536** (CVSS 8.7): Hooks in `.claude/settings.json` executed without user confirmation. Fixed. Lesson: inspect `.claude/` directory before opening any cloned repo.
- **CVE-2026-21852**: ANTHROPIC_BASE_URL override in repo settings could intercept API keys before trust dialog. Fixed. Lesson: never trust environment variable overrides in unfamiliar repos.
- **CVE-2026-33068**: `bypassPermissions` mode triggered by repo settings before trust dialog. Fixed in v2.1.53.
- **CVE-2026-25725**: Sandbox escape via missing `.claude/settings.json` — malicious sandbox code could create hooks that execute with host privileges on restart. Fixed.
- **Snyk ToxicSkills (Feb 2026)**: 36% of ClawHub agent skills contain prompt injection. Always paraphrase, never copy skill files verbatim from untrusted repos.
- **Source**: research.checkpoint.com, sentinelone.com, raxe.ai | **Implemented**: Awareness — keep Claude Code current

---

## 6. MCP Servers (Worth Installing)

### Top Recommendations
1. **Context7** (Upstash): Version-specific library docs, solves hallucination for React/Next/Prisma etc.
2. **GitHub MCP**: PR analysis, issue automation, repo access
3. **Playwright**: Browser automation, E2E testing, accessibility
4. **PostgreSQL**: Direct database queries, schema exploration
5. **Figma MCP**: Design file access, component structures, design tokens. Add with: `claude mcp add --transport http figma https://mcp.figma.com/mcp`
6. **Miro MCP**: Whiteboard collaboration, spatial visualization, visual workflows. Add with: `claude mcp add --transport http miro https://mcp.miro.com`
7. **Token Optimizer MCP**: 95%+ token reduction through caching/compression
8. **Firecrawl**: Web data extraction at scale
9. **Memory MCP / Knowledge Graph MCP**: Graph-based persistent memory with confidence decay
10. **Composio**: Managed MCP gateway for 500+ apps (Gmail, Slack, Linear, Notion, CRMs) with built-in OAuth
11. **VoiceMode MCP**: Natural voice conversations with Claude Code via OpenAI-compatible services (Whisper.cpp local option)
12. **Blender MCP**: 3D design integration — describe a scene, Claude builds it
13. **Nano Banana**: Wraps Gemini image generation, lets Claude Code generate/edit images inline
14. **Claude MCP Tool Search**: Lazy-loads MCP servers, reduces context by up to 95%
15. **lsp-mcp-server / cclsp**: Bridges Claude Code to LSP servers for semantic code intelligence
- **Source**: claudefa.st, bannerbear.com, medium.com/@itaispector1, community

### MCP Tool Search (Advanced)
Lazy-loads MCP servers, reduces context by up to 95%. Lets you run all servers without bloat.
- **Source**: Official docs

---

## 7. Skills & Agents

### Skill Design Principles
1. One clear responsibility per skill
2. Include prerequisites explicitly
3. Provide 2-3 real usage examples
4. Keep instructions scannable (headers, bullets)
5. Document common errors and solutions
6. Trigger-rich descriptions — Claude uses semantic matching to activate skills
7. Keep SKILL.md focused under 500 lines
8. Include good AND bad pattern examples with code
- **Source**: anthropics/skills repo, community | **Implemented**: Yes (3 skills created)

### Subagent Best Practices
- Use for: codebase exploration, code review, parallel investigation
- Route simple tasks to Haiku (4-8x cheaper)
- Each gets full context window in parallel
- Native worktree support prevents git conflicts
- Worktrees auto-created at `repo/.claude/worktrees/<n>`, branch from default remote
- **Source**: Official docs, pubnub.com, claudefa.st

### Agent Teams (Experimental — Enable with CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS)
Released February 5, 2026 alongside Opus 4.6. Enables true multi-agent collaboration.

**Key difference from subagents**:
- Subagents: focused workers that report to one parent, cannot talk to each other
- Agent Teams: teammates communicate peer-to-peer directly (inbox-based messaging)

**Communication patterns**:
- Lead → Teammate (task assignment)
- Teammate → Lead (status, results)
- Teammate → Teammate (direct collaboration — frontend asks backend about API format)

**Task coordination**:
- Shared task list with dependency tracking
- Tasks auto-unblock when dependencies complete
- File locking prevents race conditions
- Self-claiming: agents poll for unclaimed work and claim autonomously

**Optimal structure**: 5-6 tasks per teammate. Too small → coordination overhead dominates. Too large → no check-ins.

**Cost strategy**: Lead runs on Opus (coordination), teammates on Sonnet (execution).

**Best use cases**:
1. Competing hypotheses debugging (multiple agents investigate simultaneously, then debate)
2. Parallel specialized code review (security + performance + test coverage agents simultaneously)
3. Cross-layer features (frontend / backend / tests owned by different teammates)
4. Research & exploration (teams investigate approaches in parallel, share discoveries)
- **Source**: Official docs, addyosmani.com, alexop.dev

### Four-Tier Agent Hierarchy Pattern (Community)
Rather than generalist agents, use domain-expert tier structure:
- **Tier 1 (Opus)**: Architecture, security, production code review (highest stakes)
- **Tier 2 (Inherit)**: Complex tasks, user selects model
- **Tier 3 (Sonnet)**: Testing, debugging, documentation
- **Tier 4 (Haiku)**: Fast routine tasks, lookups, validation
This creates composable workflows that minimize token cost while maintaining domain depth.
- **Source**: github.com/wshobson/agents

### Cognitive Persona Pattern (SuperClaude Framework)
Rather than fixed agents, implement domain-specific cognitive personas that activate contextually:
- Personas defined as .md files with behavioral instructions injected at runtime
- No explicit invocation — personas activate based on task context
- Examples: architect, security-engineer, deep-researcher, business-panel (multi-expert strategic analysis)
- Research depth levels: quick / standard / deep / exhaustive (auto-selected by complexity)
- Quality scoring with confidence thresholds (0.0–1.0, target 0.8) as stopping criteria
- **Source**: github.com/SuperClaude-Org/SuperClaude_Framework

### The Retrospective Command Pattern
A `/retrospective` command (or skill) captures learnings from work sessions and converts them into reusable artifacts automatically. Prevents institutional knowledge from evaporating after productive debugging sessions.
- **Source**: nickwinder.com meta-plugin

### Meta-Plugin Pattern (Claude Code for Claude Code)
A skill that generates other skills. Three generator skills that handle creation of CLAUDE.md files, domain-specific skills, and slash commands. Each generator consults a `claude-code-guide` agent for latest best practices rather than hardcoding knowledge. Knowledge accumulates progressively: 3 skills → 7 skills + 4 commands → 15 skills, 10 commands.
- **Source**: nickwinder.com

---

## 8. Self-Improving / Living Systems

### The Minimal Seed Bootstrap
A ~1400-token CLAUDE.md that evolves into a sophisticated configuration system.
Core mechanism: the seed contains identity ("I am a learning system"), a triage loop (Reflect → Capture → Cascade), and anti-proliferation guardrails.
**Evolution timeline**: Sessions 1-3: bootstrap; Session 8: first rules extracted; Session 15+: structural patterns emerge; Session 20+: hooks and skills discovered naturally.
Learnings that repeat 2+ times → extracted into `.claude/rules/` → consolidated when rules exceed 50 lines.
- **Source**: gist.github.com/ChristopherA

### KERNEL: Self-Evolving Configuration
Key philosophy: "Static configs rot because your workflow doesn't stay still."
Core innovation: **meta-rules** teach Claude how to write quality rules, enabling self-regulation.
Meta-rule format: "Use absolute directives (NEVER/ALWAYS). Lead with why. Be concrete. No bloat."
Two-tier architecture: summary section (quick ref) + detailed sections (full rules). Claude updates both.
- **Source**: medium.com/@ariaxhan

### The One-Sentence Self-Improvement Trigger
After any error: `"Reflect on this mistake. Abstract and generalize the learning. Write it to CLAUDE.md."`
This breaks down into: Reflect → Abstract → Generalize → Document (following meta-rules).
Compounding effect: Session 1 eliminates basic mistakes; Session 2 makes more sophisticated mistakes; Session 3 reaches architectural concerns. Mistakes evolve upward rather than repeating.
- **Source**: github.com/aviadr1/claude-meta, dev.to/aviad

### Auto-Logging Behavior Pattern
CLAUDE.md instruction: "AUTO-LOGGING BEHAVIOR: Do NOT ask before logging. Automatically: when user mentions a task → add to TODO. When task completes → mark done and log. Share context in daily logs."
System routes information to appropriate files automatically.
Every conversation adds context. Every person mentioned gets remembered. Sessions build on each other.
- **Source**: jngiam.bearblog.dev

### 6R Processing Pipeline (Agent-Assisted Knowledge Processing)
Extension of Cornell Note-Taking's 5Rs for agent workflows:
1. **Record** → capture raw input without judgment
2. **Reduce** → distill to core claims
3. **Reflect** → connect to existing knowledge
4. **Reweave** → integrate into knowledge graph, update cross-links
5. **Verify** → fact-check, validate sources, flag confidence
6. **Rethink** → periodic revisit (cron/loop)

Key implementation pattern: each phase runs in a **separate subagent context** (Haiku for 1-2, Sonnet for 3-5, scheduled for 6) to avoid attention degradation in long processing chains.
- **Source**: github.com/agenticnotetaking/arscontexta (concept extracted, plugin itself on Hold)

### Three-Space Architecture (Self / Notes / Ops)
Separates agent knowledge by growth rate and access pattern:
- **Self** (slow growth): identity, methodology, goals → read at session start
- **Notes** (steady growth): knowledge graph, facts, connections → read on-demand
- **Ops** (fluctuating): queues, session state, active tasks → read/write during session

Prevents operational churn from polluting long-lived knowledge. Maps naturally to: CLAUDE.md+rules = Self, memory+knowledge = Notes, TodoWrite+git = Ops.
- **Source**: github.com/agenticnotetaking/arscontexta

### Knowledge Graph Persistent Memory (MCP)
Graph-based MCP servers (MemoryGraph, mcp-knowledge-graph, mcp-memory-service) extend Claude beyond CLAUDE.md:
- Each memory has confidence score (0–1)
- Progress memories decay over 7 days; architectural decisions never decay
- Every 10 extractions, Haiku reviews all memories to merge overlaps and drop outdated entries
- Semantic search across all stored knowledge
Add with `mcp-knowledge-graph` or `memory-graph` MCP server.
- **Source**: dev.to/dalimay28, dev.to/suede, github.com/shaneholloman

---

## 9. Spatial & Visual Workflows

### Miro as Live Architecture Canvas
Miro MCP for Claude Code: `claude mcp add --transport http miro https://mcp.miro.com`
Capabilities enabled:
- Push codebase analysis → Miro architecture diagrams automatically
- Pull PRDs and user stories from Miro → feed directly to Claude for code generation
- Code reviews conducted within Miro canvas
- Task tracking via Miro board tables
- Research findings visualized on boards

Official skills in miroapp/miro-ai:
- `/miro:browse` — explore board contents
- `/miro:diagram` — create diagrams
- `/miro:doc` — create markdown documents
- `/miro:table` — create tables
- `/miro:summarize` — extract documentation
- `miro-tasks` — automatic task tracking in Miro tables
- `miro-research` — research and visualize findings on Miro
- **Source**: github.com/miroapp/miro-ai, miro.com/marketplace

### Excalidraw Live Diagram Skill
A Claude Code skill that generates architecture diagrams on a live Excalidraw canvas in real time. Point Claude at your project and watch it build the diagram.
- **Source**: github.com/edwingao28/excalidraw-skill

### Codebase-to-Knowledge-Graph (Understand Anything)
Five specialized agents analyze a codebase and build an interactive knowledge graph:
1. project-scanner → discovers files and languages
2. file-analyzer → extracts functions, classes, imports (runs 3 concurrently)
3. architecture-analyzer → categorizes into architectural layers
4. tour-builder → creates guided walkthroughs
5. graph-reviewer → validates completeness
Outputs: React Flow visual graph, layer visualization with color-coding, semantic search, persona-adaptive UI.
Persists to `.understand-anything/knowledge-graph.json`.
- **Source**: github.com/Lum1104/Understand-Anything

### D2 Infrastructure Diagrams from Code
A Claude Code plugin (`claude-d2-diagrams`) generates infrastructure and architecture diagrams directly from your codebase using D2 diagram language.
- **Source**: github.com/heathdutton/claude-d2-diagrams

### Whiteboard Visualization (Built-in)
Claude Code can generate lightweight interactive HTML including SVG diagrams, flowcharts, concept maps, and data visualizations that render inline with conversation. No external tool needed.
- **Source**: mindstudio.ai

### D2: Best Single Tool for Claude Code Diagram Skills (Research Finding: 2026-03-25)
D2 is the recommended diagram-as-code backend for Claude Code skills because:
- Single Go binary, no Chromium, no Java, no runtime dependency
- DSL is minimal (~20 constructs) — Claude reliably produces valid output
- Supports SVG, PNG, PDF output and a `--watch` live-reload mode
- Bundled Dagre and ELK layout engines handle both hierarchical and cyclical agent graphs
- `--sketch` flag for hand-drawn aesthetic when needed
- Install: `curl -fsSL https://d2lang.com/install.sh | sh -s --`

The validate-fix loop: generate .d2 file → run `d2 input.d2 /tmp/output.svg` → if error, parse stderr line number → fix → rerender.
- **Source**: github.com/terrastruct/d2, simmering.dev/blog/diagrams

### Mermaid: Best for Docs-Embedded Diagrams
Mermaid renders natively in GitHub README, Notion, and most documentation tools.
For Claude Code skills, the key pattern is the validate-fix loop:
1. Generate Mermaid syntax
2. Run `mmdc -i file.mmd -o /tmp/validation.svg 2>&1`
3. If exit != 0: parse error line from stderr, fix, rerun
4. Loop until clean

Most reliable diagram types for LLM generation: flowchart, sequenceDiagram, simple class diagrams.
Avoid: `architecture-beta`, deep subgraph nesting, parentheses in node labels without quoting.
Install: `npm install -g @mermaid-js/mermaid-cli` (downloads Chromium ~170MB on first run).
- **Source**: github.com/mermaid-js/mermaid-cli, zolkos.com, icepanel.io

### Markmap: Best for Mind Maps and Hierarchical Concept Visualization
Converts plain Markdown headings into interactive mind map HTML files.
Input is the simplest possible DSL: just `# H1`, `## H2`, `### H3` — Claude cannot produce invalid input.
Output: single self-contained HTML file with zoom/pan/collapse.
Install: `npm install -g markmap-cli`
Usage: `markmap note.md` — opens browser preview; `markmap note.md -o output.html --no-open` for headless.
- **Source**: github.com/markmap/markmap

### Nomnoml: Lightweight UML Without Chromium
Pure Node.js, no Chromium. `npx nomnoml input.noml` renders SVG to stdout.
Node.js API: `const svg = nomnoml.renderSvg('[A] -> [B]')` — pure function, no side effects.
Bracket-based DSL: `[<actor> User] -> [<database> DB: query]`
Best for: simple relationship diagrams, agent-to-agent connection maps, quick UML sketches.
Not ideal for: complex architecture with many nested layers (use D2 instead).
- **Source**: github.com/skanaar/nomnoml

### Kroki: Multi-Format Unified API (Self-Host for Private Diagrams)
Fronts 20+ diagram formats (Mermaid, D2, PlantUML, Graphviz, Nomnoml, and more) behind a single HTTP API.
Self-hosted via Docker Compose. Public API at kroki.io is fine for demos but not for proprietary content.
POST API: `POST /mermaid/svg` with diagram source as request body.
No dedicated CLI client — shell one-liner: `curl -X POST https://kroki.io/d2/svg -d 'A -> B'`
Most useful if consolidating multiple diagram types behind a single endpoint.
- **Source**: github.com/yuzutech/kroki

### LLM Performance on Diagram Generation (Research Finding: 2026-03-25)
Claude 4.0 Sonnet was the top performer across LLMs tested on C4 architecture diagram generation.
Key finding from icepanel.io (Aug 2025): Claude better decomposes architecture into coherent abstractions (Controller-Service-Repository pattern, regional separation).
However: no model produces production-ready C4 diagrams without human refinement.
Best use: LLM generates first draft + validate-fix loop → human architect refines.
D2 and Mermaid are the most LLM-reliable formats. PlantUML and architecture-beta Mermaid are less reliable.
- **Source**: icepanel.io/blog/2025-08-18-comparison-llms

### Excalidraw Diagram Skill Pattern (Community)
The coleam00 excalidraw-diagram-skill repo demonstrates the full Claude Code skill pattern for diagram generation:
- No MCP server required — pure SKILL.md + Playwright CLI
- Iterative rendering loop: generate JSON → render PNG → visual validation → fix → re-render
- Produces hand-drawn aesthetic (useful for stakeholder-facing docs)
- Requires Playwright + Chromium (~300MB)
Full skill pattern available at: github.com/coleam00/excalidraw-diagram-skill
Security note: extract and adapt pattern, do not install verbatim (T4 individual contributor).
- **Source**: github.com/coleam00/excalidraw-diagram-skill, medium.com/@ooi_yee_fei

---

## 10. Non-Code & Creative Workflows

### Meeting Notes → Structured Summary Pipeline
Record meeting audio → transcribe → Claude Code formats using CLAUDE.md templates → auto-update work logs.
"5 minutes instead of 30" for documentation. Uses per-client CLAUDE.md as context.
Git commit messages serve as audit trail: Claude can "review how projects evolved and understand why decisions were made."
- **Source**: mattstockton.com

### Knowledge Management System Pattern
Per-project CLAUDE.md files as growing knowledge bases:
- Client background, communication preferences, templates, business terminology, writing style
- Cross-project pattern recognition: "templates generalize across projects"
- Cross-project querying: related project documentation can interact
Compounding value: every document, process, and instruction becomes part of a growing knowledge base.
- **Source**: mattstockton.com

### Twitter/X Skill (Async Posting without API Key)
Community-built async GraphQL client powered by Rust — uses browser cookies, no Twitter API key needed.
Includes thread templates and posting schedules for content strategy workflows.
- **Source**: github.com/hesreallyhim/awesome-claude-code

### Claude Cowork (Desktop App for Knowledge Work)
Anthropic's sibling to Claude Code for non-coding workflows. Launched January 12, 2026.
Same agentic architecture but for: document prep, data analysis, research synthesis, file organization.
Computer use capabilities + persistent cross-device conversation (phone → desktop) + scheduling.
For non-developer knowledge workers: researchers, analysts, operations, legal, finance.
Not Claude Code but worth knowing: some workflows may fit Cowork better.
- **Source**: anthropic.com/product/claude-cowork, venturebeat.com

### DNA Analysis Skill
The awesome-claude-code-toolkit includes a `dna-claude-analysis` skill that analyzes raw DNA data across 17 categories with terminal-style HTML dashboards. Demonstrates how far Claude Code can extend into specialized domains.
- **Source**: github.com/rohitg00/awesome-claude-code-toolkit

---

## 11. Async & Scheduling Patterns

### Claude Code Channels (Discord/Telegram)
Native plugin-based feature enabling messaging into local Claude Code sessions from mobile.

**Telegram setup**: Create bot via @BotFather, install plugin, configure token, pair with 6-char code.
**Discord setup**: Create app in Developer Portal, enable Message Content Intent, invite bot, configure.
Discord advantage: `fetch_messages` pulls up to 100 messages of history — enables session recovery.

**Key async workflows**:
- Start builds/tests at desk, receive notifications on phone, send follow-up instructions without laptop
- Team collaboration: Discord guild channels allow multiple members to interact with shared session
- Mobile-first: quick fixes mid-commute (message bot → modify config → commit → receive confirmation)
- Schedule tests hourly → report via Telegram → pause awaiting instructions

To enable: `claude mcp add channels` (Discord or Telegram plugin variant)
- **Source**: claudefa.st channels guide, venturebeat.com

### Scheduled Tasks (/loop and Cron)
Two scheduling modes:
1. **Session-scoped** (CLI): `/loop 5m "check if deployment finished"` — dies when you exit
2. **Durable** (via Channels + cron): persists across sessions, results delivered to Telegram/Discord

Community scheduler: `claude-code-scheduler` (github.com/jshchnz) and `claudecron` (MCP-based)
- **Source**: Official docs, claudefa.st

---

## 12. Agent Orchestration Frameworks (Community)

### Gas Town / Mayor Pattern
Hierarchical agent system: "mayor" agent breaks down tasks and spawns designated agents to tackle them. Manages parallel execution at the orchestration layer.
- **Source**: shipyard.build

### Claude Flow / Swarm Intelligence
Hierarchical structure: central orchestrator oversees agents working as a swarm. Supports enterprise-grade distributed execution with RAG integration.
- **Source**: github.com/ruvnet/ruflo, analyticsvidhya.com

### Claude Squad / Claude MPM
- **Claude Squad**: Terminal app managing multiple Claude Code agents in separate workspaces with isolated execution contexts
- **Claude MPM**: 47+ specialized agents organized by language/skill
- **Auto-Claude**: Multi-agent framework with kanban-style UI for plans/builds/validation
- **Source**: community

### Swarm Orchestration Skill
A complete skill for multi-agent coordination with TeammateTool, Task system, and all agent team patterns. Provides the scaffolding to orchestrate Claude teams from a single skill invocation.
- **Source**: gist.github.com/kieranklaassen

---

## 13. Cost & Model Optimization

### Model Selection Strategy
- **Opus**: Complex architecture, planning, deep reasoning, agent team leads
- **Sonnet** (default): Daily coding, 80% of tasks, agent team members
- **Haiku**: Simple tasks, 4-8x cheaper, subagent delegation, memory garbage collection
- **Hybrid**: Plan in Opus, execute in Sonnet (best cost/quality ratio)
- **Source**: Official docs, community

### Token Reduction Patterns (40-80% savings)
1. Progressive disclosure in skills (82% improvement in one case)
2. `/clear` between unrelated tasks
3. Custom compaction instructions
4. Load skills on-demand vs. bloating CLAUDE.md
5. Minimize unnecessary output (5x multiplier cost)
6. Remove unused MCP servers (8-30% context savings each)
7. Use LSP instead of file-reading for code navigation (50ms vs 45s, drastically fewer tokens)
- **Source**: Multiple blogs, claudefa.st, Advent of Claude

---

## 14. Hidden Features / Lesser Known

### Keyboard Shortcuts
- `Esc`: Stop mid-action (context preserved)
- `Esc + Esc`: Rewind menu
- `Shift + Tab`: Cycle Normal → Auto-Accept → Plan Mode
- `Ctrl+G`: Open draft plan in editor
- `/btw`: Side question (doesn't enter history)
- `!command`: Execute bash instantly and inject output into context (no model processing delay)
- **Source**: Official docs, mlearning.substack.com

### Session Management
- `/rename "oauth-migration"`: Name sessions for later reference
- `claude --continue`: Resume most recent session
- `claude --resume`: Pick from recent sessions
- `/teleport`: Beam session to claude.ai/code
- **Source**: Official docs

### Non-Interactive Mode
```bash
claude -p "prompt" --output-format json
claude -p "prompt" --output-format stream-json --allowedTools "Edit,Bash"
```
For CI, scripts, batch operations.
- **Source**: Official docs

### The /loop and /schedule Skills
- `/loop 5m "check for failed tests"` — recurring interval tasks
- `/schedule "0 9 * * *" "daily report"` — cron-based remote triggers
- **Source**: Official docs

### Gemini CLI as Fallback for Restricted Sites
Claude Code can't access some sites (Reddit, some news). Install Gemini CLI as a fallback to route requests through Gemini which has broader web access.
- **Source**: github.com/ykdojo/claude-code-tips

### claude-esp: Streaming Hidden Output to Separate Terminal
A Go-based TUI that streams Claude Code's hidden output (thinking, tool calls, subagents) to a separate terminal window. Enables monitoring multiple sessions simultaneously without interrupting main session. Valuable for debugging complex agent behavior.
- **Source**: github.com/hesreallyhim/awesome-claude-code

### claude-tmux: Multi-Session Management
Manages Claude Code within tmux: popup of all instances, quick switching, status monitoring, session lifecycle, git worktree and PR support.
- **Source**: awesome-claude-code

### Dippy: Smart Permission Management
Auto-approves safe bash commands using AST-based parsing while prompting for destructive operations. Reduces permission fatigue without disabling safety.
- **Source**: awesome-claude-code

### Plan Mode Default (Underused)
Advanced users report using Plan Mode 90% of the time. Shifts entire interaction model to exploration before execution. Most users dramatically underutilize it.
- **Source**: Advent of Claude (Day 29) | **Implemented**: No — set as default in CLAUDE.md

---

## 15. Anti-Patterns to Avoid

| Anti-Pattern | Fix |
|---|---|
| Kitchen sink session (mixing unrelated tasks) | `/clear` between tasks |
| Correction loops (3+ failed corrections) | `/clear` and rewrite prompt |
| Over-specified CLAUDE.md (>200 lines) | Prune, move to rules/skills |
| Trust without verification | Always provide tests/screenshots |
| Infinite exploration ("investigate the codebase") | Scope narrowly or use subagents |
| Ignoring context limits | Monitor with `/context`, delegate verbose work |
| One-size-fits-all model | Use Opus for planning, Sonnet for coding, Haiku for simple tasks |
| Bloated MCP server list | Remove unused MCPs (each costs 8-30% context) |
| Text search instead of LSP | Install cclsp for semantic navigation |
| Forgetting ultrathink | Add to prompt for architecture/debugging decisions |

---

## 16. Cross-Framework Agent Patterns (Transferable to Claude Code)

### ReWOO (Reasoning Without Observation)
Decouples planning from tool execution: Planner maps the full plan in one LLM call, Worker executes all tools (potentially in parallel), Solver synthesizes. Only 2 LLM calls regardless of tool count — 5x token reduction. Claude Code's Plan Mode is a partial implementation; the gap is parallelizing tool execution during the execute phase.
- **Source**: arxiv.org/abs/2305.18323, IBM

### Supervisor/Worker Pattern
Central LLM-driven Supervisor analyzes state and routes to specialized Workers. Workers are stateless and swappable. Directly describes Claude Code Agent Teams: Lead on Opus (supervisor), Teammates on Sonnet (workers). Extension: spawn two workers with conflicting instructions on the same task (debate pattern), then have Lead synthesize.
- **Source**: dev.to/programmingcentral, arxiv.org/abs/2601.13671 | **Implemented**: YES — Agent Teams

### Difficulty-Aware Routing
Route tasks based on complexity — hard to larger models, easy to cheaper ones. A Four-Tier hierarchy (Opus → Sonnet → Haiku) is a static version. A dynamic version would have a triage step classifying task complexity before routing.
- **Source**: arxiv.org/abs/2509.11079

### Description-Based Routing (Google ADK AutoFlow)
Define agents with rich capability descriptions; the LLM routes tasks by semantic matching. This is exactly how Claude Code skill activation works — skill description quality is the primary lever for routing performance.
- **Source**: Google ADK docs | **Implemented**: YES — how skills activate

### LATS (Language Agent Tree Search)
Applies Monte Carlo Tree Search to language agents: explore multiple branches, score with LLM value function, prune and continue from best. 92.7% pass@1 on HumanEval. Most useful for tasks with many possible paths. No Claude Code native support — worth adding as a skill for hard problems.
- **Source**: arxiv.org/abs/2310.04406

### A2A Protocol (Agent-to-Agent)
Google's protocol (now Linux Foundation) for agent-to-agent communication. Complements MCP: MCP = agent talks to tools, A2A = agent talks to agents. 100+ companies support it. Design agent descriptions with A2A interoperability in mind now.
- **Source**: developers.googleblog.com, linuxfoundation.org

### Academic Pattern Catalogs
Two high-quality references: CSIRO catalog (arxiv.org/abs/2405.10467, 18 patterns in Gang-of-Four style) and system-theoretic framework (arxiv.org/abs/2601.19752, 12 patterns across 5 agent subsystems). Together provide rigorous vocabulary for agent architecture design.
- **Source**: arxiv papers

---

## 17. Security Vetting for Agent Code

### Agent Skill Supply Chain Risk
36% of ClawHub skills contain prompt injection (Snyk ToxicSkills, Feb 2026). Traditional scanners are structurally blind to natural language injection in .md files. Use semantic analysis (have Claude evaluate instruction files in read-only mode) as a scanner before adoption.
- **Source**: snyk.io/blog/toxicskills, grith.ai/blog/agent-skills-supply-chain | **Implemented**: Yes — vetting-checklist.md created

### MCP Attack Vectors
Three novel vectors: tool poisoning (hidden instructions in descriptions), rug-pull (behavior changes post-approval), stored prompt injection (via SQL injection in MCP servers). Defense: pin MCP versions, semantic scan tool descriptions, monitor tool invocation patterns.
- **Source**: invariantlabs.ai, OWASP MCP Cheat Sheet

### Docker Sandboxes for Untrusted Repos
Docker's official sandboxing product isolates agents in microVMs. Recommended for first-run of any unfamiliar code. Use with `--network=none` initially.
- **Source**: docker.com/blog/docker-sandboxes, code.claude.com/docs/en/sandboxing

### Static-Before-Dynamic Evaluation Workflow
Clone `--no-checkout` → OpenSSF Scorecard → dependency scan → semantic scan of .md files → sandbox first-run → adopt. Full protocol documented in `knowledge/gh-scout/vetting-checklist.md`.
- **Source**: Synthesized from OpenSSF, Snyk, OWASP | **Implemented**: Yes — checklist created

---

## 18. Living Knowledge Base Architecture

### Zettelkasten Atomicity for KB Entries
One idea per entry, not topic-dumps. When each tip is its own entry, retrieval, update, and deprecation work independently.
- **Source**: zettelkasten.de

### TTL and Freshness Tracking
Add `Last verified: YYYY-MM-DD` and `TTL: [period]` to every entry. Staleness = days_since_verified / TTL. Above 1.0 = flagged. Above 1.5 = archived. Architectural decisions get TTL "never"; version-specific features get 30d.
- **Source**: ragaboutit.com, apxml.com

### Confidence Decay (Memento MCP Pattern)
Each entry starts at confidence 0.8. Confidence decays over configurable half-life. Below 0.3 = excluded from active use but remains searchable. Adoption by user raises to 1.0 and sets TTL to "never". Nothing is permanently deleted — entries move to archive.
- **Source**: github.com/gannonh/memento-mcp, github.com/scrypster/muninndb

### File-Based Memory Validation
Letta benchmarks show filesystem scored 74% on memory tasks, beating purpose-built vector-store libraries. The gains are in structure (organization and cross-references), not storage technology.
- **Source**: docs.letta.com, medium.com/@piyush.jhamb4u | **Implemented**: YES — file-based approach validated

### CoALA Memory Taxonomy (Princeton)
Four types: Working Memory (context window), Episodic (past events), Semantic (facts), Procedural (how-to).
Mapping: Working = context, Episodic = memory files, Semantic = CLAUDE.md, Procedural = skills + rules. Gap: automated episodic capture.
- **Source**: arxiv.org/abs/2309.02427

---

## 19. Open Source Discovery Methodology

### Separate Catalog from Endorsement (CNCF Pattern)
Broad discovery funnel (low bar: exists, has stars, fits a category) vs. strict endorsement gate (vetted, tested, recommended). The GH Scout system implements this as catalog.yaml (broad) vs. radar.md (strict).
- **Source**: github.com/cncf/landscape, contribute.cncf.io

### CHAOSS 4-Metric Starter Health Model
Minimum viable health check for any OSS project: (1) Time to First Response, (2) PR Closure Ratio, (3) Release Cadence, (4) Bus Factor / Org Diversity. From the Linux Foundation's CHAOSS project.
- **Source**: chaoss.community | **Implemented**: Yes — incorporated in vetting checklist

### OpenSSF Criticality Score vs Stars
Stars measure developer buzz; dependent count and Criticality Score measure actual ecosystem importance. A project with 200 stars but 50,000 dependents is more critical than one with 50,000 stars and 200 dependents. Public BigQuery dataset available.
- **Source**: github.com/ossf/criticality_score

---

## Sources Index

### Official
- [Best Practices](https://code.claude.com/docs/en/best-practices)
- [Common Workflows](https://code.claude.com/docs/en/common-workflows)
- [Memory](https://code.claude.com/docs/en/memory)
- [Hooks Guide](https://code.claude.com/docs/en/hooks-guide)
- [Settings](https://code.claude.com/docs/en/settings)
- [Subagents](https://code.claude.com/docs/en/sub-agents)
- [Agent Teams](https://code.claude.com/docs/en/agent-teams)
- [GitHub Actions](https://code.claude.com/docs/en/github-actions)
- [Cost Management](https://code.claude.com/docs/en/costs)
- [Model Config](https://code.claude.com/docs/en/model-config)
- [Scheduled Tasks](https://code.claude.com/docs/en/scheduled-tasks)
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference)
- [MCP Docs](https://code.claude.com/docs/en/mcp)

### Community (High Quality)
- [Builder.io: How I Use Claude Code](https://www.builder.io/blog/claude-code)
- [50 Claude Code Tips](https://www.builder.io/blog/claude-code-tips-best-practices)
- [Prompt Contracts](https://medium.com/@rentierdigital/prompt-contracts)
- [TDD with Claude Code](https://alexop.dev/posts/custom-tdd-workflow-claude-code-vue/)
- [Spec-Driven Development](https://alexop.dev/posts/spec-driven-development-claude-code-in-action/)
- [Claude Code Full Stack](https://alexop.dev/posts/understanding-claude-code-full-stack/)
- [GitHub: 45 Claude Code Tips](https://github.com/ykdojo/claude-code-tips)
- [GitHub: Ultimate Claude Code Guide](https://github.com/FlorianBruniaux/claude-code-ultimate-guide)
- [Context Optimization](https://claudefa.st/blog/guide/mechanics/context-management)
- [Writing a Good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- [Path-Specific Rules](https://paddo.dev/blog/claude-rules-path-specific-native/)
- [39 Claude Skills Examples](https://aiblewmymind.substack.com/p/claude-skills-36-examples)
- [Parallel Development with Worktrees](https://incident.io/blog/shipping-faster-with-claude-code-and-git-worktrees)
- [Awesome Claude Code](https://github.com/hesreallyhim/awesome-claude-code)
- [Awesome Claude Code Toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit)
- [SuperClaude Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework)
- [Self-Improving Bootstrap](https://gist.github.com/ChristopherA/fd2985551e765a86f4fbb24080263a2f)
- [KERNEL Self-Evolving Config](https://medium.com/@ariaxhan/kernel-the-ultimate-self-evolving-claude-code-and-cursor-configuration-system-a3ddeb7f4d32)
- [Claude Meta (Self-Improving CLAUDE.md)](https://github.com/aviadr1/claude-meta)
- [Auto-Logging Self-Improving](https://jngiam.bearblog.dev/the-instruction-that-turns-claude-into-a-self-improving-system/)
- [Claude Code Meta-Plugin](https://www.nickwinder.com/blog/claude-code-meta-plugin)
- [Meta Code Orchestrator](https://dev.to/gabrielgadea/claude-code-as-a-meta-code-orchestrator-when-the-ai-governs-itself-362)
- [Knowledge Management with Claude Code](https://mattstockton.com/2025/09/19/how-claude-code-became-my-knowledge-management-system.html)
- [Claude Code Swarms (Addy Osmani)](https://addyosmani.com/blog/claude-code-agent-teams/)
- [From Tasks to Swarms](https://alexop.dev/posts/from-tasks-to-swarms-agent-teams-in-claude-code/)
- [Agent Teams Multi-Agent Orchestration](https://shipyard.build/blog/claude-code-multi-agent/)
- [Claude Code Channels Guide](https://claudefa.st/blog/guide/development/claude-code-channels)
- [Hooks Guide 20+ Examples](https://aiorg.dev/blog/claude-code-hooks)
- [Advent of Claude Tips](https://dev.to/damogallagher/the-ultimate-claude-code-tips-collection-advent-of-claude-2025-5b73)
- [Miro AI Official Repo](https://github.com/miroapp/miro-ai)
- [Understand Anything (Codebase Knowledge Graph)](https://github.com/Lum1104/Understand-Anything)
- [Excalidraw Diagram Skill](https://github.com/edwingao28/excalidraw-skill)
- [Multi-Agent Agents Repo](https://github.com/wshobson/agents)
- [Ultrathink Guide](https://claudelog.com/faqs/what-is-ultrathink/)
- [LSP Integration Guide](https://karanbansal.in/blog/claude-code-lsp/)
- [Claude Cowork Launch](https://claude.com/blog/cowork-research-preview)
- [MCP Knowledge Graph](https://github.com/shaneholloman/mcp-knowledge-graph)

### Agent Architecture & Cross-Framework
- [ReWOO Paper](https://arxiv.org/abs/2305.18323)
- [LATS Paper](https://arxiv.org/abs/2310.04406)
- [CoALA Memory Taxonomy](https://arxiv.org/abs/2309.02427)
- [CSIRO Agent Design Patterns (18)](https://arxiv.org/abs/2405.10467)
- [System-Theoretic Agent Patterns (12)](https://arxiv.org/abs/2601.19752)
- [Difficulty-Aware Routing](https://arxiv.org/abs/2509.11079)
- [A2A Protocol (Google)](https://developers.googleblog.com/en/a2a-a-new-era-of-agent-interoperability/)
- [Google ADK Multi-Agent Patterns](https://developers.googleblog.com/developers-guide-to-multi-agent-patterns-in-adk/)
- [Awesome Agentic Patterns](https://github.com/nibzard/awesome-agentic-patterns)
- [Awesome Agentic System Design](https://github.com/gtzheng/awesome-agentic-system-design)
- [Awesome Self-Evolving Agents](https://github.com/EvoAgentX/Awesome-Self-Evolving-Agents)
- [Letta/MemGPT Memory Benchmarks](https://docs.letta.com/concepts/memgpt/)
- [Memento MCP (Confidence Decay)](https://github.com/gannonh/memento-mcp)
- [MuninnDB (Hebbian Learning)](https://github.com/scrypster/muninndb)

### Security Vetting
- [Snyk ToxicSkills Study](https://snyk.io/blog/toxicskills-malicious-ai-agent-skills-clawhub/)
- [Check Point — Claude Code CVEs](https://research.checkpoint.com/2026/rce-and-api-token-exfiltration-through-claude-code-project-files-cve-2025-59536/)
- [OWASP AI Agent Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/AI_Agent_Security_Cheat_Sheet.html)
- [OWASP MCP Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/MCP_Security_Cheat_Sheet.html)
- [Invariant Labs — MCP Tool Poisoning](https://invariantlabs.ai/blog/mcp-security-notification-tool-poisoning-attacks)
- [Docker Sandboxes for Coding Agents](https://www.docker.com/blog/docker-sandboxes-run-claude-code-and-other-coding-agents-unsupervised-but-safely/)
- [OpenSSF Scorecard](https://scorecard.dev/)
