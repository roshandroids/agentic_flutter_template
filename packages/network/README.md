# network

`dio`-based implementation of `core`'s `ApiClient`.

## What's here

- `DioApiClient` - the only concrete `ApiClient`. Constructed once at
  `apps/app/lib/composition_root.dart`.
- `AuthInterceptor` - attaches the current token; on 401, refreshes once via
  `AuthTokenProvider` and retries.
- `RetryInterceptor` - exponential backoff for idempotent (GET/PUT/DELETE)
  requests on transport-level failures only.
- `mapDioExceptionToFailure` - the only place that understands `dio`'s
  exception shape; everything else sees `core`'s `Failure` hierarchy.

## What must never be true of this package

No other package or feature should import `package:dio` directly - go
through `core`'s `ApiClient` interface instead. See
[docs/architecture/DEPENDENCY_RULES.md](../../docs/architecture/DEPENDENCY_RULES.md).
