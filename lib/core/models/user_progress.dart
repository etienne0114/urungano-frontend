import 'package:equatable/equatable.dart';

class JourneyEvent extends Equatable {
  final String type;        // 'completed' | 'quiz' | 'started' | 'setup'
  final String description;
  final String detail;
  final DateTime timestamp;

  const JourneyEvent({
    required this.type,
    required this.description,
    required this.detail,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [type, description, detail, timestamp];

  Map<String, dynamic> toMap() => {
        'type': type,
        'description': description,
        'detail': detail,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory JourneyEvent.fromMap(Map<dynamic, dynamic> m) => JourneyEvent(
        type:        m['type'] as String,
        description: m['description'] as String,
        detail:      m['detail'] as String,
        timestamp:   DateTime.fromMillisecondsSinceEpoch(m['timestamp'] as int),
      );
}

class UserProgress extends Equatable {
  final String userId;
  final String username;
  final String language;
  final int dayStreak;
  final DateTime lastActiveDate;

  /// lessonId → 0.0–1.0
  final Map<String, double> lessonProgress;
  final Map<String, int> lessonCurrentChapter;
  final List<String> completedLessons;
  final List<String> earnedBadges;
  final int totalQuestions;
  final int correctAnswers;
  final String avatarSeed;
  final DateTime joinedDate;
  final List<JourneyEvent> journeyEvents;
  final bool hasPIN;

  const UserProgress({
    required this.userId,
    required this.username,
    required this.language,
    required this.dayStreak,
    required this.lastActiveDate,
    required this.lessonProgress,
    required this.lessonCurrentChapter,
    required this.completedLessons,
    required this.earnedBadges,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.avatarSeed,
    required this.joinedDate,
    required this.journeyEvents,
    required this.hasPIN,
  });

  double get accuracy =>
      totalQuestions == 0 ? 0 : correctAnswers / totalQuestions;

  int get accuracyPercent => (accuracy * 100).round();

  @override
  List<Object?> get props => [
        userId, username, language, dayStreak, lessonProgress,
        completedLessons, earnedBadges, totalQuestions, correctAnswers,
      ];

  UserProgress copyWith({
    String? userId,
    String? username,
    String? language,
    int? dayStreak,
    DateTime? lastActiveDate,
    Map<String, double>? lessonProgress,
    Map<String, int>? lessonCurrentChapter,
    List<String>? completedLessons,
    List<String>? earnedBadges,
    int? totalQuestions,
    int? correctAnswers,
    String? avatarSeed,
    DateTime? joinedDate,
    List<JourneyEvent>? journeyEvents,
    bool? hasPIN,
  }) =>
      UserProgress(
        userId:               userId ?? this.userId,
        username:             username ?? this.username,
        language:             language ?? this.language,
        dayStreak:            dayStreak ?? this.dayStreak,
        lastActiveDate:       lastActiveDate ?? this.lastActiveDate,
        lessonProgress:       lessonProgress ?? this.lessonProgress,
        lessonCurrentChapter: lessonCurrentChapter ?? this.lessonCurrentChapter,
        completedLessons:     completedLessons ?? this.completedLessons,
        earnedBadges:         earnedBadges ?? this.earnedBadges,
        totalQuestions:       totalQuestions ?? this.totalQuestions,
        correctAnswers:       correctAnswers ?? this.correctAnswers,
        avatarSeed:           avatarSeed ?? this.avatarSeed,
        joinedDate:           joinedDate ?? this.joinedDate,
        journeyEvents:        journeyEvents ?? this.journeyEvents,
        hasPIN:               hasPIN ?? this.hasPIN,
      );

  Map<String, dynamic> toMap() => {
        'userId':               userId,
        'username':             username,
        'language':             language,
        'dayStreak':            dayStreak,
        'lastActiveDate':       lastActiveDate.millisecondsSinceEpoch,
        'lessonProgress':       lessonProgress,
        'lessonCurrentChapter': lessonCurrentChapter,
        'completedLessons':     completedLessons,
        'earnedBadges':         earnedBadges,
        'totalQuestions':       totalQuestions,
        'correctAnswers':       correctAnswers,
        'avatarSeed':           avatarSeed,
        'joinedDate':           joinedDate.millisecondsSinceEpoch,
        'journeyEvents':        journeyEvents.map((e) => e.toMap()).toList(),
        'hasPIN':               hasPIN,
      };

  factory UserProgress.fromMap(Map<dynamic, dynamic> m) => UserProgress(
        userId:   m['userId'] as String? ?? '',
        username: m['username'] as String,
        language: m['language'] as String,
        dayStreak: m['dayStreak'] as int,
        lastActiveDate:
            DateTime.fromMillisecondsSinceEpoch(m['lastActiveDate'] as int),
        lessonProgress: Map<String, double>.from(
          (m['lessonProgress'] as Map? ?? {}).map(
            (k, v) => MapEntry(k as String, (v as num).toDouble()),
          ),
        ),
        lessonCurrentChapter: Map<String, int>.from(
          (m['lessonCurrentChapter'] as Map? ?? {}).map(
            (k, v) => MapEntry(k as String, v as int),
          ),
        ),
        completedLessons:
            List<String>.from(m['completedLessons'] as List? ?? []),
        earnedBadges:
            List<String>.from(m['earnedBadges'] as List? ?? []),
        totalQuestions: m['totalQuestions'] as int,
        correctAnswers: m['correctAnswers'] as int,
        avatarSeed:     m['avatarSeed'] as String,
        joinedDate:
            DateTime.fromMillisecondsSinceEpoch(m['joinedDate'] as int),
        journeyEvents: (m['journeyEvents'] as List? ?? [])
            .map((e) => JourneyEvent.fromMap(e as Map))
            .toList(),
        hasPIN: m['hasPIN'] as bool? ?? false,
      );

  static UserProgress initial(String username) => UserProgress(
        userId:               '',
        username:             username,
        language:             'rw',
        dayStreak:            0,
        lastActiveDate:       DateTime.now(),
        lessonProgress:       const {},
        lessonCurrentChapter: const {},
        completedLessons:     const [],
        earnedBadges:         const [],
        totalQuestions:       0,
        correctAnswers:       0,
        avatarSeed:           '01',
        joinedDate:           DateTime.now(),
        journeyEvents:        const [],
        hasPIN:               false,
      );
}
