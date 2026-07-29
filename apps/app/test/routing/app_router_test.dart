import 'package:app/composition_root.dart';
import 'package:app/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:app/l10n/generated/app_localizations.dart';
import 'package:app/routing/app_router.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDashboardRepository implements DashboardRepository {
  @override
  Future<Result<DashboardSummary, Failure>> fetchSummary() async => Ok(
    DashboardSummary(
      greetingName: 'Ada',
      itemCount: 1,
      lastUpdated: DateTime(2026),
    ),
  );
}

void main() {
  testWidgets('initialLocation /dashboard resolves to the dashboard title', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(
            _FakeDashboardRepository(),
          ),
        ],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            routerConfig: ref.watch(routerProvider),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
  });
}
