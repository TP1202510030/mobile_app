import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF282A3F);
  static const secondary = Color(0xFF507642);
  static const background = Color(0xFFF4F4F4);
  static const white = Color(0xFFFFFFFF);
  static const red = Color(0xFFEA5455);
  static const grey = Color(0xFF444444);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.background,
    error: AppColors.red,
    onPrimary: AppColors.white,
    onSecondary: AppColors.white,
    onSurface: AppColors.primary,
    onError: AppColors.white,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.white,
    secondary: AppColors.secondary,
    surface: AppColors.primary,
    error: AppColors.red,
    onPrimary: AppColors.primary,
    onSecondary: AppColors.white,
    onSurface: AppColors.background,
    onError: AppColors.white,
  );
}
