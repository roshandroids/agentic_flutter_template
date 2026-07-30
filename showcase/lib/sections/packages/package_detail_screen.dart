import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../shell/section_heading.dart';
import 'package_info.dart';
import 'package_registry.dart';

/// The full documentation page for one package/module - every field
/// PackageInfo declares, rendered in the order a developer evaluating
/// this template would want to read them.
class PackageDetailScreen extends StatelessWidget {
  const PackageDetailScreen({required this.info, super.key});

  final PackageInfo info;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    final related = info.relatedPackageIds
        .map(findPackageInfo)
        .whereType<PackageInfo>()
        .toList();

    return AppScaffold(
      title: info.name,
      body: ListView(
        children: [
          Text(info.kind, style: Theme.of(context).textTheme.labelLarge),
          SizedBox(height: spacing.sm),
          Text(info.tagline, style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: spacing.lg),
          SectionHeading(title: 'Overview', child: Text(info.overview)),
          SizedBox(height: spacing.lg),
          SectionHeading(title: 'Architecture', child: Text(info.architecture)),
          SizedBox(height: spacing.lg),
          SectionHeading(
            title: 'Dependencies',
            child: _Bullets(info.dependencies),
          ),
          SizedBox(height: spacing.lg),
          SectionHeading(title: 'Public API', child: _Bullets(info.publicApi)),
          SizedBox(height: spacing.lg),
          SectionHeading(title: 'Examples', child: _Bullets(info.examples)),
          SizedBox(height: spacing.lg),
          SectionHeading(
            title: 'Best practices',
            child: _Bullets(info.bestPractices),
          ),
          SizedBox(height: spacing.lg),
          SectionHeading(title: 'Testing', child: Text(info.testingStrategy)),
          SizedBox(height: spacing.lg),
          SectionHeading(
            title: 'Extension points',
            child: _Bullets(info.extensionPoints),
          ),
          SizedBox(height: spacing.lg),
          SectionHeading(
            title: 'Related ADRs',
            child: _Bullets(info.relatedAdrs),
          ),
          if (related.isNotEmpty) ...[
            SizedBox(height: spacing.lg),
            SectionHeading(
              title: 'Related packages',
              child: Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                children: [
                  for (final r in related)
                    ActionChip(
                      label: Text(r.name),
                      onPressed: () => Navigator.of(context).push<void>(
                        MaterialPageRoute(
                          builder: (_) => PackageDetailScreen(info: r),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets(this.items);

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(item)),
              ],
            ),
          ),
      ],
    );
  }
}
