import 'package:dio/dio.dart';
import '../connectivity_service.dart';
import '../storage/hive_storage.dart';
import 'api_client.dart';

/// Progress sync service.
///
/// Flow:
///   ONLINE  → write to Hive immediately → sync to backend
///   OFFLINE → write to Hive only → sync queued when back online
///
/// Hive is always the source of truth for the UI.
/// The backend is the durable store for cross-device sync.
class ProgressService {
  ProgressService._();

  // ── Upsert ────────────────────────────────────────────────

  /// Syncs a progress update to the backend.
  /// Hive is written by [ProgressNotifier] before this is called.
  /// If offline, the update is queued in Hive and retried on next sync.
  static Future<void> upsert({
    required String lessonSlug,
    required double progress,
    required int currentChapter,
    bool isCompleted = false,
  }) async {
    final online = await ConnectivityService.check();

    if (!online) {
      // Queue for later sync
      await HiveStorage.queueProgressSync(
        lessonSlug:     lessonSlug,
        progress:       progress,
        currentChapter: currentChapter,
        isCompleted:    isCompleted,
      );
      return;
    }

    try {
      await ApiClient.instance.put<void>(
        '/progress/$lessonSlug',
        data: {
          'progress':       progress,
          'currentChapter': currentChapter,
          'isCompleted':    isCompleted,
        },
      );
      // Clear any queued entry for this lesson now that it's synced
      await HiveStorage.dequeueProgressSync(lessonSlug);
    } on DioException {
      // Request failed despite connectivity check — queue for retry
      await HiveStorage.queueProgressSync(
        lessonSlug:     lessonSlug,
        progress:       progress,
        currentChapter: currentChapter,
        isCompleted:    isCompleted,
      );
    }
  }

  // ── Flush pending queue ───────────────────────────────────

  /// Sends all queued offline progress updates to the backend.
  /// Call this when the app comes back online (e.g. on app resume).
  static Future<void> flushQueue() async {
    final online = await ConnectivityService.check();
    if (!online) return;

    final queue = HiveStorage.loadProgressQueue();
    for (final entry in queue) {
      try {
        await ApiClient.instance.put<void>(
          '/progress/${entry['lessonSlug']}',
          data: {
            'progress':       entry['progress'],
            'currentChapter': entry['currentChapter'],
            'isCompleted':    entry['isCompleted'],
          },
        );
        await HiveStorage.dequeueProgressSync(entry['lessonSlug'] as String);
      } on DioException {
        // Leave in queue — will retry next flush
      }
    }
  }

  // ── Fetch all (hydrate Hive from backend) ─────────────────

  /// Pulls all progress records from the backend and merges into Hive.
  /// Only called when online. Used on first sign-in to restore state.
  static Future<void> hydrate() async {
    final online = await ConnectivityService.check();
    if (!online) return;

    try {
      final res = await ApiClient.instance
          .get<Map<String, dynamic>>('/progress');
      final records = (ApiClient.staticUnwrap<List<dynamic>>(res))
          .cast<Map<String, dynamic>>();
      await HiveStorage.hydrateProgress(records);
    } on DioException {
      // Offline or error — Hive already has local data
    }
  }
}
