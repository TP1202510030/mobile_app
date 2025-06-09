import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/colors.dart';

abstract final class AppTheme {
  static const _textTheme = TextTheme(
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: 'InriaSans',
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: 'InriaSans',
    ),
    bodyLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: 'Roboto',
    ),
    bodyMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
  );

  // Global style for input fields
  static final _lightInputDecorationTheme = InputDecorationTheme(
    hintStyle: const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    filled: true,
    fillColor: AppColors.white,
  );

  static final _darkInputDecorationTheme = InputDecorationTheme(
    hintStyle: const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: AppColors.borderDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: AppColors.primaryDark),
    ),
    filled: true,
    fillColor: AppColors.black,
  );

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      textTheme: _textTheme,
      inputDecorationTheme: _lightInputDecorationTheme);

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,
      textTheme: _textTheme,
      inputDecorationTheme: _darkInputDecorationTheme);
}
