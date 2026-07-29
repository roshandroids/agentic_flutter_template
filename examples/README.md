# Examples

Standalone example apps demonstrating a single `packages/*` package in
isolation - useful once a package is extracted for external/open-source
consumption and needs its own minimal "here's how to use just this" app,
distinct from `apps/app` (the full product) or `showcase/` (the design
system gallery).

Empty today because no package has been extracted for external consumption
yet - see [docs/architecture/PACKAGE_STRATEGY.md](../docs/architecture/PACKAGE_STRATEGY.md)'s
promotion criteria. Add `examples/<package_name>_example/` when that
happens, as its own minimal Flutter app depending on just that package.
