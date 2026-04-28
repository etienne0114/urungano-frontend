import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_progress.dart';
import '../models/badge_definition.dart';
import '../services/api/auth_service.dart';
import '../services/api/progress_service.dart';
import '../services/api/sync_service.dart';
import '../services/connectivity_service.dart';
import '../services/storage/hive_storage.dart';
import '../services/api/api_client.dart';

/// Manages [UserProgress] state.
///
/// Hive is the primary store — the UI always reads from it.
/// The backend is the sync target — written to when online,
/// queued in Hive when offline and flushed on next online session.
class ProgressNotifier extends StateNotifier<UserProgress?> {
  ProgressNotifier() : super(HiveStorage.loadProgress());

  // ── Auth / Init ───────────────────────────────────────────

  /// Signs in anonymously.
  ///
  /// ONLINE:  calls backend → stores token → hydrates progress from server
  ///          → flushes any queued offline updates
  /// OFFLINE: uses existing Hive session (no network call)
  Future<({String? error, bool isNotFound})> signIn(String username, {String? pin, bool isRegistration = false}) async {
    final result = await AuthService.signInAnonymous(username, pin: pin, isRegistration: isRegistration);

    if (result == null) {
      // Offline — use or create local session
      if (state == null) {
        state = UserProgress.initial(username);
        await _persist();
      }
      return (error: null, isNotFound: false);
    }

    if (result.error != null) {
      return (error: result.error, isNotFound: result.isNotFound);
    }

    // Online — update state with server identity
    final existing = state;
    if (existing != null) {
      state = existing.copyWith(
        userId:   result.userId,
        username: result.username,
      );
    } else {
      state = UserProgress.initial(result.username)
          .copyWith(userId: result.userId);
    }
    await _persist();

    // 2. Fire sync in the background — do NOT await here.
    //    Awaiting sync inside signIn caused a race condition: if the /sync
    //    endpoint returned 401 (e.g. due to a brief server hiccup), the 401
    //    interceptor would clear the token we just saved, effectively logging
    //    the user out 2-3 seconds after a successful sign-in.
    unawaited(SyncService.performFullSync());

    return (error: null, isNotFound: false);
  }

  Future<void> initUser(String userId, String username) async {
    final existing = state;
    if (existing != null) {
      state = existing.copyWith(userId: userId, username: username);
    } else {
      state = UserProgress.initial(username).copyWith(userId: userId);
    }
    await _persist();
  }

  // ── App resume ────────────────────────────────────────────

  /// Call when the app comes back to the foreground.
  /// Flushes queued offline progress if now online.
  Future<void> onResume() async {
    final online = await ConnectivityService.check();
    if (online) await SyncService.performFullSync();
  }

  // ── Lesson progress ───────────────────────────────────────

  Future<void> updateLessonProgress(
    String lessonId,
    double progress,
    int currentChapter, {
    bool completed = false,
  }) async {
    final current = state;
    if (current == null) return;

    final newProgress = Map<String, double>.from(current.lessonProgress)
      ..[lessonId] = progress;
    final newChapters = Map<String, int>.from(current.lessonCurrentChapter)
      ..[lessonId] = currentChapter;

    final completedLessons =
        completed && !current.completedLessons.contains(lessonId)
            ? [...current.completedLessons, lessonId]
            : current.completedLessons;

    final events = List<JourneyEvent>.from(current.journeyEvents);
    if (completed && !current.completedLessons.contains(lessonId)) {
      events.insert(0, JourneyEvent(
        type:        'completed',
        description: '', // UI will use journeyCompleted key
        detail:      lessonId,
        timestamp:   DateTime.now(),
      ));
    }

    // 1. Write to Hive immediately (UI source of truth)
    state = current.copyWith(
      lessonProgress:       newProgress,
      lessonCurrentChapter: newChapters,
      completedLessons:     completedLessons,
      journeyEvents:        events,
    );
    _checkAndAwardBadges();
    await _persist();

    // 2. Sync to backend (queues to Hive if offline)
    await ProgressService.upsert(
      lessonSlug:     lessonId,
      progress:       progress,
      currentChapter: currentChapter,
      isCompleted:    completed,
    );
  }

  // ── Quiz results ──────────────────────────────────────────

  Future<void> recordQuizResult(
    String lessonId,
    int total,
    int correct,
  ) async {
    final current = state;
    if (current == null) return;

    final pct = total > 0 ? (correct / total * 100).round() : 0;
    final events = List<JourneyEvent>.from(current.journeyEvents)
      ..insert(0, JourneyEvent(
        type:        'quiz',
        description: '$pct', // Just the number for localization
        detail:      lessonId,
        timestamp:   DateTime.now(),
      ));

    state = current.copyWith(
      totalQuestions: current.totalQuestions + total,
      correctAnswers: current.correctAnswers + correct,
      journeyEvents:  events,
    );

    if (correct == total && total > 0 && lessonId == 'your_cycle') {
      await _awardBadge('flow_master');
    }

    await _persist();
  }

  // ── Streak ────────────────────────────────────────────────

  Future<void> touchStreak() async {
    final current = state;
    if (current == null) return;

    final now  = DateTime.now();
    final last = current.lastActiveDate;
    final diffDays = DateTime(now.year, now.month, now.day)
        .difference(DateTime(last.year, last.month, last.day))
        .inDays;

    int streak = current.dayStreak;
    if (diffDays == 1) {
      streak += 1;
    } else if (diffDays > 1) {
      streak = 1;
    }

    state = current.copyWith(dayStreak: streak, lastActiveDate: now);
    _checkAndAwardBadges();
    await _persist();
  }

  // ── Badges ────────────────────────────────────────────────

  void _checkAndAwardBadges() {
    final current = state;
    if (current == null) return;
    for (final badge in kBadgeDefinitions) {
      if (!current.earnedBadges.contains(badge.id) &&
          badge.earnCondition(current)) {
        state = current.copyWith(
          earnedBadges: [...current.earnedBadges, badge.id],
        );
      }
    }
  }

  Future<void> _awardBadge(String id) async {
    final current = state;
    if (current == null || current.earnedBadges.contains(id)) return;
    state = current.copyWith(earnedBadges: [...current.earnedBadges, id]);
    await _persist();
  }

  // ── Profile ───────────────────────────────────────────────

  Future<void> updateUsername(String username) async {
    state = state?.copyWith(username: username);
    await _persist();
  }

  Future<void> updateAvatarSeed(String seed) async {
    state = state?.copyWith(avatarSeed: seed);
    await _persist();
  }

  Future<void> setHasPIN(bool value) async {
    state = state?.copyWith(hasPIN: value);
    await _persist();
  }

  // ── Persistence ───────────────────────────────────────────

  Future<void> _persist() async {
    final current = state;
    if (current != null) {
      await HiveStorage.saveProgress(current);

      if (await ConnectivityService.check()) {
        try {
          await ApiClient.instance.patch('/users/me', data: {
            'username': current.username,
            'avatarSeed': current.avatarSeed,
            'earnedBadges': current.earnedBadges,
            'journeyEvents': current.journeyEvents.map((e) => e.toMap()).toList(),
            'totalQuestions': current.totalQuestions,
            'correctAnswers': current.correctAnswers,
          });
        } catch (_) {
          // Ignore network errors, will sync next time
        }
      }
    }
  }
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, UserProgress?>(
  (_) => ProgressNotifier(),
);

/// Tracks if the current app session has been unlocked via PIN.
/// Reset to false on app restart.
final sessionUnlockedProvider = StateProvider<bool>((ref) => false);
