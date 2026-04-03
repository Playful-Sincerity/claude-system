# Markmap & Advanced Patterns

## Markmap Reference

Plain Markdown with headings as hierarchy:
```markdown
# Central Idea

## Branch A
### Sub-branch
- Leaf 1
- Leaf 2

## Branch B
### Sub-branch
- Leaf 3
```

Render: `markmap input.md -o output.html --no-open`
Output: self-contained interactive HTML with zoom, pan, collapse/expand.

## Contrast Diagrams (What Is vs What Could Be)

Inspired by Duarte's sparkline. Place two states side-by-side:

```d2
direction: right

current: What Is {
  style.fill: "#2d2d2d"
  # Current state elements
}

future: What Could Be {
  style.fill: "#1a3a5c"
  # Future state elements
}

current -> future: "The Gap" {
  style.stroke-dash: 5
  style.animated: true
}
```

## Before/After Transformation
```d2
direction: right

before: Before {
  style.opacity: 0.6
  # Old state (grayed out)
}

after: After {
  style.stroke: "#4CAF50"
  style.stroke-width: 3
  # New state (highlighted)
}
```

## The SQVID in Practice

Same system, two SQVID settings:

**Simple + Vision** (for executives):
```d2
Users -> Platform -> Value
```

**Elaborate + Execution** (for engineers):
```d2
web_client: Web Client {shape: rectangle}
mobile_client: Mobile Client {shape: rectangle}
api_gateway: API Gateway {shape: rectangle}
auth: Auth Service {shape: rectangle}
core: Core Service {shape: rectangle}
db: PostgreSQL {shape: cylinder}
cache: Redis {shape: cylinder}
queue: RabbitMQ {shape: queue}

web_client -> api_gateway: HTTPS
mobile_client -> api_gateway: HTTPS
api_gateway -> auth: JWT verify
api_gateway -> core: gRPC
core -> db: SQL
core -> cache: get/set
core -> queue: publish
```

## Quick Reference: Choosing the Right Visual

| You want to show... | Use... | Think... |
|---|---|---|
| What something IS | Portrait / styled nodes | Who/What |
| How MUCH of something | Chart / sized elements | How Much |
| WHERE things are (spatial) | Map / positioned containers | Where |
| WHEN things happen | Timeline / Gantt | When |
| HOW something works | Flowchart / process | How |
| WHY something matters | Multi-variable / contrast | Why |
| A SYSTEM's structure | Architecture / nested containers | Where + How |
| An IDEA's branches | Mind map | Who/What + Where |
| A MESSAGE exchange | Sequence diagram | When + How |
| A TRANSFORMATION | Before/After contrast | Delta |
| A JOURNEY or ARC | Sparkline / phased timeline | When + Why |
