import 'package:core/core.dart';

import '../../domain/entities/feature_name.dart';
import '../../domain/repositories/feature_name_repository.dart';
import '../dtos/feature_name_dto.dart';

/// The only concrete [FeatureNameRepository]. Constructed at
/// `apps/app/lib/composition_root.dart`, never directly by
/// `application/` code. TODO: replace the endpoint path.
class FeatureNameRepositoryImpl implements FeatureNameRepository {
  FeatureNameRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<FeatureName, Failure>> fetch() => _apiClient.get<FeatureName>(
    '/feature_name',
    decode: (json) =>
        FeatureNameDto.fromJson(json as Map<String, dynamic>).toDomain(),
  );
}
