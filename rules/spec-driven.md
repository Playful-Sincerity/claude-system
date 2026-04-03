# Spec-Driven Development

## When to Use Specs
For any feature or project that will take more than one session to complete:
1. Interview the user about requirements, edge cases, constraints, and preferences
2. Write a SPEC.md or similar document capturing the full specification
3. Get explicit approval on the spec before implementing
4. Implement against the spec, not from memory of the conversation

## Spec Structure
```markdown
# [Feature/Project Name]

## Goal
[One paragraph — what and why]

## Requirements
[Numbered list of must-haves]

## Constraints
[What can't change, technical limits, style requirements]

## Architecture
[How it fits into existing code, which files change]

## Verification
[How to test that it works — specific test cases or validation steps]

## Open Questions
[Anything unresolved that needs the user's input]
```

## When NOT to Spec
- Single-file changes
- Bug fixes with clear reproduction steps
- Routine tasks (formatting, renaming, updating deps)
