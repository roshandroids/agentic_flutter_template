import '../failure/failure.dart';
import '../result/result.dart';

/// The only HTTP abstraction feature code should ever depend on.
/// packages/network's `DioApiClient` is the concrete implementation;
/// nothing outside packages/network should import `dio` directly. Every
/// method returns `Result<T, Failure>` - see
/// docs/adr/ADR-0004-result-failure-error-handling.md.
abstract interface class ApiClient {
  Future<Result<T, Failure>> get<T>(
    String path, {
    required T Function(dynamic json) decode,
    Map<String, dynamic>? query,
  });

  Future<Result<T, Failure>> post<T>(
    String path, {
    required T Function(dynamic json) decode,
    Object? body,
  });

  Future<Result<T, Failure>> put<T>(
    String path, {
    required T Function(dynamic json) decode,
    Object? body,
  });

  Future<Result<T, Failure>> patch<T>(
    String path, {
    required T Function(dynamic json) decode,
    Object? body,
  });

  Future<Result<void, Failure>> delete(String path);
}
