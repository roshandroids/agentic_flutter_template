# Contributing

This repository is documentation-first: for any change bigger than a typo fix,
the docs change alongside the code, in the same PR, not after.

## Before you start

1. Run `./scripts/bootstrap.sh` then `./scripts/doctor.sh` - fix anything it flags.
2. Read [docs/engineering/README.md](docs/engineering/README.md) (read order:
   goal → current sprint → next task → implementation rules).
3. If your change touches architecture (new package, new layer boundary, new
   state-management pattern), read [docs/architecture/README.md](docs/architecture/README.md)
   and write an ADR first: `./scripts/new_adr.sh "short title"`.

## Workflow

1. New feature: `./scripts/new_feature.sh <name>` scaffolds the four-layer
   structure under `apps/app/lib/features/<name>/` - do not hand-roll a
   different shape.
2. New reusable package: `./scripts/new_package.sh <name>` - only when the
   code is genuinely reused by 2+ apps or is a deliberate future-extraction
   candidate. Don't pre-extract a package "just in case" (see
   [docs/adr](docs/adr) for the extraction ADRs).
3. Keep these synchronized when behavior changes:
   - `docs/engineering/CURRENT_SPRINT.md` / `NEXT_TASK.md`
   - `docs/adr/` when a boundary or a hard technical decision changes
   - `docs/release/CHANGELOG.md` (or let `melos version` generate it from
     conventional commits)
   - the package's own `README.md` when its public API changes
4. Before opening a PR: `./scripts/verify.sh` (format check, analyze, boundary
   check, tests, coverage gate) - this is exactly what CI runs, so a green
   local run means a green PR.

## Documentation rules

- Never create placeholder documentation ("TBD", empty template left as-is).
- Never invent implementation details an ADR or research doc hasn't decided.
- Archive superseded material under `docs/archive/` instead of deleting it.
- Do not add a new top-level `docs/` folder without justifying it in the PR
  description (`template.config.yaml` sets
  `documentation.forbid_new_top_level_docs_folder_without_justification`).

## Code

- Follow [docs/architecture/DEPENDENCY_RULES.md](docs/architecture/DEPENDENCY_RULES.md) -
  `scripts/check_dependency_boundaries.sh` enforces it in CI, not just by convention.
- Follow [docs/architecture/CODING_STANDARDS.md](docs/architecture/CODING_STANDARDS.md).
- Every behavior change needs a test at the layer it changes (see
  [docs/testing/README.md](docs/testing/README.md)); pure doc/comment changes don't.
- Backend/analytics/payment SDKs live under `modules/`, never directly under
  `packages/` or `apps/app` - see [modules/README.md](modules/README.md).

## Commits & PRs

- Conventional Commits (`feat(core): ...`, `fix(app): ...`) - `melos version`
  and the changelog depend on this.
- Describe the *why*; link the relevant ADR / `NEXT_TASK.md` entry.
- Prefer small, reviewable diffs over one large PR.
