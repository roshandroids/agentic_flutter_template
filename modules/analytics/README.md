# analytics (reference module)

The template's default `AnalyticsModule` implementation - logs to the
console via `dart:developer` instead of a real vendor SDK. Demonstrates the
full `modules/*` pattern end to end:

- Implements `module_contracts`' `AnalyticsModule`, nothing else.
- Not wired into `apps/app/lib/composition_root.dart` by default -
  `template.config.yaml`'s `modules.enabled` is empty until a project
  actually needs analytics.
- Replacing this with Firebase Analytics/Segment/PostHog means writing a
  new module implementing the same `AnalyticsModule` contract and changing
  one binding in the composition root - no feature code changes.

See [../README.md](../README.md) for the full contract pattern.
