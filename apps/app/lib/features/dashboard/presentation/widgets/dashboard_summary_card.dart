import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/dashboard_summary.dart';

/// The dashboard's only feature-specific widget - everything else on
/// screen comes from `design_system`. Kept small and presentation-only;
/// no provider reads, no business logic.
class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({
    required this.summary,
    required this.onRefresh,
    super.key,
  });

  final DashboardSummary summary;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = Theme.of(context).appSpacing;
    final radius = Theme.of(context).appRadius;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: radius.mdRadius),
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.dashboardGreeting(summary.greetingName),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: spacing.sm),
            Text(
              l10n.dashboardItemCount(summary.itemCount),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: spacing.lg),
            AppButton(
              label: l10n.dashboardRefresh,
              variant: AppButtonVariant.secondary,
              onPressed: onRefresh,
            ),
          ],
        ),
      ),
    );
  }
}
