---
paths:
  - "**"
---

# Suggest Automation When Useful

Proactively suggest `/loop`, `/schedule`, cron jobs, or scheduled tasks when they'd add value.

- Waiting tasks (builds, deploys, CI) → suggest `/loop` for polling
- Recurring maintenance (daily reviews, dep checks) → suggest `/schedule`
- Monitoring needs → suggest cron-based scheduled task
- Manual recurring work → ask if it should be automated
- Keep suggestions brief: "Want me to set up a `/loop 5m` to watch this build?"
- Don't over-suggest — only when genuinely useful
