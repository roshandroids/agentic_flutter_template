import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveLayout', () {
    testWidgets('renders mobile builder below the tablet breakpoint', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayout(
            mobile: (_) => const Text('mobile'),
            tablet: (_) => const Text('tablet'),
            desktop: (_) => const Text('desktop'),
          ),
        ),
      );

      expect(find.text('mobile'), findsOneWidget);
      expect(find.text('tablet'), findsNothing);
    });

    testWidgets('renders tablet builder between breakpoints', (tester) async {
      tester.view.physicalSize = const Size(700, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayout(
            mobile: (_) => const Text('mobile'),
            tablet: (_) => const Text('tablet'),
            desktop: (_) => const Text('desktop'),
          ),
        ),
      );

      expect(find.text('tablet'), findsOneWidget);
    });

    testWidgets('renders desktop builder at/above the desktop breakpoint', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayout(
            mobile: (_) => const Text('mobile'),
            tablet: (_) => const Text('tablet'),
            desktop: (_) => const Text('desktop'),
          ),
        ),
      );

      expect(find.text('desktop'), findsOneWidget);
    });

    testWidgets('falls back to mobile when tablet/desktop are not provided', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayout(mobile: (_) => const Text('mobile')),
        ),
      );

      expect(find.text('mobile'), findsOneWidget);
    });
  });
}
