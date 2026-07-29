# Context: touching architecture

Read, in order, before proposing any change to a package boundary, state
pattern, navigation shape, or DI wiring:

1. [`docs/architecture/README.md`](../../docs/architecture/README.md) - the map.
2. [`docs/architecture/ARCHITECTURE.md`](../../docs/architecture/ARCHITECTURE.md) - the layers.
3. [`docs/architecture/DEPENDENCY_RULES.md`](../../docs/architecture/DEPENDENCY_RULES.md) - what may import what.
4. [`docs/adr/`](../../docs/adr/) - has this exact question already been decided?
5. `template.config.yaml`'s `packages:` list - the current, authoritative
   layer assignment per package (not the docs' prose, if they ever drift).

Then write a new ADR before implementing, per
[`../roles/architect.md`](../roles/architect.md).
