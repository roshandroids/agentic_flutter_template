import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/sections/packages/package_registry.dart';
import 'package:showcase/sections/packages/packages_screen.dart';

// Tall viewport: a ListView only builds the items in view, and the
// registry's six cards (each isThreeLine) overflow the default test
// surface - the same reason the old showcase_smoke_test.dart used one.
void _useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('lists every registered package', (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const PackagesScreen()),
    );

    for (final info in packageRegistry) {
      expect(find.text(info.name), findsOneWidget);
    }
  });

  testWidgets('tapping a package opens its detail page', (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const PackagesScreen()),
    );

    await tester.tap(find.text('core'));
    await tester.pumpAndSettle();

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Public API'), findsOneWidget);
  });
}
