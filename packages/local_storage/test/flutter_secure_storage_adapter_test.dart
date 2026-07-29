import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage/local_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Map<String, String> backingData;

  setUp(() {
    backingData = {};
    FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform(
      backingData,
    );
  });

  group('FlutterSecureStorageAdapter', () {
    test('writes and reads a secret', () async {
      final adapter = FlutterSecureStorageAdapter(
        storage: const FlutterSecureStorage(),
      );

      await adapter.write('token', 'super-secret');
      expect(await adapter.read('token'), 'super-secret');
    });

    test('delete removes a single key', () async {
      final adapter = FlutterSecureStorageAdapter(
        storage: const FlutterSecureStorage(),
      );
      await adapter.write('token', 'v1');
      await adapter.write('refresh', 'v2');

      await adapter.delete('token');

      expect(await adapter.read('token'), isNull);
      expect(await adapter.read('refresh'), 'v2');
    });

    test('deleteAll clears every secret', () async {
      final adapter = FlutterSecureStorageAdapter(
        storage: const FlutterSecureStorage(),
      );
      await adapter.write('token', 'v1');
      await adapter.write('refresh', 'v2');

      await adapter.deleteAll();

      expect(await adapter.read('token'), isNull);
      expect(await adapter.read('refresh'), isNull);
    });
  });
}
