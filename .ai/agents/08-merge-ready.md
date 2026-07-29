# Stage 8 - Merge ready

**Trigger:** "is this done?" / "can I merge this?" - the final gate before merge.

## Checklist

- [ ] Every acceptance criterion in the ticket is met by the **current**
      diff (re-check against current state, not the original plan - scope
      drifts during implementation).
- [ ] PR is not in draft state; CI is green.
- [ ] QA/reviewer sign-off is present if the process requires it.
- [ ] Commits follow Conventional Commits; no "wip" / "fix typo" noise left
      unsquashed if the repo's convention is to squash.
- [ ] No dead code, no debug `print`/`log` statements, no commented-out blocks.
- [ ] No unresolved TODOs that should have been resolved by this change.
- [ ] `./scripts/verify.sh` is green on the final commit.
- [ ] Regression areas identified in stage 2/7 were actually tested, not just listed.

## Output

A go/no-go decision with a punch list of anything unmet - not a vague "looks
good," a specific list of what's done and what's missing.
