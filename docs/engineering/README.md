# Engineering

The live state of work - read in this order at the start of every session:

1. [`CURRENT_SPRINT.md`](CURRENT_SPRINT.md) - what this iteration is about.
2. [`NEXT_TASK.md`](NEXT_TASK.md) - the single next unit of work.
3. [`IMPLEMENTATION_RULES.md`](IMPLEMENTATION_RULES.md) - constraints that
   apply regardless of which task you're on.

**Why this exists separately from `architecture/`:** architecture describes
the system's shape and rarely changes; this folder describes what's
happening *right now* and changes constantly. Mixing the two means either
architecture docs rot with stale sprint noise, or engineering state has
nowhere to live. Keeping the fast-changing state here means
`docs/architecture/` stays a stable reference.

Update `CURRENT_SPRINT.md`/`NEXT_TASK.md` at the end of any session that
changes what's next - stale entries here are actively misleading, worse
than no entry.
