# Deep Web Research — Multi-Source with YouTube

When doing web research on any substantive topic (not quick lookups), augment standard web search with YouTube transcript analysis.

## When This Activates

- Any research task where you're forming an understanding of a topic
- Investigating trends, techniques, opinions, or state-of-the-art
- Gathering information to inform decisions, strategy, or creative work
- NOT for simple factual lookups ("what's the syntax for X")

## The Practice

### 1. Search Broadly, Then Go Deep

Standard web search gives you articles and docs. YouTube gives you practitioners thinking out loud, conference talks, podcast conversations, and expert debates. Both matter.

- After web search, also search YouTube for the topic (via WebSearch with "site:youtube.com" or "youtube <topic>")
- Pull transcripts using `python3 ~/claude-system/scripts/youtube-transcript.py <url>`
- Prioritize: recent uploads (< 6-12 months), high view counts relative to channel size, practitioners over commentators, long-form over clips

### 2. Source Attribution and Vetting

Every claim from web or YouTube research must be attributed:

- **Who said it** — name, role, affiliation, channel
- **Their perspective** — what's their angle? Selling something? Academic? Practitioner? Enthusiast?
- **Recency** — when was this published? Is it still current?
- **Corroboration** — does this align with other sources, or is it a lone voice?

No single source is gospel. Compose understanding from multiple voices. Flag where sources disagree.

### 3. Source Quality Signals

**Higher trust:**
- Practitioners sharing what they actually built/used (not what they read about)
- Conference talks at reputable venues
- Long-form conversations where ideas get pressure-tested
- People with skin in the game (building companies, publishing research, running teams)

**Lower trust (still useful, just weight accordingly):**
- Aggregator/summary content (often second-hand)
- Promotional content disguised as education
- Hot takes and reaction videos
- Anonymous or unverifiable sources

### 4. Synthesis Format

When presenting research findings, include:

- **Sources consulted** — list with type (article, video, paper, etc.) and key attribution
- **Points of agreement** — what multiple sources converge on
- **Points of disagreement** — where sources conflict and why
- **Recency assessment** — is this information fresh or potentially stale?
- **Confidence level** — how well-supported is each finding?

## Recency — Fast-Moving Domains

Some domains deprecate in weeks, not years. For these topics, treat recency as a hard filter, not just a preference:

**High-velocity domains** (AI tooling, Claude Code, agent architectures, LLM techniques, SaaS platforms, API ecosystems):
- Default to **last 3 months**. Content older than 6 months needs corroboration from a recent source before trusting.
- Check upload/publish date BEFORE pulling a transcript or reading an article. Don't waste time on stale content.
- When a video references a specific tool version, API, or feature — verify it still exists. Deprecation is silent.
- If you find conflicting info between an older popular video and a newer one, bias toward the newer source and flag the discrepancy.

**Slower domains** (physics, math, philosophy, history, psychology, business strategy):
- Recency matters less. A 2-year-old talk can still be definitive. Judge on substance.

This is especially critical for client consulting work — the AI ops landscape shifts monthly. A "best practice" from January 2026 may already be obsolete.

## YouTube-Specific Notes

- Auto-generated transcripts have errors — don't quote exact wording as authoritative, extract meaning
- Long videos (1hr+) are often the richest source — don't skip them for being long
- Check video description for links to papers, repos, or resources mentioned
- Channel subscriber count alone doesn't indicate quality — look at the content itself
- **Always note the upload date** in source attribution — a video's position in search results says nothing about its recency
