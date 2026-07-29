import '../failure/failure.dart';
import '../network/api_client.dart';
import '../result/result.dart';

/// A scriptable fake [ApiClient] for tests: register the canned raw
/// value/failure a path should produce, and this runs it through the same
/// `decode` callback a real [ApiClient] would - so a repository test
/// exercises its actual DTO-to-domain mapping instead of bypassing it.
/// See docs/testing/README.md's "prefer hand-written fakes" rule.
class FakeApiClient implements ApiClient {
  final Map<String, Result<dynamic, Failure>> _responses = {};

  /// Registers what [path] resolves to, regardless of HTTP method -
  /// sufficient for the common case of one fake response per repository
  /// test. For [Ok], [result]'s value is the *raw* (pre-decode) payload,
  /// e.g. the JSON map a real API would return.
  void whenPath(String path, Result<dynamic, Failure> result) {
    _responses[path] = result;
  }

  Result<T, Failure> _respond<T>(String path, T Function(dynamic json) decode) {
    final response = _responses[path];
    if (response == null) {
      throw StateError(
        'FakeApiClient: no response registered for "$path" - call whenPath() first.',
      );
    }
    return response.fold(onOk: (raw) => Ok(decode(raw)), onErr: Err.new);
  }

  @override
  Future<Result<T, Failure>> get<T>(
    String path, {
    required T Function(dynamic json) decode,
    Map<String, dynamic>? query,
  }) async => _respond(path, decode);

  @override
  Future<Result<T, Failure>> post<T>(
    String path, {
    required T Function(dynamic json) decode,
    Object? body,
  }) async => _respond(path, decode);

  @override
  Future<Result<T, Failure>> put<T>(
    String path, {
    required T Function(dynamic json) decode,
    Object? body,
  }) async => _respond(path, decode);

  @override
  Future<Result<T, Failure>> patch<T>(
    String path, {
    required T Function(dynamic json) decode,
    Object? body,
  }) async => _respond(path, decode);

  @override
  Future<Result<void, Failure>> delete(String path) async =>
      _respond(path, (_) {});
}
