# Benchmarks

No benchmarks exist yet - this section documents the convention for when a
feature has real performance requirements (e.g. a virtualized list, a large
document renderer), not a requirement to benchmark this template's demo
feature.

## Convention

- Pure-Dart performance benchmarks live in a package's own `benchmark/`
  directory, run via `dart run benchmark/<name>_benchmark.dart`.
- Flutter frame-timing budgets are asserted as soft p95 checks inside a
  `flutter test` (see `.github/workflows/build_verify.yml`'s comments for
  where this would plug into CI once a feature needs it) - not as a
  separate manual process.
