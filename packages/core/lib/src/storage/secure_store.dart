/// Secret local persistence - auth tokens, anything that must not land in
/// plain-text prefs. Kept a separate interface from [KeyValueStore] rather
/// than a flag on one interface, so a repository's own type signature makes
/// clear which storage guarantee it needs.
abstract interface class SecureStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> deleteAll();
}
