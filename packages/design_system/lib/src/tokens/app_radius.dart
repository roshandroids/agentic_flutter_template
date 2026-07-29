import 'package:flutter/material.dart';

/// Corner-radius scale as a [ThemeExtension] - see [AppSpacing] for why
/// tokens are modeled this way instead of scattered magic numbers.
@immutable
class AppRadius extends ThemeExtension<AppRadius> {
  const AppRadius({this.sm = 4, this.md = 8, this.lg = 16, this.full = 999});

  final double sm;
  final double md;
  final double lg;

  /// Effectively fully-rounded for any reasonable widget size (pill shapes).
  final double full;

  static const standard = AppRadius();

  BorderRadius get smRadius => BorderRadius.circular(sm);
  BorderRadius get mdRadius => BorderRadius.circular(md);
  BorderRadius get lgRadius => BorderRadius.circular(lg);
  BorderRadius get fullRadius => BorderRadius.circular(full);

  @override
  AppRadius copyWith({double? sm, double? md, double? lg, double? full}) =>
      AppRadius(
        sm: sm ?? this.sm,
        md: md ?? this.md,
        lg: lg ?? this.lg,
        full: full ?? this.full,
      );

  @override
  AppRadius lerp(ThemeExtension<AppRadius>? other, double t) {
    if (other is! AppRadius) return this;
    return AppRadius(
      sm: _lerp(sm, other.sm, t),
      md: _lerp(md, other.md, t),
      lg: _lerp(lg, other.lg, t),
      full: _lerp(full, other.full, t),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}

extension AppRadiusThemeX on ThemeData {
  AppRadius get appRadius => extension<AppRadius>() ?? AppRadius.standard;
}
