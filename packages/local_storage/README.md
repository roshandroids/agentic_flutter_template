# local_storage

Concrete implementations of `core`'s storage interfaces.

- `SharedPreferencesKeyValueStore` implements `KeyValueStore`.
- `FlutterSecureStorageAdapter` implements `SecureStore`.

Repositories depend on `core`'s interfaces, never on `shared_preferences` or
`flutter_secure_storage` directly - swapping to Hive/Isar or another secure
storage plugin later means writing a new implementation here, touching zero
feature code. See [docs/architecture/ARCHITECTURE.md](../../docs/architecture/ARCHITECTURE.md).
