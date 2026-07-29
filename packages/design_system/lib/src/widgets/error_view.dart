import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';
import 'app_button.dart';

/// Renders any [Failure] generically - the reason `core`'s `Failure`
/// hierarchy is shared instead of per-feature error types (see
/// docs/adr/ADR-0004). Every `AsyncValue.when(error: ...)` in the app
/// should render this, not a bespoke error widget per feature.
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.failure,
    super.key,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.message,
  });

  final Failure failure;
  final VoidCallback? onRetry;

  /// Override for the retry button's label - this package has no access to
  /// the app's `AppLocalizations` (a design system is shared beneath the
  /// app, not above it), so callers that need a localized label pass it
  /// here rather than this widget hardcoding English.
  final String retryLabel;

  /// Override for the displayed message - defaults to a generic mapping of
  /// [failure] if not provided. Pass a localized string from the caller
  /// for the same reason as [retryLabel].
  final String? message;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 40,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: spacing.md),
            Text(
              message ?? _userFacingMessage(failure),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              SizedBox(height: spacing.md),
              AppButton(
                label: retryLabel,
                variant: AppButtonVariant.secondary,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Maps [Failure] to a message safe to show a user - deliberately not
  /// just `failure.message`, which is a log-safe string, not guaranteed to
  /// be phrased for an end user. Feature code that needs a more specific
  /// message can still branch on the [Failure] subtype before reaching here.
  String _userFacingMessage(Failure failure) => switch (failure) {
    NetworkFailure() =>
      "Couldn't connect. Check your connection and try again.",
    UnauthorizedFailure() => 'Your session expired. Please sign in again.',
    NotFoundFailure() => "That couldn't be found.",
    ValidationFailure(:final message) => message,
    UnexpectedFailure() => 'Something went wrong. Please try again.',
  };
}
