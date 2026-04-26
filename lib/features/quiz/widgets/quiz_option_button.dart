import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Single answer option tile.
/// Before answering: tapping highlights the tile.
/// After answering: correct option turns green, wrong selection turns red.
class QuizOptionButton extends StatelessWidget {
  const QuizOptionButton({
    required this.label,
    required this.index,
    required this.selected,
    required this.answered,
    required this.isCorrect,
    required this.onTap,
    super.key,
  });

  final String label;
  final int    index;
  final bool   selected;
  final bool   answered;
  final bool   isCorrect;
  final VoidCallback onTap;

  static const _letters = ['A', 'B', 'C', 'D'];

  Color _bgColor() {
    if (!answered) return selected ? AppColors.primaryLight : AppColors.white;
    if (isCorrect) return const Color(0xFFD4EEE8);
    if (selected)  return const Color(0xFFF5DDD9);
    return AppColors.white;
  }

  Color _borderColor() {
    if (!answered) return selected ? AppColors.primary : AppColors.divider;
    if (isCorrect) return AppColors.accHivSti;
    if (selected)  return AppColors.primaryDark;
    return AppColors.divider;
  }

  Color _badgeColor() {
    if (answered && isCorrect) return AppColors.accHivSti;
    if (answered && selected)  return AppColors.primaryDark;
    if (selected)              return AppColors.primary;
    return AppColors.divider;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: answered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _bgColor(),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor(), width: 1.5),
        ),
        child: Row(
          children: [
            // Letter badge
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _badgeColor(),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _letters[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: (selected || (answered && isCorrect))
                        ? AppColors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Option text
            Expanded(
              child: Text(label, style: AppTextStyles.body()),
            ),

            // Result icon
            if (answered && isCorrect)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.accHivSti, size: 20),
            if (answered && selected && !isCorrect)
              const Icon(Icons.cancel_rounded,
                  color: AppColors.primaryDark, size: 20),
          ],
        ),
      ),
    );
  }
}
