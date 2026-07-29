import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/feature_name.dart';

/// TODO: replace with feature_name's real presentation widget(s). Prefer
/// design_system's tokens/widgets over hardcoded values - see
/// packages/design_system/README.md.
class FeatureNameCard extends StatelessWidget {
  const FeatureNameCard({required this.data, super.key});

  final FeatureName data;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: const Text('TODO: render feature_name'),
      ),
    );
  }
}
