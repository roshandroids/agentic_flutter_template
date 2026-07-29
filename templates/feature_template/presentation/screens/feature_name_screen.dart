import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/feature_name_providers.dart';

// TODO: register this screen's route in apps/app/lib/routing/app_router.dart
// and add a destination to apps/app/lib/routing/app_shell.dart, following
// the dashboard feature's route as the example.

class FeatureNameScreen extends ConsumerWidget {
  const FeatureNameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureNameProvider);

    return AppScaffold(
      title: 'FeatureName', // TODO: replace with an AppLocalizations key
      body: state.when(
        data: (data) => const Center(child: Text('TODO: render feature_name')),
        loading: () => const LoadingView(),
        error: (error, stackTrace) => ErrorView(
          failure: error is Failure
              ? error
              : UnexpectedFailure(error.toString(), cause: error),
          onRetry: () => ref.invalidate(featureNameProvider),
        ),
      ),
    );
  }
}
