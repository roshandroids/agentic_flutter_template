import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_storage/local_storage.dart';
import 'package:network/network.dart';

import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/infrastructure/repositories/dashboard_repository_impl.dart';
import 'shared/network/app_auth_token_provider.dart';

/// The only file that constructs concrete infrastructure classes and binds
/// them to their abstract providers - see
/// docs/architecture/ARCHITECTURE.md "Dependency injection" and
/// docs/adr/ADR-0003. Nowhere else in `apps/app` should import
/// `DioApiClient`, `SharedPreferencesKeyValueStore`,
/// `FlutterSecureStorageAdapter`, or a feature's `*RepositoryImpl`
/// directly - only the abstract types these providers expose.

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.example.com',
);

final secureStoreProvider = Provider<SecureStore>(
  (ref) => FlutterSecureStorageAdapter(),
);

final keyValueStoreProvider = Provider<KeyValueStore>(
  (ref) => SharedPreferencesKeyValueStore(),
);

final authTokenProviderProvider = Provider<AuthTokenProvider>(
  (ref) => AppAuthTokenProvider(ref.watch(secureStoreProvider)),
);

final apiClientProvider = Provider<ApiClient>(
  (ref) => DioApiClient(
    baseUrl: _apiBaseUrl,
    tokenProvider: ref.watch(authTokenProviderProvider),
  ),
);

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepositoryImpl(ref.watch(apiClientProvider)),
);
