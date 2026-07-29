import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/__feature___providers.dart';

// TODO: register this screen's route in apps/app/lib/routing/app_router.dart
// and add a destination to apps/app/lib/routing/app_shell.dart, following
// the dashboard feature's route as the example.

class __Feature__Screen extends ConsumerWidget {
  const __Feature__Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(__featureCamel__Provider);

    return AppScaffold(
      title: '__Feature__', // TODO: replace with an AppLocalizations key
      body: state.when(
        data: (data) => const Center(child: Text('TODO: render __feature__')),
        loading: () => const LoadingView(),
        error: (error, stackTrace) => ErrorView(
          failure: error is Failure
              ? error
              : UnexpectedFailure(error.toString(), cause: error),
          onRetry: () => ref.invalidate(__featureCamel__Provider),
        ),
      ),
    );
  }
}
