import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get displayLg => GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        height: 56 / 48,
        letterSpacing: -0.04 * 48,
      );

  static TextStyle get displayMobile => GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 42 / 36,
        letterSpacing: -0.03 * 36,
      );

  static TextStyle get headlineMd => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        letterSpacing: -0.02 * 24,
      );

  static TextStyle get metricXl => GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 40 / 40,
        letterSpacing: -0.05 * 40,
      );

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
      );

  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      );

  static TextStyle get labelBold => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 20 / 14,
        letterSpacing: 0.05 * 14,
      );
}
