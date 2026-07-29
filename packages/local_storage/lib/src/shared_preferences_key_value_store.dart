import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [KeyValueStore] backed by `shared_preferences`. Swapping to Hive/Isar
/// later means writing a new implementation of [KeyValueStore] here -
/// nothing outside this package or `core` needs to change.
class SharedPreferencesKeyValueStore implements KeyValueStore {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<String?> getString(String key) async => (await _prefs).getString(key);

  @override
  Future<void> setString(String key, String value) async =>
      (await _prefs).setString(key, value);

  @override
  Future<bool?> getBool(String key) async => (await _prefs).getBool(key);

  @override
  Future<void> setBool(String key, {required bool value}) async =>
      (await _prefs).setBool(key, value);

  @override
  Future<int?> getInt(String key) async => (await _prefs).getInt(key);

  @override
  Future<void> setInt(String key, int value) async =>
      (await _prefs).setInt(key, value);

  @override
  Future<bool> containsKey(String key) async => (await _prefs).containsKey(key);

  @override
  Future<void> remove(String key) async => (await _prefs).remove(key);

  @override
  Future<void> clear() async => (await _prefs).clear();
}
