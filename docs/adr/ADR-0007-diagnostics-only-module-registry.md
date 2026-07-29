# ADR-0007: Diagnostics-only module registry

**Status:** Accepted
**Date:** 2026-07-28

## Context

The module system (`modules/module_contracts` + `modules/*` +
`apps/app/lib/composition_root.dart`) had contracts but no module was ever
actually wired in (`template.config.yaml`'s `modules.enabled` was `[]`).
Proving the pattern end-to-end raised a question the contracts alone don't
answer: how does tooling (the Playground, an eventual Architecture
Explorer, `doctor.sh`) discover "what's enabled and what does it
implement" without parsing source? A naive reading of "module discovery"
and "capability discovery" suggests a runtime plugin registry - the module
resolves itself into the app via reflection or a service locator. That
would be a new dependency-injection mechanism competing with the one this
template already committed to.

## Decision

Add read-only metadata types (`ModuleDescriptor`, `ModuleRegistry`) to
`module_contracts`, populated by hand in the same file and at the same
time as each module's real provider. The registry describes modules that
composition root already wired; it never constructs, resolves, or loads
one. Composition root (`apps/app/lib/composition_root.dart`,
`showcase/lib/modules/modules_screen.dart`) remains the only DI mechanism,
per ADR-0003.

## Alternatives considered

- **Runtime plugin registry** (modules discovered via reflection or a
  service locator that resolves `AnalyticsModule` etc. through the
  registry itself) - rejected: this is a second, competing DI mechanism.
  It also can't do reflection-based discovery in Flutter release builds
  (`dart:mirrors` isn't available), so "discovery" would still have to be
  config-driven - at which point it isn't buying anything a hand-built
  list doesn't already give.
- **No registry at all, diagnostics read `template.config.yaml` directly**
  - rejected: `modules.enabled` only names a module id, not what contract
    it implements or whether it has lifecycle behavior - tooling would
    need to parse Dart source or duplicate that knowledge anyway. A
    descriptor declared next to the provider keeps both in one place.

## Consequences

- **Easier:** the Playground's Modules screen, `doctor.sh`, and any future
  Architecture Explorer can list enabled modules and their capabilities
  without parsing source or duplicating a mapping elsewhere.
- **Harder:** nothing - the registry is additive. Adding a module still
  means the same manual steps as before (contract, provider,
  `modules.enabled`), plus one more line (a `ModuleDescriptor`) in the same
  file.
- **Forecloses:** using the registry itself to resolve or construct a
  module. If a future need (loading a module the app wasn't compiled with,
  enabling one after release) requires that, it's a new decision and needs
  its own ADR - not a quiet extension of this one.

## How this changes agent behavior

An agent wiring a new module into `apps/app/lib/composition_root.dart`
must also add a `ModuleDescriptor` for it to `moduleRegistryProvider` in
the same file (see
[`docs/guides/ADDING_A_MODULE.md`](../guides/ADDING_A_MODULE.md)) - but
must never make the registry itself perform module construction or
resolution. See the one-line entry added to
[`.ai/memory/decisions.md`](../../.ai/memory/decisions.md).
