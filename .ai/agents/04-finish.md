# Stage 4 - Finish

**Trigger:** implementation is complete.

One pipeline stage, not three ad-hoc steps - self-review, commit, and PR
creation happen together so momentum at session-end doesn't skip the review.

## Steps

1. Run `./scripts/verify.sh` (format check, analyze, boundary check, tests,
   coverage gate). Fix everything it flags before proceeding - do not commit
   a red `verify.sh`.
2. Self-review against [`../roles/reviewer.md`](../roles/reviewer.md) as if
   this were someone else's PR. Check the acceptance criteria from the
   original ticket line by line.
3. Stage only the files the change actually touches (never a blanket `git
   add -A`). Commit using Conventional Commits with a scope
   (`feat(core): ...`).
4. Open the PR: title mirrors the commit type/scope, body links the ticket
   and summarizes *why*, not *what* (the diff already shows what).
5. Link the PR back to the ticket/issue.

## Output

A merged-ready PR: green `verify.sh`, a self-review pass, a linked ticket.
Hands off to external review, then [`06-review-feedback.md`](06-review-feedback.md)
when comments arrive.
