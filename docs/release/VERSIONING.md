# Versioning

Each `packages/*` package is versioned independently (semver), driven by
Conventional Commits scoped to that package (`feat(core): ...`,
`fix(design_system): ...`). `apps/app` itself uses build-number versioning
(`pubspec.yaml`'s `version: 1.0.0+N`), incremented per store submission, not
per commit.

**Why independent, not lockstep:** `design_system` changing far more often
than `core` is expected and healthy - forcing every package to the same
version number on every release would make the changelog noisy and the
version number meaningless (a "v2.3.0" that only touched
`design_system` looks like a `core` change to a downstream consumer).

## Process

```bash
./scripts/release.sh
```

wraps `melos version` (bumps only packages with commits since their last
tag, generates each package's `CHANGELOG.md` from commit messages) then
pushes tags. `.github/workflows/release.yml` runs the same thing on
`workflow_dispatch` - deliberate, not automatic on every merge to `main`.

## Publishing to pub.dev

Manual, per-package, via `.github/workflows/package_publish.yml`
(`workflow_dispatch`, dry-run by default). See that workflow's comments for
why publishing is never automatic.
