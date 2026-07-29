# Architecture docs

| File | Content |
|---|---|
| [`ARCHITECTURE.md`](ARCHITECTURE.md) | The layered, feature-first shape of the app: domain/application/infrastructure/presentation, state management, navigation, DI, storage, networking. |
| [`CODING_STANDARDS.md`](CODING_STANDARDS.md) | Naming, structure, and style rules beyond what the linter enforces. |
| [`DEPENDENCY_RULES.md`](DEPENDENCY_RULES.md) | What each package/layer may and may not import - and how that's enforced in CI, not just by convention. |
| [`PACKAGE_STRATEGY.md`](PACKAGE_STRATEGY.md) | When code becomes a `packages/*` package vs. staying in `apps/app/lib/features/`. |

Decisions that changed one of these (a new pattern, a new boundary) get an
ADR under [`../adr/`](../adr/) first - this folder describes the *current*
state; `adr/` explains *why* it's the current state and what was rejected.
