import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.emergencyRed,
    brightness: Brightness.light,
    primary: AppColors.emergencyRed,
    surface: AppColors.lightSurface,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: AppColors.lightBackground,
      foregroundColor: Colors.black,
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
