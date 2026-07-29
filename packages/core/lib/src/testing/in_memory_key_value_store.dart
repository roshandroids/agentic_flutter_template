import '../storage/key_value_store.dart';

/// An in-memory [KeyValueStore] for tests - never imported from `lib/`,
/// only from `test/` (own or a consumer's). See docs/testing/README.md's
/// "prefer hand-written fakes" rule.
class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, Object?> _values = {};

  @override
  Future<String?> getString(String key) async => _values[key] as String?;

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async => _values[key] as bool?;

  @override
  Future<void> setBool(String key, {required bool value}) async {
    _values[key] = value;
  }

  @override
  Future<int?> getInt(String key) async => _values[key] as int?;

  @override
  Future<void> setInt(String key, int value) async {
    _values[key] = value;
  }

  @override
  Future<bool> containsKey(String key) async => _values.containsKey(key);

  @override
  Future<void> remove(String key) async => _values.remove(key);

  @override
  Future<void> clear() async => _values.clear();
}
