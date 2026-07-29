# Script reference

| Script | Purpose | Also runs in CI as |
|---|---|---|
| `bootstrap.sh` | First-time setup: installs Melos if missing, runs `melos bootstrap`. | - |
| `doctor.sh` | Checks local toolchain (Flutter/Dart versions, platforms from config, enabled modules exist) - the "is my machine ready" check. | - |
| `verify.sh` | Format check + analyze + boundary check + tests + coverage gate, in one command - exactly what CI runs across its separate jobs. | `.github/workflows/{format,analyze,dependency_validate,test,coverage}.yml` |
| `check_dependency_boundaries.sh` | Enforces `docs/architecture/DEPENDENCY_RULES.md` using `template.config.yaml`'s package/layer list. | `.github/workflows/dependency_validate.yml` |
| `check_coverage.sh` | Runs coverage for pure-Dart packages, fails under `template.config.yaml`'s `testing.coverage_threshold`. | `.github/workflows/coverage.yml` |
| `new_feature.sh` | Scaffolds a feature's four layers under `apps/app/lib/features/`. | - |
| `new_package.sh` | Scaffolds a new `packages/*` package. | - |
| `new_module.sh` | Scaffolds a new `modules/*` module and registers it in config. | - |
| `new_adr.sh` | Creates a numbered ADR from the template. | - |
| `release.sh` | Wraps `melos version` + tag push. | `.github/workflows/release.yml` |
| `clean.sh` | Removes build artifacts and generated code across the workspace. | - |
| `update_docs.sh` | Regenerates the derived reference tables in this folder (package index, script reference) from the current repo state. | - |
| `generate.sh` | Runs `build_runner` for every package that declares it (freezed/json_serializable/gen_l10n). | - |
