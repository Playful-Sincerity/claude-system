# Scout Schema — Entry Metadata Format

## Trust Tiers

| Tier | Criteria | Action |
|---|---|---|
| **T1: Official** | `anthropics/` org, official docs links, Anthropic employees | Adopt with confidence |
| **T2: Foundation-backed** | CNCF, OpenSSF, Linux Foundation, major org projects | Evaluate, likely adopt |
| **T3: Community-vetted** | >50 stars, multiple contributors, Scorecard >6, cited by 2+ independent sources | Full vetting, then adopt |
| **T4: Individual quality** | Single author, <50 stars, novel pattern, Scorecard >4 | Extract patterns only, never run code directly |
| **T5: Untrusted** | No stars, no history, Scorecard <4, suspicious patterns | Flag and skip |

## Radar Ring Definitions (ThoughtWorks-inspired)

- **Adopt**: It would be irresponsible NOT to use this, given our setup. Very few items earn this.
- **Trial**: Real production evidence exists. We or trusted sources have used it successfully.
- **Assess**: Worth investigating to understand its impact. No production requirement.
- **Hold**: Do not start new work with this. May be outdated, superseded, or risky.

## Catalog Entry Format (YAML)

```yaml
- name: "repo-name"
  url: "https://github.com/org/repo"
  description: "One-line description"
  discovered: YYYY-MM-DD
  last_verified: YYYY-MM-DD
  trust_tier: T1|T2|T3|T4|T5
  scorecard: 0-10       # OpenSSF Scorecard score (if available)
  stars: N
  contributors: N
  last_commit: YYYY-MM-DD
  license: MIT|Apache-2.0|etc
  confidence: 0.0-1.0   # starts at 0.8, decays with TTL
  ttl: never|90d|30d|14d|7d
  radar_ring: adopt|trial|assess|hold
  asset_types: [skill, agent, hook, rule, pattern, mcp, framework, concept]
  assets_extracted: []   # list of extracted asset filenames
  security_notes: "Clean — no injection patterns found"
  related: []            # other catalog entries this connects to
  tags: []               # searchable tags
```

## TTL by Content Type

| Content Type | TTL |
|---|---|
| Architectural patterns, design principles | never |
| Stable tool/framework configurations | 90d |
| Version-specific features | 30d |
| Community tips and trends | 14d |
| Dynamic data (pricing, availability) | 7d |

## Staleness Computation

`staleness_score = days_since_last_verified / TTL_days`
- Score > 1.0 → flagged for re-verification
- Score > 1.5 → moved to Hold ring pending review
- Entries with TTL "never" are exempt

## Asset File Naming Convention

Extracted assets go in `assets/{type}/` with the naming pattern:
`{source-repo}_{asset-name}.md`

Example: `superclaude_architect-persona.md`

Each asset file includes frontmatter:
```yaml
---
source_repo: "https://github.com/org/repo"
source_file: "path/to/original/file"
trust_tier: T3
extracted: YYYY-MM-DD
adapted: true|false   # whether we modified it from original
security_reviewed: true|false
notes: "What we changed and why"
---
```
