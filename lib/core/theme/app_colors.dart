import 'package:flutter/material.dart';

/// Central colour palette for URUNGANO — exact design tokens from Urungano Web/Prototype.
abstract final class AppColors {
  // ── Background & surfaces ─────────────────────────────────
  static const Color background   = Color(0xFFFDF4EC); // --cream
  static const Color surface      = Color(0xFFF8EADA); // --cream-2
  static const Color white        = Color(0xFFFFFFFF);
  static const Color divider      = Color(0x142A1A1F); // rgba(42,26,31,0.08)
  static const Color divider2     = Color(0x242A1A1F); // rgba(42,26,31,0.14)

  // ── Brand / primary (rose) ────────────────────────────────
  static const Color primary      = Color(0xFFE85D75); // --rose
  static const Color primaryDark  = Color(0xFFC8425C); // --rose-deep
  static const Color primaryLight = Color(0xFFFCE4E8); // --rose-soft

  // ── Typography ────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF2A1A1F); // --plum
  static const Color textSecondary = Color(0xFF4A2F37); // --plum-2
  static const Color ink60         = Color(0xFF6B5560); // --ink-60
  static const Color ink40         = Color(0xFF9A8691); // --ink-40
  static const Color ink10         = Color(0xFF2A1A1F); // --plum (base for shadows)
  static const Color textMuted     = Color(0xFF9A8691); // --ink-40
  static const Color textOnDark    = Color(0xFFFFFFFF);

  // ── Sage (HIV/STI accent, correct answer) ────────────────
  static const Color sage          = Color(0xFF7FA99B); // --sage
  static const Color sageSoft      = Color(0xFFD4E3DC); // --sage-soft

  // ── Warm accents ──────────────────────────────────────────
  static const Color amber         = Color(0xFFE8A87C); // --amber
  static const Color sun           = Color(0xFFF4B860); // --sun
  static const Color peach         = Color(0xFFF5C6A5); // --peach
  static const Color peachSoft     = Color(0xFFFADFC8); // --peach-soft

  // ── Dark surfaces (challenge card, gesture screen) ────────
  static const Color darkSurface  = Color(0xFF2A1A1F); // plum as dark bg

  // ── Category tile backgrounds ─────────────────────────────
  static const Color catMenstrual  = Color(0xFFFCE4E8); // rose-soft
  static const Color catHivSti     = Color(0xFFD4E3DC); // sage-soft
  static const Color catAnatomy    = Color(0xFFFADFC8); // peach-soft
  static const Color catMental     = Color(0xFFCEC5E3);
  static const Color catRelations  = Color(0xFFC5D5E8);

  // ── Category accent colours (progress bars, tags) ─────────
  static const Color accMenstrual  = Color(0xFFE85D75); // rose
  static const Color accHivSti     = Color(0xFF7FA99B); // sage
  static const Color accAnatomy    = Color(0xFFE8A87C); // amber
  static const Color accMental     = Color(0xFF7A5FBF);

  // ── Quick-action widgets ──────────────────────────────────
  static const Color streakBg      = Color(0xFFD4E3DC); // sage-soft
  static const Color gestureBg     = Color(0xFFF8EADA); // cream-2

  // ── Sidebar (web layout) ──────────────────────────────────
  static const Color sidebarBg     = Color(0xFFF8EADA); // cream-2
  static const Color sidebarActive = Color(0xFF2A1A1F); // plum

  // ── Journey dot colours ───────────────────────────────────
  static const Color dotCompleted = Color(0xFF7FA99B); // sage
  static const Color dotQuiz      = Color(0xFFE85D75); // rose
  static const Color dotStarted   = Color(0xFFE8A87C); // amber
  static const Color dotSetup     = Color(0xFF2A1A1F); // plum
}
