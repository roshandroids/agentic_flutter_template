# core

Domain-layer foundation shared by every package and app in this workspace.

## What's here

- `Result<T, Failure>` / `Ok` / `Err` - the error-handling type every
  repository and use case returns instead of throwing for expected
  failures. See [ADR-0004](../../docs/adr/ADR-0004-result-failure-error-handling.md).
- `Failure` and its subtypes (`NetworkFailure`, `ValidationFailure`,
  `NotFoundFailure`, `UnauthorizedFailure`, `UnexpectedFailure`).
- `ApiClient` - the interface `packages/network`'s `DioApiClient` implements.
- `KeyValueStore` / `SecureStore` - the interfaces `packages/local_storage`
  implements.
- `testing.dart` (separate entry point) - `FakeApiClient`,
  `InMemoryKeyValueStore`, `InMemorySecureStore` for use from `test/` only.

## What must never be true of this package

Zero `package:flutter` import, zero import of any other local package.
Enforced by `./scripts/check_dependency_boundaries.sh`, not just this
README - see [docs/architecture/DEPENDENCY_RULES.md](../../docs/architecture/DEPENDENCY_RULES.md).

## Why that constraint

Keeping this package Flutter-free means its logic is unit-testable in
milliseconds with no widget harness, and is reusable outside Flutter
entirely if that's ever needed (a CLI tool, a server).
