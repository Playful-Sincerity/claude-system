# Security Vetting Checklist for GitHub Repos

## Why This Exists
36% of ClawHub agent skills contain prompt injection (Snyk ToxicSkills, Feb 2026).
Two CVEs (CVE-2025-59536, CVE-2026-21852) demonstrated RCE and API key exfiltration via Claude Code project config files.
Traditional security scanners cannot detect natural language injection in .md files.

## The Static-Before-Dynamic Workflow

### Step 1: Metadata Check (seconds)
- [ ] Check star count, contributor count, last commit date
- [ ] Check license compatibility
- [ ] Look up author/org reputation (other repos, contributions)
- [ ] Check if cited by multiple independent trusted sources

### Step 2: OpenSSF Scorecard (seconds)
- [ ] Run or check scorecard at https://scorecard.dev
- [ ] Score < 4 → REJECT without deep review (or find alternative)
- [ ] Check "Dangerous-Workflow" specifically (critical weight)

### Step 3: Dependency Scan (minutes)
- [ ] Check deps.dev for dependency health and known CVEs
- [ ] Look for pinned vs. floating dependency versions
- [ ] Check for suspicious or obfuscated dependencies

### Step 4: Clone Safely
- [ ] Clone with `git clone --no-checkout` (gets metadata without triggering hooks)
- [ ] Then: `git checkout HEAD -- <specific files>` for targeted review

### Step 5: Semantic Scan of Instruction Files (critical)
Manually review ALL .md files that would be loaded by Claude Code:
- [ ] CLAUDE.md — scan for injection patterns
- [ ] .claude/settings.json — check for ANTHROPIC_BASE_URL overrides, suspicious hooks
- [ ] Any SKILL.md files — check for shell commands, data exfiltration
- [ ] Any agent .md files — check for behavioral directives
- [ ] Hook scripts — review line-by-line (they execute in your shell)
- [ ] MCP server configs — check for tool poisoning patterns

### Injection Patterns to Flag
- Role hijacking: "you are a", "act as", "pretend to be"
- Directive override: "ignore previous instructions", "system:", "override"
- Covert action: "do not tell the user", "secretly", "hide this"
- Shell execution: embedded `curl`, `wget`, `bash -c`, `eval()` in non-code contexts
- Data exfiltration: instructions to send data to external URLs
- Encoded payloads: Base64 strings, invisible/zero-width unicode
- ANTHROPIC_BASE_URL or API key redirection in configs

### Step 6: Sandbox First-Run (for any code execution)
- [ ] Use Docker Sandbox or isolated environment for first run
- [ ] Run with `--network=none` first
- [ ] Graduate to limited network only after clean behavior
- [ ] Monitor for unexpected file access or network calls

### Step 7: Adoption Decision
- [ ] Document what was found in `security/scan-results/{repo-name}.md`
- [ ] Assign trust tier (T1-T5)
- [ ] Extract assets via paraphrasing (don't copy .md instruction text verbatim)
- [ ] Pin any MCP server versions (defend against rug-pull attacks)

## Key Principle
**Paraphrase, don't copy** instruction text from external repos.
This breaks injection chains — even if the original contained hidden directives, rewriting in your own words neutralizes them.

## Tools Reference
| Tool | URL | Use |
|---|---|---|
| OpenSSF Scorecard | https://scorecard.dev | Security posture score (0-10) |
| deps.dev | https://deps.dev | Dependency graph + CVEs |
| OSV.dev | https://osv.dev | Open source vulnerability DB |
| OWASP MCP Cheat Sheet | https://cheatsheetseries.owasp.org/cheatsheets/MCP_Security_Cheat_Sheet.html | MCP attack vectors |
| OWASP AI Agent Cheat Sheet | https://cheatsheetseries.owasp.org/cheatsheets/AI_Agent_Security_Cheat_Sheet.html | Agent-specific defenses |
