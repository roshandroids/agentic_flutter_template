# Architecture Decision Records

One file per significant, hard-to-reverse decision - a package boundary, a
state-management or navigation choice, a persisted-data format, a
cross-cutting pattern. Not every decision needs one; a decision needs one
when reversing it later would be expensive or when the reasoning isn't
obvious from the code.

Use [`.ai/templates/ADR_TEMPLATE.md`](../../.ai/templates/ADR_TEMPLATE.md)
or `./scripts/new_adr.sh "title"`. Number sequentially, never reuse a
number even if an ADR is superseded - supersede by adding a new ADR that
says so.

## Index

- [ADR-0001](ADR-0001-riverpod-for-state-management.md) - Riverpod for state management
- [ADR-0002](ADR-0002-go-router-for-navigation.md) - go_router for navigation
- [ADR-0003](ADR-0003-melos-monorepo-package-strategy.md) - Melos monorepo + package strategy
- [ADR-0004](ADR-0004-result-failure-error-handling.md) - Result/Failure error handling
- [ADR-0005](ADR-0005-ai-single-source-of-truth.md) - `.ai/` as the single AI source of truth
- [ADR-0006](ADR-0006-feature-first-over-layer-first.md) - Feature-first over layer-first folder structure
- [ADR-0007](ADR-0007-diagnostics-only-module-registry.md) - Diagnostics-only module registry
