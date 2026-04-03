---
description: Incremental build discipline for n8n workflows
paths:
  - "**/n8n/**"
  - "**/n8n-*/**"
---

# n8n Workflow Build Method

When building n8n workflows (via MCP or generating JSON), follow these rules strictly.

## Never Delete Working Nodes

When adding a new node to a workflow, you MUST preserve every existing node. Use `n8n_update_partial_workflow` for incremental changes when possible. If using `n8n_update_full_workflow`, include ALL existing nodes in the update — not just the new ones.

If the MCP validator rejects disconnected nodes, connect them (branch from trigger, or disable them) — do NOT remove them.

## Use Native Nodes First

Always search for the actual service node (e.g., Apify, Google Sheets, Slack) before using HTTP Request. Native nodes handle auth via n8n credentials and are easier to maintain. Only fall back to HTTP Request if no native node exists.

## Build One Node at a Time

1. Add ONE node, connected to what's already confirmed working
2. Tell the user what "success" looks like for that step
3. User executes in n8n UI and confirms
4. Only after confirmation, add the next node

Never build the entire workflow at once and test at the end. The chain grows organically from confirmed-working foundations.

## Read Before Write

Before updating any workflow, use `n8n_get_workflow` to read its current state. This prevents accidentally overwriting nodes added manually by the user in the n8n UI.
