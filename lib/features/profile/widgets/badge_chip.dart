import 'package:flutter/material.dart';
import '../../../core/models/badge_definition.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Pill chip showing a badge emoji + name.
/// Greyed out when [earned] is false.
class BadgeChip extends StatelessWidget {
  const BadgeChip({
    required this.badge,
    required this.earned,
    super.key,
  });

  final BadgeDefinition badge;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: badge.description,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: earned ? AppColors.white : AppColors.divider,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: earned ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              badge.emoji,
              style: TextStyle(
                fontSize: 16,
                color: earned ? null : AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              badge.title,
              style: AppTextStyles.label().copyWith(
                color: earned ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
