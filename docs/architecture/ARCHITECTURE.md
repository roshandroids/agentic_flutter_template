# Architecture

Feature-first Clean Architecture on Flutter, with Riverpod for state/DI and
go_router for navigation. This document describes the current shape; see
[`../adr/`](../adr/) for why each piece was chosen over its alternatives.

## The four layers

Every feature under `apps/app/lib/features/<feature>/` is organized into up
to four layers. A feature that genuinely doesn't need a layer omits it
explicitly (documented in that feature's own README) rather than adding an
empty folder.

```
features/<feature>/
├── domain/            Entities + repository interfaces. Zero Flutter import.
│   ├── entities/       Plain Dart classes - the feature's vocabulary.
│   └── repositories/    Abstract contracts (implemented in infrastructure/).
├── application/        Use cases + Riverpod state notifiers. Orchestrates
│   ├── use_cases/       domain repositories; contains business rules that
│   └── providers/       don't belong to a single entity.
├── infrastructure/      Concrete repository implementations: talks to
│   ├── repositories/     packages/network, packages/local_storage, or a
│   └── dtos/             modules/* backend. DTOs + mapping to domain
│                         entities live here - a DTO never leaks into
│                         domain or presentation.
└── presentation/         Widgets, screens, view-models (Riverpod
    ├── screens/           `Notifier`/`AsyncNotifier` that read
    ├── widgets/           application-layer state and render it).
    └── providers/
```

**Why this shape:** dependencies point inward
(presentation → application → domain ← infrastructure). Domain never knows
Flutter exists; infrastructure never knows how data is displayed. That means
the same domain + application code could back a CLI or a server-driven UI
with no change - and, more practically day-to-day, it means a repository
implementation can be swapped (REST → GraphQL → local-only) without
touching a single widget.

**Why feature-first, not layer-first** (i.e. not `lib/screens/`,
`lib/repositories/`, `lib/models/` as top-level folders): a feature's four
layers live together, so deleting or extracting a feature is deleting or
moving one folder, not hunting across five layer-folders for every file
that belonged to it. See
[ADR-0006](../adr/ADR-0006-feature-first-over-layer-first.md).

## State management - Riverpod

See [ADR-0001](../adr/ADR-0001-riverpod-for-state-management.md) for why
Riverpod over Bloc/Provider/GetX.

- **Provider organization:** one `providers.dart` (or split file) per layer
  within a feature. Application-layer providers expose
  `AsyncNotifier<T>`/`Notifier<T>`; presentation-layer providers derive from
  them (`.select`, computed providers) rather than re-fetching.
- **Async state:** every async operation is `AsyncValue<T>` - `.when(data:,
  error:, loading:)` in the widget, never a manually-tracked
  `isLoading`/`error` pair of fields.
- **Mutation pattern:** mutations are methods on the feature's
  `AsyncNotifier`, each wrapping its body in `state = const
  AsyncValue.loading()` → `AsyncValue.guard(...)` - so every mutation has
  consistent loading/error semantics without hand-writing try/catch per call site.
- **Repository providers:** infrastructure repositories are provided once,
  at the composition root (`apps/app/lib/composition_root.dart`), as the
  concrete implementation bound to the domain interface -
  `Provider<DashboardRepository>((ref) => DashboardRepositoryImpl(...))`.
  Feature code depends on the abstract `DashboardRepository` type, never the
  `Impl`.
- **Shared providers:** cross-feature state (current user, connectivity,
  active locale) lives in `apps/app/lib/shared/providers/` - promoted there
  only once a second feature actually needs it, not preemptively.
- **Avoiding provider spaghetti:** a provider only ever reads providers from
  its own layer or layers it's allowed to depend on (application may read
  domain interfaces + infrastructure providers via DI; presentation reads
  application). A presentation widget reading an infrastructure provider
  directly is the specific smell this structure exists to prevent.

## Navigation - go_router

See [ADR-0002](../adr/ADR-0002-go-router-for-navigation.md).

- Routes are typed and centralized in `apps/app/lib/routing/app_router.dart`
  - feature code never calls `Navigator.push` directly, it calls a typed
    `context.goDashboard()` extension or a generated route helper.
- **Shell routes** provide the adaptive nav chrome (bottom nav on mobile,
  nav rail on tablet/desktop) around the feature screens - see
  `apps/app/lib/routing/app_shell.dart`.
- **Auth guards** are a `redirect` on the router reading an auth-state
  provider - unauthenticated access to a guarded route redirects to
  `/sign-in`, preserving the originally requested location for
  post-login redirect.
- **Deep links** map 1:1 to route paths already, since go_router is
  path-based - no separate deep-link table to keep in sync.
- **Nested navigation** (e.g. a tab with its own back stack) uses
  `StatefulShellRoute.indexedStack`, not a hand-rolled `IndexedStack` +
  manual state.

## Dependency injection - Riverpod composition root

See [ADR-0003](../adr/ADR-0003-melos-monorepo-package-strategy.md) for the
package-boundary side of this and
[`docs/architecture/DEPENDENCY_RULES.md`](DEPENDENCY_RULES.md) for the
import rules.

`apps/app/lib/composition_root.dart` is the **only** file that constructs
concrete infrastructure classes (`DioApiClient`, `SecureStorageAdapter`,
feature `RepositoryImpl`s) and binds them to their abstract providers. No
other file in `apps/app` imports a concrete infrastructure class directly.
This is intentionally not a service-locator (`GetIt`, `Injectable`) -
Riverpod's provider graph already gives compile-time-checked,
override-in-tests DI without a second mechanism; adding a service locator
on top would mean two competing ways to get a dependency.

## Local storage

`packages/core` defines `KeyValueStore` and `SecureStore` interfaces (get,
set, delete, watch). `packages/local_storage` implements them with
`shared_preferences` (key-value) and `flutter_secure_storage` (secure).
Repositories in `infrastructure/` depend on the `core` interfaces, never on
`shared_preferences` directly - swapping to Hive/Isar later means writing a
new `packages/local_storage` implementation, touching zero feature code.

## Networking

`packages/core` defines `ApiClient` (an interface: `get`/`post`/`put`/`delete`
returning `Future<Result<T, Failure>>`) and `Failure` (see
[ADR-0004](../adr/ADR-0004-result-failure-error-handling.md)).
`packages/network` implements `ApiClient` with `dio`, and layers:
- an **auth interceptor** that attaches the current token and triggers
  refresh-and-retry on 401,
- a **retry interceptor** with exponential backoff for idempotent requests,
- an **error mapper** that turns `DioException`/status codes into typed
  `Failure` subtypes - so a repository never sees a raw HTTP exception.

No feature or presentation code imports `dio` directly - only
`packages/network`.

## Design system

See [`packages/design_system/README.md`](../../packages/design_system/README.md)
for the concrete tokens, theme, and shared widgets - a Material 3
`ThemeExtension`-based token set (color, spacing, radius, typography),
responsive breakpoints, and common states (loading/error/empty) shared
across every feature.

## Localization

`gen_l10n` with ARB files under `apps/app/lib/l10n/arb/`. Extraction rule:
no hardcoded user-facing string in `presentation/` - a lint-level convention
checked in code review (dart's `avoid_hardcoded_strings` is not a stock
lint; see [`CODING_STANDARDS.md`](CODING_STANDARDS.md) for the manual
review rule). New locales are additive: add the ARB file, run `melos run
generate`, no code change required for a language that only adds
translations.
