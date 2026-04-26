import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import 'package:urungano/core/providers/progress_provider.dart';
import 'package:urungano/core/providers/settings_provider.dart';
import 'package:urungano/core/services/storage/hive_storage.dart';
import 'package:urungano/core/theme/app_colors.dart';
import 'package:urungano/core/theme/app_text_styles.dart';
import 'package:urungano/core/widgets/constrained_screen_wrapper.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isWide   = MediaQuery.sizeOf(context).width >= 900;
    final l        = AppLocalizations.of(context);

    void toggleAppLock() {
      if (!settings.appLock) {
        context.go('/pin-setup');
      } else {
        notifier.setAppLock(false);
        HiveStorage.clearPinHash();
        ref.read(progressProvider.notifier).setHasPIN(false);
      }
    }

    final a11yTiles = [
      _ToggleTile(icon: Icons.volume_up_outlined,    iconBg: AppColors.primaryLight, iconColor: AppColors.primary,      title: l.a11yVoice,       subtitle: l.a11yVoiceSub,    value: settings.voiceNarration, onChanged: notifier.setVoiceNarration),
      _ToggleTile(icon: Icons.closed_caption_outlined,iconBg: AppColors.primaryLight, iconColor: AppColors.primary,      title: l.a11yCaptions,    subtitle: l.a11yCaptionsSub, value: settings.captions,       onChanged: notifier.setCaptions),
      _ToggleTile(icon: Icons.sign_language_outlined, iconBg: AppColors.catMenstrual, iconColor: AppColors.accMenstrual, title: l.a11ySign,         subtitle: l.a11ySignSub,     value: settings.signLanguage,   onChanged: notifier.setSignLanguage),
      _ToggleTile(icon: Icons.back_hand_outlined,     iconBg: AppColors.catMenstrual, iconColor: AppColors.accMenstrual, title: l.a11yGesture,      subtitle: l.a11yGestureSub,  value: settings.gestureControl, onChanged: notifier.setGestureControl),
    ];
    final displayTiles = [
      _ToggleTile(icon: Icons.contrast_rounded,    iconBg: AppColors.darkSurface, iconColor: AppColors.white,      title: l.a11yContrast,    subtitle: l.a11yContrastSub,    value: settings.highContrast, onChanged: notifier.setHighContrast),
      _ToggleTile(icon: Icons.text_fields_rounded, iconBg: AppColors.catAnatomy,  iconColor: AppColors.accAnatomy, title: l.a11yLargerText,  subtitle: l.a11yLargerTextSub,  value: settings.largerText,   onChanged: notifier.setLargerText),
    ];
    final privacyRows = [
      _PrivacyRow(icon: Icons.lock_outline_rounded,    title: l.settingsAppLock,   subtitle: l.settingsAppLockSub,         onTap: toggleAppLock),
      _PrivacyRow(icon: Icons.visibility_off_outlined, title: l.settingsPrivateMode, subtitle: l.settingsPrivateModeSub,   onTap: () => notifier.setPrivateMode(!settings.privateMode)),
      _PrivacyRow(icon: Icons.nightlight_outlined,     title: l.settingsIncognito, subtitle: l.settingsIncognitoSub,       onTap: () => notifier.setIncognitoLessons(!settings.incognitoLessons)),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ConstrainedScreenWrapper(
          maxWidth: isWide ? 1000 : 600,
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.settingsTitle, style: AppTextStyles.display()
                    .copyWith(fontSize: 36, fontWeight: FontWeight.w800))
                    .animate().fadeIn(duration: 350.ms),

                const SizedBox(height: 32),

                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionHeader(l.settingsA11y.toUpperCase()),
                            const SizedBox(height: 12),
                            ...a11yTiles,
                            const SizedBox(height: 32),
                            _SectionHeader(l.settingsDisplay.toUpperCase()),
                            const SizedBox(height: 12),
                            ...displayTiles,
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionHeader(l.settingsLanguage.toUpperCase()),
                            const SizedBox(height: 12),
                            _LanguageSelector(
                              current: settings.language,
                              onChanged: notifier.setLanguage,
                            ),
                            const SizedBox(height: 32),
                            _SectionHeader(l.settingsPrivacy.toUpperCase()),
                            const SizedBox(height: 12),
                            ...privacyRows,
                            const SizedBox(height: 32),
                            _HelpCard(l: l),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(l.settingsA11y.toUpperCase()),
                      const SizedBox(height: 12),
                      ...a11yTiles,
                      ...displayTiles,
                      const SizedBox(height: 32),
                      _SectionHeader(l.settingsLanguage.toUpperCase()),
                      const SizedBox(height: 12),
                      _LanguageSelector(
                        current: settings.language,
                        onChanged: notifier.setLanguage,
                      ),
                      const SizedBox(height: 32),
                      _SectionHeader(l.settingsPrivacy.toUpperCase()),
                      const SizedBox(height: 12),
                      ...privacyRows,
                      const SizedBox(height: 32),
                      _HelpCard(l: l),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.l});
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.favorite_rounded,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: 16),
          Text(l.settingsHotline,
              style: AppTextStyles.headline().copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(l.settingsHotlineSub, style: AppTextStyles.bodyMedium().copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
            label: Text(l.settingsCall),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkSurface,
              foregroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppTextStyles.label().copyWith(
      letterSpacing: 1.2,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
    ));
  }
}

// ── Toggle tile ───────────────────────────────────────────────────────────────

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color    iconBg;
  final Color    iconColor;
  final String   title;
  final String   subtitle;
  final bool     value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink10.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.title().copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(subtitle, style: AppTextStyles.bodySmall().copyWith(color: AppColors.textSecondary)),
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
      ),
    );
  }
}

// ── Privacy row ───────────────────────────────────────────────────────────────

class _PrivacyRow extends StatelessWidget {
  const _PrivacyRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String   title;
  final String   subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink10.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.textSecondary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.title().copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(subtitle, style: AppTextStyles.bodySmall().copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Language selector ─────────────────────────────────────────────────────────

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.current, required this.onChanged});

  final String current;
  final ValueChanged<String> onChanged;

  static const _langs = [
    ('rw', 'Kinyarwanda'),
    ('en', 'English'),
    ('fr', 'Français'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink10.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: _langs.map((lang) {
          final active = lang.$1 == current;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(lang.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: active ? AppColors.darkSurface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    lang.$2,
                    style: AppTextStyles.body().copyWith(
                      fontSize: 14,
                      color: active ? AppColors.white : AppColors.textSecondary,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
