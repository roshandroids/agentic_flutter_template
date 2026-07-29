# ADR-0003: Melos monorepo + package strategy

**Status:** Accepted
**Date:** 2026-07-28

## Context

This template needs to support a single app today and, without
restructuring, a monorepo with multiple apps, extracted open-source
packages, and pluggable backend modules over its multi-year lifetime (this
is meant to be cloned and evolved for 5+ years, not a one-off scaffold).
Reusable code (`core`, `network`, `local_storage`, `design_system`) needs to
evolve in lockstep with the app that consumes it, in the same PR, without
publishing an intermediate version to test a change.

## Decision

Use Melos to manage a single Dart/Flutter workspace under `apps/`,
`packages/`, and `modules/`, resolved via Dart's native pub workspaces
(the root `pubspec.yaml`'s `workspace:` list, each member's
`resolution: workspace`) with Melos layered on top for scripting and
independent per-package versioning via Conventional Commits (`packages/core`
and `packages/design_system` do not share a version number).

## Alternatives considered

- **Multiple separate repos** (one per package) - rejected: a change
  spanning `core` + `app` would need two PRs and an intermediate published
  version just to test the pair together; far more overhead than this
  template's "minimize ceremony" goal accepts, for a benefit (independent
  repo permissions) this project doesn't need yet.
- **Bare native pub workspaces, no Melos** (just the root `pubspec.yaml`'s
  `workspace:` field, hand-rolled scripts for everything else) - rejected:
  pub workspaces alone give shared dependency resolution but nothing for
  independent per-package versioning/changelog generation or `exec`-style
  fan-out across packages - this template's release process and several
  `scripts/*.sh` depend on Melos providing that. Melos 7+ is itself built
  on top of pub workspaces (not an alternative to them - see its
  [migration guide](https://melos.invertase.dev/migrations/6xx-to-7xx)),
  so this isn't "Melos vs. native workspaces," it's "native workspaces,
  plus Melos's scripting layer on top" vs. "native workspaces alone."
- **A single flat `lib/` with no packages at all** - rejected: makes future
  extraction (open-sourcing `design_system`, reusing `core` in a second
  app) a large one-time migration instead of something that was designed
  in from the start.

## Consequences

- **Easier:** atomic cross-package PRs; `melos bootstrap` always links
  local packages to local packages, never a stale published version;
  `melos version` automates per-package changelogs from commit history.
- **Harder:** contributors need Melos installed (`scripts/bootstrap.sh`
  handles this); a first-time contributor needs to understand "which
  package does this file belong to" - mitigated by
  [`docs/architecture/PACKAGE_STRATEGY.md`](../architecture/PACKAGE_STRATEGY.md).
- **Forecloses:** treating `packages/*` as a place to dump anything
  reusable-ish - see `PACKAGE_STRATEGY.md`'s promotion criteria; premature
  extraction is an accepted anti-pattern here, not just a style preference.

## How this changes agent behavior

New reusable code is a `packages/*` package (via `./scripts/new_package.sh`),
never a `lib/shared/` folder inside `apps/app`. See
[`.ai/memory/decisions.md`](../../.ai/memory/decisions.md).
