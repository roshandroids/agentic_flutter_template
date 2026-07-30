/// Structured documentation for one real workspace package or module,
/// rendered by [PackageDetailScreen] - see package_registry.dart for the
/// list this template ships with.
class PackageInfo {
  const PackageInfo({
    required this.id,
    required this.name,
    required this.tagline,
    required this.kind,
    required this.overview,
    required this.architecture,
    required this.dependencies,
    required this.publicApi,
    required this.examples,
    required this.bestPractices,
    required this.testingStrategy,
    required this.extensionPoints,
    required this.relatedAdrs,
    required this.relatedPackageIds,
  });

  /// Matches the directory name under `packages/` or `modules/`.
  final String id;

  final String name;
  final String tagline;

  /// e.g. "Package - Domain layer" or "Module - modules/*". Shown as a
  /// subtitle chip; not a controlled enum because new kinds (a future
  /// `tools/*` entry, say) shouldn't require a code change here.
  final String kind;

  final String overview;
  final String architecture;
  final List<String> dependencies;
  final List<String> publicApi;
  final List<String> examples;
  final List<String> bestPractices;
  final String testingStrategy;
  final List<String> extensionPoints;
  final List<String> relatedAdrs;

  /// [PackageInfo.id] values of related entries in the same registry -
  /// resolved against the full list at render time rather than storing a
  /// direct reference, so entries can be declared in any order.
  final List<String> relatedPackageIds;
}
