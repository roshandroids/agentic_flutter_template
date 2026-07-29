import 'package:core/core.dart';

import '../entities/feature_name.dart';

/// The contract `application/` depends on; `infrastructure/` implements
/// it. `application/` code never imports the `*RepositoryImpl` directly -
/// only this interface, bound at `apps/app/lib/composition_root.dart`.
abstract interface class FeatureNameRepository {
  Future<Result<FeatureName, Failure>> fetch();
}
