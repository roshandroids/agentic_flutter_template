# app

The product application - feature-first Clean Architecture, Riverpod,
go_router. See [docs/architecture/ARCHITECTURE.md](../../docs/architecture/ARCHITECTURE.md).

## Layout

```
lib/
├── main.dart               Entry point - ProviderScope + App.
├── app.dart                 MaterialApp.router: theme, l10n, routerProvider.
├── composition_root.dart    The only file binding concrete infra to abstract providers.
├── routing/                 Typed go_router config + adaptive AppShell.
├── shared/                  Cross-feature infra (e.g. AppAuthTokenProvider) - promoted
│                             here only once a second feature needs it.
└── features/
    └── dashboard/            The one demonstration feature - see its own layers.
```

## Running

```bash
flutter run                       # apps/app
flutter run -d chrome              # web
```

## Testing

```bash
flutter test                       # unit + widget (this dir's test/)
flutter test integration_test      # cross-feature smoke test, needs a device/Chrome
```

## Why only one feature (`dashboard`)

This repository is the template - the deliverable is the architecture, not
a product. `dashboard` exists solely to make every layer, provider, and
routing pattern concrete and testable. See
[docs/guides/NEW_FEATURE.md](../../docs/guides/NEW_FEATURE.md) to add a real one.
