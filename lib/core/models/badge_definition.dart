import 'user_progress.dart';

class BadgeDefinition {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final bool Function(UserProgress progress) earnCondition;

  const BadgeDefinition({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.earnCondition,
  });
}

/// All badge definitions for URUNGANO.
final List<BadgeDefinition> kBadgeDefinitions = [
  BadgeDefinition(
    id: 'first_cycle',
    title: 'First cycle',
    emoji: '🌸',
    description: 'Completed your first menstrual health lesson',
    earnCondition: (p) => p.completedLessons.contains('your_cycle'),
  ),
  BadgeDefinition(
    id: 'hiv_101',
    title: 'HIV 101',
    emoji: '🛡',
    description: 'Completed the HIV prevention lesson',
    earnCondition: (p) => p.completedLessons.contains('hiv_prevention'),
  ),
  BadgeDefinition(
    id: 'early_bird',
    title: 'Early bird',
    emoji: '☀️',
    description: 'Started a lesson within 24 hours of joining',
    earnCondition: (p) =>
        p.lessonProgress.isNotEmpty &&
        DateTime.now().difference(p.joinedDate).inHours < 24,
  ),
  BadgeDefinition(
    id: 'flow_master',
    title: 'Flow master',
    emoji: '〰️',
    description: 'Scored 100% on a menstrual health quiz',
    earnCondition: (p) => p.earnedBadges.contains('flow_master'),
  ),
  BadgeDefinition(
    id: 'seven_day_streak',
    title: '7-day streak',
    emoji: '🤍',
    description: 'Learned for 7 days in a row',
    earnCondition: (p) => p.dayStreak >= 7,
  ),
  BadgeDefinition(
    id: 'all_chapters',
    title: 'All chapters',
    emoji: '⭐',
    description: 'Completed every chapter in any lesson',
    earnCondition: (p) => p.completedLessons.isNotEmpty,
  ),
];
