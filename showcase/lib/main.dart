import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'modules/modules_screen.dart';

void main() => runApp(const ShowcaseApp());

/// Every token and shared widget in packages/design_system, rendered on
/// one screen so a change is visible immediately - no need to run the
/// full app or hunt through a feature to find where a widget is used.
class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Design System Showcase',
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: ThemeMode.system,
    home: const ShowcaseScreen(),
  );
}

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;

    return AppScaffold(
      title: 'Design System Showcase',
      actions: [
        IconButton(
          icon: const Icon(Icons.extension_outlined),
          tooltip: 'Modules',
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(builder: (_) => const ModulesScreen()),
          ),
        ),
      ],
      body: ListView(
        children: [
          const _Section(title: 'Buttons', child: _ButtonsShowcase()),
          SizedBox(height: spacing.lg),
          const _Section(
            title: 'Loading',
            child: LoadingView(message: 'Loading…'),
          ),
          SizedBox(height: spacing.lg),
          _Section(
            title: 'Error',
            child: ErrorView(
              failure: const NetworkFailure(
                'Simulated failure for the showcase',
              ),
              onRetry: () {},
            ),
          ),
          SizedBox(height: spacing.lg),
          const _Section(
            title: 'Empty',
            child: EmptyView(message: 'Nothing to show yet.'),
          ),
          SizedBox(height: spacing.lg),
          const _Section(title: 'Spacing scale', child: _SpacingShowcase()),
          SizedBox(height: spacing.lg),
          const _Section(title: 'Radius scale', child: _RadiusShowcase()),
          SizedBox(height: spacing.lg),
          const _Section(
            title: 'Responsive breakpoint',
            child: _BreakpointShowcase(),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: spacing.sm),
          child,
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

class _BreakpointShowcase extends StatelessWidget {
  const _BreakpointShowcase();

  @override
  Widget build(BuildContext context) => ResponsiveLayout(
    mobile: (_) => const Text('Current: mobile (<600px)'),
    tablet: (_) => const Text('Current: tablet (600-1024px)'),
    desktop: (_) => const Text('Current: desktop (≥1024px)'),
  );
}
