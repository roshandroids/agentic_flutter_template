import 'package:analytics/analytics.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:module_contracts/module_contracts.dart';

/// Mirrors the explicit, hand-built registration in
/// `apps/app/lib/composition_root.dart` - showcase is a separate consumer
/// app, so it declares its own copy rather than sharing apps/app's
/// composition root. See modules/README.md "Module registry (diagnostics
/// only)": this list is metadata for display, not how the button below
/// gets its `AnalyticsModule` instance.
const _moduleRegistry = ModuleRegistry([
  ModuleDescriptor(
    id: 'analytics',
    version: '0.1.0',
    capabilities: {'AnalyticsModule'},
  ),
]);

/// Demonstrates the module system end-to-end: the registry above for
/// "what's enabled", and a real `ConsoleAnalyticsModule` instance below
/// for "it actually works" - pressing the button calls the real
/// `AnalyticsModule.logEvent`, not a re-implementation of it.
class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  final AnalyticsModule _analytics = ConsoleAnalyticsModule();
  final List<String> _triggeredEvents = [];

  void _logDashboardViewed() {
    _analytics.logEvent('dashboard_viewed', parameters: {'source': 'showcase'});
    setState(() => _triggeredEvents.insert(0, 'dashboard_viewed'));
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;

    return AppScaffold(
      title: 'Modules',
      body: ListView(
        children: [
          Text(
            'Enabled modules',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: spacing.sm),
          Text(
            'Read-only metadata from the module registry - see '
            'modules/README.md. Composition still happens by hand in '
            'composition_root.dart; this list only reports on it.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: spacing.md),
          if (_moduleRegistry.isEmpty)
            const Text('No modules enabled.')
          else
            for (final module in _moduleRegistry.modules)
              Card(
                child: ListTile(
                  title: Text(module.id),
                  subtitle: Text(
                    'v${module.version} · '
                    '${module.capabilities.join(', ')} · '
                    '${module.hasLifecycle ? 'has lifecycle' : 'no lifecycle'}',
                  ),
                ),
              ),
          SizedBox(height: spacing.xl),
          Text(
            'Try the real module',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: spacing.sm),
          Text(
            'This calls the actual ConsoleAnalyticsModule.logEvent - open '
            'your IDE or DevTools console to see the "analytics" log line '
            'it produces.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: spacing.sm),
          AppButton(
            label: 'Log dashboard_viewed event',
            onPressed: _logDashboardViewed,
          ),
          SizedBox(height: spacing.md),
          for (final event in _triggeredEvents)
            Text('• $event', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
