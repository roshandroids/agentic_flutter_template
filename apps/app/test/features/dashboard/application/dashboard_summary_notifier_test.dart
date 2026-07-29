import 'package:app/composition_root.dart';
import 'package:app/features/dashboard/application/providers/dashboard_providers.dart';
import 'package:app/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:module_contracts/module_contracts.dart';

class _FakeDashboardRepository implements DashboardRepository {
  Result<DashboardSummary, Failure> Function() onFetch = () => Ok(
    DashboardSummary(
      greetingName: 'Ada',
      itemCount: 1,
      lastUpdated: DateTime(2026),
    ),
  );

  @override
  Future<Result<DashboardSummary, Failure>> fetchSummary() async => onFetch();
}

class _FakeAnalyticsModule implements AnalyticsModule {
  final events = <String>[];

  @override
  void logEvent(String name, {Map<String, Object?> parameters = const {}}) =>
      events.add(name);

  @override
  void setUserProperty(String name, String? value) {}
}

void main() {
  group('DashboardSummaryNotifier', () {
    test('build() resolves to Ok data as AsyncData', () async {
      final repository = _FakeDashboardRepository();
      final container = ProviderContainer(
        overrides: [dashboardRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final result = await container.read(dashboardSummaryProvider.future);

      expect(result.greetingName, 'Ada');
    });

    test('build() surfaces a Failure as AsyncError', () async {
      final repository = _FakeDashboardRepository()
        ..onFetch = () => const Err(NetworkFailure('down'));
      final container = ProviderContainer(
        overrides: [dashboardRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(dashboardSummaryProvider.future),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('refresh() re-fetches and updates state', () async {
      var callCount = 0;
      final repository = _FakeDashboardRepository()
        ..onFetch = () {
          callCount++;
          return Ok(
            DashboardSummary(
              greetingName: 'Ada',
              itemCount: callCount,
              lastUpdated: DateTime(2026),
            ),
          );
        };
      final container = ProviderContainer(
        overrides: [dashboardRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(dashboardSummaryProvider.future);
      await container.read(dashboardSummaryProvider.notifier).refresh();

      final state = container.read(dashboardSummaryProvider);
      expect(state.value?.itemCount, 2);
    });

    test(
      'logs a dashboard_viewed event via the analytics module on build',
      () async {
        final analytics = _FakeAnalyticsModule();
        final container = ProviderContainer(
          overrides: [
            dashboardRepositoryProvider.overrideWithValue(
              _FakeDashboardRepository(),
            ),
            analyticsModuleProvider.overrideWithValue(analytics),
          ],
        );
        addTearDown(container.dispose);

        await container.read(dashboardSummaryProvider.future);

        expect(analytics.events, ['dashboard_viewed']);
      },
    );

    test(
      'logs a dashboard_refreshed event via the analytics module on refresh',
      () async {
        final analytics = _FakeAnalyticsModule();
        final container = ProviderContainer(
          overrides: [
            dashboardRepositoryProvider.overrideWithValue(
              _FakeDashboardRepository(),
            ),
            analyticsModuleProvider.overrideWithValue(analytics),
          ],
        );
        addTearDown(container.dispose);

        await container.read(dashboardSummaryProvider.future);
        await container.read(dashboardSummaryProvider.notifier).refresh();

        expect(analytics.events, ['dashboard_viewed', 'dashboard_refreshed']);
      },
    );
  });
}
