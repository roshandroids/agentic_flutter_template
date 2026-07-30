import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// A titled block of demo content - the shape every section screen groups
/// its examples with, so a new section composes from this instead of
/// reimplementing title-plus-spacing each time.
class SectionHeading extends StatelessWidget {
  const SectionHeading({required this.title, required this.child, super.key});

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
