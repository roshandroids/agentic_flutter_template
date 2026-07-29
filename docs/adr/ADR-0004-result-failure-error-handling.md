# ADR-0004: Result/Failure error handling

**Status:** Accepted
**Date:** 2026-07-28

## Context

Every layer above infrastructure needs to distinguish "this operation
failed in an expected, handleable way" (network timeout, 404, validation
error) from "this is a bug" (a null a precondition should have prevented, an
unreachable switch branch). Flutter's default idiom - throwing exceptions
for both - forces every caller to guess which `catch` clauses are worth
writing, and it's easy to let an expected failure silently propagate as an
unhandled exception that crashes a widget tree.

## Decision

`packages/core` defines a sealed `Result<T, F extends Failure>` (`Ok<T>` /
`Err<F>`) and a `Failure` class hierarchy (`NetworkFailure`,
`ValidationFailure`, `NotFoundFailure`, `UnexpectedFailure`, etc.).
Repositories, use cases, and `ApiClient`/`Storage` implementations return
`Result`, never throw, for any outcome a caller is expected to handle.
`throw` remains reserved for genuine programmer errors.

## Alternatives considered

- **`dartz`'s `Either<L, R>`** - rejected: functionally similar, but
  `Either` is generic or-of-two-things; a purpose-built `Result`/`Failure`
  hierarchy reads as intent ("this is the failure path") rather than
  requiring every reader to remember "Left is the error side" project-wide.
  Also removes a dependency on a package whose functional-programming API
  surface (bifunctor, monad transformers) is far larger than this
  template's actual need.
- **`try`/`catch` everywhere, no `Result` type** - rejected: leaves it to
  convention (easy to forget) whether a given call can throw and what for;
  a `Result<T, Failure>` return type makes the failure path visible at the
  call site and at the type level, and the compiler flags an unhandled
  `Err` branch via exhaustive `switch`.
- **`freezed` union type per feature for its own error type** - rejected as
  the *only* mechanism: per-feature error types would mean no shared
  `ErrorView` mapping and no shared retry-on-`NetworkFailure` logic. A
  shared `Failure` hierarchy in `core`, extended per-feature only when a
  feature has a genuinely unique failure case, gets both consistency and
  extensibility.

## Consequences

- **Easier:** `packages/design_system`'s `ErrorView` can render any
  `Failure` generically; a repository's public contract states exactly
  what can go wrong, visible in its return type.
- **Harder:** slightly more verbose call sites than a bare `await` (a
  `.when`/`switch` on the result) - accepted as the cost of explicit error
  handling.
- **Forecloses:** throwing for an expected failure path anywhere above
  infrastructure - a `throw NetworkException()` from a repository is a bug
  under this ADR, not a style choice.

## How this changes agent behavior

An agent implementing a repository or use case must return
`Result<T, Failure>` for any outcome the caller should branch on, and must
never silently discard the `Err` branch. See
[`.ai/memory/decisions.md`](../../.ai/memory/decisions.md) and
[`docs/architecture/CODING_STANDARDS.md`](../architecture/CODING_STANDARDS.md).
