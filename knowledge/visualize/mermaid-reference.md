# Mermaid DSL Reference

## Flowchart
```mermaid
flowchart TD
    A[Start] --> B{Decision}
    B -->|yes| C[Action]
    B -->|no| D[Other Action]
    C --> E[End]
    D --> E
```

## Sequence Diagram
```mermaid
sequenceDiagram
    participant U as User
    participant A as API
    participant D as Database
    U->>A: POST /create
    A->>D: INSERT
    D-->>A: OK
    A-->>U: 201 Created
```

## Class Diagram
```mermaid
classDiagram
    class Animal {
        +String name
        +move()
    }
    class Dog {
        +bark()
    }
    Animal <|-- Dog
```

## ER Diagram
```mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ LINE_ITEM : contains
    PRODUCT ||--o{ LINE_ITEM : "is in"
```

## Gantt Chart
```mermaid
gantt
    title Project Timeline
    dateFormat YYYY-MM-DD
    section Phase 1
    Research    :a1, 2026-01-01, 30d
    Design      :a2, after a1, 20d
    section Phase 2
    Build       :b1, after a2, 45d
```

## Known LLM Pitfalls
- Parentheses in labels: use `A["label (detail)"]` with quotes
- Special characters in edge labels: wrap in quotes
- `architecture-beta`: unreliable, prefer D2
- Subgraph nesting >2 levels: often malformed
