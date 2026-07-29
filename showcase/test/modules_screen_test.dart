import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/modules/modules_screen.dart';

void main() {
  testWidgets('lists the enabled analytics module', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const ModulesScreen()),
    );

    expect(find.text('analytics'), findsOneWidget);
    expect(
      find.text('v0.1.0 · AnalyticsModule · no lifecycle'),
      findsOneWidget,
    );
  });

  testWidgets('logging an event via the button records it on screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const ModulesScreen()),
    );

    expect(find.text('• dashboard_viewed'), findsNothing);

    await tester.tap(find.text('Log dashboard_viewed event'));
    await tester.pump();

    expect(find.text('• dashboard_viewed'), findsOneWidget);
  });
}
