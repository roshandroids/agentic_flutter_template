# Stage 3 - Development

**Trigger:** a technical analysis plan exists.

## Steps

1. Follow [`../roles/implementer.md`](../roles/implementer.md).
2. Before writing a new widget/provider/repository, search for an existing
   one in `packages/design_system`, `packages/core`, and sibling features -
   duplication is the default failure mode here, not the exception.
3. New feature → `./scripts/new_feature.sh <name>` for the four-layer
   scaffold. Do not hand-roll a different folder shape.
4. Respect layer boundaries as you go, not as a final check -
   `packages/core` importing `package:flutter` is a stage-3 mistake to avoid,
   not a stage-4 fix.
5. Add tests at the layer you changed as you write the code, not after
   ("add tests" is not a separate future step).
6. If you discover the plan from stage 2 was wrong (missing file, wrong root
   cause), update the plan and say so - don't silently implement a different
   approach than what stage 2 decided.

## Output

Working code + tests for the planned change, ready for
[`04-finish.md`](04-finish.md).
