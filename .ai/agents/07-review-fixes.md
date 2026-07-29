# Stage 7 - Review fixes

**Trigger:** fixes from stage 6's plan have been implemented, before committing.

Verification is a distinct activity from fixing - a fix that silences the
comment without resolving the underlying issue is a common enough failure
mode to warrant its own stage.

## Steps

1. Check each fix against its item in the stage 6 plan - resolved, not just touched.
2. Re-run the acceptance criteria from the original ticket, not just the
   reviewer's specific comments - a fix can satisfy the comment and still
   miss the AC.
3. Identify regression risk: what else calls the code you just changed?
   Run the tests for those areas, not just the changed file's own tests.
4. Only once verified: commit and prepare to resubmit.

## Output

Confirmation each fix is complete and regression-checked, ready for
[`04-finish.md`](04-finish.md)'s commit step or directly for re-review.
