# ADR-0006: Feature-first over layer-first folder structure

**Status:** Accepted
**Date:** 2026-07-28

## Context

Clean Architecture's four layers (domain, application, infrastructure,
presentation) need a folder structure. The two common shapes are
layer-first (`lib/domain/`, `lib/application/`, ... each containing every
feature's files) and feature-first (`lib/features/<feature>/` each
containing its own four layers).

## Decision

Feature-first: `apps/app/lib/features/<feature>/{domain,application,
infrastructure,presentation}/`.

## Alternatives considered

- **Layer-first** (`lib/domain/dashboard/`, `lib/domain/settings/`, ... /
  `lib/presentation/dashboard/`, ...) - rejected: understanding or deleting
  one feature means visiting five top-level folders and finding that
  feature's slice in each; as feature count grows, each layer folder
  becomes a flat list of every feature's files with no natural grouping.
  Feature-first makes "everything about the dashboard feature" a single
  directory.
- **Hybrid** (shared layers top-level, only presentation feature-scoped) -
  rejected as the default: partial feature-first still splits a feature's
  files across two homes for no benefit here; reconsider only if a specific
  layer (e.g. `domain/`) is proven small and stable enough that scattering
  it feature-first adds pure overhead - not assumed true at template scale.

## Consequences

- **Easier:** a feature is deletable/extractable/reviewable as one folder;
  a new contributor working on one feature never needs to open folders
  belonging to unrelated features.
- **Harder:** genuinely cross-feature domain concepts need a deliberate
  home (`packages/core` or a promoted shared package) rather than "just
  living in `lib/domain/`" - this is treated as a feature, not a bug: it
  forces the "is this really shared" question at the point of writing it
  in [`docs/architecture/PACKAGE_STRATEGY.md`](../architecture/PACKAGE_STRATEGY.md).
- **Forecloses:** a flat top-level `lib/domain/`, `lib/models/`, etc. -
  `./scripts/new_feature.sh` only scaffolds the feature-first shape.

## How this changes agent behavior

An agent creating a new feature must use `./scripts/new_feature.sh <name>`
and place all of that feature's domain/application/infrastructure/
presentation code under `features/<name>/`, never in a top-level
layer folder.
