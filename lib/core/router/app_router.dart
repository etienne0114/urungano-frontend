import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/language_screen.dart';
import '../../features/onboarding/accessibility_setup_screen.dart';
import '../../features/onboarding/privacy_consent_screen.dart';
import '../../features/onboarding/pin_setup_screen.dart';
import '../../features/onboarding/pin_verify_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/lesson/lesson_screen.dart';
import '../../features/quiz/quiz_screen.dart';
import '../../features/gesture/gesture_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/community/community_screen.dart';
import '../../features/community/community_thread_screen.dart';
import '../services/api/api_client.dart';
import '../services/storage/hive_storage.dart';
import '../widgets/adaptive_scaffold.dart';
import '../providers/progress_provider.dart';
import '../providers/settings_provider.dart';

final _shellKey = GlobalKey<NavigatorState>();

/// Router is created once as a provider — never recreated on rebuild.
/// This prevents the router from resetting to '/' every time a provider
/// changes (which would cause the onboarding redirect loop).
/// Listenable that triggers GoRouter redirect when providers change.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    ref.listen(sessionUnlockedProvider, (_, __) => notifyListeners());
    ref.listen(settingsProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = RouterRefreshNotifier(ref);
  
  // Handle session expiration (401) globally
  ApiClient.instance.onUnauthorized = () {
    final progress = HiveStorage.loadProgress();
    if (progress?.hasPIN == true) {
      // Force PIN verification
      ref.read(sessionUnlockedProvider.notifier).state = false;
    } else if (progress != null) {
      // No PIN, try to re-login anonymously automatically
      ref.read(progressProvider.notifier).signIn(progress.username);
    }
  };

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final path = state.matchedLocation;
      if (path == '/') return null;

      final settings = HiveStorage.loadSettings();
      final onboarded = settings.onboardingComplete;

      final isOnboardingPath =
          path == '/language' ||
          path == '/accessibility-setup' ||
          path == '/privacy-consent' ||
          path == '/pin-setup' ||
          path == '/pin-verify';

      if (!onboarded && !isOnboardingPath) return '/language';

      if (onboarded && isOnboardingPath && path != '/pin-verify') {
        return '/home';
      }

      if (onboarded && settings.appLock) {
        final progress = HiveStorage.loadProgress();
        final hasPIN = progress?.hasPIN == true && HiveStorage.pinHash != null;
        final isUnlocked = ref.read(sessionUnlockedProvider);
        
        if (hasPIN && !isUnlocked && path != '/pin-verify') {
          return '/pin-verify';
        }
      }

      return null;
    },
    routes: [
      // ── Boot ──────────────────────────────────────────────
      GoRoute(
        path: '/',
        builder: (_, __) => const SplashScreen(),
      ),

      // ── Onboarding ────────────────────────────────────────
      GoRoute(
        path: '/language',
        builder: (_, __) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/accessibility-setup',
        builder: (_, __) => const AccessibilitySetupScreen(),
      ),
      GoRoute(
        path: '/privacy-consent',
        builder: (_, __) => const PrivacyConsentScreen(),
      ),
      GoRoute(
        path: '/pin-setup',
        builder: (_, __) => const PinSetupScreen(),
      ),
      GoRoute(
        path: '/pin-verify',
        builder: (_, __) => const PinVerifyScreen(),
      ),

      // ── Main app ──────────────────────────────────────────
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => AdaptiveScaffold(
          currentPath: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: '/library',
            builder: (_, __) => const LibraryScreen(),
          ),
          GoRoute(
            path: '/lesson/:id',
            builder: (_, state) => LessonScreen(
              lessonId: state.pathParameters['id']!,
              initialChapter: int.tryParse(
                    state.uri.queryParameters['chapter'] ?? '0',
                  ) ??
                  0,
            ),
          ),
          GoRoute(
            path: '/quiz/:lessonId',
            builder: (_, state) => QuizScreen(
              lessonId: state.pathParameters['lessonId']!,
            ),
          ),
          GoRoute(
            path: '/community',
            builder: (_, __) => const CommunityScreen(),
          ),
          GoRoute(
            path: '/community/thread/:circleId',
            builder: (_, state) => CommunityThreadScreen(
              circleId: state.pathParameters['circleId']!,
            ),
          ),
          GoRoute(
            path: '/gesture',
            builder: (_, __) => const GestureScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
