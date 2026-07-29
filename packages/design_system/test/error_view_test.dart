import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorView', () {
    testWidgets('shows a friendly message for NetworkFailure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(failure: NetworkFailure('timeout'))),
        ),
      );

      expect(
        find.text("Couldn't connect. Check your connection and try again."),
        findsOneWidget,
      );
    });

    testWidgets('shows the ValidationFailure message verbatim', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(failure: ValidationFailure('Email is required')),
          ),
        ),
      );

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('tapping retry calls onRetry', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              failure: const UnexpectedFailure('boom'),
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retried, isTrue);
    });

    testWidgets('no retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(failure: NotFoundFailure('gone'))),
        ),
      );

      expect(find.text('Retry'), findsNothing);
    });
  });
}
