import 'package:app/features/dashboard/infrastructure/repositories/dashboard_repository_impl.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardRepositoryImpl', () {
    test('maps a successful response to DashboardSummary', () async {
      final apiClient = FakeApiClient();
      apiClient.whenPath(
        '/dashboard/summary',
        const Ok<Map<String, dynamic>, Failure>({
          'name': 'Ada',
          'item_count': 3,
          'updated_at': '2026-01-01T00:00:00.000Z',
        }),
      );
      final repository = DashboardRepositoryImpl(apiClient);

      final result = await repository.fetchSummary();

      expect(result.dataOrNull?.greetingName, 'Ada');
      expect(result.dataOrNull?.itemCount, 3);
    });

    test('propagates a Failure from the ApiClient untouched', () async {
      final apiClient = FakeApiClient();
      apiClient.whenPath(
        '/dashboard/summary',
        const Err<Map<String, dynamic>, Failure>(NetworkFailure('down')),
      );
      final repository = DashboardRepositoryImpl(apiClient);

      final result = await repository.fetchSummary();

      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });
}
