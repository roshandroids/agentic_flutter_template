import 'package:core/core.dart';
import 'package:dio/dio.dart';

import 'auth_token_provider.dart';
import 'error_mapper.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// The only concrete [ApiClient] in this workspace. Constructed once at
/// `apps/app/lib/composition_root.dart` and provided as the abstract
/// `ApiClient` type - feature code never imports this class or `dio`
/// directly. See docs/architecture/ARCHITECTURE.md "Networking".
class DioApiClient implements ApiClient {
  DioApiClient({
    required String baseUrl,
    required AuthTokenProvider tokenProvider,
    Dio? dio,
  }) : _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.addAll([
      AuthInterceptor(tokenProvider, _dio),
      RetryInterceptor(_dio),
    ]);
  }

  final Dio _dio;

  Future<Result<T, Failure>> _run<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic json) decode,
  ) async {
    try {
      final response = await request();
      return Ok(decode(response.data));
    } on DioException catch (e) {
      return Err(mapDioExceptionToFailure(e));
    }
  }

  @override
  Future<Result<T, Failure>> get<T>(
    String path, {
    required T Function(dynamic json) decode,
    Map<String, dynamic>? query,
  }) => _run(() => _dio.get<dynamic>(path, queryParameters: query), decode);

  @override
  Future<Result<T, Failure>> post<T>(
    String path, {
    required T Function(dynamic json) decode,
    Object? body,
  }) => _run(() => _dio.post<dynamic>(path, data: body), decode);

  @override
  Future<Result<T, Failure>> put<T>(
    String path, {
    required T Function(dynamic json) decode,
    Object? body,
  }) => _run(() => _dio.put<dynamic>(path, data: body), decode);

  @override
  Future<Result<T, Failure>> patch<T>(
    String path, {
    required T Function(dynamic json) decode,
    Object? body,
  }) => _run(() => _dio.patch<dynamic>(path, data: body), decode);

  @override
  Future<Result<void, Failure>> delete(String path) =>
      _run(() => _dio.delete<dynamic>(path), (_) {});
}
