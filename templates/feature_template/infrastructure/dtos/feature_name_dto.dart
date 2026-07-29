import '../../domain/entities/feature_name.dart';

/// The wire shape - never leaks into `domain/` or `presentation/`. Mapping
/// to [FeatureName] happens here, once, at the infrastructure boundary.
/// TODO: replace with feature_name's real fields.
class FeatureNameDto {
  const FeatureNameDto();

  factory FeatureNameDto.fromJson(Map<String, dynamic> _) =>
      const FeatureNameDto();

  FeatureName toDomain() => const FeatureName();
}
