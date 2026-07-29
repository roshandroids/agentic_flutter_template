# Modules

Pluggable backend/platform integrations - Firebase, Supabase, Serverpod,
Auth, Analytics, Notifications, Payments. Distinct from `packages/*`: a
package is app-agnostic reusable *code* (`core`, `network`); a module is a
*swappable integration* with a specific third-party or backend service,
isolated behind a contract so switching providers - or removing one
entirely - never touches feature code.

## Why modules are separate from packages

`packages/network` will look the same in every app built from this
template. Whether that app talks to Firebase or Supabase or a custom
Serverpod backend is a per-project decision, often revisited mid-project.
Folding backend SDKs into `packages/` would mean every consumer pays for
every SDK whether they use it or not, and swapping providers would mean
editing shared package code. A `modules/` directory - each module a
separate local package implementing one or more contracts from
[`module_contracts/`](module_contracts/) - means:

- Only enabled modules (`template.config.yaml`'s `modules.enabled`) are
  wired into `apps/app/lib/composition_root.dart`.
- Swapping `firebase` for `supabase` means writing a new module against
  the same contract and changing one line in the composition root - zero
  changes to `apps/app/lib/features/*`.
- A module can be deleted entirely (`modules/firebase/`) without leaving
  dead abstractions behind, because nothing outside the composition root
  ever imported it directly.

## The contract pattern

1. [`module_contracts/`](module_contracts/) defines the abstract interface
   a module type must implement (e.g. `AuthModule`, `AnalyticsModule`) -
   pure Dart, no dependency on any specific provider's SDK.
2. Each concrete module (`modules/firebase/`, `modules/auth/`, ...)
   implements the relevant contract(s), depending on whatever SDK it needs.
3. `apps/app/lib/composition_root.dart` is the only place that constructs
   a concrete module and binds it to the contract's provider - feature
   code depends on the contract, never on a specific module.

## Adding a module

```bash
./scripts/new_module.sh <name>
```

See [docs/guides/ADDING_A_MODULE.md](../docs/guides/ADDING_A_MODULE.md).
`<name>` must be listed in `template.config.yaml`'s `modules.available` -
add it there first if it's a genuinely new module type this template
hasn't anticipated.

## Status

No module is implemented yet (`template.config.yaml`'s `modules.enabled`
is `[]`) - only the contracts a first module would implement. Building a
real `firebase` or `supabase` module and validating this pattern against
it is tracked in [docs/release/ROADMAP.md](../docs/release/ROADMAP.md).
