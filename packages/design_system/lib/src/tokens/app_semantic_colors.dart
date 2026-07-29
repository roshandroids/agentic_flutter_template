import 'package:flutter/material.dart';

/// Semantic colors Material 3's [ColorScheme] doesn't define
/// (success/warning/info) - modeled as a [ThemeExtension] the same way as
/// [ColorScheme] itself, rather than bolting extra static constants onto
/// an unrelated class.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
  });

  factory AppSemanticColors.light() => const AppSemanticColors(
    success: Color(0xFF2E7D32),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFFED6C02),
    onWarning: Color(0xFFFFFFFF),
    info: Color(0xFF0288D1),
    onInfo: Color(0xFFFFFFFF),
  );

  factory AppSemanticColors.dark() => const AppSemanticColors(
    success: Color(0xFF81C784),
    onSuccess: Color(0xFF00390D),
    warning: Color(0xFFFFB74D),
    onWarning: Color(0xFF4A2800),
    info: Color(0xFF4FC3F7),
    onInfo: Color(0xFF003547),
  );

  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
  }) => AppSemanticColors(
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
    warning: warning ?? this.warning,
    onWarning: onWarning ?? this.onWarning,
    info: info ?? this.info,
    onInfo: onInfo ?? this.onInfo,
  );

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
    );
  }
}

extension AppSemanticColorsThemeX on ThemeData {
  AppSemanticColors get appColors =>
      extension<AppSemanticColors>() ?? AppSemanticColors.light();
}
