# Risks

| Risk | Impact | Mitigation | Owner |
|---|---|---|---|
| Melos/Flutter workspace tooling changes upstream (native workspaces mature further) | Medium - could warrant migration | Revisit as an ADR when native workspaces cover versioning/scripting, not just resolution | Maintainer |
| Golden tests drift between local (macOS) and CI (Linux) fonts | Low - flaky-looking CI failures | Golden tests run only in CI (`golden.yml`); never trust a local-only golden pass | Maintainer |
| A module (`modules/*`) backend SDK introduces a breaking change | Medium - build breakage until updated | Dependabot tracks `pub` deps per package; module isolation limits blast radius to that module | Maintainer |
