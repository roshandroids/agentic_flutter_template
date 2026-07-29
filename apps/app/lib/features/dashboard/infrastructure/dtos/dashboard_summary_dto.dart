import '../../domain/entities/dashboard_summary.dart';

/// The wire shape - never leaks into `domain/` or `presentation/`. Mapping
/// to [DashboardSummary] happens here, once, at the infrastructure
/// boundary.
class DashboardSummaryDto {
  const DashboardSummaryDto({
    required this.name,
    required this.itemCount,
    required this.updatedAtIso,
  });

  factory DashboardSummaryDto.fromJson(Map<String, dynamic> json) =>
      DashboardSummaryDto(
        name: json['name'] as String,
        itemCount: json['item_count'] as int,
        updatedAtIso: json['updated_at'] as String,
      );

  final String name;
  final int itemCount;
  final String updatedAtIso;

  DashboardSummary toDomain() => DashboardSummary(
    greetingName: name,
    itemCount: itemCount,
    lastUpdated: DateTime.parse(updatedAtIso),
  );
}
