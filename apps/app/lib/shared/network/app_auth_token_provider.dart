import 'package:core/core.dart';
import 'package:network/network.dart';

/// Bridges `network`'s [AuthTokenProvider] contract to `core`'s
/// [SecureStore]. Lives under `shared/`, not a feature, because it's
/// infrastructure the composition root needs before any feature does -
/// see docs/architecture/ARCHITECTURE.md "Dependency injection".
///
/// No real auth module is enabled yet (`template.config.yaml`'s
/// `modules.enabled` is empty) - `refresh()` is a stub returning `false`
/// until an `auth` module is added via `./scripts/new_module.sh auth` and
/// wired in here. Do not treat this as "auth is implemented."
class AppAuthTokenProvider implements AuthTokenProvider {
  AppAuthTokenProvider(this._secureStore);

  static const _accessTokenKey = 'auth.access_token';

  final SecureStore _secureStore;

  @override
  Future<String?> get accessToken => _secureStore.read(_accessTokenKey);

  @override
  Future<bool> refresh() async => false;
}
