import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/sections/design_tokens/design_tokens_screen.dart';

void main() {
  testWidgets('renders the spacing and radius scales', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const DesignTokensScreen()),
    );

    expect(find.text('Spacing scale'), findsOneWidget);
    expect(find.text('Radius scale'), findsOneWidget);
    // One row/swatch per token in AppSpacing/AppRadius.
    expect(find.text('xs'), findsOneWidget);
    expect(find.text('xxl'), findsOneWidget);
  });
}
