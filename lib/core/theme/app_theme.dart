import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';

ThemeData buildDarkTheme() {
  const ColorScheme colorScheme = ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    primaryContainer: Color(0xFF5C0030),
    onPrimaryContainer: Color(0xFFFFD9E4),
    secondary: AppColors.secondary,
    onSecondary: AppColors.textOnSecondary,
    secondaryContainer: Color(0xFF584500),
    onSecondaryContainer: Color(0xFFFFE177),
    tertiary: AppColors.teal,
    onTertiary: AppColors.textOnPrimary,
    tertiaryContainer: Color(0xFF003F47),
    onTertiaryContainer: Color(0xFFB2EBEE),
    error: AppColors.error,
    onError: Colors.white,
    background: AppColors.backgroundDark,
    onBackground: AppColors.textPrimary,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimary,
    surfaceVariant: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.divider,
    shadow: Colors.black,
    scrim: AppColors.scrim,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: AppTypography.textTheme,

    // ── AppBar ──────────────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: true,
      titleTextStyle: AppTypography.titleLarge,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      actionsIconTheme: const IconThemeData(color: AppColors.primary),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.backgroundDark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),

    // ── BottomNavigationBar ─────────────────────────────────────────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0D0D0D),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHint,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // NavigationBar (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF0D0D0D),
      indicatorColor: AppColors.primary.withOpacity(0.2),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: AppColors.primary, size: 26);
        }
        return const IconThemeData(color: AppColors.textHint, size: 24);
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppTypography.labelSmall.copyWith(color: AppColors.primary);
        }
        return AppTypography.labelSmall;
      }),
    ),

    // ── Cards ───────────────────────────────────────────────────────────────
    cardTheme: CardTheme(
      color: AppColors.surfaceCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    ),

    // ── Buttons ─────────────────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        textStyle: AppTypography.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.5),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        textStyle: AppTypography.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),

    // ── FAB ─────────────────────────────────────────────────────────────────
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // ── Inputs ──────────────────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintStyle: const TextStyle(color: AppColors.textHint),
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
    ),

    // ── Chips ───────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primary.withOpacity(0.3),
      labelStyle: AppTypography.labelMedium,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),

    // ── Divider ─────────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    // ── ListTile ────────────────────────────────────────────────────────────
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      iconColor: AppColors.primary,
      titleTextStyle: AppTypography.bodyLarge,
      subtitleTextStyle: AppTypography.bodySmall,
    ),

    // ── Tabs ────────────────────────────────────────────────────────────────
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: AppTypography.labelLarge,
      unselectedLabelStyle: AppTypography.labelMedium,
      dividerColor: AppColors.divider,
    ),

    // ── SnackBar ────────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceVariant,
      contentTextStyle: AppTypography.bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
      actionTextColor: AppColors.primary,
    ),

    // ── Dialog ──────────────────────────────────────────────────────────────
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.surfaceDark,
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: AppTypography.headlineSmall,
      contentTextStyle: AppTypography.bodyMedium,
    ),

    // ── Slider ──────────────────────────────────────────────────────────────
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.border,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withOpacity(0.2),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle:
          AppTypography.labelMedium.copyWith(color: Colors.white),
      trackHeight: 4,
    ),

    // ── Progress ────────────────────────────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.surfaceVariant,
      circularTrackColor: AppColors.surfaceVariant,
    ),
  );
}
