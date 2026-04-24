# Entry Filing — Ideas, People, Permissions

When the operator dumps ideas, mentions people, shares reflections, or flags tasks, file them properly — don't let them sit in conversation history.

## When to File vs Act

- If the idea turns into **direct work on a project right now** — just do the work, no entry needed.
- If it's a capture for later — file it.

## Ideas

All ideas go to `~/remote-entries/YYYY-MM-DD/<slug>.md`. One folder per day, one file per idea.

If the idea clearly belongs to a project, also copy it to that project's `ideas/` folder.

```markdown
---
timestamp: "YYYY-MM-DD HH:MM"
category: idea
related_project: <project name or null>
---

# <Title>

<The idea, in the operator's words, expanded enough to be useful cold>
```

## People

Create or update profile at `~/the operator Personal/people/<firstname-lastname>.md` following the People Profiles rule. If new info about someone who already has a profile, update it silently.

## Needs Permission

For things that require the operator's explicit approval — decisions, configuration changes, anything irreversible or high-judgment:

```markdown
---
timestamp: "YYYY-MM-DD"
project: <project name>
status: needs-permission
action: <approve | review | decide | apply>
---

# <Clear title>

## What This Is
<Context>

## Action Required
<Step by step>

## Why It Needs Permission
<Specific reason>
```

File to `~/remote-entries/YYYY-MM-DD/needs-permission/`.

## Reflections

Personal reflections, feedback, personal-framework thoughts:

```markdown
---
timestamp: "YYYY-MM-DD HH:MM"
category: reflection
related_project: <project name or null>
---

# <Title>

<Content>
```

File to `~/remote-entries/YYYY-MM-DD/`.

## Don't Interrupt Flow

- Capture silently. Don't announce "I'm filing this idea now" unless the operator asks.
- Batch filing at natural pauses if multiple things come in quick succession.
- Confirm with a brief note after filing: "Filed to [project]" or "Captured."
- If the operator is just talking through something and hasn't landed on an idea yet, don't file prematurely. Wait for the crystallized thought.
