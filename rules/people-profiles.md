# People Profiles — Recognize, Recall, Record

When the operator mentions someone by name, check if context exists. Keep a two-tier system: the CSV/CRM for everyone, markdown profiles for people who are contextually relevant to projects.

## Two-Tier System

### Tier 1: CSV/CRM (base layer — everyone)
`~/the operator Personal/the operators Network/contacts.csv` — the full network. Messaging stats, phone numbers, voice-enriched notes, event tags. This is the ground truth for "who does the operator know." Contacts get enriched here through the the operators Network enrichment process.

### Tier 2: Markdown Profiles (elevated — project-relevant people)
`~/the operator Personal/people/<firstname-lastname>.md` — standalone profiles for people who are contextually relevant to PS projects, active collaborators, or frequently discussed. These exist because:
- They connect to specific projects ([client-work], PS collaborators, co-founders)
- They come up in conversation repeatedly
- Their context is too rich for a CSV row
- Quick lookup without opening the full CSV

**Not everyone needs a markdown profile.** People enriched through the normal CSV process don't get promoted unless they become project-relevant.

## When This Activates

- the operator mentions a person's name in conversation (not historical figures or public celebrities)
- the operator shares new information about someone who already has a profile
- A person comes up in project context who should be linked to that project

## The Check

When you notice a name:

1. **Check memory** — scan `MEMORY.md` for existing `user_*` entries about this person
2. **Check profiles** — look for `~/the operator Personal/people/<name>.md`
3. **Check CSV** — the person may exist in `contacts.csv` with enrichment data
4. **If profile found:** silently note what you know. Update if new information emerges (batch at natural pauses)
5. **If CSV only:** use the enrichment data for context. Promote to markdown profile only if the conversation reveals project relevance
6. **If NOT found anywhere:** build a profile from what's been said if they're project-relevant; otherwise just note them for future reference

## Markdown Profile Template

```markdown
# <Full Name> — <One-Line Role/Relationship>

## Category
<Family | Friend | Collaborator | Client | Advisor | Community>

## Relationship to the operator
<How the operator knows them, nature of relationship>

## Background
- <What they do, their expertise, their situation>

## Network Connections
- <Other people in the operator's network they connect to>

## Collaboration Areas
- **<Project>** — <how they're involved or could be>

## Key Details
- <Contact info if shared>
- <Location, company, etc.>

## Key Dates
- <Important dates, milestones in the relationship>

## Open Questions
- <Things the operator might want to learn/discuss next>
```

Not every section needs content — only fill what's known. Profiles grow over time.

## Categories

Tag each markdown profile with one primary category:
- **Family** — parents, siblings, partners
- **Friend** — Personal relationships
- **Collaborator** — Active project collaborators
- **Client** — [your project] or other business clients
- **Advisor** — People who provide guidance (Eric, Vince, etc.)
- **Community** — Event community, dance community, etc.

## Memory Pointer

Every person with a markdown profile also gets a memory file at:
```
~/.claude/projects/-Users-[user]/memory/user_<firstname_lastname>.md
```

The memory file is a **brief pointer** (3-5 lines) — just enough for cross-conversation recall. The full profile lives in `~/the operator Personal/people/`.

Memory description format: `<Name> — <relationship>. <1-line context>. Full profile at ~/the operator Personal/people/<file>.md`

## Project Linking

When a person is relevant to a specific project:
- Note the project connection in their profile under "Collaboration Areas"
- If the project has its own people/contacts system (like [your project]'s CRM), keep that system authoritative for project-specific data — the personal profile captures the full relationship

## What NOT to Markdown-Profile

- People only in the CSV with no project relevance (they're already captured)
- Public figures, historical people, celebrities (unless the operator has a personal connection)
- People mentioned in passing with no context ("my friend said X" where the friend is unnamed)
- Service providers with no ongoing relationship

## Updating

- Don't interrupt conversation flow to announce updates — do it silently
- Batch updates at natural pauses (end of a topic, task completion)
- Convert relative dates to absolute dates ("last week" → "2026-03-27")
- If information contradicts what's in the profile, update the profile and note what changed
- Keep CSV and markdown profile consistent — if you update one, check the other

## CSV ↔ Markdown Sync

When a markdown profile exists AND the person is in the CSV:
- The CSV's `raw_notes` and messaging stats provide quantitative context
- The markdown profile provides qualitative, project-linked context
- Neither replaces the other — they complement
- If the operator enriches someone in the CSV and they're project-relevant, consider promoting to markdown
