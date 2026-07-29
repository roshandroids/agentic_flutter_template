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
4. `./scripts/doctor.sh` will now check the module directory exists and is wired.
