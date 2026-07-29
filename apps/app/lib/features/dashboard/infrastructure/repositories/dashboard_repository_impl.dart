import 'package:core/core.dart';

import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../dtos/dashboard_summary_dto.dart';

/// The only concrete [DashboardRepository]. Constructed at
/// `apps/app/lib/composition_root.dart`, never directly by
/// `application/` code.
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<DashboardSummary, Failure>> fetchSummary() =>
      _apiClient.get<DashboardSummary>(
        '/dashboard/summary',
        decode: (json) => DashboardSummaryDto.fromJson(
          json as Map<String, dynamic>,
        ).toDomain(),
      );
}
