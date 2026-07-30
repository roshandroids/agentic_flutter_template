import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Playground landing section - a short orientation, not a demo. See
/// showcase/README.md for what the Playground is and how to add a section.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return AppScaffold(
      title: 'Playground',
      body: ListView(
        children: [
          Text(
            'Agentic Flutter Template Playground',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: spacing.sm),
          const Text(
            'Living documentation for this template: every reusable '
            'package and module gets a section here, demonstrated with '
            'real, working code - not a mockup. Pick a section from the '
            'nav to explore it.',
          ),
        ],
      ),
    );
  }
}
