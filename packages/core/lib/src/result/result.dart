/// A value that is either a success ([Ok]) or an expected failure ([Err]).
///
/// Every repository/use-case/API-client method in this workspace returns
/// `Result<T, Failure>` for outcomes a caller is meant to handle - never
/// throws for them. `throw` stays reserved for programmer errors. See
/// docs/adr/ADR-0004-result-failure-error-handling.md for why.
sealed class Result<T, F extends Object> {
  const Result();

  /// True if this is [Ok].
  bool get isOk => this is Ok<T, F>;

  /// True if this is [Err].
  bool get isErr => this is Err<T, F>;

  /// The success value, or `null` if this is [Err]. Prefer [fold] or a
  /// `switch` when the failure case needs handling - reaching for this
  /// getter is how a failure gets silently discarded.
  T? get dataOrNull => switch (this) {
    Ok<T, F>(:final value) => value,
    Err<T, F>() => null,
  };

  /// The failure, or `null` if this is [Ok].
  F? get failureOrNull => switch (this) {
    Ok<T, F>() => null,
    Err<T, F>(:final failure) => failure,
  };

  /// Transforms the success value, leaving a failure untouched.
  Result<R, F> map<R>(R Function(T value) transform) => switch (this) {
    Ok<T, F>(:final value) => Ok(transform(value)),
    Err<T, F>(:final failure) => Err(failure),
  };

  /// Chains another `Result`-returning operation, short-circuiting on failure.
  Result<R, F> flatMap<R>(Result<R, F> Function(T value) transform) =>
      switch (this) {
        Ok<T, F>(:final value) => transform(value),
        Err<T, F>(:final failure) => Err(failure),
      };

  /// Collapses both branches into a single value - the explicit way to
  /// handle a `Result` end-to-end without discarding either side.
  R fold<R>({
    required R Function(T value) onOk,
    required R Function(F failure) onErr,
  }) => switch (this) {
    Ok<T, F>(:final value) => onOk(value),
    Err<T, F>(:final failure) => onErr(failure),
  };
}

/// A successful [Result].
final class Ok<T, F extends Object> extends Result<T, F> {
  const Ok(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Ok<T, F> && other.value == value;

  @override
  int get hashCode => Object.hash(Ok, value);

  @override
  String toString() => 'Ok($value)';
}

/// A failed [Result].
final class Err<T, F extends Object> extends Result<T, F> {
  const Err(this.failure);

  final F failure;

  @override
  bool operator ==(Object other) =>
      other is Err<T, F> && other.failure == failure;

  @override
  int get hashCode => Object.hash(Err, failure);

  @override
  String toString() => 'Err($failure)';
}
