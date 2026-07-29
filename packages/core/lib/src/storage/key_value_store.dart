/// Non-secret local persistence - preferences, cached UI state, feature
/// flags. Repositories depend on this interface, never on
/// `shared_preferences` directly, so packages/local_storage's
/// implementation can be swapped (e.g. for Hive/Isar) without touching
/// feature code. See docs/architecture/ARCHITECTURE.md "Local storage".
abstract interface class KeyValueStore {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);

  Future<bool?> getBool(String key);
  Future<void> setBool(String key, {required bool value});

  Future<int?> getInt(String key);
  Future<void> setInt(String key, int value);

  Future<bool> containsKey(String key);
  Future<void> remove(String key);
  Future<void> clear();
}
