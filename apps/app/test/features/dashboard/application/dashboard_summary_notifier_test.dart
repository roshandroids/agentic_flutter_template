import 'package:app/composition_root.dart';
import 'package:app/features/dashboard/application/providers/dashboard_providers.dart';
import 'package:app/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
  });
}
