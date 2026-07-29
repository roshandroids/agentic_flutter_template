# Coding standards

Rules beyond what `analysis_options.yaml` already enforces mechanically -
if the linter can catch it, it's a lint rule, not a line in this doc.

## Naming

- Files: `snake_case.dart`. Classes: `UpperCamelCase`. Providers:
  `lowerCamelCase` + `Provider` suffix (`dashboardRepositoryProvider`).
- Repository interfaces live in `domain/repositories/`, named
  `<Noun>Repository` (abstract class); implementations in
  `infrastructure/repositories/`, named `<Noun>RepositoryImpl`.
- Use cases (when a feature has one): a verb phrase class with a single
  `call()` method (`FetchDashboardSummary`), so `await
  fetchDashboardSummary()` reads like a function.

## Error handling

- Domain/application code returns `Result<T, Failure>`
  ([ADR-0004](../adr/ADR-0004-result-failure-error-handling.md)) for every
  expected failure path (network error, not-found, validation). `throw` is
  reserved for programmer errors (a violated precondition, an unreachable
  branch) - if it's something a caller should handle, it's a `Failure`, not
  an exception.
- Never swallow a `Result`'s error branch silently - either handle it or
  propagate it; a bare `result.dataOrNull` that ignores the failure case is
  a code-review-blocking pattern here.

## Widgets

- Prefer `const` constructors wherever the analyzer allows it - already
  linted, but treat a missing `const` as worth fixing on sight, not "later."
- A widget over ~150 lines is a signal to extract a child widget, not a
  hard rule - extract when it improves readability, not by line-count alone.
- No business logic in a widget's `build()` - if it needs a conditional
  beyond simple presentation branching, that logic belongs in the
  application-layer notifier.

## Comments

- Comment the *why*, never the *what* - a comment restating what the next
  line of code does is noise. Write one when there's a non-obvious
  constraint, a workaround, or a decision that would otherwise look like a
  mistake to a future reader.
- No commented-out code left in a merged PR.

## Imports

- `directives_ordering` (linted) keeps imports sorted; beyond that, never
  import across a boundary [`DEPENDENCY_RULES.md`](DEPENDENCY_RULES.md)
  forbids, even transitively through a barrel file.

## Tests

See [`../testing/README.md`](../testing/README.md) for the full strategy;
in short - one behavior per test, named after the behavior not the method,
at the layer that owns the logic being tested.
