# Stage 2 - Technical analysis

**Trigger:** intake is done; before any code is written.

No code is written during this stage. The output is a plan, not a diff.

## Steps

1. Locate every file the change touches or must be consistent with - name
   them explicitly, don't say "the relevant files."
2. Identify the architectural layer(s) involved (domain / application /
   infrastructure / presentation - see
   [`../../docs/architecture/README.md`](../../docs/architecture/README.md))
   and check [`../../docs/architecture/DEPENDENCY_RULES.md`](../../docs/architecture/DEPENDENCY_RULES.md)
   for any boundary the change might cross.
3. Check for existing patterns to reuse: search `packages/` and
   `apps/app/lib/features/` for a similar feature before proposing a new
   abstraction. Note what's reusable and what genuinely needs to be new.
4. If the change is architectural (new package, new persisted format, new
   cross-cutting pattern), stop and draft an ADR
   (`./scripts/new_adr.sh "title"`) before proceeding to stage 3.
5. Write the plan: root cause (for bugs) or approach (for features),
   file-by-file changes, risk areas, edge cases, and what regression areas
   to watch (see [`../../docs/testing/README.md`](../../docs/testing/README.md)).

## Output

A written plan the implementer (stage 3) can execute without re-deriving
root cause. If a decision in the plan is non-obvious, it belongs in an ADR,
not buried in the plan text.
