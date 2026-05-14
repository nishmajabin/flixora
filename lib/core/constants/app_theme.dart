import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Color Palette ─────────────────────────────────────────────────────────
  static const Color primaryColor = Color(0xFFE50914); // Netflix-inspired red
  static const Color primaryDarkColor = Color(0xFFB20710);
  static const Color accentColor = Color(0xFFFFD700); // Gold accent
  static const Color accentCyan = Color(0xFF00D4FF); // Cyan for highlights
  static const Color scaffoldBackground = Color(0xFF0A0A0A);
  static const Color cardBackground = Color(0xFF1A1A2E);
  static const Color surfaceColor = Color(0xFF16213E);
  static const Color surfaceVariant = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF253550);
  static const Color onSurfaceColor = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color dividerColor = Color(0xFF334155);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF22C55E);
  static const Color shimmerBase = Color(0xFF1E293B);
  static const Color shimmerHighlight = Color(0xFF334155);
  static const Color ratingStarColor = Color(0xFFFBBF24);
  static const Color navBarBackground = Color(0xFF0D1117);
  static const Color premiumGold = Color(0xFFD4A84B);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE50914), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x00000000),
      Color(0x80000000),
      Color(0xE6000000),
      Color(0xFF0A0A0A),
    ],
    stops: [0.0, 0.3, 0.55, 0.8, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000), Color(0xF2000000)],
    stops: [0.0, 0.6, 1.0],
  );

  // ── Border Radius ─────────────────────────────────────────────────────────
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusRound = 100.0;

  // ── Spacing ───────────────────────────────────────────────────────────────
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ── Elevation ─────────────────────────────────────────────────────────────
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // ── Movie Card Sizes ──────────────────────────────────────────────────────
  static const double movieCardWidth = 140.0;
  static const double movieCardHeight = 210.0;
  static const double bannerHeight = 480.0;

  // ── Dark Theme ────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // ── Colors ──────────────────────────────────────────────────────────
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: accentColor,
        onSecondary: Colors.black,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        error: errorColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: scaffoldBackground,

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(
          color: textPrimary,
          size: 24,
        ),
      ),

      // ── Card ────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: elevationLow,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: spacingMD,
          vertical: spacingSM,
        ),
      ),

      // ── Text ────────────────────────────────────────────────────────────
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: textTheme.titleSmall?.copyWith(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          color: textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: textTheme.labelSmall?.copyWith(
          color: textMuted,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ── Bottom Navigation Bar ───────────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: navBarBackground,
        selectedItemColor: primaryColor,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ── Chip ────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primaryColor.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingSM,
          vertical: spacingXS,
        ),
      ),

      // ── Icon ────────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 0.5,
        space: 1,
      ),

      // ── Snackbar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceColor,
        contentTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Progress Indicator ──────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: surfaceVariant,
      ),
    );
  }
}
