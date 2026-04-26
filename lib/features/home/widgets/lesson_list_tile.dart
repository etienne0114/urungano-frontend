import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/lesson.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/category_tag.dart';
import '../../../core/widgets/progress_indicator_bar.dart';

class LessonListTile extends StatelessWidget {
  const LessonListTile({
    required this.lesson,
    required this.progress,
    required this.completed,
    super.key,
  });

  final Lesson lesson;
  final double progress; // 0.0–1.0
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return GestureDetector(
      onTap: () => context.go('/lesson/${lesson.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // ── Emoji icon ──────────────────────────────────
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: lesson.category.tileColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Text(
                  lesson.category.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ── Title + category + progress ─────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryTag(category: lesson.category),
                  const SizedBox(height: 2),
                  Text(
                    lesson.titleFor(langCode),
                    style: AppTextStyles.title().copyWith(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (progress > 0) ...[
                    const SizedBox(height: 6),
                    ProgressIndicatorBar(
                      value: progress,
                      color: lesson.category.accentColor,
                      backgroundColor:
                          lesson.category.accentColor.withValues(alpha: 0.15),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── Checkmark or chevron ────────────────────────
            if (completed)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 22,
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
