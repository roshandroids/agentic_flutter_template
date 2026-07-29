import 'dart:developer' as developer;

import 'package:module_contracts/module_contracts.dart';

/// The template's default `AnalyticsModule` - logs to the console via
/// `dart:developer` instead of sending events anywhere. This is a genuine,
/// working default (useful during development, safe with no vendor
/// credentials configured), not a placeholder - swap it for a real
/// provider module by binding a different `AnalyticsModule` implementation
/// at `apps/app/lib/composition_root.dart`.
class ConsoleAnalyticsModule implements AnalyticsModule {
  final Map<String, String?> _userProperties = {};

  @override
  void logEvent(String name, {Map<String, Object?> parameters = const {}}) {
    developer.log('event: $name $parameters', name: 'analytics');
  }

  @override
  void setUserProperty(String name, String? value) {
    _userProperties[name] = value;
    developer.log('user property: $name=$value', name: 'analytics');
  }
}
