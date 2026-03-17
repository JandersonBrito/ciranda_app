import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppDecorations {
  // ── Cards ────────────────────────────────────────────────────────────────
  static BoxDecoration get card => BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      );

  static BoxDecoration cardWithAccent(Color accentColor) => BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get festivalBannerCard => BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppColors.festivalGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  // ── Headers / Gradients ──────────────────────────────────────────────────
  static BoxDecoration get gradientHeader => BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      );

  static BoxDecoration get appBarDecoration => BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0020), AppColors.backgroundDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );

  // ── Inputs ───────────────────────────────────────────────────────────────
  static InputDecoration inputField({
    required String label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );

  // ── Badges ───────────────────────────────────────────────────────────────
  static BoxDecoration positionBadge(int position) {
    final Color color = switch (position) {
      1 => AppColors.gold,
      2 => AppColors.silver,
      3 => AppColors.bronze,
      _ => AppColors.surfaceVariant,
    };
    return BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.5),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // ── Bottom Sheet ─────────────────────────────────────────────────────────
  static BoxDecoration get bottomSheet => const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      );

  // ── Chip ─────────────────────────────────────────────────────────────────
  static BoxDecoration chip(Color color) => BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      );

  // ── Glowing button ───────────────────────────────────────────────────────
  static BoxDecoration glowButton(Color color) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
