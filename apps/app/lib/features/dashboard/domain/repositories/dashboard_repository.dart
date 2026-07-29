import 'package:core/core.dart';

import '../entities/dashboard_summary.dart';

/// The contract `application/` depends on; `infrastructure/` implements
/// it. Application code never imports `DashboardRepositoryImpl` directly -
/// only this interface, bound to the impl at
/// `apps/app/lib/composition_root.dart`.
abstract interface class DashboardRepository {
  Future<Result<DashboardSummary, Failure>> fetchSummary();
}
