import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/sections/packages/package_detail_screen.dart';
import 'package:showcase/sections/packages/package_registry.dart';

// Tall viewport: a ListView only builds the items in view, and this
// screen's ten titled sections overflow the default test surface.
void _useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 6000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('renders every documentation field for a package', (
    tester,
  ) async {
    _useTallViewport(tester);
    final core = findPackageInfo('core')!;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: PackageDetailScreen(info: core),
      ),
    );

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Architecture'), findsOneWidget);
    expect(find.text('Dependencies'), findsOneWidget);
    expect(find.text('Public API'), findsOneWidget);
    expect(find.text('Examples'), findsOneWidget);
    expect(find.text('Best practices'), findsOneWidget);
    expect(find.text('Testing'), findsOneWidget);
    expect(find.text('Extension points'), findsOneWidget);
    expect(find.text('Related ADRs'), findsOneWidget);
    expect(find.text('Related packages'), findsOneWidget);
  });

  testWidgets('tapping a related package chip navigates to its page', (
    tester,
  ) async {
    _useTallViewport(tester);
    final core = findPackageInfo('core')!;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: PackageDetailScreen(info: core),
      ),
    );

    await tester.tap(find.widgetWithText(ActionChip, 'network'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'dio-based ApiClient implementation - auth attachment/refresh, '
        'retry with backoff, and DioException-to-Failure mapping.',
      ),
      findsOneWidget,
    );
  });
}
