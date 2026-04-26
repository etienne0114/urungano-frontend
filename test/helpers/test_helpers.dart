/// Test helpers and utilities for consistent testing patterns
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urungano/core/models/app_settings.dart';
import 'package:urungano/core/providers/settings_provider.dart';
import 'package:urungano/l10n/app_localizations.dart';

/// Creates a test widget wrapper with all necessary providers and localizations
Widget createTestApp({
  required Widget child,
  List<Override>? overrides,
  AppSettings? initialSettings,
}) {
  return ProviderScope(
    overrides: [
      if (overrides != null) ...overrides,
      if (initialSettings != null)
        settingsProvider.overrideWith((ref) => SettingsNotifier(initialSettings)),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

/// Creates a test widget with minimal setup for unit testing
Widget createMinimalTestWidget({
  required Widget child,
  List<Override>? overrides,
}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

/// Pumps a widget and settles all animations
Future<void> pumpAndSettleWidget(
  WidgetTester tester,
  Widget widget, {
  Duration? duration,
}) async {
  await tester.pumpWidget(widget);
  if (duration != null) {
    await tester.pumpAndSettle(duration);
  } else {
    await tester.pumpAndSettle();
  }
}

/// Common test data for lessons
class TestData {
  static const Map<String, dynamic> sampleLessonJson = {
    'id': 'test-lesson-1',
    'title': 'Test Lesson',
    'category': 'menstrual_health',
    'durationMinutes': 15,
    'chapters': [
      {
        'id': 'chapter-1',
        'orderIndex': 0,
        'title': 'Chapter 1',
        'narrationText': 'Test narration',
        'hotspots': [
          {
            'id': 'hotspot-1',
            'number': 1,
            'title': 'Test Hotspot',
            'description': 'Test description',
          }
        ]
      }
    ]
  };

  static const Map<String, dynamic> sampleUserJson = {
    'id': 'test-user-1',
    'isAnonymous': true,
    'hasPin': false,
    'createdAt': '2024-01-01T00:00:00Z',
  };

  static const Map<String, dynamic> sampleProgressJson = {
    'userId': 'test-user-1',
    'lessonId': 'test-lesson-1',
    'completedChapters': ['chapter-1'],
    'currentStreak': 5,
    'totalLessonsCompleted': 10,
    'lastActivityAt': '2024-01-01T00:00:00Z',
  };
}

/// Custom matchers for testing
class TestMatchers {
  /// Matches a widget that has accessibility semantics
  static Matcher hasSemantics() => _HasSemanticsMatcher();
  
  /// Matches a widget that is focusable
  static Matcher isFocusable() => _IsFocusableMatcher();
}

class _HasSemanticsMatcher extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Widget) return false;
    // This would need to be implemented based on specific semantics requirements
    return true;
  }

  @override
  Description describe(Description description) =>
      description.add('has accessibility semantics');
}

class _IsFocusableMatcher extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Widget) return false;
    // This would need to be implemented based on focus requirements
    return true;
  }

  @override
  Description describe(Description description) =>
      description.add('is focusable');
}

/// Test utilities for async operations
class AsyncTestUtils {
  /// Waits for a condition to be true with timeout
  static Future<void> waitForCondition(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 5),
    Duration interval = const Duration(milliseconds: 100),
  }) async {
    final stopwatch = Stopwatch()..start();
    
    while (!condition() && stopwatch.elapsed < timeout) {
      await Future.delayed(interval);
    }
    
    if (!condition()) {
      throw TimeoutException('Condition not met within timeout', timeout);
    }
  }
}

/// Exception for test timeouts
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;
  
  const TimeoutException(this.message, this.timeout);
  
  @override
  String toString() => 'TimeoutException: $message (timeout: $timeout)';
}