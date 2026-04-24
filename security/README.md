# Security Knowledge Base

Central depot for security thinking, best practices, research, and learnings. Take security seriously — not paranoidly, but systematically.

## Philosophy

Security is a practice, not a product. It compounds: small consistent habits beat occasional heroics. The goal is a posture where good security is the default, not something you have to remember.

**Threat model.** Solo operator with many accounts, projects, and API keys across a macOS (or Linux) development environment. Not a high-profile target, but a high-surface-area one. The biggest risks are credential leaks, account takeover via weak 2FA, and supply chain compromise through dev tooling.

The Digital Core adds a specific concern: the model follows instructions from CLAUDE.md, memory files, skills, and agent configs without question. A compromised file means compromised behavior. That's why the `/audit` skill runs prompt-injection scans across all trusted instruction sources, and why the `bash-safety` and `web-content-safety` rules exist.

## Structure

| Directory | What Goes Here |
|---|---|
| **practices/** | Best practices organized by domain — dev security, infrastructure, communications, physical |
| **checklists/** | Actionable checklists for recurring security tasks |
| **research/** | Deeper dives into specific security topics |

Not included in the public release (operator-specific):
- Personal security stack (2FA choices, password manager, passkey layout)
- Incident post-mortems (tied to specific accounts and context)

If you're adopting this subsystem, add a `personal-stack.md` at the root of `security/` describing your own setup — what 2FA method, what password manager, what keychain, what endpoint protection. The act of writing it down is half the value.

## Related Rules

These are the behavioral directives the system runs by default. They live in `rules/`, not here, but they're the enforceable side of what this knowledge base describes:

- `bash-safety.md` — scans for command injection, exfiltration, reverse shells before execution
- `web-content-safety.md` — prompt-injection detection in fetched web content
- `memory-safety.md` — frontmatter conventions to avoid memory-file tampering

## How to Use This

Deposit anything security-related here. When you learn something new — a better practice, a vulnerability you read about, a near-miss — add it to the right place. The goal is that this grows into a comprehensive, personalized security reference over time.
