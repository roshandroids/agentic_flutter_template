import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/sections/components/components_screen.dart';

void main() {
  testWidgets('renders every design_system widget it demonstrates', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const ComponentsScreen()),
    );
    // Not pumpAndSettle: the Loading section's CircularProgressIndicator
    // animates indefinitely.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Buttons'), findsOneWidget);
    expect(find.byType(AppButton), findsWidgets);
    expect(find.text('Loading'), findsWidgets);
    expect(find.byType(LoadingView), findsOneWidget);
    expect(find.text('Error'), findsOneWidget);
    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Empty'), findsOneWidget);
    expect(find.byType(EmptyView), findsOneWidget);
  });
}
