import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../shell/section_heading.dart';

/// The spacing and radius scales every shared widget builds from - see
/// packages/design_system/lib/src/tokens.
class DesignTokensScreen extends StatelessWidget {
  const DesignTokensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return AppScaffold(
      title: 'Design tokens',
      body: ListView(
        children: [
          const SectionHeading(
            title: 'Spacing scale',
            child: _SpacingShowcase(),
          ),
          SizedBox(height: spacing.lg),
          const SectionHeading(title: 'Radius scale', child: _RadiusShowcase()),
        ],
      ),
    );
  }
}

class _SpacingShowcase extends StatelessWidget {
  const _SpacingShowcase();

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    final entries = {
      'xs': spacing.xs,
      'sm': spacing.sm,
      'md': spacing.md,
      'lg': spacing.lg,
      'xl': spacing.xl,
      'xxl': spacing.xxl,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in entries.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                SizedBox(width: 40, child: Text(entry.key)),
                Container(
                  width: entry.value,
                  height: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text('${entry.value.toStringAsFixed(0)}px'),
              ],
            ),
          ),
      ],
    );
  }
}

class _RadiusShowcase extends StatelessWidget {
  const _RadiusShowcase();

  @override
  Widget build(BuildContext context) {
    final radius = Theme.of(context).appRadius;
    final spacing = Theme.of(context).appSpacing;
    final entries = {'sm': radius.sm, 'md': radius.md, 'lg': radius.lg};

    return Wrap(
      spacing: spacing.md,
      children: [
        for (final entry in entries.entries)
          Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(entry.value),
                ),
              ),
              Text(entry.key),
            ],
          ),
      ],
    );
  }
}
