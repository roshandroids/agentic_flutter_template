import 'package:app/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardSummary', () {
    test('equality is value-based', () {
      final updated = DateTime(2026, 1, 1);
      expect(
        DashboardSummary(
          greetingName: 'Ada',
          itemCount: 3,
          lastUpdated: updated,
        ),
        DashboardSummary(
          greetingName: 'Ada',
          itemCount: 3,
          lastUpdated: updated,
        ),
      );
    });

    test('differs when any field differs', () {
      final updated = DateTime(2026, 1, 1);
      expect(
        DashboardSummary(
          greetingName: 'Ada',
          itemCount: 3,
          lastUpdated: updated,
        ),
        isNot(
          DashboardSummary(
            greetingName: 'Grace',
            itemCount: 3,
            lastUpdated: updated,
          ),
        ),
      );
    });
  });
}
