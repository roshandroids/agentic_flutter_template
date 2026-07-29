# Adding a new feature

```bash
./scripts/new_feature.sh <feature_name>
```

Scaffolds `apps/app/lib/features/<feature_name>/` with all four layers
(`domain/`, `application/`, `infrastructure/`, `presentation/`), a matching
`test/` mirror, and a route stub registered in
`apps/app/lib/routing/app_router.dart`. See
[`../architecture/ARCHITECTURE.md`](../architecture/ARCHITECTURE.md) for
what belongs in each layer before filling them in - the script scaffolds
structure, not implementation; per
[`CONTRIBUTING.md`](../../CONTRIBUTING.md), don't leave any of it as an
unfilled placeholder past the PR that added it.

The template under `templates/feature_template/` uses public placeholder
identifiers (`FeatureName`, `featureName`, `feature_name`) so it analyzes
cleanly before scaffolding. Leading-underscore tokens would be
library-private in Dart and break cross-file references.
