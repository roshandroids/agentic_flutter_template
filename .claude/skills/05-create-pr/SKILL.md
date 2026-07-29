---
name: 05-create-pr
description: Standalone PR creation when code was already committed outside the pipeline. Triggers on: "just create the PR", "I already committed, make a PR"
---

Follow [`.ai/agents/05-create-pr.md`](../../../.ai/agents/05-create-pr.md) exactly -
this file is a thin pointer, not a duplicate. Also read
[`.ai/workflow/WORKFLOW.md`](../../../.ai/workflow/WORKFLOW.md) for how this
stage fits the overall pipeline, and the relevant role(s) under
[`.ai/roles/`](../../../.ai/roles/).

Do not add stage-specific instructions to this file - edit
`.ai/agents/05-create-pr.md` instead, so Cursor/Copilot/ChatGPT/Gemini working
the same repo see the identical instructions (see
[ADR-0005](../../../docs/adr/ADR-0005-ai-single-source-of-truth.md)).
