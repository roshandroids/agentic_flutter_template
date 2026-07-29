// Golden (screenshot) coverage for AppButton - see .ai/memory/gotchas.md for
// why goldens are treated as CI-authoritative (Linux runner), not local.
@Tags(['golden'])
library;

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppButton renders every variant and state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(label: 'Primary', onPressed: _noop),
                AppButton(
                  label: 'Secondary',
                  onPressed: _noop,
                  variant: AppButtonVariant.secondary,
                ),
                AppButton(
                  label: 'Text',
                  onPressed: _noop,
                  variant: AppButtonVariant.text,
                ),
                AppButton(label: 'Disabled', onPressed: null),
                AppButton(label: 'Loading', onPressed: _noop, isLoading: true),
              ],
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/app_button.png'),
    );
  });
}

void _noop() {}
