import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryKeyValueStore', () {
    test('round-trips values and supports remove/clear', () async {
      final store = InMemoryKeyValueStore();

      await store.setString('name', 'Ada');
      await store.setBool('enabled', value: true);
      await store.setInt('count', 3);

      expect(await store.getString('name'), 'Ada');
      expect(await store.getBool('enabled'), isTrue);
      expect(await store.getInt('count'), 3);
      expect(await store.containsKey('name'), isTrue);

      await store.remove('name');
      expect(await store.containsKey('name'), isFalse);

      await store.clear();
      expect(await store.getBool('enabled'), isNull);
    });
  });

  group('InMemorySecureStore', () {
    test('round-trips a secret and deletes it', () async {
      final store = InMemorySecureStore();

      await store.write('token', 'secret-value');
      expect(await store.read('token'), 'secret-value');

      await store.delete('token');
      expect(await store.read('token'), isNull);
    });

    test('deleteAll clears every secret', () async {
      final store = InMemorySecureStore();
      await store.write('token', 'a');
      await store.write('refresh', 'b');

      await store.deleteAll();

      expect(await store.read('token'), isNull);
      expect(await store.read('refresh'), isNull);
    });
  });

  group('FakeApiClient', () {
    test('returns the registered result for a path', () async {
      final client = FakeApiClient();
      client.whenPath(
        '/dashboard',
        const Ok<Map<String, dynamic>, Failure>({'greeting': 'hello'}),
      );

      final result = await client.get<Map<String, dynamic>>(
        '/dashboard',
        decode: (json) => json as Map<String, dynamic>,
      );

      expect(result.dataOrNull?['greeting'], 'hello');
    });

    test('throws a clear error when no response was registered', () {
      final client = FakeApiClient();
      expect(
        () => client.get<void>('/missing', decode: (_) {}),
        throwsA(isA<StateError>()),
      );
    });

    test('post/put/patch/delete all return the registered result', () async {
      final client = FakeApiClient();
      client.whenPath(
        '/thing',
        const Ok<Map<String, dynamic>, Failure>({'id': '1'}),
      );

      final postResult = await client.post<Map<String, dynamic>>(
        '/thing',
        body: {'id': '1'},
        decode: (json) => json as Map<String, dynamic>,
      );
      final putResult = await client.put<Map<String, dynamic>>(
        '/thing',
        body: {'id': '1'},
        decode: (json) => json as Map<String, dynamic>,
      );
      final patchResult = await client.patch<Map<String, dynamic>>(
        '/thing',
        body: {'id': '1'},
        decode: (json) => json as Map<String, dynamic>,
      );

      expect(postResult.dataOrNull?['id'], '1');
      expect(putResult.dataOrNull?['id'], '1');
      expect(patchResult.dataOrNull?['id'], '1');

      client.whenPath('/thing', const Ok<void, Failure>(null));
      final deleteResult = await client.delete('/thing');
      expect(deleteResult.isOk, isTrue);
    });

    test('returns a registered Err for any method', () async {
      final client = FakeApiClient();
      client.whenPath(
        '/thing',
        const Err<Map<String, dynamic>, Failure>(NotFoundFailure('gone')),
      );

      final result = await client.post<Map<String, dynamic>>(
        '/thing',
        decode: (json) => json as Map<String, dynamic>,
      );

      expect(result.failureOrNull, isA<NotFoundFailure>());
    });
  });
}
