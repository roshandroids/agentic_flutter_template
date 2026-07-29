/// What [AuthInterceptor] needs from the app to attach and refresh auth
/// tokens - implemented at the composition root (backed by
/// packages/local_storage's SecureStore, or a modules/auth module), never
/// by this package itself. Keeps `network` ignorant of *how* tokens are
/// obtained, only that they can be.
abstract interface class AuthTokenProvider {
  /// The current access token, or `null` if signed out.
  Future<String?> get accessToken;

  /// Attempts to refresh the access token (e.g. via a refresh token).
  /// Returns `true` on success - the interceptor then retries the original
  /// request once with the new token. Returns `false` if refresh failed,
  /// in which case the original 401 propagates as [UnauthorizedFailure].
  Future<bool> refresh();
}
