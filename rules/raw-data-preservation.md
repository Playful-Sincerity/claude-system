# Raw Data Preservation

**Philosophy: Storage is cheap, context is expensive.**

When doing any research — web search, YouTube transcripts, API responses, scraped content, academic papers — save the raw text alongside any synthesis. Re-fetching is slow, wasteful, and sometimes impossible (IP blocks, dead links, paywalls, rate limits).

## When This Activates

- Any `WebFetch` or `WebSearch` result that informed the response
- Any YouTube transcript pulled via `youtube-transcript.py`
- Any Firecrawl/scraping output
- Any API response used for research or analysis
- Any PDF/document content extracted during research

## The Pattern

For any research task, create this structure in the project:

```
<project>/research/sources/
├── catalog.md              # Master index of everything fetched
├── transcripts/            # Raw YouTube transcripts (VIDEO_ID.md)
├── web/                    # Raw web page content (domain-slug.md)
├── search-queries/         # Search query + results (YYYY-MM-DD-query.md)
├── api-responses/          # Raw API JSON/XML
└── documents/              # PDF extracts, etc.
```

Each raw file gets a header:
```markdown
---
source_url: <full URL>
fetched_at: YYYY-MM-DD HH:MM
fetched_by: <Claude session or agent>
project: <project name>
---
```

Then the raw content below.

## The Catalog

`catalog.md` is the deduplication index. Before doing any research, check the catalog. If it's already there, use the saved version. Only re-fetch if the content is time-sensitive and the cached version is stale.

Catalog format:
```markdown
| Source | URL | Fetched | Stored At | Used In |
|--------|-----|---------|-----------|---------|
```

## Hierarchy of Synthesis

Raw data → summaries → syntheses → decisions. Each layer links back to the layer below.

- Decisions cite syntheses
- Syntheses cite summaries
- Summaries cite raw files
- Raw files are the ground truth

This makes it possible to audit any claim back to source.

## What NOT to Save

- Secrets, API keys, auth tokens that leaked into responses
- Personal data of third parties without consent
- Content that violates ToS to retain
- Duplicates (check the catalog first)

## When Re-fetching Is Required

- Time-sensitive data (prices, availability, news)
- Cached version is older than relevance window (define per project)
- Source explicitly updated

Otherwise: use the cached version.

## Why This Matters

Research that isn't cataloged gets redone. Redoing research wastes time, tokens, and API quota. Worse, it fragments the knowledge base — different sessions synthesize from different slices of the same underlying data, producing inconsistent conclusions.

The cataloged raw corpus is an accumulating asset. Every research session adds to it. Every subsequent session benefits. Over time, the corpus becomes more valuable than any individual synthesis built from it.

## Enforcement

Rule-level for now. When the [your larger system] Director is built, this pattern is inherited by default — every research heartbeat follows it. If compliance is low, escalate to a hook that verifies catalog updates after research tool use.
