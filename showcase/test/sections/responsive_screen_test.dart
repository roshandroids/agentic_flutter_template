import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/sections/responsive/responsive_screen.dart';

void main() {
  testWidgets('reports mobile below the tablet breakpoint', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const ResponsiveScreen()),
    );

    expect(find.text('Current: mobile (<600px)'), findsOneWidget);
  });

  testWidgets('reports desktop at or above the desktop breakpoint', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const ResponsiveScreen()),
    );

    expect(find.text('Current: desktop (≥1024px)'), findsOneWidget);
  });
}
