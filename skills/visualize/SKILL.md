---
name: visualize
description: "Visualize ideas, systems, and relationships as clear 2D diagrams — grounded in visual thinking philosophy (Roam, Duarte, Reynolds, Heath). Thinks before drawing: identifies the core idea, matches it to the right visual form, and renders with maximum signal and minimum noise."
effort: high
---

# /visualize — Visual Thinking & Diagram Generation

Make the invisible visible. Every diagram should help someone *see* what they couldn't see before — not just document what they already know.

> "There is no more powerful way to prove that we know something well than to draw a simple picture of it." — Dan Roam

## Philosophy

This skill is grounded in five books on visual communication:

- **The Back of the Napkin** (Dan Roam) — The 6W framework, SQVID, Look-See-Imagine-Show
- **Resonate** (Nancy Duarte) — Audience as hero, contrast structure, sparkline, S.T.A.R. moments
- **Slideology** (Nancy Duarte) — Signal-to-noise, 3-second rule, diagram taxonomy, design principles
- **Presentation Zen** (Garr Reynolds) — Restraint, empty space, analog-first thinking, amplification through simplification
- **Made to Stick** (Chip & Dan Heath) — SUCCESs: Simple, Unexpected, Concrete, Credible, Emotional, Stories

**Core belief:** A diagram is not a decoration. It is a thinking tool that makes complexity navigable. The goal is not to make something *pretty* — it is to make something *clear*.

## Usage

```
/visualize <description>                    # Think-first flow (recommended)
/visualize --type=portrait <desc>           # Who/What — entities, profiles, objects
/visualize --type=chart <desc>              # How Much — quantities, comparisons
/visualize --type=map <desc>                # Where — spatial relationships, positioning
/visualize --type=timeline <desc>           # When — sequences, phases, history
/visualize --type=flow <desc>              # How — processes, cause-and-effect
/visualize --type=plot <desc>              # Why — multi-variable relationships
/visualize --type=architecture <desc>       # Systems — nested containers (D2)
/visualize --type=mindmap <desc>            # Ideas — brainstorm, hierarchy (Markmap)
/visualize --type=sequence <desc>           # Messages — request/response (Mermaid)
/visualize --type=contrast <desc>           # What Is vs What Could Be (sparkline-style)
/visualize --type=er <desc>                 # Database schema (Mermaid)
/visualize --type=gantt <desc>              # Schedule/milestones (Mermaid)
/visualize --type=cloud <desc>              # Infrastructure (D2 + icons)
/visualize --sketch <desc>                  # Hand-drawn napkin aesthetic (D2 sketch mode)
/visualize --watch <desc>                   # Live-reload browser preview
```

## Workflow: Think Before Drawing

Inspired by Roam's four-step visual thinking process and Duarte's "ideas first, slides second."

### Step 0: Identify the Core Idea (The "Big Idea" Filter)

Before touching any DSL, answer:
- **What is the ONE thing this diagram must communicate?** (Duarte's Big Idea — a complete sentence with a point of view and what's at stake, not just a topic)
- **Who is the audience?** They are the hero — the diagram serves their comprehension, not the creator's ego
- **What should they DO after seeing this?** (Understand a system? Make a decision? See a problem?)

If the request is vague, ask ONE clarifying question. Not "what do you want?" but a specific diagnostic:
- "Is this about *who* is involved, *how much* of something, *where* things are, *when* things happen, *how* they work, or *why* they matter?"

### Step 1: LOOK — Gather the Raw Material

Extract from the description:
- **Entities**: What things exist? (nodes, actors, components)
- **Relationships**: How do they connect? What flows between them?
- **Groupings**: Are there natural clusters, layers, or hierarchies?
- **Tensions**: Where is the contrast? What is surprising? What doesn't fit?

### Step 2: SEE — Match the Problem to a Visual Form

Use Roam's **6W Framework** — every idea can be understood through six questions, and each maps to a specific visual form:

| Question | What You're Showing | Visual Framework | Best Backend |
|---|---|---|---|
| **Who/What** | Entities, traits, identity | **Portrait** — object defined by its own attributes | D2 (styled nodes) |
| **How Much** | Quantities, comparison | **Chart** — relative quantities on axes | Mermaid (pie, bar) or D2 |
| **Where** | Position in space | **Map** — spatial relationships | D2 (containers, layout) |
| **When** | Position in time | **Timeline** — sequence, phases | Mermaid Gantt or D2 |
| **How** | Cause and effect | **Flowchart** — influences, processes | Mermaid flowchart or D2 |
| **Why** | Multi-variable interaction | **Multi-variable plot** — 2+ dimensions | D2 (complex layout) |

**Combination types** (most real diagrams combine 2+ W's):
- Architecture = Where + How (spatial arrangement + data flow)
- Sparkline/Contrast = When + Why (temporal arc + meaning)
- Mind map = Who/What + Where (concepts + spatial clustering)

### Step 3: IMAGINE — Tune with the SQVID

Before drawing, run the idea through Roam's **SQVID** — five dials that tune the visualization to the audience:

| Dial | Question | Warm (Creative) | Cool (Analytic) |
|---|---|---|---|
| **S** | Simple or Elaborate? | Essence only, minimal | Full context, detailed |
| **Q** | Qualitative or Quantitative? | Feel, impression, sensory | Numbers, measurements, data |
| **V** | Vision or Execution? | Where we're going (ideal future) | How we get there (steps) |
| **I** | Individual or Comparison? | Standalone, focused | Side-by-side, relative |
| **D** | Delta or Status Quo? | What's changing | What is now |

**Default tuning by audience:**
- Executives/decision-makers → Simple + Qualitative + Vision + Comparison + Delta
- Engineers/implementers → Elaborate + Quantitative + Execution + Individual + Status Quo
- External/pitch audiences → Simple + Qualitative + Vision + Comparison + Delta
- Working sessions → Elaborate + Quantitative + Execution + Comparison + Delta

### Step 4: SHOW — Generate and Render

Now — and only now — write the diagram DSL.

**Apply these design principles while generating:**

#### Signal-to-Noise (Slideology)
Every element earns its place or gets cut. No decorative nodes. No redundant labels. No chartjunk. If an element can be removed without losing meaning, remove it.

#### The 3-Second Rule (Slideology)
The viewer should grasp the diagram's core message within 3 seconds of looking at it. If they can't, it's too complex — split it, simplify it, or add visual hierarchy.

#### Contrast Creates Meaning (Resonate)
Use visual contrast to direct attention:
- **Size** — the most important element should be largest
- **Color** — highlight the key element; gray out the rest
- **Position** — central = important; peripheral = supporting
- **Whitespace** — breathing room signals importance
- **Style** — bold vs. regular, solid vs. dashed

#### Amplification Through Simplification (Presentation Zen)
Strip to essential meaning. What you leave OUT matters as much as what you include. Empty space is an active design element, not wasted space.

#### Make It Stick (Made to Stick — SUCCESs)
Before finalizing, check:
- **Simple** — Is there one core idea? Can you state the takeaway in one sentence?
- **Unexpected** — Does anything break a visual pattern to capture attention?
- **Concrete** — Are labels specific (not abstract)? "PostgreSQL" not "Database Layer"
- **Credible** — Does the structure honestly represent the system? No misleading layouts
- **Emotional** — Does the viewer *care*? Is the human impact visible?
- **Story** — Is there a beginning, middle, end? A direction? A journey?

Not every diagram needs all six. But every diagram should nail Simple and Concrete.

## Backend Selection Logic

If `--type` is not specified, select based on description signals:

| Signal | Backend | Why |
|---|---|---|
| architecture, system, agents, components, services | **D2** | Nested containers, layout control |
| flow, process, decision, steps, workflow, how | **Mermaid** flowchart | Most LLM-reliable Mermaid type |
| sequence, API calls, request/response, messages | **Mermaid** sequence | Native strength |
| ideas, brainstorm, concepts, hierarchy, outline | **Markmap** | Markdown → interactive HTML |
| class, inheritance, interface, methods | **Mermaid** class | Standard UML |
| database, tables, relations, schema, ER | **Mermaid** ER | Entity-relationship native |
| timeline, schedule, milestones, phases, when | **Mermaid** Gantt | Timeline native |
| cloud, AWS, GCP, infrastructure, deploy | **D2** | Clean infra diagrams |
| who, what, portrait, profile, comparison | **D2** | Styled nodes with attributes |
| how much, quantities, metrics, data | **Mermaid** or **D2** | Chart-like layouts |
| contrast, before/after, what-is/could-be | **D2** | Side-by-side containers |

Default when ambiguous: **D2** — fewest dependencies, most reliable output.

## Prerequisites

Check for installed backends before generating. Install what's missing.

### D2 (primary — zero dependencies)
```bash
d2 --version
# Install: curl -fsSL https://d2lang.com/install.sh | sh -s --
```

### Mermaid CLI (flowcharts, sequence, class, ER, Gantt)
```bash
mmdc --version
# Install: npm install -g @mermaid-js/mermaid-cli
```

### Markmap CLI (mind maps)
```bash
markmap --version
# Install: npm install -g markmap-cli
```

Only install when needed. Fall back to available backends if user declines install.

## Generation & Validation

### File output
Write DSL to `diagrams/<descriptive-name>.<ext>` (create `diagrams/` if needed).
- D2: `.d2` → `.svg` or `.png`
- Mermaid: `.mmd` → `.svg`
- Markmap: `.md` → `.html`

### Validate-fix loop
```
write DSL → run renderer → check exit code
    if error: read error → fix DSL → retry (max 3 attempts)
    if success: confirm output exists
```

### Render commands
```bash
# D2
d2 diagrams/name.d2 diagrams/name.svg
d2 --sketch diagrams/name.d2 diagrams/name.svg           # Napkin aesthetic
d2 --layout=elk diagrams/name.d2 diagrams/name.svg       # Dense graphs
d2 --theme=200 diagrams/name.d2 diagrams/name.svg        # Dark theme
d2 --watch diagrams/name.d2 diagrams/name.svg            # Live reload

# Mermaid
mmdc -i diagrams/name.mmd -o diagrams/name.svg

# Markmap
markmap diagrams/name.md -o diagrams/name.html --no-open
```

### Report to user
- Source file path (editable)
- Output file path (viewable)
- Backend used
- The core idea the diagram communicates (one sentence)
- Suggest `--watch` for iteration

## Visual Design Defaults

### Layout and Composition
- **Readable at 1200px wide** — if >15 nodes, split into sub-diagrams
- **Visual hierarchy** — use size, color, and position to guide the eye (most important = largest, most central, most colorful)
- **Whitespace** — leave breathing room; overcrowded diagrams fail
- **Flow direction** — left-to-right or top-to-bottom (follows natural reading); reserve right-to-left for tension/conflict
- **Rule of thirds** — place key elements at intersection points, not dead center
- **Grouping by proximity** — related items close together; unrelated items apart

## DSL Reference

For syntax details, examples, and advanced patterns, see the knowledge files:
- `~/.claude/knowledge/visualize/d2-reference.md` — D2 shapes, connections, styling, containers, layout engines
- `~/.claude/knowledge/visualize/mermaid-reference.md` — Flowchart, sequence, class, ER, Gantt + LLM pitfalls
- `~/.claude/knowledge/visualize/markmap-and-patterns.md` — Markmap syntax, contrast diagrams, SQVID examples, visual chooser table

Read these on-demand when generating diagrams — no need to load them all upfront.

## Output Location

Default: `diagrams/` in current project root.
If running from home directory or outside a project, ask the user where to save.
