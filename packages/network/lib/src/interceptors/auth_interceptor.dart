import 'package:dio/dio.dart';

import '../auth_token_provider.dart';

/// Attaches the current access token to every request and, on a 401,
/// attempts one refresh-and-retry before giving up. This is the only place
/// in the workspace that knows a 401 might be recoverable - everywhere
/// else, a 401 that reaches [mapDioExceptionToFailure] means refresh
/// already failed or wasn't attempted.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenProvider, this._dio);

  final AuthTokenProvider _tokenProvider;
  final Dio _dio;

  static const _retriedKey = 'network.auth_interceptor.retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final alreadyRetried = err.requestOptions.extra[_retriedKey] == true;
    if (err.response?.statusCode != 401 || alreadyRetried) {
      handler.next(err);
      return;
    }

    final refreshed = await _tokenProvider.refresh();
    if (!refreshed) {
      handler.next(err);
      return;
    }

    try {
      final retryOptions = err.requestOptions..extra[_retriedKey] = true;
      final token = await _tokenProvider.accessToken;
      if (token != null) {
        retryOptions.headers['Authorization'] = 'Bearer $token';
      }
      final response = await _dio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
