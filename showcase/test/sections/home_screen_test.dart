import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/sections/home/home_screen.dart';

void main() {
  testWidgets('renders the Playground orientation copy', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const HomeScreen()),
    );

    expect(find.text('Agentic Flutter Template Playground'), findsOneWidget);
  });
}
