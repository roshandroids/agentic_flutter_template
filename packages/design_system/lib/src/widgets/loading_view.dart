import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';

/// The one loading state every `AsyncValue.when(loading: ...)` should
/// render, instead of an ad-hoc `CircularProgressIndicator()` per screen.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: spacing.md),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
