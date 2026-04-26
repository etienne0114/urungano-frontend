import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/widgets/constrained_screen_wrapper.dart';
import '../../core/widgets/primary_button.dart';

class AccessibilitySetupScreen extends ConsumerWidget {
  const AccessibilitySetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final l        = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ConstrainedScreenWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),

              Text(l.a11yTitle,
                style: AppTextStyles.display().copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ))
                  .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 12),

              Text(l.a11ySubtitle,
                style: AppTextStyles.bodyMedium().copyWith(
                  color: AppColors.textSecondary,
                ))
                  .animate(delay: 150.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 48),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _AccessibilityTile(
                        delay: 200,
                        icon: Icons.text_fields_rounded,
                        title: l.a11yLargerText,
                        subtitle: l.a11yLargerTextSub,
                        value: settings.largerText,
                        onChanged: (v) => notifier.setLargerText(v),
                      ),
                      _AccessibilityTile(
                        delay: 280,
                        icon: Icons.contrast_rounded,
                        title: l.a11yContrast,
                        subtitle: l.a11yContrastSub,
                        value: settings.highContrast,
                        onChanged: (v) => notifier.setHighContrast(v),
                      ),
                      _AccessibilityTile(
                        delay: 360,
                        icon: Icons.record_voice_over_rounded,
                        title: l.a11yVoice,
                        subtitle: l.a11yVoiceSub,
                        value: settings.voiceNarration,
                        onChanged: (v) => notifier.setVoiceNarration(v),
                      ),
                      _AccessibilityTile(
                        delay: 440,
                        icon: Icons.closed_caption_rounded,
                        title: l.a11yCaptions,
                        subtitle: l.a11yCaptionsSub,
                        value: settings.captions,
                        onChanged: (v) => notifier.setCaptions(v),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              PrimaryButton(
                label: l.continue_,
                onPressed: () => context.go('/privacy-consent'),
                icon: Icons.arrow_forward_rounded,
              ).animate(delay: 550.ms).fadeIn(duration: 350.ms),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccessibilityTile extends StatelessWidget {
  const _AccessibilityTile({
    required this.delay,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final int delay;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink10.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.title().copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  )),
                  const SizedBox(height: 2),
                  Text(subtitle,
                    style: AppTextStyles.bodySmall().copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    )),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primaryLight,
            ),
          ],
        ),
      ).animate(delay: Duration(milliseconds: delay))
       .fadeIn(duration: 350.ms)
       .slideY(begin: 0.1, end: 0),
    );
  }
}
