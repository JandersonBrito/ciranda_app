import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Marca Ciranda Mídia ──────────────────────────────────────────────────
  static const Color primary = Color(0xFFE91E8C); // Rosa pink
  static const Color secondary = Color(0xFFFFD600); // Amarelo
  static const Color accent = Color(0xFFFF6B00); // Laranja
  static const Color teal = Color(0xFF00BCD4); // Verde-azulado

  // ── Gradientes ───────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient festivalGradient = LinearGradient(
    colors: [Color(0xFF6A0572), primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [backgroundDark, surfaceDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Fundos ───────────────────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFF2A2A2A);
  static const Color surfaceCard = Color(0xFF242424);

  // ── Texto ────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textHint = Color(0xFF666666);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF1A1A1A);

  // ── Estados ──────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFCF6679);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = teal;

  // ── Pódio ────────────────────────────────────────────────────────────────
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);

  // ── Dividers / Borders ───────────────────────────────────────────────────
  static const Color divider = Color(0xFF333333);
  static const Color border = Color(0xFF3A3A3A);
  static const Color borderFocused = primary;

  // ── Overlay / Scrim ──────────────────────────────────────────────────────
  static const Color scrim = Color(0xAA000000);
  static const Color cardOverlay = Color(0x66000000);
}
