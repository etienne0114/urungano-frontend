class QuizQuestion {
  final String id;
  final String lessonId;
  final String questionText;
  final Map<String, String> localizedQuestionText;
  final List<String> options;
  final Map<String, List<String>> localizedOptions;
  // correctIndex is NOT present in the API response — only revealed after submit.
  final int? correctIndex;
  final String? explanation;
  final Map<String, String> localizedExplanation;

  const QuizQuestion({
    required this.id,
    required this.lessonId,
    required this.questionText,
    this.localizedQuestionText = const {},
    required this.options,
    this.localizedOptions = const {},
    this.correctIndex,
    this.explanation,
    this.localizedExplanation = const {},
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
        id: json['id'] as String,
        lessonId:
            (json['lesson'] as Map<String, dynamic>?)?['id'] as String? ?? '',
        questionText: json['questionText'] as String,
        localizedQuestionText:
            Map<String, String>.from(json['localizedQuestionText'] ?? const {}),
        options: List<String>.from(json['options'] as List),
        localizedOptions:
            (json['localizedOptions'] as Map<String, dynamic>? ?? const {})
                .map((k, v) => MapEntry(k, List<String>.from(v as List))),
        correctIndex: json['correctIndex'] as int?,
        explanation: json['explanation'] as String?,
        localizedExplanation:
            Map<String, String>.from(json['localizedExplanation'] ?? const {}),
      );

  String questionFor(String langCode) =>
      localizedQuestionText[langCode] ?? questionText;

  List<String> optionsFor(String langCode) =>
      localizedOptions[langCode] ?? options;

  String explanationFor(String langCode) =>
      localizedExplanation[langCode] ?? (explanation ?? '');
}

class QuestionBreakdown {
  final String questionId;
  final String questionText;
  final int selectedIndex;
  final int correctIndex;
  final bool isCorrect;
  final String explanation;
  final Map<String, String> localizedExplanation;

  const QuestionBreakdown({
    required this.questionId,
    required this.questionText,
    required this.selectedIndex,
    required this.correctIndex,
    required this.isCorrect,
    required this.explanation,
    this.localizedExplanation = const {},
  });

  factory QuestionBreakdown.fromJson(Map<String, dynamic> json) =>
      QuestionBreakdown(
        questionId: json['questionId'] as String,
        questionText: json['questionText'] as String,
        selectedIndex: json['selectedIndex'] as int,
        correctIndex: json['correctIndex'] as int,
        isCorrect: json['isCorrect'] as bool,
        explanation: json['explanation'] as String,
        localizedExplanation:
            Map<String, String>.from(json['localizedExplanation'] ?? const {}),
      );

  String explanationFor(String langCode) =>
      localizedExplanation[langCode] ?? explanation;
}

class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final double accuracy;
  final List<QuestionBreakdown> breakdown;

  const QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.accuracy,
    required this.breakdown,
  });

  bool get isPerfect => correctAnswers == totalQuestions;

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
        totalQuestions: json['totalQuestions'] as int,
        correctAnswers: json['correctAnswers'] as int,
        accuracy: (json['accuracy'] as num).toDouble(),
        breakdown: (json['breakdown'] as List<dynamic>)
            .map((b) => QuestionBreakdown.fromJson(b as Map<String, dynamic>))
            .toList(),
      );
}
