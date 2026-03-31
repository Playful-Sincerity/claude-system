# Claude Code Meta-System Architecture

A working architecture for treating Claude Code configuration as a first-class software project.

Built on a **three-layer model** inspired by PSSO (Personal & Social Systems Optimization):

1. **Foundations** (Identity & Guardrails) -- CLAUDE.md, rules, hooks, permissions
2. **Methods** (Capabilities & Knowledge) -- Skills, knowledge base, scripts, memory
3. **Domains** (Project-Specific) -- Agents, per-project config, experiments

## What's Here

| Directory | Contents |
|---|---|
| `docs/` | Architecture documentation, PSSO-to-agent mapping |
| `templates/` | Starter templates for skills, agents, rules |
| `examples/` | Sanitized examples of real configurations |

## Key Ideas

- **Canonical source + symlinks**: One git-tracked directory (`~/claude-system/`) is the source of truth. `~/.claude/` directories are symlinks pointing there. This gives you version control without fighting Claude Code's expected paths.

- **Skills as markdown**: Each skill is a `SKILL.md` file with structured instructions. No runtime code needed -- Claude follows the markdown protocol.

- **Rules with scope**: Rules use YAML frontmatter `paths:` to apply only where relevant. Global rules stay small; project-specific rules go in project CLAUDE.md files.

- **Memory as a system**: Persistent memory files with typed frontmatter (user, feedback, project, reference). An index file (`MEMORY.md`) acts as the table of contents loaded each session.

- **Automated health checks**: Hook scripts run at session start for pre-flight checks (uncommitted changes, missing gitignore, etc).

## Philosophy

This system treats Claude Code configuration the way PSSO treats personal development: as something that benefits from systematic tracking, reflection, and intentional evolution. The journal tracks *why* decisions were made, not just what changed.

## License

MIT
