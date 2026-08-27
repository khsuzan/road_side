import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceDim = Color(0xFFD9DADB);
  static const Color surfaceBright = Color(0xFFF8F9FA);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);
  static const Color surfaceContainer = Color(0xFFEDEEEF);
  static const Color surfaceContainerHigh = Color(0xFFE7E8E9);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E4);
  static const Color onSurface = Color(0xFF191C1D);
  static const Color onSurfaceVariant = Color(0xFF584235);
  static const Color inverseSurface = Color(0xFF2E3132);
  static const Color inverseOnSurface = Color(0xFFF0F1F2);
  static const Color outline = Color(0xFF8C7263);
  static const Color outlineVariant = Color(0xFFE0C0AF);
  static const Color surfaceTint = Color(0xFF994700);

  static const Color primary = Color(0xFFFF7A00); // Electric Amber
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFF7A00);
  static const Color onPrimaryContainer = Color(0xFF5C2800);
  static const Color inversePrimary = Color(0xFFFFB68B);

  static const Color secondary = Color(0xFF5F5E5E);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE2DFDE);
  static const Color onSecondaryContainer = Color(0xFF636262);

  static const Color tertiary = Color(0xFF006E1C);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF51B454);
  static const Color onTertiaryContainer = Color(0xFF00410D);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color primaryFixed = Color(0xFFFFDBC8);
  static const Color primaryFixedDim = Color(0xFFFFB68B);
  static const Color onPrimaryFixed = Color(0xFF321200);
  static const Color onPrimaryFixedVariant = Color(0xFF753400);

  static const Color secondaryFixed = Color(0xFFE5E2E1);
  static const Color secondaryFixedDim = Color(0xFFC8C6C5);
  static const Color onSecondaryFixed = Color(0xFF1C1B1B);
  static const Color onSecondaryFixedVariant = Color(0xFF474746);

  static const Color tertiaryFixed = Color(0xFF94F990);
  static const Color tertiaryFixedDim = Color(0xFF78DC77);
  static const Color onTertiaryFixed = Color(0xFF002204);
  static const Color onTertiaryFixedVariant = Color(0xFF005313);

  static const Color background = Color(0xFFF8F9FA);
  static const Color onBackground = Color(0xFF191C1D);
  static const Color surfaceVariant = Color(0xFFE1E3E4);

  // Gradient definitions helper
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF9E46), Color(0xFFFF7A00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
