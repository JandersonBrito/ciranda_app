import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  // ── Display — Baloo 2 (títulos festivos) ─────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.baloo2(
        fontSize: 57,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.25,
      );

  static TextStyle get displayMedium => GoogleFonts.baloo2(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get displaySmall => GoogleFonts.baloo2(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  // ── Headline — Baloo 2 ───────────────────────────────────────────────────
  static TextStyle get headlineLarge => GoogleFonts.baloo2(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.baloo2(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.baloo2(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // ── Title — Baloo 2 ──────────────────────────────────────────────────────
  static TextStyle get titleLarge => GoogleFonts.baloo2(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.baloo2(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.15,
      );

  static TextStyle get titleSmall => GoogleFonts.baloo2(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      );

  // ── Body — Nunito (corpo de texto legível) ───────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: 0.4,
      );

  // ── Label — Nunito ───────────────────────────────────────────────────────
  static TextStyle get labelLarge => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      );

  // ── Utilidades ───────────────────────────────────────────────────────────
  static TextStyle get caption => GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get overline => GoogleFonts.nunito(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 1.5,
      );

  static TextStyle get button => GoogleFonts.baloo2(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get scoreDisplay => GoogleFonts.baloo2(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: AppColors.secondary,
        letterSpacing: -1,
      );

  static TextStyle get positionBadge => GoogleFonts.baloo2(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  // ── TextTheme para MaterialApp ───────────────────────────────────────────
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
