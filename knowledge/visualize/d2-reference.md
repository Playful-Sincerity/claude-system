# D2 DSL Reference

## Shapes (Semantic)
```d2
user: User {shape: person}           # Human actors
db: PostgreSQL {shape: cylinder}     # Data stores
api: API Gateway {shape: rectangle}  # Services
storage: S3 {shape: cloud}          # Cloud/external
queue: Task Queue {shape: queue}    # Queues/buffers
config: Settings {shape: page}      # Documents/config
process: ETL {shape: hexagon}       # Processes/transforms
```

## Color Philosophy
- **One highlight color** for the most important element; everything else neutral
- **Dark theme** (`--theme=200`) for visual language consistency
- **Sketch mode** for napkin-style/presentation aesthetic
- Avoid rainbow palettes — they create noise, not meaning
- Color should encode meaning (green=good/go, red=problem/stop, blue=information, gray=background/supporting)

## Labels and Text
- Arrow labels describe **what flows** (data, signals, requests), not relationship type
- Node labels should be **specific and concrete** — "PostgreSQL" not "DB"
- Use **Markdown labels** for rich detail when needed
- Keep labels short — if it takes a sentence, the diagram needs restructuring

## Containers and Nesting
```d2
backend: Backend Services {
  api: API Server {shape: rectangle}
  worker: Background Worker {shape: hexagon}
  db: Database {shape: cylinder}
  api -> db: read/write
  api -> worker: enqueue
}

frontend: React App {shape: rectangle}
frontend -> backend.api: HTTP
```

## Nodes and Connections
```d2
server -> database: SQL queries       # Forward
response <- api: JSON                 # Reverse
frontend <-> backend: REST API        # Bidirectional
```

## Styling
```d2
node: {
  style: {
    fill: "#1a1a2e"
    stroke: "#4a90d9"
    font-color: "#ffffff"
    border-radius: 8
    bold: true
  }
}

a -> b: {
  style: {
    stroke-dash: 5
    stroke: "#ff6b6b"
    animated: true
  }
}
```

## Markdown Labels
```d2
explanation: |md
  ## Component Details
  - Handles authentication
  - Rate limited to 100 req/s
|
```

## Layout Engines
- `--layout=dagre` — hierarchical (default, fast)
- `--layout=elk` — better for dense graphs, cycles, agent systems
