# analytics (reference module)

The template's default `AnalyticsModule` implementation - logs to the
console via `dart:developer` instead of a real vendor SDK. Demonstrates the
full `modules/*` pattern end to end:

- Implements `module_contracts`' `AnalyticsModule`, nothing else.
- Wired into `apps/app/lib/composition_root.dart`'s `analyticsModuleProvider`
  and registered in `template.config.yaml`'s `modules.enabled` - this
  template's reference module, proving the full contract -> composition
  root -> registry -> Playground pattern end to end. See it called from the
  dashboard feature (`dashboard_viewed` / `dashboard_refreshed` events) and
  from `showcase`'s Modules section (a live "log an event" button).
- Replacing this with Firebase Analytics/Segment/PostHog means writing a
  new module implementing the same `AnalyticsModule` contract and changing
  one binding in the composition root - no feature code changes.

See [../README.md](../README.md) for the full contract pattern.
