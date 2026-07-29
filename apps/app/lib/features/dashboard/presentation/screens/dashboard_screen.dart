import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../application/providers/dashboard_providers.dart';
import '../widgets/dashboard_summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(dashboardSummaryProvider);

    return AppScaffold(
      title: l10n.dashboardTitle,
      body: summary.when(
        data: (data) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: DashboardSummaryCard(
              summary: data,
              onRefresh: () =>
                  ref.read(dashboardSummaryProvider.notifier).refresh(),
            ),
          ),
        ),
        loading: () => const LoadingView(),
        error: (error, stackTrace) => ErrorView(
          failure: error is Failure
              ? error
              : UnexpectedFailure(error.toString(), cause: error),
          retryLabel: l10n.dashboardErrorRetry,
          onRetry: () => ref.invalidate(dashboardSummaryProvider),
        ),
      ),
    );
  }
}
