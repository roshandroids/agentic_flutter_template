# Testing strategy

## What gets which kind of test

| Layer | Test type | Lives in | Tooling |
|---|---|---|---|
| `domain/`, `application/` | Unit test | `<package or feature>/test/` | `package:test` (pure Dart), no widget harness |
| `infrastructure/` (repository impls) | Unit test with fake `ApiClient`/`Storage` | same | `package:test` + hand-written fakes from `packages/core`'s test helpers |
| `presentation/` widgets | Widget test | same | `flutter_test`, `ProviderScope(overrides: ...)` to inject fakes |
| Visual regression | Golden test | `*_golden_test.dart`, tagged `golden` | `flutter_test` `matchesGoldenFile`; CI-only, see `.ai/memory/gotchas.md`. Reference example: `packages/design_system/test/app_button_golden_test.dart` |
| Cross-feature flow | Integration test | `apps/app/integration_test/` | `integration_test` package, runs on a real/simulated device |
| Repository contracts | Repository test | package `test/` | Same suite as a domain unit test, run against both a fake and (where feasible) a real client in a separate suite |
| Use cases | Use case test | feature `test/application/` | Unit test, fakes the repository interface |
| Navigation | Navigation test | `apps/app/test/routing/` | `flutter_test` pumping `MaterialApp.router` with the real `GoRouter` config |

## Mock/fake strategy

Prefer hand-written fakes implementing the `core` interfaces
(`FakeApiClient`, `InMemoryKeyValueStore`) over a mocking framework for
anything reused across many tests - a fake is a real implementation with
predictable behavior, easier to reason about than verifying mock call
counts. Use `mockito`/`mocktail` only for one-off interaction verification
in a single test.

## Fixtures

Shared test fixtures (sample DTOs, sample domain entities) live in
`packages/core`'s exported test helpers (`packages/core/lib/testing.dart`,
imported only from `test/` directories) - not duplicated per test file, not
in the production `lib/` import path.

## Coverage

Line-coverage gate applies to pure-Dart packages only (90% -
`template.config.yaml`'s `testing.coverage_threshold`), enforced by
`scripts/check_coverage.sh` and `.github/workflows/coverage.yml`. Flutter
widget/golden coverage is judged by behavior, not a percentage - see
[`../release/COVERAGE.md`](../release/COVERAGE.md).

## CI integration

`.github/workflows/test.yml` (unit + widget, excluding golden) and
`.github/workflows/golden.yml` (golden only, isolated because of font
sensitivity - see `.ai/memory/gotchas.md`) run on every PR.
`.github/workflows/coverage.yml` runs the gate separately so a coverage dip
is a distinct, clearly-labeled CI failure, not buried inside a general test
job's output.
