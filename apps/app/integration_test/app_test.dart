// Cross-feature end-to-end smoke test - run on a real device/simulator or
// Chrome via `flutter test integration_test`, not `flutter test` (that
// only runs unit/widget tests). See docs/testing/README.md.
import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app launches to the dashboard shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump(const Duration(seconds: 1));

    // A real backend isn't running in this smoke test, so the dashboard is
    // expected to show its error state rather than data - this test only
    // proves the app boots, routes, and renders without crashing.
    expect(find.byType(Scaffold), findsWidgets);
  });
}
