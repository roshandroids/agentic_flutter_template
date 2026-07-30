import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../shell/section_heading.dart';

/// Every shared widget in `packages/design_system` - buttons and the
/// loading/error/empty states a feature's `AsyncValue.when` renders into.
/// See packages/design_system/README.md.
class ComponentsScreen extends StatelessWidget {
  const ComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return AppScaffold(
      title: 'Components',
      body: ListView(
        children: [
          const SectionHeading(title: 'Buttons', child: _ButtonsShowcase()),
          SizedBox(height: spacing.lg),
          const SectionHeading(
            title: 'Loading',
            child: LoadingView(message: 'Loading…'),
          ),
          SizedBox(height: spacing.lg),
          SectionHeading(
            title: 'Error',
            child: ErrorView(
              failure: const NetworkFailure(
                'Simulated failure for the showcase',
              ),
              onRetry: () {},
            ),
          ),
          SizedBox(height: spacing.lg),
          const SectionHeading(
            title: 'Empty',
            child: EmptyView(message: 'Nothing to show yet.'),
          ),
        ],
      ),
    );
  }
}

class _ButtonsShowcase extends StatelessWidget {
  const _ButtonsShowcase();

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return Wrap(
      spacing: spacing.sm,
      runSpacing: spacing.sm,
      children: [
        AppButton(label: 'Primary', onPressed: () {}),
        AppButton(
          label: 'Secondary',
          variant: AppButtonVariant.secondary,
          onPressed: () {},
        ),
        AppButton(
          label: 'Text',
          variant: AppButtonVariant.text,
          onPressed: () {},
        ),
        const AppButton(label: 'Loading', isLoading: true, onPressed: null),
        const AppButton(label: 'Disabled', onPressed: null),
      ],
    );
  }
}
