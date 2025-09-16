import 'package:flutter/material.dart';

/// Defines custom accent colors for the application theme.
///
/// Using a [ThemeExtension] allows us to define colors that are not part of
/// the standard [ColorScheme] and access them via `Theme.of(context)`.
@immutable
class AppAccentColors extends ThemeExtension<AppAccentColors> {
  final Color? accent;

  const AppAccentColors({required this.accent});

  @override
  AppAccentColors copyWith({Color? accentColor}) {
    return AppAccentColors(
      accent: accentColor ?? accent,
    );
  }

  @override
  AppAccentColors lerp(ThemeExtension<AppAccentColors>? other, double t) {
    if (other is! AppAccentColors) {
      return this;
    }
    return AppAccentColors(
      accent: Color.lerp(accent, other.accent, t),
    );
  }
}
