import 'package:dio/dio.dart';

/// Retries idempotent requests (GET/PUT/DELETE - never POST, which may not
/// be idempotent server-side) with exponential backoff, only for
/// transport-level failures (timeout/connection error) - never for a 4xx,
/// which retrying can't fix.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(
    this._dio, {
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 300),
  });

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;

  static const _attemptKey = 'network.retry_interceptor.attempt';
  static const _idempotentMethods = {'GET', 'PUT', 'DELETE'};

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final method = err.requestOptions.method.toUpperCase();
    final isRetryable =
        _idempotentMethods.contains(method) &&
        (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.sendTimeout ||
            err.type == DioExceptionType.connectionError);

    final attempt = (err.requestOptions.extra[_attemptKey] as int?) ?? 0;

    if (!isRetryable || attempt >= maxRetries) {
      handler.next(err);
      return;
    }

    final delay = baseDelay * (1 << attempt); // exponential backoff
    await Future<void>.delayed(delay);

    try {
      final retryOptions = err.requestOptions..extra[_attemptKey] = attempt + 1;
      final response = await _dio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
