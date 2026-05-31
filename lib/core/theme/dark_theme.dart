import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.emergencyRed,
    brightness: Brightness.dark,
    primary: AppColors.emergencyRed,
    surface: AppColors.darkSurface,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.emergencyRed,
        foregroundColor: AppColors.white,
      ),
    ),
  );
}
