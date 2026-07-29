import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    testWidgets(
      'light theme exposes AppSpacing, AppRadius, AppSemanticColors',
      (tester) async {
        late BuildContext capturedContext;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        final theme = Theme.of(capturedContext);
        expect(theme.appSpacing.md, 16);
        expect(theme.appRadius.md, 8);
        expect(theme.appColors.success, isNotNull);
      },
    );

    testWidgets('dark theme uses dark semantic colors', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final theme = Theme.of(capturedContext);
      expect(theme.colorScheme.brightness, Brightness.dark);
      expect(theme.appColors.success, AppSemanticColors.dark().success);
    });
  });
}
