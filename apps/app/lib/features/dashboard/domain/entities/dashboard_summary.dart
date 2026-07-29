/// The dashboard feature's own vocabulary - plain Dart, zero Flutter
/// import, zero dependency on how it's fetched or rendered. See
/// docs/architecture/ARCHITECTURE.md's four-layer feature shape.
class DashboardSummary {
  const DashboardSummary({
    required this.greetingName,
    required this.itemCount,
    required this.lastUpdated,
  });

  final String greetingName;
  final int itemCount;
  final DateTime lastUpdated;

  @override
  bool operator ==(Object other) =>
      other is DashboardSummary &&
      other.greetingName == greetingName &&
      other.itemCount == itemCount &&
      other.lastUpdated == lastUpdated;

  @override
  int get hashCode => Object.hash(greetingName, itemCount, lastUpdated);

  @override
  String toString() =>
      'DashboardSummary(greetingName: $greetingName, itemCount: $itemCount, lastUpdated: $lastUpdated)';
}
