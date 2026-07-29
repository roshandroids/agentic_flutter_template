# `template.config.yaml` key reference

| Key | Meaning | Consumed by |
|---|---|---|
| `project.name`, `project.organization`, `project.description` | App identity | `scripts/bootstrap.sh` (renames on first run, if implemented for your fork) |
| `platforms` | Which platforms this repo actively targets | `scripts/doctor.sh` (toolchain check), `.github/workflows/build_verify.yml` (build matrix) |
| `modules.enabled` | Which `modules/*` are active | `scripts/doctor.sh` (verifies directory + wiring exist), `scripts/new_module.sh` (appends here) |
| `modules.available` | Documented catalog of supported module types | `scripts/new_module.sh` (validates the name being added) |
| `packages` (name/path/layer) | Local package → architectural layer mapping. Scoped to packages that commit to a fixed layer - not every root `pubspec.yaml` `workspace:` member belongs here (see `docs/architecture/DEPENDENCY_RULES.md`) | `scripts/check_dependency_boundaries.sh` (which import rule applies), `scripts/doctor.sh` (checks every entry is a real workspace member), `docs/architecture/DEPENDENCY_RULES.md` (kept in sync manually) |
| `architecture.*` | Named current architecture choices | Documentation only today - a change here without a matching ADR should be treated as a documentation bug |
| `testing.coverage_threshold` | Line-coverage gate percentage | `scripts/check_coverage.sh`, `.github/workflows/coverage.yml` |
| `testing.golden_tests` | Whether golden tests are expected to exist/run | `.github/workflows/golden.yml` (future: skip the job entirely if `false`) |
| `documentation.require_adr_for_architectural_change` | Policy flag | Documentation/process only - enforced by code review today, not a script |
| `documentation.forbid_new_top_level_docs_folder_without_justification` | Policy flag | `.github/workflows/docs_validate.yml`'s README-per-folder check is the closest automated proxy |
| `ai.canonical_source`, `ai.supported_surfaces` | Where AI instructions live and which tools are supported | `.ai/AGENTS.md`'s own documentation - kept in sync manually |

This file is the reference; `.ai/AGENTS.md` and the architecture docs are
the narrative. If they disagree, `template.config.yaml` wins for anything a
script actually reads (packages/layers, coverage threshold, platforms) -
file a doc-fix if you find a mismatch.
