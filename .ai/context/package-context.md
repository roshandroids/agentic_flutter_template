# Context: touching a specific package

Before editing any `packages/*`, read that package's own `README.md` first
- it states the package's one job and what it must NOT depend on. If the
package has no `README.md` or the README doesn't state a boundary, that's a
documentation gap to fix as part of the change, not a license to guess.

Quick map (keep in sync with `template.config.yaml`'s `packages:` list):

| Package | Layer | May depend on |
|---|---|---|
| `packages/core` | domain | nothing local |
| `packages/network` | infrastructure | `core` |
| `packages/local_storage` | infrastructure | `core` |
| `packages/design_system` | presentation | `core` (types only) |
