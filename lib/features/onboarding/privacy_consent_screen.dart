import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/constrained_screen_wrapper.dart';
import '../../core/widgets/primary_button.dart';

class PrivacyConsentScreen extends ConsumerStatefulWidget {
  const PrivacyConsentScreen({super.key});

  @override
  ConsumerState<PrivacyConsentScreen> createState() =>
      _PrivacyConsentScreenState();
}

class _PrivacyConsentScreenState extends ConsumerState<PrivacyConsentScreen> {
  bool _agreed = false;

  void _confirm() => context.go('/pin-setup');

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final points = [
      _PrivacyPoint(
        icon: Icons.lock_rounded,
        title: l.consentPoint1Title,
        body: l.consentPoint1Body,
      ),
      _PrivacyPoint(
        icon: Icons.visibility_off_rounded,
        title: l.consentPoint2Title,
        body: l.consentPoint2Body,
      ),
      _PrivacyPoint(
        icon: Icons.shield_rounded,
        title: l.consentPoint3Title,
        body: l.consentPoint3Body,
      ),
      _PrivacyPoint(
        icon: Icons.delete_outline_rounded,
        title: l.consentPoint4Title,
        body: l.consentPoint4Body,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ConstrainedScreenWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),

              Text(l.consentTitle,
                style: AppTextStyles.display().copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ))
                  .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 12),

              Text(l.consentBody,
                style: AppTextStyles.bodyMedium().copyWith(
                  color: AppColors.textSecondary,
                ))
                  .animate(delay: 150.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 32),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ...List.generate(points.length, (i) {
                        return _PrivacyPointTile(
                          point: points[i],
                          delay: 200 + i * 80,
                        );
                      }),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: () => setState(() => _agreed = !_agreed),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: _agreed ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _agreed ? AppColors.primary : AppColors.divider,
                            width: 2,
                          ),
                        ),
                        child: _agreed
                            ? const Icon(Icons.check_rounded,
                                color: AppColors.white, size: 18)
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          l.consentAgree,
                          style: AppTextStyles.title().copyWith(
                            fontSize: 15,
                            color: _agreed ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: 500.ms).fadeIn(duration: 350.ms),

              const SizedBox(height: 24),

              PrimaryButton(
                label: l.continue_,
                onPressed: _agreed ? _confirm : null,
                icon: Icons.arrow_forward_rounded,
              ).animate(delay: 600.ms).fadeIn(duration: 350.ms),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyPoint {
  const _PrivacyPoint({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;
}

class _PrivacyPointTile extends StatelessWidget {
  const _PrivacyPointTile({required this.point, required this.delay});

  final _PrivacyPoint point;
  final int delay;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(point.icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(point.title, style: AppTextStyles.title().copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  )),
                  const SizedBox(height: 4),
                  Text(point.body,
                    style: AppTextStyles.bodySmall().copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    )),
                ],
              ),
            ),
          ],
        ),
      ).animate(delay: Duration(milliseconds: delay))
       .fadeIn(duration: 350.ms)
       .slideY(begin: 0.1, end: 0),
    );
  }
}
