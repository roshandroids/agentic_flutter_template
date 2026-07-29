import 'package:flutter/material.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_semantic_colors.dart';
import '../tokens/app_spacing.dart';

/// Builds this app's Material 3 themes. One seed color drives the entire
/// [ColorScheme] (`ColorScheme.fromSeed`) rather than hand-picking every
/// color - Material 3's whole design is built around deriving a
/// harmonious palette from one seed, and fighting that means re-deriving
/// what the framework already does well.
abstract final class AppTheme {
  static const Color _seed = Color(0xFF3B5BDB);

  static ThemeData light() => _base(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ),
    semanticColors: AppSemanticColors.light(),
  );

  static ThemeData dark() => _base(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
    semanticColors: AppSemanticColors.dark(),
  );

  static ThemeData _base({
    required ColorScheme colorScheme,
    required AppSemanticColors semanticColors,
  }) => ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    extensions: [AppSpacing.standard, AppRadius.standard, semanticColors],
  );
}
