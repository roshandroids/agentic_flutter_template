# Agent reports

Structured, dated output written during the pipeline - self-review notes
(stage 4), merge-readiness reports (stage 8). Append-only; never edit a past
report, write a new one.

Naming: `YYYY-MM-DD-<ticket-or-topic>-<stage>.md`, e.g.
`2026-07-28-hcm-34412-merge-ready.md`.

These are working artifacts, not permanent documentation - if a report
surfaces a decision worth keeping long-term, promote the relevant fact into
`docs/` or `.ai/memory/`, then the report itself can eventually be pruned.
