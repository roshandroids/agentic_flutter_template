# Adding a module

See [`../../modules/README.md`](../../modules/README.md) for the full
contract pattern. Short version:

```bash
./scripts/new_module.sh <module_name>
```

1. Implement the relevant contract(s) from `modules/module_contracts`
   (e.g. `AuthModule`, `AnalyticsModule`).
2. Bind it in `apps/app/lib/composition_root.dart` behind the same
   provider the app already depends on - feature code never imports the
   module package directly.
3. Add `<module_name>` to `template.config.yaml`'s `modules.enabled` list.
4. Add a `ModuleDescriptor` for it to the `moduleRegistryProvider` list in
   `composition_root.dart` (id, version, the contract(s) it implements) -
   this is metadata for diagnostics/the Playground, not a second wiring
   mechanism. See modules/README.md "Module registry (diagnostics only)".
5. `./scripts/doctor.sh` will now check the module directory exists and is wired.

## Worked example: `analytics`

`modules/analytics`'s `ConsoleAnalyticsModule` is a complete, minimal
example of every step above:

- Contract: implements `AnalyticsModule` from `module_contracts`
  (`modules/analytics/lib/src/console_analytics_module.dart`).
- Composition root: `analyticsModuleProvider` in
  `apps/app/lib/composition_root.dart` binds it to `AnalyticsModule`; the
  dashboard feature depends on `AnalyticsModule` through that provider,
  never on `ConsoleAnalyticsModule` directly
  (`apps/app/lib/features/dashboard/application/providers/dashboard_providers.dart`).
- Config: `analytics` is in `template.config.yaml`'s `modules.enabled`.
- Registry: `moduleRegistryProvider` in the same `composition_root.dart`
  lists a `ModuleDescriptor(id: 'analytics', ...)`.
- Demonstrated: `showcase`'s Modules screen
  (`showcase/lib/modules/modules_screen.dart`) lists the registry and
  calls the real module's `logEvent` from a button.

Reading those five files together is the fastest way to see the whole
pattern end-to-end before building a new module.
