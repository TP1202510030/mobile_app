import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/colors.dart';

abstract final class AppTheme {
  static const _textTheme = TextTheme(
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
  static const _inputDecorationTheme = InputDecorationTheme(
    hintStyle: TextStyle(
      color: AppColors.grey,
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
    ),
  );

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme);

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme);
}
