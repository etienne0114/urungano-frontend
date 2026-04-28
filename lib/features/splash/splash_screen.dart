import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/services/storage/hive_storage.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Give the animation time to play
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final settings = ref.read(settingsProvider);
    final progress = ref.read(progressProvider);

    if (!settings.onboardingComplete) {
      context.go('/language');
      return;
    }

    // If onboarding is complete but no session exists, redirect back to start
    if (progress == null) {
      context.go('/language');
      return;
    }

    // If PIN lock is enabled and user has a PIN, require verification
    // Note: We read progress again because it might have been initialized above
    final currentProgress = ref.read(progressProvider);
    if (settings.appLock &&
        currentProgress?.hasPIN == true &&
        HiveStorage.pinHash != null) {
      context.go('/pin-verify');
      return;
    }

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Logo mark ────────────────────────────────────
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text('rh',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    )),
              ),
            ).animate().fadeIn(duration: 500.ms).scale(
                begin: const Offset(0.7, 0.7),
                duration: 600.ms,
                curve: Curves.easeOutBack),

            const SizedBox(height: 24),

            Text(l.splashTagline, style: AppTextStyles.headline())
                .animate(delay: 400.ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 8),

            Text(l.appTitle.toUpperCase(),
                    style: AppTextStyles.label()
                        .copyWith(color: AppColors.primary, letterSpacing: 3))
                .animate(delay: 600.ms)
                .fadeIn(duration: 400.ms),

            const SizedBox(height: 48),

            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ).animate(delay: 900.ms).fadeIn(duration: 300.ms),
          ],
        ),
      ),
    );
  }
}
