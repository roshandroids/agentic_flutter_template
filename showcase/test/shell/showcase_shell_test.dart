import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/main.dart';
import 'package:showcase/shell/showcase_sections.dart';

Future<void> _pumpShell(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  // Not pumpAndSettle: Components' Loading section has an indefinitely
  // animating CircularProgressIndicator, and IndexedStack keeps every
  // section mounted regardless of which is selected - pumpAndSettle would
  // time out waiting for it. A couple of fixed pumps is enough for
  // everything else to finish building.
  await tester.pumpWidget(const ShowcaseApp());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  group('adaptive nav chrome', () {
    testWidgets('shows a NavigationRail on desktop, not a NavigationBar', (
      tester,
    ) async {
      await _pumpShell(tester, const Size(1200, 900));

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('shows a NavigationBar on mobile, not a NavigationRail', (
      tester,
    ) async {
      await _pumpShell(tester, const Size(400, 800));

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });
  });

  group('section navigation', () {
    testWidgets('Home is the initial section', (tester) async {
      await _pumpShell(tester, const Size(1200, 900));

      expect(find.text('Agentic Flutter Template Playground'), findsOneWidget);
    });

    testWidgets('selecting a rail destination shows that section', (
      tester,
    ) async {
      await _pumpShell(tester, const Size(1200, 900));

      final componentsIcon = showcaseSections
          .firstWhere((s) => s.id == 'components')
          .icon;
      await tester.tap(find.byIcon(componentsIcon));
      await tester.pump();

      expect(find.text('Buttons'), findsOneWidget);
    });

    testWidgets('selecting a bottom-nav destination shows that section', (
      tester,
    ) async {
      await _pumpShell(tester, const Size(400, 800));

      final modulesIcon = showcaseSections
          .firstWhere((s) => s.id == 'modules')
          .icon;
      await tester.tap(find.byIcon(modulesIcon));
      await tester.pump();

      expect(find.text('Enabled modules'), findsOneWidget);
    });

    testWidgets('switching away and back preserves section state', (
      tester,
    ) async {
      await _pumpShell(tester, const Size(1200, 900));

      final modulesIcon = showcaseSections
          .firstWhere((s) => s.id == 'modules')
          .icon;
      final homeIcon = showcaseSections.firstWhere((s) => s.id == 'home').icon;

      await tester.tap(find.byIcon(modulesIcon));
      await tester.pump();
      await tester.tap(find.text('Log dashboard_viewed event'));
      await tester.pump();
      expect(find.text('• dashboard_viewed'), findsOneWidget);

      await tester.tap(find.byIcon(homeIcon));
      await tester.pump();
      await tester.tap(find.byIcon(modulesIcon));
      await tester.pump();

      expect(find.text('• dashboard_viewed'), findsOneWidget);
    });
  });
}
