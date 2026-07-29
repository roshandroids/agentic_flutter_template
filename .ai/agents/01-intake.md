# Stage 1 - Intake

**Trigger:** a new ticket/issue is picked up, or a session resumes one already in progress.

## Steps

1. Resolve the ticket: read its description, acceptance criteria, and any
   linked design/spec. If the ticket references a Figma file, load it before
   forming an opinion on scope.
2. Repository hygiene: confirm `main` is clean and up to date
   (`./scripts/doctor.sh` should be green). Do not branch from a dirty tree.
3. Branch: `<type>/<ticket-id>-<short-slug>` (`feat/`, `fix/`, `chore/`).
4. If the tracker supports status transitions, move the ticket to
   "in progress" and post a short comment noting the branch name.
5. Hand off to [`02-technical-analysis.md`](02-technical-analysis.md) - do
   not start writing implementation code from this stage.

## Output

A branch, an updated ticket status, and a one-paragraph restatement of the
ask in your own words (surfaces misunderstandings before analysis begins).
