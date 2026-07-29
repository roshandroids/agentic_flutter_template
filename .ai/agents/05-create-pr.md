# Stage 5 - Create PR (standalone)

**Trigger:** code was already committed outside the normal pipeline (stage 4
was skipped) and a PR is still needed.

## Steps

1. Confirm the branch is pushed and CI can see it.
2. Title: Conventional-Commit style, derived from the commit history - no
   ticket numbers in the title.
3. Body: summary of the change + link to the ticket/issue for full context.
4. Ask which reviewer to request and whether this should be a draft.
5. Link the PR back to the ticket as a remote link.

## Output

An open PR, linked to its ticket. Prefer [`04-finish.md`](04-finish.md) over
running this stage in isolation whenever possible - it already includes this.
