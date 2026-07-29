import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/__feature__.dart';

/// TODO: replace with __feature__'s real presentation widget(s). Prefer
/// design_system's tokens/widgets over hardcoded values - see
/// packages/design_system/README.md.
class __Feature__Card extends StatelessWidget {
  const __Feature__Card({required this.data, super.key});

  final __Feature__ data;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: const Text('TODO: render __feature__'),
      ),
    );
  }
}
