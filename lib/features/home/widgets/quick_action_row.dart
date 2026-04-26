import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/progress_provider.dart';

class QuickActionRow extends ConsumerWidget {
  const QuickActionRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final progress = ref.watch(progressProvider);
    final streak = progress?.dayStreak ?? 0;

    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            backgroundColor: AppColors.streakBg,
            icon: Icons.local_fire_department_rounded,
            iconColor: const Color(0xFFD97B3A),
            label: l.homeStreakDays(streak),
            sublabel: l.homeStreakEncouragement,
            onTap: () => _showStreakSheet(context, l, streak),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            backgroundColor: AppColors.gestureBg,
            icon: Icons.waving_hand_rounded,
            iconColor: AppColors.primary,
            label: l.gestureTitle,
            sublabel: l.homeGestureSub,
            onTap: () => context.go('/gesture'),
          ),
        ),
      ],
    );
  }
}

void _showStreakSheet(
    BuildContext context, AppLocalizations l, int streak) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text('🔥', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            l.homeStreakDays(streak),
            style: AppTextStyles.display()
                .copyWith(fontSize: 28, color: const Color(0xFFD97B3A)),
          ),
          const SizedBox(height: 8),
          Text(
            l.homeStreakEncouragement,
            style: AppTextStyles.body()
                .copyWith(color: AppColors.textSecondary, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/profile');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(l.profileTitle,
                  style: AppTextStyles.button()
                      .copyWith(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.title()),
            Text(sublabel,
                style: AppTextStyles.bodySmall().copyWith(
                  color: AppColors.textSecondary,
                )),
          ],
        ),
      ),
    );
  }
}
