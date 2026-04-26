import 'package:dio/dio.dart';
import '../../data/quiz_bank.dart';
import '../../models/quiz_question.dart';
import '../connectivity_service.dart';
import '../storage/hive_storage.dart';
import 'api_client.dart';

/// Quiz data access.
///
/// Flow:
///   ONLINE  → fetch questions from API → cache to Hive → return API data
///             submit answers to API → return scored result
///   OFFLINE → return Hive-cached questions → fall back to bundled [kQuizBank]
///             score locally (no backend submission)
class QuizService {
  QuizService._();

  // ── Questions ─────────────────────────────────────────────

  static Future<List<QuizQuestion>> fetchQuestions(String lessonSlug) async {
    final online = await ConnectivityService.check();

    if (online) {
      try {
        final res = await ApiClient.instance
            .get<Map<String, dynamic>>('/quiz/$lessonSlug');
        final questions = (ApiClient.staticUnwrap<List<dynamic>>(res))
            .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
            .toList();

        // Cache to Hive for offline use
        await HiveStorage.saveQuizQuestions(lessonSlug, questions);
        return questions;
      } on DioException {
        // Fall through to cache
      }
    }

    // OFFLINE path: Hive cache → bundled fallback
    final cached = HiveStorage.loadQuizQuestions(lessonSlug);
    if (cached.isNotEmpty) return cached;
    return kQuizBank[lessonSlug] ?? const [];
  }

  // ── Submit ────────────────────────────────────────────────

  /// Online: submits to backend and returns server-scored result.
  /// Offline: scores locally from cached/bundled questions, returns result.
  static Future<QuizResult> submitAnswers(
    String lessonSlug,
    List<int> answers,
  ) async {
    final online = await ConnectivityService.check();

    if (online) {
      try {
        final res = await ApiClient.instance.post<Map<String, dynamic>>(
          '/quiz/$lessonSlug/submit',
          data: {'answers': answers},
        );
        return QuizResult.fromJson(
            ApiClient.staticUnwrap<Map<String, dynamic>>(res));
      } on DioException {
        // Fall through to local scoring
      }
    }

    // OFFLINE: score locally
    return _scoreLocally(lessonSlug, answers);
  }

  static QuizResult _scoreLocally(String lessonSlug, List<int> answers) {
    final questions = HiveStorage.loadQuizQuestions(lessonSlug).isNotEmpty
        ? HiveStorage.loadQuizQuestions(lessonSlug)
        : (kQuizBank[lessonSlug] ?? const <QuizQuestion>[]);

    final breakdown = questions.asMap().entries.map((e) {
      final q   = e.value;
      final sel = e.key < answers.length ? answers[e.key] : 0;
      return QuestionBreakdown(
        questionId:    q.id,
        questionText:  q.questionText,
        selectedIndex: sel,
        correctIndex:  q.correctIndex ?? 0,
        isCorrect:     sel == q.correctIndex,
        explanation:   q.explanation ?? '',
      );
    }).toList();

    final correct = breakdown.where((b) => b.isCorrect).length;
    final total   = breakdown.length;

    return QuizResult(
      totalQuestions: total,
      correctAnswers: correct,
      accuracy:       total > 0 ? correct / total : 0,
      breakdown:      breakdown,
    );
  }
}
