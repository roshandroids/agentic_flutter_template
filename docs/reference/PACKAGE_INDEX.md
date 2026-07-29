# Package index

Regenerate with `./scripts/update_docs.sh` if it drifts.

| Path | Type | One-line purpose |
|---|---|---|
| `apps/app` | Flutter app | The product application. |
| `packages/core` | Pure Dart | `Result`/`Failure`, repository/storage/network interfaces - zero Flutter. |
| `packages/network` | Pure Dart (dio) | `ApiClient` implementation: auth, retry, error mapping. |
| `packages/local_storage` | Flutter | `KeyValueStore`/`SecureStore` implementations. |
| `packages/design_system` | Flutter | Theme tokens, responsive layout, shared widgets. |
| `showcase` | Flutter (web) | Design-system component gallery. |
| `modules/module_contracts` | Pure Dart | Interfaces every pluggable backend/service module implements. |
