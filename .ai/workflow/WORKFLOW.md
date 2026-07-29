# Development lifecycle

The canonical shape of "doing a piece of work" in this repo. Every agent
spec in [`../agents/`](../agents/) is one stage of this pipeline. This isn't
aspirational - it's the actual sequence, so a new team member (or a fresh
agent session) can join at any stage and know what came before and what's next.

```
1. Intake         →  2. Technical      →  3. Development  →  4. Finish
   (understand         Analysis            (write the         (self-review,
   the ask,             (root cause,        code, following    commit, PR,
   set up branch,       affected files,     patterns found      link to
   Jira/issue           risk, plan -        in analysis)        tracker)
   status)              no code yet)

                                                                    │
                                                                    ▼
                                          6. Review-Feedback  ←  5. (external
                                             (QA / reviewer        review
                                             comments →             happens)
                                             prioritized fix
                                             plan)
                                                    │
                                                    ▼
                                          7. Review-Fixes
                                             (verify fixes are
                                             complete + no
                                             regressions)
                                                    │
                                                    ▼
                                          8. Merge-Ready
                                             (final go/no-go:
                                             AC met, tests green,
                                             no debug prints,
                                             no dead code)
```

## Why this shape

- **Analysis is a separate stage from development.** Writing code before
  understanding root cause and blast radius is how "quick fixes" become
  regressions. Stage 2 produces a plan; stage 3 executes it.
- **"Finish" bundles self-review + commit + PR into one gate**, not three
  ad-hoc steps, because skipping self-review is the single most common way
  low-quality PRs happen when a session is winding down and momentum says
  "just commit it."
- **Review-feedback and review-fixes are separate stages**, not "read
  comments, fix, done" - because verifying a fix actually resolved the
  reported issue (not just quieted the comment) is a distinct activity from
  triaging what to fix.
- **Merge-ready is a gate, not a formality.** It re-checks acceptance
  criteria against the *current* diff, not the diff as originally planned -
  scope drifts during implementation, and this stage catches that drift
  before it ships.

## Entry points

An agent (or human) can enter this pipeline at any stage - not every task is
a new feature starting at stage 1. Bug reports from QA enter at stage 6.
A tech-debt cleanup with no ticket enters at stage 3 directly. What matters
is knowing which stage you're in and reading that stage's [agent spec](../agents/)
before acting.

## Session handoff

If a session ends mid-pipeline, write
[`../handoff/HANDOFF_TEMPLATE.md`](../handoff/HANDOFF_TEMPLATE.md) filled in
under `../handoff/` before stopping, so the next session resumes at the right
stage instead of re-deriving context.
