---
name: digest
description: Process large data exports (ChatGPT, Claude, Drive, etc.) into organized, searchable, context-efficient knowledge archives with topic summaries and memory integration.
effort: high
---

# /digest — Large Data Export Processing Skill

Process large conversational or document exports into organized, searchable knowledge archives.
Produces: structured directory, searchable index, topic summaries, and memory integration.

## Usage

```
/digest <path-to-export>                    # Auto-detect format, full pipeline
/digest <path> --format=chatgpt             # Force ChatGPT export format
/digest <path> --format=claude              # Force Claude export format
/digest <path> --format=documents           # Generic document collection
/digest <path> --skip-summaries             # Index only, no AI summaries
/digest <path> --clusters-only              # Stop after clustering, review before summarizing
/digest <path> --update                     # Re-run summaries on existing archive
```

## Supported Formats

| Format | Detection Signal | Structure |
|--------|-----------------|-----------|
| ChatGPT | `conversations-*.json` files, `mapping` dict with tree-structured messages | UUID folders, audio, DALL-E images |
| Claude | `conversations.json` with `chat_messages` array, `projects.json` | Flat JSON, project docs |
| Documents | Directory of `.md`, `.txt`, `.docx`, `.pdf` files | Flat or nested directories |

Auto-detection: examine zip contents or directory structure before asking for format.

## Pipeline (6 Phases)

### Phase 1: Extract & Organize

**Goal**: Get raw data into a clean, predictable directory structure.

```
~/<Archive Name>/
├── CLAUDE.md                      # Archive documentation (generated)
├── conversations/                 # Raw conversation data (preserved as-is)
├── media/                         # Audio, images, uploads (if present)
│   ├── audio/
│   ├── dalle-generations/
│   └── user-uploads/
├── metadata/                      # User info, settings, manifests
├── clusters/                      # Pre-extracted text by topic (Phase 3)
└── summaries/                     # AI-generated topic summaries (Phase 4)
```

**Steps**:
1. If zip: extract to `~/<Source Name> Archive/`
2. Identify all content types (conversations, media, metadata, documents)
3. Organize into canonical directory structure
4. Skip redundant files (e.g., `chat.html` in ChatGPT exports — it's a 177MB rendered duplicate)
5. Write `CLAUDE.md` with structure documentation, data sensitivity notes, and cross-references

**Key decisions**:
- Archive lives at `~/` level, not nested inside a project
- Raw data is NEVER modified — only copied/moved into structure
- Sensitive files (user.json, emails, phone numbers) are flagged in CLAUDE.md

### Phase 2: Build Searchable Index

**Goal**: Machine-readable and human-readable indexes of all content.

**Output files**:
- `conversations-index.json` — Full index with: id, title, date, update_date, message_count, word_count, auto-tags, source_file
- `conversations-index.md` — Human-readable catalog grouped by topic cluster with quick stats table

**Auto-tagging approach**:
1. Define keyword → tag mapping for known project domains
2. First pass: match on conversation titles
3. Second pass: sample first 500 chars of first user message for untagged conversations
4. Tag conversations with multiple matching topics (multi-tag allowed)
5. Remaining untagged → "Uncategorized"

**Keyword map template** (customize per user):
```python
tags_map = {
    'Topic Name': ['keyword1', 'keyword2', 'keyword3'],
    # ... one entry per known project/domain
}
```

Build the keyword map from:
- Existing project directories (`~/` level)
- Memory file project names
- CLAUDE.md subproject lists
- Obvious title patterns in the data itself

**Index markdown format**:
```markdown
# Archive Name — Conversation Index

**Total**: N conversations | ~X words | date-range

## Quick Stats
| Topic | Count | Words |
|-------|-------|-------|

## Topic Name (N)
- **YYYY-MM-DD** | X,XXXw | N msgs | Title
```

### Phase 3: Cluster & Extract Text

**Goal**: Prepare manageable text chunks for summary agents.

**Steps**:
1. Group conversations by tag into logical agent-sized clusters
2. Merge small clusters (< 5 conversations) with thematically adjacent ones
3. Target: 4-8 clusters, each processable by one subagent
4. Extract conversation text with per-conversation word limits:
   - Small archive (< 500 convos): 3,000 words/conversation
   - Large archive (500+ convos): 2,000 words/conversation
   - Very large conversations: truncate with `... [truncated]` marker
5. Write each cluster to `clusters/<cluster-name>.txt`

**Cluster file format**:
```
# Cluster: <name>
# Tags: <tag1>, <tag2>
# Conversations: <count>

---
## [YYYY-MM-DD] Conversation Title (tags: X, Y, ~N words)

[User]: First message text...

[Assistant]: Response text...
```

**Text extraction rules**:
- Identify sender role: map to "User" (human) and "Claude"/"ChatGPT" (assistant)
- For ChatGPT: traverse the `mapping` tree following `parent`/`children` links
- For Claude: iterate `chat_messages` array directly
- Strip system messages, tool calls, and metadata — keep only human-readable text
- If project documents exist (Claude `projects.json`), extract those as a separate `project-docs.txt` cluster

### Phase 4: Summarize via Parallel Agents

**Goal**: Extract non-obvious insights from each cluster.

**Launch one subagent per cluster**, all in parallel. Each agent:
1. Reads its cluster `.txt` file
2. Writes a structured summary to `summaries/<archive-prefix>-<cluster-name>.md`

**Summary template**:
```markdown
# <Topic> — <Source> History Summary
## Source: N conversations (date range)

## Key Insights (non-obvious findings)
[Things that wouldn't be apparent from reading current project docs.
Skip generic summaries. Be specific with dates and decisions.]

## Evolution of Thinking (chronological)
[How ideas developed over time — trace the arc]

## Decisions Made & Why
[Explicit choices and their reasoning]

## Ideas Explored but Parked
[Things tried/discussed but not pursued — and why]

## Open Threads
[Unresolved ideas worth revisiting]
```

**Agent instructions** (include in every agent prompt):
- Focus on NON-OBVIOUS insights — things that add depth beyond current project docs
- Be specific with dates and decisions
- Note naming changes, scope shifts, and pivots
- Flag any recurring patterns in thinking style
- Identify the strongest unfinished ideas

**Recommended agent model**: `sonnet` (fast, sufficient for summarization)

### Phase 5: Integrate into Knowledge System

**Goal**: Connect archive insights to existing memory and project files.

**Principle: Recency wins.**
Existing memory files reflect the latest understanding.
Archive adds *historical context* only — never overwrites current state.

**Integration steps**:
1. **Update reference memory**: Create or update a reference memory file pointing to the archive with lookup instructions and summary file table
2. **Update MEMORY.md**: Add archive reference entry and relevant triggers
3. **Targeted memory updates**: For each project memory file, check if the archive reveals:
   - Name lineage or evolution not captured elsewhere
   - Key decisions and their reasoning
   - Parked ideas worth tracking
   - User research or validation data
   - Recurring patterns or signature thinking moves
4. **New project folders**: If the archive reveals substantial work on a domain without a project folder, create `~/<Project>/CLAUDE.md`
5. **Cross-reference existing project CLAUDE.md files**: Add archive section pointing to relevant summaries

**Memory update format** (append to existing files):
```markdown
## Historical Context (from <Archive Name>)

<Concise bullet points of non-obvious findings>

See `~/<Archive Name>/summaries/<file>.md` for full context.
```

**What NOT to push into memory**:
- Generic summaries of what was discussed
- Content already captured in current project docs
- Ephemeral details (specific conversation turns, timestamps of minor exchanges)
- Anything that can be found by reading the summary files directly

### Phase 6: Verify & Report

**Checklist**:
- [ ] All conversations indexed (count matches source)
- [ ] Media organized (not mixed with conversations)
- [ ] All topic clusters summarized
- [ ] New project folders created where needed (each with CLAUDE.md)
- [ ] Memory files updated (historical context sections, no info lost)
- [ ] Archive CLAUDE.md written with full structure documentation
- [ ] Cross-references between archive, memory, and project folders
- [ ] Offer to delete the source zip

**Report to user**:
- Total conversations/words processed
- Number of topic summaries written
- Memory files created/updated
- Biggest non-obvious findings (3-5 highlights)
- Any open questions or parked items worth revisiting

## Scaling Guidelines

| Archive Size | Conversations | Approach |
|-------------|---------------|----------|
| Small | < 100 | 3-4 clusters, can read more per conversation |
| Medium | 100-500 | 5-8 clusters, 3000 words/conversation |
| Large | 500-1000 | 6-10 clusters, 2000 words/conversation |
| Very large | 1000+ | 8-12 clusters, 1500 words/conversation, prioritize by recency |

For very large archives, consider a two-pass approach:
1. First pass: index and cluster everything, summarize only high-priority clusters (recent, project-relevant)
2. Second pass: summarize remaining clusters on demand

## Adding New Formats

To support a new export format, you need:
1. **Detection logic**: What files/structure identify this format?
2. **Message extraction**: How to get sender + text from the raw data?
3. **Metadata extraction**: What useful metadata exists (dates, models, attachments)?
4. Add a section to the format table and implement in the extraction script.

Common formats that could be added:
- Slack export (JSON per channel, threaded messages)
- Notion export (Markdown/CSV with nested pages)
- Obsidian vault (Markdown with `[[wikilinks]]`)
- Email export (MBOX/EML)
- Google Docs (via Drive API or Takeout)

## Design Principles

1. **Raw data is sacred** — never modify source files, only organize copies
2. **Recency wins** — archive adds historical context, never overwrites current knowledge
3. **Context-efficient** — summaries are the bridge; memory files link to them, don't absorb them
4. **Well-linked** — every summary references conversation IDs, every memory update references its source
5. **Incremental** — can deep-dive any conversation later; the index is the permanent entry point
6. **Self-documenting** — CLAUDE.md in every archive explains its own structure
7. **Parallel by default** — cluster extraction and summarization use parallel subagents
