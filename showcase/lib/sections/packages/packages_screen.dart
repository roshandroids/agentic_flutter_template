import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'package_detail_screen.dart';
import 'package_registry.dart';

/// Package Explorer - every reusable package/module this template ships,
/// linking to a full documentation page for each. See
/// docs/architecture/PACKAGE_STRATEGY.md for the packages/ vs modules/
/// distinction this list mirrors.
class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return AppScaffold(
      title: 'Packages',
      applyBodyPadding: false,
      body: ListView.separated(
        padding: EdgeInsets.all(spacing.md),
        itemCount: packageRegistry.length,
        separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
        itemBuilder: (context, index) {
          final info = packageRegistry[index];
          return Card(
            child: ListTile(
              title: Text(info.name),
              subtitle: Text(info.tagline),
              trailing: const Icon(Icons.chevron_right),
              isThreeLine: true,
              onTap: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => PackageDetailScreen(info: info),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
