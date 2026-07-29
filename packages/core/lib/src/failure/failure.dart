import 'package:meta/meta.dart';

/// Base type for every expected failure in the app - the `F` in
/// `Result<T, F>`. Add a new subtype here (not a one-off exception class)
/// when a new *kind* of expected failure appears; a feature-specific
/// failure that doesn't fit these should extend [Failure] directly rather
/// than reusing an unrelated subtype.
@immutable
sealed class Failure {
  const Failure(this.message);

  /// A message safe to log; not necessarily safe to show a user verbatim -
  /// presentation code maps this to a localized, user-facing string via
  /// packages/design_system's error-state widgets.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The network/transport layer failed - timeout, no connectivity, DNS,
/// or a non-2xx HTTP response packages/network couldn't map more
/// specifically.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  bool operator ==(Object other) =>
      other is NetworkFailure &&
      other.message == message &&
      other.statusCode == statusCode;

  @override
  int get hashCode => Object.hash(message, statusCode);
}

/// The request reached the server but was rejected as invalid - a 400 with
/// field-level errors, or a client-side validation check before the request
/// was even sent.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.fieldErrors = const {}});

  /// Field name -> error message, for form-level display.
  final Map<String, String> fieldErrors;

  @override
  bool operator ==(Object other) =>
      other is ValidationFailure &&
      other.message == message &&
      _mapEquals(other.fieldErrors, fieldErrors);

  @override
  int get hashCode => Object.hash(
    message,
    // `MapEntry` has no value-based `==`/`hashCode` of its own (it's
    // identity-based), so hashing `fieldErrors.entries` directly would
    // give two `==`-equal ValidationFailures different hash codes -
    // violating the hashCode/equals contract. Hash each key/value pair's
    // own hash instead.
    Object.hashAllUnordered(
      fieldErrors.entries.map((e) => Object.hash(e.key, e.value)),
    ),
  );
}

/// The requested resource does not exist (HTTP 404, or a local-storage
/// lookup that came back empty when the caller expected a value).
final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);

  @override
  bool operator ==(Object other) =>
      other is NotFoundFailure && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

/// The caller isn't authenticated, or the token has expired and refresh
/// failed - packages/network's auth interceptor produces this after a
/// refresh attempt is exhausted, distinct from a plain 401 mid-refresh.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);

  @override
  bool operator ==(Object other) =>
      other is UnauthorizedFailure && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

/// Anything that doesn't fit the above - always carries the original
/// [cause] so it isn't a dead end for debugging, but presentation code
/// must never assume anything about its shape beyond [Failure.message].
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {this.cause});

  final Object? cause;

  @override
  bool operator ==(Object other) =>
      other is UnexpectedFailure &&
      other.message == message &&
      other.cause == cause;

  @override
  int get hashCode => Object.hash(message, cause);
}

bool _mapEquals(Map<String, String> a, Map<String, String> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}
