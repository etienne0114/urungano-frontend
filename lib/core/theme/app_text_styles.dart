import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralised text styles — always read `largerText` from settings
/// and pass it in as [scaleFactor] (1.0 = normal, 1.18 = larger).
abstract final class AppTextStyles {
  // ── Display / headline: Fraunces (serif, warm — matches design) ───────────

  static TextStyle display({double scaleFactor = 1.0, bool italic = false}) =>
      GoogleFonts.fraunces(
        fontSize: 32 * scaleFactor,
        fontWeight: FontWeight.w500,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        color: AppColors.textPrimary,
        height: 1.1,
        letterSpacing: -0.32, // -0.01em at 32px
      );

  static TextStyle headline({double scaleFactor = 1.0, bool italic = false}) =>
      GoogleFonts.fraunces(
        fontSize: 24 * scaleFactor,
        fontWeight: FontWeight.w500,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        color: AppColors.textPrimary,
        height: 1.15,
        letterSpacing: -0.24, // -0.01em at 24px
      );

  // ── UI / body: DM Sans (sans-serif, high legibility — matches design) ─────

  static TextStyle title({double scaleFactor = 1.0}) => GoogleFonts.dmSans(
        fontSize: 18 * scaleFactor,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle body({double scaleFactor = 1.0}) => GoogleFonts.dmSans(
        fontSize: 15 * scaleFactor,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.55,
      );

  static TextStyle bodyMedium({double scaleFactor = 1.0}) => body(scaleFactor: scaleFactor);

  static TextStyle bodySmall({double scaleFactor = 1.0}) => GoogleFonts.dmSans(
        fontSize: 13 * scaleFactor,
        fontWeight: FontWeight.w400,
        color: AppColors.ink60,
        height: 1.45,
      );

  static TextStyle label({double scaleFactor = 1.0}) => GoogleFonts.dmSans(
        fontSize: 11 * scaleFactor,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.9,
        color: AppColors.ink60,
      );

  static TextStyle button({double scaleFactor = 1.0}) => GoogleFonts.dmSans(
        fontSize: 15 * scaleFactor,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  static TextStyle caption({double scaleFactor = 1.0}) => GoogleFonts.dmSans(
        fontSize: 12 * scaleFactor,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.4,
      );
}
