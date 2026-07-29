# Stage 6 - Review feedback

**Trigger:** comments arrive from a human reviewer, QA, or a bot - from any
source (PR comments, ticket comments, a pasted QA report).

Never respond to feedback ad-hoc, one comment at a time as they're read.
Triage the whole batch first.

## Steps

1. Collect every comment from every source into one list.
2. Group by type: correctness bug, missed acceptance criterion, style/nit,
   question needing clarification, out-of-scope suggestion.
3. Map each actionable item to a specific file and a specific fix - "handle
   the edge case" is not a plan, "null-check `user` in
   `dashboard_repository.dart:42`" is.
4. Flag anything genuinely ambiguous for clarification instead of guessing.
5. Hand the prioritized, file-mapped plan to
   [`03-development.md`](03-development.md) for fixes, or execute directly
   if trivial.

## Output

A prioritized fix plan (file + fix per item), separate from a "needs
clarification" list. This plan is the input to
[`07-review-fixes.md`](07-review-fixes.md).
