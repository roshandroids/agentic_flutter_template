# Adding a new package

Read [`../architecture/PACKAGE_STRATEGY.md`](../architecture/PACKAGE_STRATEGY.md)
first - only promote code to a package when its criteria are actually met.

```bash
./scripts/new_package.sh <package_name>
```

Scaffolds `packages/<package_name>/` with `pubspec.yaml`, `analysis_options.yaml`
(including this workspace's shared config), `lib/<package_name>.dart` (the
public export surface), and `test/`. Then:

1. Add the package to `template.config.yaml`'s `packages:` list with its layer.
2. Add its path to the root `pubspec.yaml`'s `workspace:` list, and add
   `resolution: workspace` to the new package's own `pubspec.yaml` - this
   is what actually links it locally via Dart's native pub workspaces (see
   [ADR-0003](../adr/ADR-0003-melos-monorepo-package-strategy.md)). Then
   run `melos bootstrap` (or `dart pub get` at the repo root).
3. If it's Flutter-free, `scripts/check_dependency_boundaries.sh` will
   enforce that automatically once listed.
