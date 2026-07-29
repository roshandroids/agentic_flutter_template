import 'package:app/composition_root.dart';
import 'package:app/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:app/l10n/generated/app_localizations.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDashboardRepository implements DashboardRepository {
  _FakeDashboardRepository(this.result, {this.delay = Duration.zero});

  final Result<DashboardSummary, Failure> result;

  /// Non-zero in the loading-state test below - a zero-delay Future
  /// resolves within the same `pump()`, before the loading state would
  /// ever be observable.
  final Duration delay;

  @override
  Future<Result<DashboardSummary, Failure>> fetchSummary() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return result;
  }
}

Widget _wrap(DashboardRepository repository) => ProviderScope(
  overrides: [dashboardRepositoryProvider.overrideWithValue(repository)],
  child: MaterialApp(
    theme: AppTheme.light(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const DashboardScreen(),
  ),
);

void main() {
  group('DashboardScreen', () {
    testWidgets('shows the summary once loaded', (tester) async {
      final repository = _FakeDashboardRepository(
        Ok(
          DashboardSummary(
            greetingName: 'Ada',
            itemCount: 2,
            lastUpdated: DateTime(2026),
          ),
        ),
      );

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      expect(find.text('Hello, Ada!'), findsOneWidget);
      expect(find.text('2 items'), findsOneWidget);
    });

    testWidgets('shows ErrorView with a retry button on failure', (
      tester,
    ) async {
      final repository = _FakeDashboardRepository(
        const Err(NetworkFailure('down')),
      );

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      expect(
        find.text("Couldn't connect. Check your connection and try again."),
        findsOneWidget,
      );
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('shows LoadingView before the future resolves', (tester) async {
      final repository = _FakeDashboardRepository(
        Ok(
          DashboardSummary(
            greetingName: 'Ada',
            itemCount: 1,
            lastUpdated: DateTime(2026),
          ),
        ),
        delay: const Duration(seconds: 1),
      );

      await tester.pumpWidget(_wrap(repository));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Let the delayed future resolve so the pending timer doesn't leak
      // into the next test.
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
