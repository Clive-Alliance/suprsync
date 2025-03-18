import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:suprsync/core/theme/app_colors.dart';

/// This file declares all the color scheme for the snapshot app
class AppTheme {
  static Color green = const Color(0xFF1F6554);
  static Color greenContainer = const Color(0xFFE5FEE0);
  static Color yellow = const Color(0xFFE3B41B);
  static Color pink = const Color(0xFFD9694D);
  static ThemeData light = FlexThemeData.light(
    colorScheme: lightModeScheme,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // useMaterial3: true,
    scaffoldBackground: const Color(0xFFF3EFF6),
    swapLegacyOnMaterial3: true,
    appBarElevation: 0,
    appBarBackground: lightModeScheme.surface,
    // fontFamilyFallback: ['Freight'],
    fontFamily: 'JakartaSans',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        letterSpacing: 0,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        letterSpacing: 0,
        fontSize: 26,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        letterSpacing: 0,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        letterSpacing: 0,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        letterSpacing: 0,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        letterSpacing: 0,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        letterSpacing: 0,

        fontSize: 18,
        // fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        // fontSize: 14,
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        letterSpacing: 0,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        letterSpacing: 0,
        color: Color(0xffffffff),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
