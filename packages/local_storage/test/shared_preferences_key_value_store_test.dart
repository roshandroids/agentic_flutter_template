import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('SharedPreferencesKeyValueStore', () {
    test('round-trips string, bool, and int values', () async {
      final store = SharedPreferencesKeyValueStore();

      await store.setString('name', 'Ada');
      await store.setBool('enabled', value: true);
      await store.setInt('count', 7);

      expect(await store.getString('name'), 'Ada');
      expect(await store.getBool('enabled'), isTrue);
      expect(await store.getInt('count'), 7);
    });

    test('containsKey, remove, and clear behave as expected', () async {
      final store = SharedPreferencesKeyValueStore();
      await store.setString('a', '1');

      expect(await store.containsKey('a'), isTrue);

      await store.remove('a');
      expect(await store.containsKey('a'), isFalse);

      await store.setString('b', '2');
      await store.clear();
      expect(await store.containsKey('b'), isFalse);
    });

    test('missing keys return null, not throw', () async {
      final store = SharedPreferencesKeyValueStore();
      expect(await store.getString('missing'), isNull);
      expect(await store.getBool('missing'), isNull);
      expect(await store.getInt('missing'), isNull);
    });
  });
}
