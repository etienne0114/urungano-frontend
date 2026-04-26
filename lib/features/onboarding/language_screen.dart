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

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  String _selected = 'rw';

  List<_Lang> _languages(AppLocalizations l) => [
    _Lang(code: 'rw', name: l.langKinyarwanda, flag: '🇷🇼', subtitle: l.greeting),
    _Lang(code: 'en', name: l.langEnglish,     flag: '🇬🇧', subtitle: l.greeting),
    _Lang(code: 'fr', name: l.langFrench,      flag: '🇫🇷', subtitle: l.greeting),
  ];

  Future<void> _confirm() async {
    await ref.read(settingsProvider.notifier).setLanguage(_selected);
    if (mounted) context.go('/accessibility-setup');
  }

  @override
  Widget build(BuildContext context) {
    final l    = AppLocalizations.of(context);
    final langs = _languages(l);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ConstrainedScreenWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),

              Text(l.chooseLang,
                style: AppTextStyles.display().copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ))
                  .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 12),

              Text(l.settingsLanguage,
                style: AppTextStyles.bodyMedium().copyWith(
                  color: AppColors.textSecondary,
                ))
                  .animate(delay: 150.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 48),

              Expanded(
                child: ListView.builder(
                  itemCount: langs.length,
                  itemBuilder: (context, i) {
                    final lang = langs[i];
                    final active = _selected == lang.code;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _LanguageTile(
                        lang: lang,
                        active: active,
                        onTap: () => setState(() => _selected = lang.code),
                      ).animate(delay: Duration(milliseconds: 200 + i * 80))
                       .fadeIn(duration: 350.ms)
                       .slideY(begin: 0.1, end: 0),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                label: l.continue_,
                onPressed: _confirm,
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

class _Lang {
  const _Lang({
    required this.code,
    required this.name,
    required this.flag,
    required this.subtitle,
  });
  final String code, name, flag, subtitle;
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.lang,
    required this.active,
    required this.onTap,
  });

  final _Lang lang;
  final bool  active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: active ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.darkSurface : AppColors.divider.withValues(alpha: 0.5),
            width: 1.5,
          ),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: active ? AppColors.white.withValues(alpha: 0.1) : AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(lang.flag, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lang.name,
                    style: AppTextStyles.title().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: active ? AppColors.white : AppColors.textPrimary,
                    )),
                  const SizedBox(height: 2),
                  Text(lang.subtitle,
                    style: AppTextStyles.bodySmall().copyWith(
                      fontSize: 14,
                      color: active
                          ? AppColors.white.withValues(alpha: 0.7)
                          : AppColors.textSecondary,
                    )),
                ],
              ),
            ),
            if (active)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
