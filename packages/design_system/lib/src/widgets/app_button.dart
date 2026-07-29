import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, text }

/// The one button every feature should use, instead of reaching for
/// `FilledButton`/`OutlinedButton`/`TextButton` directly per screen - keeps
/// button styling (and its loading-state behavior) consistent app-wide.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
  });

  final String label;

  /// `null` disables the button - also forced while [isLoading] is true so
  /// a slow tap can't double-submit.
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final child = isLoading
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
    };
  }
}
