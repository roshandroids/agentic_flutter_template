# Gotchas

Non-obvious constraints that have caused real mistakes. Add an entry only
when something actually went wrong for a non-obvious reason - not
speculative "watch out for" notes.

- **`packages/core` must never gain a Flutter import**, including
  transitively through a dev dependency. `scripts/check_dependency_boundaries.sh`
  catches direct imports; it does NOT catch a pure-Dart package accidentally
  depending on a package that itself depends on Flutter - check
  `dart pub deps` if a boundary failure doesn't make sense from `grep` alone.
- **Melos 7+ reads workspace config from the root `pubspec.yaml`'s
  `melos:` key, not a standalone `melos.yaml`.** A `melos.yaml` file in the
  repo root is silently ignored by Melos 8.x - there's no error, `melos
  bootstrap` just says "does not appear to be within a Melos workspace."
  Resolution is Dart's native pub workspaces: the root `pubspec.yaml` needs
  a `workspace:` list (every member path, no globs) and each member's own
  `pubspec.yaml` needs `resolution: workspace`. See
  [ADR-0003](../../docs/adr/ADR-0003-melos-monorepo-package-strategy.md).
- **A new package/module must be added to the root `pubspec.yaml`'s
  `workspace:` list by hand** - `scripts/new_package.sh`/`new_module.sh`
  don't do this automatically (YAML list edits are left manual on purpose).
  Forgetting it means the new package resolves fine in isolation but
  `melos bootstrap`/`dart pub get` at the root won't link it to the rest
  of the workspace.
- **`scripts/*.sh` must stay portable to macOS's stock toolchain**: the
  default `/bin/bash` on macOS is 3.2 (no `${var^}` case-expansion - that's
  a bash 4+ feature) and the default `sed` is BSD sed (no GNU `\U` in
  replacement strings - it's a GNU extension, and BSD sed silently treats
  it as literal text instead of erroring). Use `to_pascal_case`/
  `to_camel_case` from `scripts/lib/common.sh` for snake_case conversions,
  not `${NAME^}` or `sed 's/.../\U.../'`.
- **Scaffold tokens must be public Dart identifiers.** A leading `_` makes
  a name library-private, so tokens like `__Feature__` break cross-file
  references in `templates/` before substitution. Use `FeatureName` /
  `featureName` / `feature_name` (and `PackageName` / `package_name`)
  instead - see `scripts/new_feature.sh` / `new_package.sh`.
- **Golden tests are platform-sensitive.** They're generated and verified in
  CI (Linux runner), not locally on macOS - a locally-passing golden test can
  still fail in CI due to font rendering differences. Don't regenerate
  goldens locally and assume they'll hold in CI without checking the workflow.
- **`template.config.yaml`'s `packages:` list is intentionally NOT the same
  set as the root `pubspec.yaml`'s `workspace:` list.** `packages:` only
  covers code that commits to a fixed architectural layer (`core`,
  `network`, `local_storage`, `design_system`, `module_contracts`) - it
  deliberately excludes `apps/app`, `showcase`, `tools/repo_tools`, and
  concrete `modules/*` (which may legitimately depend on Flutter plugins).
  Don't "fix" this by adding every workspace member to `packages:` - that
  would force a Flutter-free or no-design_system rule onto code that was
  never meant to have one. `scripts/doctor.sh` only checks the direction
  that matters: every `packages:` entry must be a real workspace member.
