import 'package:app/routing/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

GoRouter _routerWithShell() => GoRouter(
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const Text('dashboard body'),
            ),
          ],
        ),
      ],
    ),
  ],
);

void main() {
  // Today's AppShell has exactly one destination (Dashboard) - Material's
  // NavigationBar requires 2+, and one destination has nothing to
  // navigate between anyway, so AppShell renders no chrome at all. Once a
  // second feature/branch is added, update these to assert the chrome
  // *does* appear (see app_shell.dart's `_destinations.length < 2` check).
  testWidgets('renders no nav chrome with a single destination (mobile size)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: _routerWithShell()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('dashboard body'), findsOneWidget);
  });

  testWidgets(
    'renders no nav chrome with a single destination (desktop size)',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: _routerWithShell()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.text('dashboard body'), findsOneWidget);
    },
  );
}
