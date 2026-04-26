import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/app_settings.dart';
import '../../models/lesson.dart';
import '../../models/quiz_question.dart';
import '../../models/user_progress.dart';

/// Single source of truth for all local persistence via Hive.
///
/// Box responsibilities:
///   settings  — AppSettings (always local, never from API)
///   auth      — JWT token, userId, PIN hash (always local)
///   progress  — UserProgress state + offline sync queue
///   lessons   — Lesson list + individual lesson content (API cache)
///   quiz      — Quiz questions per lesson (API cache)
abstract final class HiveStorage {
  static const _boxSettings = 'settings';
  static const _boxAuth = 'auth';
  static const _boxProgress = 'progress';
  static const _boxLessons = 'lessons';
  static const _boxQuiz = 'quiz';
  static const _boxCommunity = 'community';

  static Future<void> openBoxes() async {
    await Hive.openBox(_boxSettings);
    await Hive.openBox(_boxAuth);
    await Hive.openBox(_boxProgress);
    await Hive.openBox(_boxLessons);
    await Hive.openBox(_boxQuiz);
    await Hive.openBox(_boxCommunity);
  }

  static Box? _safeBox(String name) {
    try {
      if (!Hive.isBoxOpen(name)) return null;
      return Hive.box(name);
    } catch (_) {
      return null;
    }
  }

  /// Ensures a box is open before returning it.
  /// Critical for Web where connections can close unexpectedly.
  static Future<Box?> _getBox(String name) async {
    try {
      if (Hive.isBoxOpen(name)) {
        final box = Hive.box(name);
        // On Web, sometimes isBoxOpen is true but the connection is closing/closed.
        // This is a defensive check.
        return box;
      }
      return await Hive.openBox(name);
    } catch (e) {
      debugPrint('Hive: Failed to open box $name: $e');
      return null;
    }
  }

  // ══════════════════════════════════════════════════════════
  // ALWAYS LOCAL — never replaced by API data
  // ══════════════════════════════════════════════════════════

  // ── Settings ──────────────────────────────────────────────

  static AppSettings loadSettings() {
    final b = _safeBox(_boxSettings);
    if (b == null) return AppSettings.defaults;
    return AppSettings(
      voiceNarration: b.get('voice_narration', defaultValue: true) as bool,
      captions: b.get('captions', defaultValue: true) as bool,
      signLanguage: b.get('sign_language', defaultValue: false) as bool,
      gestureControl: b.get('gesture_control', defaultValue: false) as bool,
      highContrast: b.get('high_contrast', defaultValue: false) as bool,
      largerText: b.get('larger_text', defaultValue: false) as bool,
      appLock: b.get('app_lock', defaultValue: false) as bool,
      privateMode: b.get('private_mode', defaultValue: false) as bool,
      incognitoLessons: b.get('incognito_lessons', defaultValue: false) as bool,
      language: b.get('language', defaultValue: 'rw') as String,
      onboardingComplete:
          b.get('onboarding_complete', defaultValue: false) as bool,
    );
  }

  static Future<bool> saveSettings(AppSettings s) async {
    try {
      final box = await _getBox(_boxSettings);
      if (box == null) return false;
      await box.putAll({
        'voice_narration': s.voiceNarration,
        'captions': s.captions,
        'sign_language': s.signLanguage,
        'gesture_control': s.gestureControl,
        'high_contrast': s.highContrast,
        'larger_text': s.largerText,
        'app_lock': s.appLock,
        'private_mode': s.privateMode,
        'incognito_lessons': s.incognitoLessons,
        'language': s.language,
        'onboarding_complete': s.onboardingComplete,
      });
      return true;
    } catch (e) {
      debugPrint('Hive: saveSettings failed: $e');
      return false;
    }
  }

  // ── Auth (token + PIN hash) ───────────────────────────────

  static String? get accessToken =>
      _safeBox(_boxAuth)?.get('access_token') as String?;
  static String? get userId => _safeBox(_boxAuth)?.get('user_id') as String?;

  static Future<bool> saveAuth(String token, String uid) async {
    try {
      final box = await _getBox(_boxAuth);
      if (box == null) return false;
      await box.put('access_token', token);
      await box.put('user_id', uid);
      return true;
    } catch (e) {
      debugPrint('Hive: saveAuth failed: $e');
      return false;
    }
  }

  static Future<bool> clearAuth() async {
    try {
      final box = await _getBox(_boxAuth);
      if (box == null) return false;
      await box.delete('access_token');
      await box.delete('user_id');
      return true;
    } catch (e) {
      debugPrint('Hive: clearAuth failed: $e');
      return false;
    }
  }

  static String? get pinHash => _safeBox(_boxAuth)?.get('pin_hash') as String?;

  static Future<bool> savePinHash(String hash) async {
    try {
      final box = await _getBox(_boxAuth);
      if (box == null) return false;
      await box.put('pin_hash', hash);
      return true;
    } catch (e) {
      debugPrint('Hive: savePinHash failed: $e');
      return false;
    }
  }

  static Future<bool> clearPinHash() async {
    try {
      final box = await _getBox(_boxAuth);
      if (box == null) return false;
      await box.delete('pin_hash');
      return true;
    } catch (e) {
      debugPrint('Hive: clearPinHash failed: $e');
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════
  // USER PROGRESS — Hive is primary; backend is sync target
  // ══════════════════════════════════════════════════════════

  // ── Current progress state ────────────────────────────────

  static UserProgress? loadProgress() {
    final box = _safeBox(_boxProgress);
    final raw = box?.get('state') ?? box?.get('user_progress');
    if (raw == null) return null;
    try {
      return UserProgress.fromMap(raw as Map);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> saveProgress(UserProgress p) async {
    try {
      final box = await _getBox(_boxProgress);
      if (box == null) return false;
      await box.put('state', p.toMap());
      return true;
    } catch (e) {
      debugPrint('Hive: saveProgress failed: $e');
      return false;
    }
  }

  // ── Offline sync queue ────────────────────────────────────
  // Stores progress updates that couldn't be sent to the backend.
  // Keyed by lessonSlug so later updates overwrite earlier ones.

  static Future<bool> queueProgressSync({
    required String lessonSlug,
    required double progress,
    required int currentChapter,
    required bool isCompleted,
  }) async {
    try {
      final box = await _getBox(_boxProgress);
      if (box == null) return false;
      final queue =
          Map<String, dynamic>.from(box.get('sync_queue') as Map? ?? {});
      queue[lessonSlug] = {
        'lessonSlug': lessonSlug,
        'progress': progress,
        'currentChapter': currentChapter,
        'isCompleted': isCompleted,
      };
      await box.put('sync_queue', queue);
      return true;
    } catch (e) {
      debugPrint('Hive: queueProgressSync failed: $e');
      return false;
    }
  }

  static Future<void> dequeueProgressSync(String lessonSlug) async {
    final queue = Map<String, dynamic>.from(
      (_safeBox(_boxProgress)?.get('sync_queue') as Map? ?? {}),
    );
    queue.remove(lessonSlug);
    await _safeBox(_boxProgress)?.put('sync_queue', queue);
  }

  static List<Map<String, dynamic>> loadProgressQueue() {
    final raw = _safeBox(_boxProgress)?.get('sync_queue') as Map?;
    if (raw == null) return const [];
    return raw.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  // ── Hydrate from backend ──────────────────────────────────
  // Merges backend progress records into the local UserProgress state.
  // Only updates fields that the backend owns (progress ratio, chapter,
  // isCompleted). Does NOT overwrite streak, badges, or journey events
  // which are computed locally.

  static Future<void> hydrateProgress(
    List<Map<String, dynamic>> records,
  ) async {
    final current = loadProgress();
    if (current == null) return;

    final lessonProgress = Map<String, double>.from(current.lessonProgress);
    final lessonCurrentChapter =
        Map<String, int>.from(current.lessonCurrentChapter);
    final completedLessons = List<String>.from(current.completedLessons);

    for (final r in records) {
      final slug = r['lessonId'] as String;
      final progress = (r['progress'] as num).toDouble();
      final chapter = r['currentChapter'] as int;
      final done = r['isCompleted'] as bool;

      // Take the higher value (never regress progress)
      lessonProgress[slug] = progress > (lessonProgress[slug] ?? 0)
          ? progress
          : (lessonProgress[slug] ?? 0);
      lessonCurrentChapter[slug] = chapter > (lessonCurrentChapter[slug] ?? 0)
          ? chapter
          : (lessonCurrentChapter[slug] ?? 0);
      if (done && !completedLessons.contains(slug)) {
        completedLessons.add(slug);
      }
    }

    await saveProgress(current.copyWith(
      lessonProgress: lessonProgress,
      lessonCurrentChapter: lessonCurrentChapter,
      completedLessons: completedLessons,
    ));
  }

  static Future<void> hydrateProfile(Map<String, dynamic> profile) async {
    final current = loadProgress();
    if (current == null) return;

    await saveProgress(current.copyWith(
      dayStreak: profile['dayStreak'] as int?,
      totalQuestions: profile['totalQuestions'] as int?,
      correctAnswers: profile['correctAnswers'] as int?,
      earnedBadges:
          (profile['earnedBadges'] as List?)?.map((e) => e.toString()).toList(),
      journeyEvents: (profile['journeyEvents'] as List?)
          ?.map((e) => JourneyEvent.fromMap(e as Map))
          .toList(),
      avatarSeed: profile['avatarSeed'] as String?,
      joinedDate: profile['joinedDate'] != null
          ? DateTime.tryParse(profile['joinedDate'].toString())
          : null,
    ));
  }

  // ══════════════════════════════════════════════════════════
  // API CACHE — only used when offline; replaced on next online fetch
  // ══════════════════════════════════════════════════════════

  // ── Lesson list cache ─────────────────────────────────────

  static Future<void> saveLessons(List<Lesson> lessons) async {
    final box = _safeBox(_boxLessons);
    if (box == null) return;
    await box.put(
      '_catalogue',
      lessons.map(_lessonToMap).toList(),
    );
  }

  static List<Lesson> loadLessons() {
    final raw = _safeBox(_boxLessons)?.get('_catalogue');
    if (raw == null) return const [];
    try {
      return (raw as List<dynamic>)
          .map((e) => Lesson.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  // ── Single lesson content cache ───────────────────────────

  static Future<void> saveLesson(Lesson lesson) async {
    await _safeBox(_boxLessons)?.put(lesson.id, _lessonToMap(lesson));
  }

  static Lesson? loadLesson(String slug) {
    final raw = _safeBox(_boxLessons)?.get(slug);
    if (raw == null) return null;
    try {
      return Lesson.fromJson(Map<String, dynamic>.from(raw as Map));
    } catch (_) {
      return null;
    }
  }

  // ── Quiz question cache ───────────────────────────────────

  static Future<void> saveQuizQuestions(
    String lessonSlug,
    List<QuizQuestion> questions,
  ) async {
    await _safeBox(_boxQuiz)?.put(
      lessonSlug,
      questions.map(_questionToMap).toList(),
    );
  }

  static List<QuizQuestion> loadQuizQuestions(String lessonSlug) {
    final raw = _safeBox(_boxQuiz)?.get(lessonSlug);
    if (raw == null) return const [];
    try {
      return (raw as List<dynamic>)
          .map(
              (e) => QuizQuestion.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  // ══════════════════════════════════════════════════════════
  // COMMUNITY CACHE — circles, messages, debates, questions
  // ══════════════════════════════════════════════════════════

  // ── Circles ───────────────────────────────────────────────

  static Future<void> saveCommunityCircles(
      List<Map<String, dynamic>> circles) async {
    await _safeBox(_boxCommunity)?.put('circles', circles);
  }

  static List<Map<String, dynamic>> loadCommunityCircles() {
    final raw = _safeBox(_boxCommunity)?.get('circles');
    if (raw == null) return const [];
    return (raw as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // ── Messages (keyed by circleSlug) ───────────────────────

  static Future<void> saveCommunityMessages(
      String circleSlug, List<Map<String, dynamic>> messages) async {
    await _safeBox(_boxCommunity)?.put('messages_$circleSlug', messages);
  }

  static List<Map<String, dynamic>> loadCommunityMessages(String circleSlug) {
    final raw = _safeBox(_boxCommunity)?.get('messages_$circleSlug');
    if (raw == null) return const [];
    return (raw as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // ── Debates ───────────────────────────────────────────────

  static Future<void> saveCommunityDebates(
      List<Map<String, dynamic>> debates) async {
    await _safeBox(_boxCommunity)?.put('debates', debates);
  }

  static List<Map<String, dynamic>> loadCommunityDebates() {
    final raw = _safeBox(_boxCommunity)?.get('debates');
    if (raw == null) return const [];
    return (raw as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // ── Anonymous questions ───────────────────────────────────

  static Future<void> saveCommunityQuestions(
      List<Map<String, dynamic>> questions) async {
    await _safeBox(_boxCommunity)?.put('questions', questions);
  }

  static List<Map<String, dynamic>> loadCommunityQuestions() {
    final raw = _safeBox(_boxCommunity)?.get('questions');
    if (raw == null) return const [];
    return (raw as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // ── Pending message queue (offline writes) ────────────────
  // Messages queued while offline are flushed by SyncService on reconnect.

  static Future<void> queuePendingMessage(
      String circleSlug, Map<String, dynamic> payload) async {
    final box = _safeBox(_boxCommunity);
    if (box == null) return;
    final key = 'pending_msgs_$circleSlug';
    final existing = (box.get(key) as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    existing.add(payload);
    await box.put(key, existing);
  }

  static List<Map<String, dynamic>> loadPendingMessages(String circleSlug) {
    final raw = _safeBox(_boxCommunity)?.get('pending_msgs_$circleSlug');
    if (raw == null) return const [];
    return (raw as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  static Future<void> clearPendingMessages(String circleSlug) async {
    await _safeBox(_boxCommunity)?.delete('pending_msgs_$circleSlug');
  }

  // ── Pending question queue ────────────────────────────────

  static Future<void> queuePendingQuestion(Map<String, dynamic> payload) async {
    final box = _safeBox(_boxCommunity);
    if (box == null) return;
    const key = 'pending_questions';
    final existing = (box.get(key) as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    existing.add(payload);
    await box.put(key, existing);
  }

  static List<Map<String, dynamic>> loadPendingQuestions() {
    final raw = _safeBox(_boxCommunity)?.get('pending_questions');
    if (raw == null) return const [];
    return (raw as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  static Future<void> clearPendingQuestions() async {
    await _safeBox(_boxCommunity)?.delete('pending_questions');
  }

  // ══════════════════════════════════════════════════════════
  // Serialisation helpers
  // ══════════════════════════════════════════════════════════

  static Map<String, dynamic> _lessonToMap(Lesson l) => {
        'id': l.id,
        'title': l.title,
        'localizedTitle': l.localizedTitle,
        'category': l.category.apiKey,
        'durationMinutes': l.durationMinutes,
        'chapters': l.chapters
            .map((c) => {
                  'id': c.id,
                  'orderIndex': c.orderIndex,
                  'title': c.title,
                  'localizedTitle': c.localizedTitle,
                  'narrationText': c.narrationText,
                  'localizedNarration': c.localizedNarration,
                  'modelUrl': c.modelUrl,
                  'modelReady': c.modelReady,
                  'audioUrl': c.audioUrl,
                  'hotspots': c.hotspots
                      .map((h) => {
                            'id': h.id,
                            'number': h.number,
                            'title': h.title,
                            'localizedTitle': h.localizedTitle,
                            'description': h.description,
                            'localizedDescription': h.localizedDescription,
                          })
                      .toList(),
                })
            .toList(),
      };

  static Map<String, dynamic> _questionToMap(QuizQuestion q) => {
        'id': q.id,
        'lessonId': q.lessonId,
        'lesson': {'id': q.lessonId},
        'questionText': q.questionText,
        'localizedQuestionText': q.localizedQuestionText,
        'options': q.options,
        'localizedOptions': q.localizedOptions,
        'explanation': q.explanation,
        'localizedExplanation': q.localizedExplanation,
        // correctIndex and explanation are NOT cached — only revealed after submit
      };
}
