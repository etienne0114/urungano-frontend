import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../storage/hive_storage.dart';
import '../../models/lesson.dart';
import '../../models/quiz_question.dart';
import 'api_client.dart';

class SyncService {
  SyncService._();

  /// Perform a full data synchronization with the backend.
  /// This fetches the latest lessons, quiz data, and user progress.
  static Future<void> performFullSync() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>('/sync');
      final data = ApiClient.staticUnwrap<Map<String, dynamic>>(response);

      // 1. Sync Lessons
      if (data.containsKey('lessons')) {
        final lessons = (data['lessons'] as List<dynamic>)
            .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
            .toList();
        await HiveStorage.saveLessons(lessons);
        
        // Cache individual lessons for faster access
        for (final lesson in lessons) {
          await HiveStorage.saveLesson(lesson);
        }
      }

      // 2. Sync Quiz Data (if provided in bulk)
      if (data.containsKey('quizzes')) {
        final quizzes = data['quizzes'] as Map<String, dynamic>;
        for (final entry in quizzes.entries) {
          final lessonSlug = entry.key;
          final questions = (entry.value as List<dynamic>)
              .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
              .toList();
          await HiveStorage.saveQuizQuestions(lessonSlug, questions);
        }
      }

      // 3. Sync User Progress
      if (data.containsKey('progress')) {
        final progressRecords = (data['progress'] as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        await HiveStorage.hydrateProgress(progressRecords);
      }

      // 4. Sync Profile Stats
      if (data.containsKey('profile')) {
        final profile = data['profile'] as Map<String, dynamic>;
        await HiveStorage.hydrateProfile(profile);
      }

      // 5. Push local changes from queue
      await pushLocalChanges();

      // 6. Flush offline community writes
      await flushPendingCommunityWrites();

    } on DioException catch (e) {
      // Log error but don't crash - sync will retry later
      debugPrint('Sync failed: ${e.message}');
    }
  }

  /// Flush community messages and questions queued while offline.
  static Future<void> flushPendingCommunityWrites() async {
    // Flush pending messages per circle
    final circles = HiveStorage.loadCommunityCircles();
    for (final circle in circles) {
      final slug = circle['slug'] as String? ?? '';
      if (slug.isEmpty) continue;
      final pending = HiveStorage.loadPendingMessages(slug);
      if (pending.isEmpty) continue;
      for (final payload in pending) {
        try {
          await ApiClient.instance.post(
            '/community/circles/$slug/messages',
            data: {'text': payload['text'], 'lang': payload['lang']},
          );
        } on DioException {
          return; // stop flushing if network fails; retry next sync
        }
      }
      await HiveStorage.clearPendingMessages(slug);
    }

    // Flush pending questions
    final pendingQ = HiveStorage.loadPendingQuestions();
    for (final payload in pendingQ) {
      try {
        await ApiClient.instance.post(
          '/community/questions',
          data: {'text': payload['text']},
        );
      } on DioException {
        return;
      }
    }
    await HiveStorage.clearPendingQuestions();
  }

  /// Push locally queued progress updates to the backend.
  static Future<void> pushLocalChanges() async {
    final queue = HiveStorage.loadProgressQueue();
    if (queue.isEmpty) return;

    for (final record in queue) {
      try {
        final lessonSlug = record['lessonSlug'] as String;
        await ApiClient.instance.post(
          '/progress/$lessonSlug',
          data: {
            'progress':       record['progress'],
            'currentChapter': record['currentChapter'],
            'isCompleted':    record['isCompleted'],
          },
        );
        // If successful, remove from local queue
        await HiveStorage.dequeueProgressSync(lessonSlug);
      } on DioException {
        // Stop pushing if network fails, will resume next time
        break;
      }
    }
  }
}
