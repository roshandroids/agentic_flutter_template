import 'package_info.dart';

/// Every reusable package and module this template ships, in dependency
/// order (innermost first). Adding an entry is the only step needed to
/// give a new package/module a Package Explorer page - see
/// showcase/README.md "Adding a section".
///
/// Six entries, not the twelve a generic "every Flutter template package"
/// list might assume - this template ships `core`, `network`,
/// `local_storage`, `design_system`, plus `module_contracts` and one
/// reference module (`analytics`). A name here should match a real
/// directory under `packages/` or `modules/`.
final List<PackageInfo> packageRegistry = [
  const PackageInfo(
    id: 'core',
    name: 'core',
    tagline:
        'Domain-layer foundation - Result/Failure error handling and the '
        'storage/network abstractions everything else implements.',
    kind: 'Package - Domain layer',
    overview:
        'Zero-Flutter-dependency domain layer shared by every package and '
        'app in the workspace. Defines the error-handling type '
        '(Result/Failure) and the abstract interfaces (ApiClient, '
        'KeyValueStore, SecureStore) that network and local_storage '
        'implement concretely.',
    architecture:
        'The innermost layer in this template\'s Clean Architecture - '
        'every other package and app depends on core; core depends on '
        'nothing local. Enforced by scripts/check_dependency_boundaries.sh, '
        'not just convention.',
    dependencies: ['meta (^1.15.0) - the only dependency, local or external'],
    publicApi: [
      'Result<T, Failure> / Ok / Err - the return type every repository '
          'and use case uses instead of throwing',
      'Failure and its subtypes: NetworkFailure, ValidationFailure, '
          'NotFoundFailure, UnauthorizedFailure, UnexpectedFailure',
      'ApiClient - the interface network\'s DioApiClient implements',
      'KeyValueStore / SecureStore - the interfaces local_storage '
          'implements',
      'testing.dart (separate entry point, test-only): FakeApiClient, '
          'InMemoryKeyValueStore, InMemorySecureStore',
    ],
    examples: [
      'result.fold(onOk: (v) => ..., onErr: (f) => ...) - the standard way '
          'to unwrap a Result',
      'See packages/core/test/result_test.dart and failure_test.dart',
    ],
    bestPractices: [
      'Never let this package gain a package:flutter import, even '
          'transitively through a dev dependency',
      'Repositories return Result<T, Failure>, never throw for expected '
          'failure paths - throw is reserved for programmer errors',
      'Import core/testing.dart only from test/, never from lib/',
    ],
    testingStrategy:
        'Plain package:test, no widget harness - core has zero Flutter '
        'dependency so every test runs in milliseconds.',
    extensionPoints: [
      'Add a new Failure subtype here when an error case doesn\'t fit the '
          'existing ones',
      'Add a new abstract interface here (not in network/local_storage) '
          'when a new category of infrastructure needs a swappable '
          'implementation',
    ],
    relatedAdrs: [
      'ADR-0004: Result/Failure error handling',
      'ADR-0006: Feature-first over layer-first',
    ],
    relatedPackageIds: ['network', 'local_storage', 'module_contracts'],
  ),
  const PackageInfo(
    id: 'network',
    name: 'network',
    tagline:
        'dio-based ApiClient implementation - auth attachment/refresh, '
        'retry with backoff, and DioException-to-Failure mapping.',
    kind: 'Package - Infrastructure layer',
    overview:
        'The only package allowed to import package:dio. Implements '
        'core\'s ApiClient so every repository talks to an abstract '
        'interface, never to dio directly - swapping HTTP clients later '
        'touches this package only.',
    architecture:
        'Infrastructure layer - depends on core, implements core\'s '
        'ApiClient. apps/app/lib/composition_root.dart is the only place '
        'that constructs DioApiClient.',
    dependencies: [
      'core (path) - implements ApiClient, returns core\'s Failure types',
      'dio (^5.7.0) - never imported outside this package',
    ],
    publicApi: [
      'DioApiClient - the only concrete ApiClient',
      'AuthInterceptor - attaches the current token, refreshes once on '
          '401 and retries',
      'RetryInterceptor - exponential backoff for idempotent GET/PUT/'
          'DELETE on transport failures',
      'mapDioExceptionToFailure - the only place that understands dio\'s '
          'exception shape',
    ],
    examples: [
      'apiClientProvider in apps/app/lib/composition_root.dart constructs '
          'the only DioApiClient instance',
      'See test/dio_api_client_test.dart for auth-refresh and retry '
          'behavior asserted directly',
    ],
    bestPractices: [
      'No package outside network should import package:dio directly - '
          'go through core\'s ApiClient',
      'RetryInterceptor only retries idempotent methods and '
          'transport-level failures - never a POST or a 4xx',
    ],
    testingStrategy:
        'package:test with a mocked dio adapter - see '
        'test/dio_api_client_test.dart (auth refresh, retry, every HTTP '
        'verb) and test/error_mapper_test.dart (every DioException type).',
    extensionPoints: [
      'Add a new interceptor here (request logging, caching) rather than '
          'in composition_root.dart',
      'mapDioExceptionToFailure is the one place to extend if a new '
          'DioExceptionType needs a specific Failure',
    ],
    relatedAdrs: ['ADR-0004: Result/Failure error handling'],
    relatedPackageIds: ['core', 'local_storage'],
  ),
  const PackageInfo(
    id: 'local_storage',
    name: 'local_storage',
    tagline:
        'shared_preferences + flutter_secure_storage implementations of '
        'core\'s KeyValueStore/SecureStore.',
    kind: 'Package - Infrastructure layer',
    overview:
        'Concrete storage backends behind core\'s abstract interfaces. '
        'Repositories never import shared_preferences or '
        'flutter_secure_storage directly - swapping to Hive/Isar or a '
        'different secure storage plugin means a new implementation here, '
        'zero feature-code changes.',
    architecture:
        'Infrastructure layer - depends on core and Flutter plugins, '
        'implements core\'s storage interfaces.',
    dependencies: [
      'core (path)',
      'shared_preferences (^2.3.3)',
      'flutter_secure_storage (^10.3.1)',
    ],
    publicApi: [
      'SharedPreferencesKeyValueStore implements KeyValueStore',
      'FlutterSecureStorageAdapter implements SecureStore',
    ],
    examples: [
      'keyValueStoreProvider / secureStoreProvider in '
          'apps/app/lib/composition_root.dart wire the concrete adapters '
          'behind core\'s interfaces',
    ],
    bestPractices: [
      'Depend on core\'s KeyValueStore/SecureStore interfaces from '
          'feature code, never on this package\'s concrete classes',
    ],
    testingStrategy:
        'flutter_test for both adapters; core\'s testing.dart provides '
        'InMemoryKeyValueStore/InMemorySecureStore fakes for feature-level '
        'tests that don\'t need real plugin channels.',
    extensionPoints: [
      'Add a new KeyValueStore/SecureStore implementation here to swap '
          'backends without touching core\'s interface or any feature',
    ],
    relatedAdrs: ['ADR-0004: Result/Failure error handling'],
    relatedPackageIds: ['core', 'network'],
  ),
  const PackageInfo(
    id: 'design_system',
    name: 'design_system',
    tagline:
        'Material 3 theme tokens, responsive layout, and shared widgets - '
        'the presentation layer\'s common building blocks.',
    kind: 'Package - Presentation layer',
    overview:
        'One definition of theme, spacing/radius/color tokens, and '
        'adaptive breakpoints instead of every feature reinventing them. '
        'Every shared widget here is demonstrated live in this '
        'Playground\'s Components and Design tokens sections.',
    architecture:
        'Presentation-layer package - depends on core (for ErrorView\'s '
        'Failure parameter), never on network or local_storage directly '
        '(enforced by check_dependency_boundaries.sh).',
    dependencies: [
      'core (path) - ErrorView takes a core.Failure',
      'flutter (sdk)',
    ],
    publicApi: [
      'AppTheme.light() / AppTheme.dark()',
      'AppSpacing, AppRadius, AppSemanticColors - ThemeExtension token '
          'scales via Theme.of(context)',
      'deviceTypeOf(context) / ResponsiveLayout - breakpoint-based '
          'adaptive layout',
      'AppButton, LoadingView, ErrorView, EmptyView, AppScaffold',
    ],
    examples: [
      'This Playground\'s Components section renders every widget above '
          'live',
      'Design tokens section renders the full spacing and radius scales',
    ],
    bestPractices: [
      'Reach for AppSpacing/AppRadius tokens instead of hardcoded '
          'EdgeInsets/BorderRadius values',
      'ErrorView takes a core.Failure so error rendering stays generic '
          'across every feature',
    ],
    testingStrategy:
        'flutter_test widget tests per widget/token - see '
        'packages/design_system/test/.',
    extensionPoints: [
      'Add a new shared widget here (not inside a feature) once it\'s '
          'used by 2+ features - add its Playground demonstration in the '
          'same PR',
    ],
    relatedAdrs: ['ADR-0004: Result/Failure error handling'],
    relatedPackageIds: ['core'],
  ),
  const PackageInfo(
    id: 'module_contracts',
    name: 'module_contracts',
    tagline:
        'Pure-Dart contracts every modules/* integration implements - '
        'AuthModule, AnalyticsModule, NotificationsModule, PaymentsModule.',
    kind: 'Module contract - modules/*',
    overview:
        'Models each pluggable capability generically (sign in, log an '
        'event, send a notification, process a payment) with zero '
        'provider SDK dependency, so modules/firebase and modules/supabase '
        'can both implement the same contract and be swapped at '
        'composition_root.dart without touching feature code. Also home '
        'to ModuleRegistry - diagnostics-only metadata about which '
        'modules are enabled.',
    architecture:
        'Domain layer, same constraint as core: zero Flutter import. '
        'Depends only on core.',
    dependencies: ['core (path)'],
    publicApi: [
      'AuthModule, AnalyticsModule, NotificationsModule, PaymentsModule - '
          'the contracts',
      'ModuleDescriptor / ModuleRegistry - diagnostics-only metadata, NOT '
          'a service locator',
    ],
    examples: [
      'modules/analytics implements AnalyticsModule',
      'composition_root.dart\'s moduleRegistryProvider builds a '
          'ModuleRegistry by hand',
      'This Playground\'s Modules section reads that registry',
    ],
    bestPractices: [
      'Never resolve a module through ModuleRegistry - it\'s read-only '
          'metadata for tooling/diagnostics; composition_root.dart remains '
          'the only DI mechanism',
      'A new module type gets its contract added here first, before any '
          'concrete modules/* implementation',
    ],
    testingStrategy:
        'package:test - see test/module_contracts_test.dart (each '
        'contract is implementable and callable).',
    extensionPoints: [
      'Add a new *Module abstract interface here for a capability this '
          'template hasn\'t anticipated (see modules/README.md "Adding a '
          'module")',
    ],
    relatedAdrs: [
      'ADR-0003: Melos monorepo package strategy (modules vs packages)',
      'ADR-0007: Diagnostics-only module registry',
    ],
    relatedPackageIds: ['core', 'analytics'],
  ),
  const PackageInfo(
    id: 'analytics',
    name: 'analytics',
    tagline:
        'Reference AnalyticsModule implementation - logs to the console, '
        'proves the modules/* pattern end-to-end.',
    kind: 'Module - modules/*',
    overview:
        'This template\'s first real module, wired into '
        'apps/app/lib/composition_root.dart and this Playground\'s '
        'Modules section. Demonstrates the full contract -> composition '
        'root -> registry -> Playground pattern every other modules/* '
        'integration should follow.',
    architecture:
        'A modules/* integration - implements module_contracts\' '
        'AnalyticsModule, depends on nothing else. Concrete modules may '
        'depend on Flutter plugins/SDKs freely (unlike packages/*) since '
        'only composition_root.dart ever imports one directly.',
    dependencies: ['module_contracts (path)'],
    publicApi: [
      'ConsoleAnalyticsModule implements AnalyticsModule - logs via '
          'dart:developer',
    ],
    examples: [
      'composition_root.dart\'s analyticsModuleProvider binds this as the '
          'AnalyticsModule',
      'This Playground\'s Modules section calls '
          'ConsoleAnalyticsModule.logEvent directly',
    ],
    bestPractices: [
      'A real vendor module (Firebase/Segment/PostHog) follows this exact '
          'shape - implement the contract, nothing else, bind it in '
          'composition_root.dart',
      'Not enabled unless a project needs it - template.config.yaml\'s '
          'modules.enabled opts it in explicitly',
    ],
    testingStrategy:
        'package:test - see test/console_analytics_module_test.dart.',
    extensionPoints: [
      'Replace ConsoleAnalyticsModule\'s binding in composition_root.dart '
          'with a real vendor module to swap providers - zero feature '
          'code changes',
    ],
    relatedAdrs: ['ADR-0007: Diagnostics-only module registry'],
    relatedPackageIds: ['module_contracts'],
  ),
];

/// Looks up a registered package by id, or `null` if none matches -
/// used to resolve [PackageInfo.relatedPackageIds] at render time.
PackageInfo? findPackageInfo(String id) {
  for (final info in packageRegistry) {
    if (info.id == id) return info;
  }
  return null;
}
