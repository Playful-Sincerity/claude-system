When running research agents (subagents that search papers, books, web, or GitHub), ALWAYS save and cross-reference the detailed findings.

## Saving Agent Outputs

- Create a `research/[round-name]-agents/` directory
- Save each agent's full output as a separate `.md` file named by its stream/topic
- Include a `README.md` that maps each file to its stream, agent ID, and key sources
- Do this DURING the research process as agents complete, not after the fact

**How to extract:** Agent outputs are stored as JSONL in `.claude/projects/.../subagents/agent-[id].jsonl`. Extract the final assistant message with substantial text content (>1000 chars) — that's the research report. Use a Python extraction pattern: open the JSONL, iterate messages, find the last assistant message with `len(content) > 1000`, write it to a file.

## Cross-Referencing in Synthesis

The synthesis/summary document MUST link back to the raw agent files wherever it references their findings:

- When citing a finding, link to the specific agent file: `(see [stream-3a-neuroscience-validation.md](round4-agents/stream-3a-neuroscience-validation.md))`
- In each section of the synthesis, note which agent(s) produced the findings
- The comprehensive audit / living validation document should also link to the raw agent files for each claim

The raw agent outputs are the PRIMARY DATA. The synthesis is derived from them. Anyone reading the synthesis should be able to trace any claim back to the detailed agent output that produced it.

## Applies To

Any project with a research component.
