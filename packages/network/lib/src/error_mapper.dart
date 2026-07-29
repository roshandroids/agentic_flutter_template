import 'package:core/core.dart';
import 'package:dio/dio.dart';

/// Maps a [DioException] to a typed [Failure] - the one place in the
/// workspace that understands dio's exception shape, so a repository never
/// sees a raw [DioException].
Failure mapDioExceptionToFailure(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.transformTimeout:
      return NetworkFailure(exception.message ?? 'Network connection failed');
    case DioExceptionType.badCertificate:
      return NetworkFailure(
        exception.message ?? 'Certificate validation failed',
      );
    case DioExceptionType.cancel:
      return const NetworkFailure('Request was cancelled');
    case DioExceptionType.badResponse:
      return _mapStatusCode(exception);
    case DioExceptionType.unknown:
      return UnexpectedFailure(
        exception.message ?? 'Unexpected network error',
        cause: exception.error,
      );
  }
}

Failure _mapStatusCode(DioException exception) {
  final statusCode = exception.response?.statusCode;
  final data = exception.response?.data;

  switch (statusCode) {
    case 401:
      return UnauthorizedFailure(_extractMessage(data) ?? 'Unauthorized');
    case 404:
      return NotFoundFailure(_extractMessage(data) ?? 'Not found');
    case 400:
    case 422:
      return ValidationFailure(
        _extractMessage(data) ?? 'Validation failed',
        fieldErrors: _extractFieldErrors(data),
      );
    default:
      return NetworkFailure(
        _extractMessage(data) ?? 'Request failed',
        statusCode: statusCode,
      );
  }
}

String? _extractMessage(dynamic data) {
  if (data is Map && data['message'] is String) {
    return data['message'] as String;
  }
  return null;
}

Map<String, String> _extractFieldErrors(dynamic data) {
  if (data is Map && data['errors'] is Map) {
    return (data['errors'] as Map).map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  }
  return const {};
}
