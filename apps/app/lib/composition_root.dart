import 'package:analytics/analytics.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_storage/local_storage.dart';
import 'package:module_contracts/module_contracts.dart';
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

/// The template's first real module binding - see modules/README.md.
/// Feature code depends on `AnalyticsModule` (from `module_contracts`),
/// never on `ConsoleAnalyticsModule` directly. Swapping analytics
/// providers means changing this one line, not any feature code.
final analyticsModuleProvider = Provider<AnalyticsModule>(
  (ref) => ConsoleAnalyticsModule(),
);

/// Diagnostics-only metadata about the modules enabled above - see
/// modules/README.md "Module registry (diagnostics only)". Built by hand
/// to mirror `template.config.yaml`'s `modules.enabled` list; nothing
/// resolves a module through this, it only reports on what's already
/// wired for tooling like the Playground's Modules screen.
final moduleRegistryProvider = Provider<ModuleRegistry>(
  (ref) => const ModuleRegistry([
    ModuleDescriptor(
      id: 'analytics',
      version: '0.1.0',
      capabilities: {'AnalyticsModule'},
    ),
  ]),
);
