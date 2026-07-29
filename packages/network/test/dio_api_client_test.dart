import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:network/network.dart';
import 'package:test/test.dart';

/// Replaces dio's real transport: added AFTER DioApiClient's internal
/// interceptors, so requests flow Auth -> Retry -> this fake "network",
/// and errors propagate back Retry -> Auth, exactly like a real transport
/// failure would. [respond] decides per-call-count what "the network"
/// returns, without any real HTTP call being made.
class _FakeTransport extends Interceptor {
  _FakeTransport(this.respond);

  final Response<dynamic> Function(RequestOptions options, int callCount)
  respond;
  int callCount = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    callCount++;
    final result = respond(options, callCount);
    handler.resolve(result);
  }
}

class _FailNTimesThenSucceed extends Interceptor {
  _FailNTimesThenSucceed(this.failCount, this.successData);

  final int failCount;
  final dynamic successData;
  int callCount = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    callCount++;
    if (callCount <= failCount) {
      // `true` marks this as a dispatch-level failure so it's routed
      // through every interceptor's onError - see the note on
      // RequestInterceptorHandler.reject's callFollowingErrorInterceptor
      // param; a plain reject() would skip onError entirely, which is
      // correct for an interceptor deliberately short-circuiting a
      // request, but wrong for simulating a real transport failure.
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        ),
        true,
      );
      return;
    }
    handler.resolve(
      Response<dynamic>(requestOptions: options, data: successData),
    );
  }
}

class _FakeAuthTokenProvider implements AuthTokenProvider {
  _FakeAuthTokenProvider({this.refreshSucceeds = true});

  String? token = 'stale-token';
  final bool refreshSucceeds;
  int refreshCalls = 0;

  @override
  Future<String?> get accessToken async => token;

  @override
  Future<bool> refresh() async {
    refreshCalls++;
    if (refreshSucceeds) {
      token = 'fresh-token';
      return true;
    }
    return false;
  }
}

void main() {
  group('DioApiClient - happy path', () {
    test('get returns Ok with decoded data', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      final client = DioApiClient(
        baseUrl: 'https://example.test',
        tokenProvider: _FakeAuthTokenProvider(),
        dio: dio,
      );
      dio.interceptors.add(
        _FakeTransport(
          (options, count) => Response<dynamic>(
            requestOptions: options,
            data: {'greeting': 'hello'},
          ),
        ),
      );

      final result = await client.get<String>(
        '/dashboard',
        decode: (json) => (json as Map<String, dynamic>)['greeting'] as String,
      );

      expect(result.dataOrNull, 'hello');
    });

    test('a 404 response maps to NotFoundFailure', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      final client = DioApiClient(
        baseUrl: 'https://example.test',
        tokenProvider: _FakeAuthTokenProvider(),
        dio: dio,
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response<dynamic>(
                requestOptions: options,
                statusCode: 404,
              ),
            ),
            true,
          ),
        ),
      );

      final result = await client.get<String>(
        '/missing',
        decode: (j) => j as String,
      );

      expect(result.failureOrNull, isA<NotFoundFailure>());
    });
  });

  group('DioApiClient - retry', () {
    test(
      'retries a transient connection error and eventually succeeds',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
        final client = DioApiClient(
          baseUrl: 'https://example.test',
          tokenProvider: _FakeAuthTokenProvider(),
          dio: dio,
        );
        final transport = _FailNTimesThenSucceed(2, {'ok': true});
        dio.interceptors.add(transport);

        final result = await client.get<bool>(
          '/flaky',
          decode: (json) => (json as Map<String, dynamic>)['ok'] as bool,
        );

        expect(result.dataOrNull, isTrue);
        expect(transport.callCount, 3); // 2 failures + 1 success
      },
    );

    test('gives up after maxRetries and returns NetworkFailure', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      final client = DioApiClient(
        baseUrl: 'https://example.test',
        tokenProvider: _FakeAuthTokenProvider(),
        dio: dio,
      );
      final transport = _FailNTimesThenSucceed(99, {'ok': true});
      dio.interceptors.add(transport);

      final result = await client.get<bool>(
        '/always-down',
        decode: (json) => (json as Map<String, dynamic>)['ok'] as bool,
      );

      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  group('DioApiClient - auth refresh', () {
    test('refreshes and retries once on 401, then succeeds', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      final authProvider = _FakeAuthTokenProvider();
      final client = DioApiClient(
        baseUrl: 'https://example.test',
        tokenProvider: authProvider,
        dio: dio,
      );

      var calls = 0;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            calls++;
            final authHeader = options.headers['Authorization'] as String?;
            if (calls == 1) {
              expect(authHeader, 'Bearer stale-token');
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: Response<dynamic>(
                    requestOptions: options,
                    statusCode: 401,
                  ),
                ),
                true,
              );
              return;
            }
            expect(authHeader, 'Bearer fresh-token');
            handler.resolve(
              Response<dynamic>(requestOptions: options, data: {'ok': true}),
            );
          },
        ),
      );

      final result = await client.get<bool>(
        '/secure',
        decode: (json) => (json as Map<String, dynamic>)['ok'] as bool,
      );

      expect(result.dataOrNull, isTrue);
      expect(authProvider.refreshCalls, 1);
    });

    test('propagates UnauthorizedFailure when refresh fails', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      final authProvider = _FakeAuthTokenProvider(refreshSucceeds: false);
      final client = DioApiClient(
        baseUrl: 'https://example.test',
        tokenProvider: authProvider,
        dio: dio,
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response<dynamic>(
                requestOptions: options,
                statusCode: 401,
              ),
            ),
            true,
          ),
        ),
      );

      final result = await client.get<bool>(
        '/secure',
        decode: (json) => (json as Map<String, dynamic>)['ok'] as bool,
      );

      expect(result.failureOrNull, isA<UnauthorizedFailure>());
      expect(authProvider.refreshCalls, 1);
    });

    test(
      'propagates a new failure if the retried request also fails',
      () async {
        // Refresh succeeds, but the retried request hits a different error
        // (e.g. the backend is down) - the interceptor's own retry attempt
        // must surface *that* failure, not silently swallow it.
        final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
        final authProvider = _FakeAuthTokenProvider();
        final client = DioApiClient(
          baseUrl: 'https://example.test',
          tokenProvider: authProvider,
          dio: dio,
        );

        var calls = 0;
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              calls++;
              if (calls == 1) {
                handler.reject(
                  DioException(
                    requestOptions: options,
                    type: DioExceptionType.badResponse,
                    response: Response<dynamic>(
                      requestOptions: options,
                      statusCode: 401,
                    ),
                  ),
                  true,
                );
                return;
              }
              // The retry (with a fresh token) still fails.
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: Response<dynamic>(
                    requestOptions: options,
                    statusCode: 404,
                  ),
                ),
                true,
              );
            },
          ),
        );

        final result = await client.get<bool>(
          '/secure',
          decode: (json) => (json as Map<String, dynamic>)['ok'] as bool,
        );

        expect(result.failureOrNull, isA<NotFoundFailure>());
        expect(authProvider.refreshCalls, 1);
      },
    );
  });

  group('DioApiClient - post/put/patch/delete', () {
    late Dio dio;
    late DioApiClient client;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      client = DioApiClient(
        baseUrl: 'https://example.test',
        tokenProvider: _FakeAuthTokenProvider(),
        dio: dio,
      );
      dio.interceptors.add(
        _FakeTransport(
          (options, count) =>
              Response<dynamic>(requestOptions: options, data: {'ok': true}),
        ),
      );
    });

    test('post decodes the response', () async {
      final result = await client.post<bool>(
        '/thing',
        body: {'name': 'x'},
        decode: (json) => (json as Map<String, dynamic>)['ok'] as bool,
      );
      expect(result.dataOrNull, isTrue);
    });

    test('put decodes the response', () async {
      final result = await client.put<bool>(
        '/thing',
        body: {'name': 'x'},
        decode: (json) => (json as Map<String, dynamic>)['ok'] as bool,
      );
      expect(result.dataOrNull, isTrue);
    });

    test('patch decodes the response', () async {
      final result = await client.patch<bool>(
        '/thing',
        body: {'name': 'x'},
        decode: (json) => (json as Map<String, dynamic>)['ok'] as bool,
      );
      expect(result.dataOrNull, isTrue);
    });

    test('delete returns Ok on success', () async {
      final result = await client.delete('/thing');
      expect(result.isOk, isTrue);
    });
  });

  group('DioApiClient - construction', () {
    test('builds its own Dio instance when none is provided', () {
      final client = DioApiClient(
        baseUrl: 'https://example.test',
        tokenProvider: _FakeAuthTokenProvider(),
      );
      expect(client, isA<ApiClient>());
    });
  });
}
