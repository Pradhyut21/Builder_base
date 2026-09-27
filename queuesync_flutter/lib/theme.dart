import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================
// QueueSync Design System
// All design tokens defined here. Do NOT scatter hex codes or
// font sizes across widget files — use these constants only.
// ============================================================

/// Color palette: calm and trustworthy — reduces anxiety in waiting rooms.
class AppColors {
  AppColors._();

  /// Primary teal — used for primary actions, served state, branding.
  static const primary = Color(0xFF2A7F7E);
  static const primaryLight = Color(0xFF3FA09F);
  static const primaryDark = Color(0xFF1A6160);

  /// Warm off-white background — easier on the eyes than stark white.
  static const background = Color(0xFFFAFAF7);
  static const surfaceCard = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF0F0EC);

  /// Text colors.
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF5C5C5C);
  static const textMuted = Color(0xFF8C8C8C);
  static const textOnPrimary = Color(0xFFFFFFFF);

  /// Status colors — paired with labels/icons, never used alone.
  static const statusWaiting = Color(0xFF64748B); // neutral slate
  static const statusCalled = Color(0xFFF59E0B); // warm amber
  static const statusServed = Color(0xFF2A7F7E); // primary teal
  static const statusExpired = Color(0xFFB45454); // desaturated red — not harsh
  static const statusLeft = Color(0xFF8C8C8C); // muted grey

  /// Text/icon-safe variant of [statusCalled].
  ///
  /// The bright amber above measures ~2.0:1 contrast against both the
  /// off-white background AND as white-on-amber — well under the 4.5:1
  /// WCAG AA minimum for text. Use THIS color (~6.8:1 on off-white, ~7.1:1
  /// with white text on top) for any headline, label, or icon glyph that
  /// renders the "called" status. Reserve [statusCalled] itself for
  /// decorative-only fills (glows, soft tinted washes) where no text or
  /// icon sits directly on it.
  static const statusCalledOn = Color(0xFF92400E);

  /// Semantic colors.
  static const error = Color(0xFFB45454);
  static const success = Color(0xFF2A7F7E);
  static const warning = Color(0xFFF59E0B);

  /// Border and divider.
  static const border = Color(0xFFE2E2DC);
  static const divider = Color(0xFFEEEEEA);
}

/// Spacing scale: 8px base. Use ONLY these values.
/// No hand-typed EdgeInsets.all(13) anywhere.
class AppSpacing {
  AppSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const xxxl = 64.0;
}

/// Typography — single font family (Inter via google_fonts).
/// Position numbers get hero sizing, not standard body text.
class AppTextStyles {
  AppTextStyles._();

  static TextTheme get textTheme => GoogleFonts.interTextTheme().copyWith(
    displayLarge: GoogleFonts.inter(
      fontSize: 96,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      height: 1.0,
      letterSpacing: -2,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 64,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      height: 1.0,
      letterSpacing: -1.5,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.1,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.2,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textMuted,
      height: 1.5,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      letterSpacing: 0.3,
    ),
  );
}

/// The application theme.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          surface: AppColors.background,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.textOnPrimary,
          surface: AppColors.background,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
        ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: AppTextStyles.textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textMuted,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      labelStyle: GoogleFonts.inter(color: AppColors.textSecondary),
      hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
    ),
  );
}

/// Helper to get status color — always paired with a label, never alone.
Color statusColor(String status) {
  switch (status) {
    case 'waiting':
      return AppColors.statusWaiting;
    case 'called':
      return AppColors.statusCalled;
    case 'served':
      return AppColors.statusServed;
    case 'expired':
    case 'left':
    default:
      return AppColors.statusExpired;
  }
}
