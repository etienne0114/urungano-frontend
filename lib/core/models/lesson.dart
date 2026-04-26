import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ── Category ──────────────────────────────────────────────────────────────────

enum LessonCategory {
  menstrualHealth,
  hivSti,
  anatomy,
  mentalHealth,
  relationships;

  String get apiKey {
    switch (this) {
      case LessonCategory.menstrualHealth:
        return 'menstrual_health';
      case LessonCategory.hivSti:
        return 'hiv_sti';
      case LessonCategory.anatomy:
        return 'anatomy';
      case LessonCategory.mentalHealth:
        return 'mental_health';
      case LessonCategory.relationships:
        return 'relationships';
    }
  }

  String get label {
    switch (this) {
      case LessonCategory.menstrualHealth:
        return 'MENSTRUAL HEALTH';
      case LessonCategory.hivSti:
        return 'HIV & STI';
      case LessonCategory.anatomy:
        return 'ANATOMY';
      case LessonCategory.mentalHealth:
        return 'MENTAL HEALTH';
      case LessonCategory.relationships:
        return 'RELATIONSHIPS';
    }
  }

  String localizedLabel(String langCode) {
    switch (this) {
      case LessonCategory.menstrualHealth:
        return switch (langCode) {
          'fr' => 'SANTE MENSTRUELLE',
          'rw' => "UBUZIMA BW'IMIHANGO",
          _ => 'MENSTRUAL HEALTH',
        };
      case LessonCategory.hivSti:
        return switch (langCode) {
          'fr' => 'VIH & IST',
          'rw' => 'VIH & IST',
          _ => 'HIV & STI',
        };
      case LessonCategory.anatomy:
        return switch (langCode) {
          'fr' => 'ANATOMIE',
          'rw' => "IMITERERE Y'UMUBIRI",
          _ => 'ANATOMY',
        };
      case LessonCategory.mentalHealth:
        return switch (langCode) {
          'fr' => 'SANTE MENTALE',
          'rw' => "UBUZIMA BWO MU MUTWE",
          _ => 'MENTAL HEALTH',
        };
      case LessonCategory.relationships:
        return switch (langCode) {
          'fr' => 'RELATIONS',
          'rw' => 'IMIBANO',
          _ => 'RELATIONSHIPS',
        };
    }
  }

  Color get tileColor {
    switch (this) {
      case LessonCategory.menstrualHealth:
        return AppColors.catMenstrual;
      case LessonCategory.hivSti:
        return AppColors.catHivSti;
      case LessonCategory.anatomy:
        return AppColors.catAnatomy;
      case LessonCategory.mentalHealth:
        return AppColors.catMental;
      case LessonCategory.relationships:
        return AppColors.catRelations;
    }
  }

  Color get accentColor {
    switch (this) {
      case LessonCategory.menstrualHealth:
        return AppColors.accMenstrual;
      case LessonCategory.hivSti:
        return AppColors.accHivSti;
      case LessonCategory.anatomy:
        return AppColors.accAnatomy;
      case LessonCategory.mentalHealth:
        return AppColors.accMental;
      case LessonCategory.relationships:
        return AppColors.primary;
    }
  }

  String get emoji {
    switch (this) {
      case LessonCategory.menstrualHealth:
        return '🌸';
      case LessonCategory.hivSti:
        return '🛡';
      case LessonCategory.anatomy:
        return '🫀';
      case LessonCategory.mentalHealth:
        return '🧠';
      case LessonCategory.relationships:
        return '💙';
    }
  }

  static LessonCategory fromApiKey(String key) =>
      LessonCategory.values.firstWhere(
        (c) => c.apiKey == key,
        orElse: () => LessonCategory.anatomy,
      );
}

// ── Hotspot ───────────────────────────────────────────────────────────────────

class Hotspot {
  final String id;
  final int number;
  final String title;
  final Map<String, String> localizedTitle;
  final String description;
  final Map<String, String> localizedDescription;

  const Hotspot({
    required this.id,
    required this.number,
    required this.title,
    this.localizedTitle = const {},
    required this.description,
    this.localizedDescription = const {},
  });

  factory Hotspot.fromJson(Map<String, dynamic> json) => Hotspot(
        id: json['id'] as String,
        number: json['number'] as int,
        title: json['title'] as String,
        localizedTitle: Map<String, String>.from(json['localizedTitle'] ?? {}),
        description: json['description'] as String,
        localizedDescription: Map<String, String>.from(
          json['localizedDescription'] ?? {},
        ),
      );

  String titleFor(String langCode) => localizedTitle[langCode] ?? title;
  String descriptionFor(String langCode) =>
      localizedDescription[langCode] ?? description;
}

// ── Chapter ───────────────────────────────────────────────────────────────────

class LessonChapter {
  final String id;
  final int orderIndex;
  final String title;
  final Map<String, String> localizedTitle;
  final String narrationText; // Keep for backward compatibility/default
  final Map<String, String> localizedNarration;
  final List<Hotspot> hotspots;
  final String? modelUrl;
  final bool modelReady;
  final String? audioUrl;

  const LessonChapter({
    required this.id,
    required this.orderIndex,
    required this.title,
    this.localizedTitle = const {},
    required this.narrationText,
    this.localizedNarration = const {},
    this.hotspots = const [],
    this.modelUrl,
    this.modelReady = true,
    this.audioUrl,
  });

  factory LessonChapter.fromJson(Map<String, dynamic> json) => LessonChapter(
        id: json['id'] as String,
        orderIndex: json['orderIndex'] as int,
        title: json['title'] as String,
        localizedTitle: Map<String, String>.from(json['localizedTitle'] ?? {}),
        narrationText: json['narrationText'] as String,
        localizedNarration:
            Map<String, String>.from(json['localizedNarration'] ?? {}),
        hotspots: (json['hotspots'] as List<dynamic>? ?? [])
            .map((h) => Hotspot.fromJson(h as Map<String, dynamic>))
            .toList(),
        modelUrl: json['modelUrl'] as String?,
        modelReady: (json['modelReady'] as bool?) ?? (json['modelUrl'] != null),
        audioUrl: json['audioUrl'] as String?,
      );

  String titleFor(String langCode) => localizedTitle[langCode] ?? title;
  String narrationFor(String langCode) =>
      localizedNarration[langCode] ?? narrationText;
}

// ── Lesson ────────────────────────────────────────────────────────────────────

class Lesson {
  final String id;
  // slug is the human-readable identifier ('your_cycle', 'hiv_prevention', …).
  // When a lesson is fetched from the backend, id is a UUID and slug is set
  // from the API response. For local/offline lessons, id == slug.
  final String slug;
  final String title;
  final Map<String, String> localizedTitle;
  final LessonCategory category;
  final int durationMinutes;
  final List<LessonChapter> chapters;

  const Lesson({
    required this.id,
    String? slug,
    required this.title,
    this.localizedTitle = const {},
    required this.category,
    required this.durationMinutes,
    required this.chapters,
  }) : slug = slug ?? id;

  int get totalChapters => chapters.length;

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'] as String,
        slug: json['slug'] as String? ?? json['id'] as String,
        title: json['title'] as String,
        localizedTitle: Map<String, String>.from(json['localizedTitle'] ?? {}),
        category: LessonCategory.fromApiKey(json['category'] as String),
        durationMinutes: json['durationMinutes'] as int,
        chapters: (json['chapters'] as List<dynamic>? ?? [])
            .map((c) => LessonChapter.fromJson(c as Map<String, dynamic>))
            .toList(),
      );

  String titleFor(String langCode) => localizedTitle[langCode] ?? title;
}
