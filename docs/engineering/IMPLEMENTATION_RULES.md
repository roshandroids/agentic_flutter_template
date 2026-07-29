# Implementation rules

Constraints that apply to every task, regardless of what's in
`NEXT_TASK.md`. This is the condensed, always-applicable subset of
[`../architecture/CODING_STANDARDS.md`](../architecture/CODING_STANDARDS.md)
and [`../architecture/DEPENDENCY_RULES.md`](../architecture/DEPENDENCY_RULES.md) -
read those for the full reasoning.

1. Search before writing - a new widget/provider/repository/util has
   likely already been written somewhere in `packages/` or a sibling
   feature. Duplication is the default failure mode to avoid.
2. Respect layer boundaries as you write, not as a final cleanup pass.
3. New architectural pattern → ADR first (`./scripts/new_adr.sh`).
4. Tests land with the code, same PR, same commit where practical.
5. `./scripts/verify.sh` green locally before opening a PR - it's exactly
   what CI runs.
6. No placeholder code or docs - see [`../README.md`](../README.md)'s rules.
