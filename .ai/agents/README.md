# Agent specs

One file per stage of [`../workflow/WORKFLOW.md`](../workflow/WORKFLOW.md).
These are tool-agnostic task specs - Claude Code exposes them as project
skills under `.claude/skills/<nn>-<name>/SKILL.md` (thin wrappers that point
here), but the specs themselves don't assume any particular tool.

| Stage | File | Input | Output |
|---|---|---|---|
| 1 | [01-intake.md](01-intake.md) | Issue/ticket ID or URL | Branch created, ticket status updated, briefing posted |
| 2 | [02-technical-analysis.md](02-technical-analysis.md) | Ticket + codebase | Root cause, affected files, risk, implementation plan - **no code** |
| 3 | [03-development.md](03-development.md) | Plan from stage 2 | Working code following [`../roles/implementer.md`](../roles/implementer.md) |
| 4 | [04-finish.md](04-finish.md) | Completed code | Self-review, commit, PR, ticket linked |
| 5 | [05-create-pr.md](05-create-pr.md) | Committed branch | PR opened (only if stage 4 was skipped) |
| 6 | [06-review-feedback.md](06-review-feedback.md) | Reviewer/QA comments | Prioritized, file-mapped fix plan |
| 7 | [07-review-fixes.md](07-review-fixes.md) | Applied fixes | Verification that fixes are complete + regression check |
| 8 | [08-merge-ready.md](08-merge-ready.md) | "Ready to merge?" | Go/no-go report against acceptance criteria |

Stage 5 is bracketed because stage 4 normally includes PR creation - it only
runs standalone when someone committed manually outside the pipeline.
