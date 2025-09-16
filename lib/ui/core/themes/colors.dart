import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color.fromRGBO(39, 48, 67, 1);
  static const primaryDark = Color.fromRGBO(244, 244, 244, 1);
  static const secondary = Color.fromRGBO(68, 68, 68, 100);
  static const secondaryDark = Color.fromRGBO(236, 236, 236, 1);
  static const background = Color.fromRGBO(236, 236, 236, 1);
  static const backgroundDark = Color.fromRGBO(40, 42, 63, 1);
  static const white = Color.fromRGBO(248, 248, 248, 1);
  static const black = Color.fromRGBO(32, 34, 54, 1);
  static const alert = Color(0xFFEA5455);
  static const accent = Color.fromRGBO(80, 118, 66, 1);
  static const accentDark = Color.fromRGBO(180, 219, 70, 1);
  static const border = Color.fromRGBO(210, 213, 219, 1);
  static const borderDark = Color.fromRGBO(56, 58, 86, 1);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.background,
    error: AppColors.alert,
    onPrimary: AppColors.white,
    onSecondary: AppColors.white,
    onSurface: AppColors.primary,
    onError: AppColors.white,
    outline: AppColors.border,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    secondary: AppColors.secondaryDark,
    surface: AppColors.backgroundDark,
    error: AppColors.alert,
    onPrimary: AppColors.black,
    onSecondary: AppColors.white,
    onSurface: AppColors.background,
    onError: AppColors.white,
    outline: AppColors.borderDark,
  );
}
