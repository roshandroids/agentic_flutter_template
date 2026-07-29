# ADR-0002: go_router for navigation

**Status:** Accepted
**Date:** 2026-07-28

## Context

The app needs adaptive navigation (bottom nav on mobile, nav rail on
tablet/desktop) behind a single shell, auth-gated routes, deep-link support
matching web URLs when built for web, and nested navigation for tabs that
keep their own back stack - all in a way that's testable without pumping a
full `MaterialApp` per test.

## Decision

Use `go_router` with `StatefulShellRoute.indexedStack` for the adaptive
shell, a `redirect` callback for auth guarding, and centralized typed routes
in `apps/app/lib/routing/`.

## Alternatives considered

- **Navigator 2.0 hand-rolled (RouterDelegate/RouteInformationParser
  directly)** - rejected: correct, but every project reimplements the same
  boilerplate go_router already solved; no benefit to hand-rolling it here.
- **auto_route** - rejected: comparable capability via code generation, but
  adds a build_runner dependency for routing specifically, on top of the
  one this template already accepts for `freezed`/`json_serializable`
  elsewhere. go_router's declarative API needs no code generation, which
  keeps one fewer thing to regenerate when a route changes.
- **Navigator 1.0 (imperative push/pop only)** - rejected outright: no deep
  link support and no clean way to express the shell + guard requirements
  above without significant hand-built infrastructure.

## Consequences

- **Easier:** deep links are free (route path = URL path on web); typed
  route helpers catch a broken navigation call at compile time instead of a
  runtime `Navigator` assertion.
- **Harder:** `StatefulShellRoute`'s nested-navigator state has a learning
  curve the first time a developer needs custom transition behavior between
  shell branches.
- **Forecloses:** ad-hoc `Navigator.push(MaterialPageRoute(...))` calls in
  feature code - all navigation must go through the typed router.

## How this changes agent behavior

An agent must never call `Navigator.push`/`Navigator.of(context)` directly
in feature code - add a route to `apps/app/lib/routing/app_router.dart` and
navigate through its typed helper instead. See
[`.ai/memory/decisions.md`](../../.ai/memory/decisions.md).
