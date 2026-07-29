/// Implemented by whichever analytics module is enabled. Kept
/// provider-agnostic (event name + flat param map) rather than modeling
/// any one vendor's SDK shape - a module translates this into its
/// provider's actual call.
abstract interface class AnalyticsModule {
  void logEvent(String name, {Map<String, Object?> parameters = const {}});

  void setUserProperty(String name, String? value);
}
