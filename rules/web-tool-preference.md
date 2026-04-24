# Web Tool Preference — WebFetch First, Firecrawl as Escalation

Firecrawl is a paid API. Every call costs credits and triggers a permission prompt. Most web content does not need it. This rule applies in every conversation.

## Default Tools

For any web retrieval task, try these first:

- **WebSearch** — for discovery / finding URLs
- **WebFetch** — for reading a specific URL
- **`python3 ~/claude-system/scripts/youtube-transcript.py <url>`** — for every YouTube video or podcast-on-YouTube, always. Never Firecrawl a YouTube URL.
- **Jina Reader shortcut** — if WebFetch returns messy HTML, prefix the URL with `https://r.jina.ai/` and WebFetch again. Free, no key, returns clean markdown.

## When to Use Firecrawl

Only reach for `mcp__firecrawl__*` if ALL of these are true:

1. The site is one of the known-problematic ones: `linkedin.com`, `twitter.com`, `x.com`, `instagram.com`, `facebook.com`, `tiktok.com`, or a site behind a JavaScript SPA / login wall
2. OR you already tried WebFetch on this exact URL in the current session and got empty, garbage, or obvious-JS-placeholder HTML back
3. The content is actually worth the Firecrawl credit (skip marginal pages)

## Explicit Do-Not List

Do NOT Firecrawl these even if the instinct says "be thorough":

- GoodReads, Patreon, Substack, Medium, WordPress blogs
- Podcast show-note pages, Spotify/Apple podcast pages, YouTube pages
- Institutional sites (`*.org`, `*.edu`, foundations, nonprofits, labs)
- GitHub (any subpath)
- Wikipedia, arxiv, news articles, academic bios, conference pages

These all work perfectly with WebFetch. Firecrawling them is waste.

## Default Search

Use `WebSearch`, not `mcp__firecrawl__firecrawl_search`. Only escalate to Firecrawl's search if WebSearch returned nothing and you specifically need full-page content inline with search results — which is rare.

## For Subagents

When spawning a research subagent, include this rule's summary in the agent prompt. Haiku follows forceful short rules; a paragraph in a skill is not enough. Lead with "WebFetch first. Do NOT Firecrawl [list]."

## When This Rule Activates

- Every conversation where web retrieval happens
- Every skill that dispatches research subagents (especially `/gh-scout` and other research-dispatching skills)
- Every plan that includes "research X on the web"

## Why This Matters

Beyond the per-call cost, reflex Firecrawl usage means the operator gets 10-20 permission prompts per research task, which both wastes his time and trains Claude Code to feel noisy and expensive. Tool discipline is table stakes for the [your larger system] where many agents will scrape at scale.
