# ADR-0001: Riverpod for state management

**Status:** Accepted
**Date:** 2026-07-28

## Context

The app needs one state-management approach used consistently across every
feature, that also doubles as the dependency-injection mechanism (see
[ADR-0003](ADR-0003-melos-monorepo-package-strategy.md) for why a second DI
tool wasn't added on top). It needs to support async data (network + local
storage), be testable without a widget harness for non-widget state, and
scale from a single counter to a graph of interdependent feature providers
without the wiring becoming unreadable.

## Decision

Use `flutter_riverpod` (code-generation-free, `Provider`/`Notifier`/`AsyncNotifier`
API) as the only state-management and dependency-injection mechanism in
this repository.

## Alternatives considered

- **Bloc/Cubit** - rejected because it requires an event class per state
  transition for simple cases, adding ceremony that doesn't pay for itself
  in a template meant to minimize boilerplate for a new feature. Riverpod's
  `AsyncNotifier` covers the same state machine with less code for the
  common case.
- **Provider (package:provider) alone** - rejected because it isn't a DI
  solution by itself (no easy override-for-testing without an
  InheritedWidget rebuild) and doesn't handle async state as a first-class
  concept the way `AsyncValue` does.
- **GetIt + ChangeNotifier** - rejected because it's two mechanisms (a
  service locator for DI, ChangeNotifier for state) instead of one, and a
  service locator's dependencies aren't visible in the widget tree or
  overridable per-test the way a provider graph is.
- **flutter_bloc + get_it** - same two-mechanism objection, plus more
  boilerplate per feature than this template's "minimize ceremony for a new
  feature" goal accepts.

## Consequences

- **Easier:** one mental model for state and DI; `ProviderScope.overrides`
  gives trivial test doubles without a mocking framework for the wiring
  itself; `AsyncValue` gives consistent loading/error handling for free.
- **Harder:** developers unfamiliar with Riverpod (vs. the more ubiquitous
  Bloc in some enterprise Flutter shops) have a small ramp-up cost -
  mitigated by [`docs/architecture/ARCHITECTURE.md`](../architecture/ARCHITECTURE.md)'s
  concrete patterns section.
- **Forecloses:** using a second state-management library "just for this
  one feature" - if Riverpod genuinely can't express a need, that's an ADR
  of its own, not a silent exception.

## How this changes agent behavior

An agent must never introduce `setState`-based state for anything beyond a
single widget's purely-local, non-shared UI state (e.g. a `TextField`'s
focus animation), never a second DI mechanism, and never a `ChangeNotifier`-based
alternative. See
[`.ai/memory/decisions.md`](../../.ai/memory/decisions.md).
