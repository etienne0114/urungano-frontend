import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/lesson.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/widgets/progress_indicator_bar.dart';

class ContinueLearningCard extends ConsumerWidget {
  const ContinueLearningCard({required this.lesson, super.key});

  final Lesson lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final langCode = Localizations.localeOf(context).languageCode;
    final progress = ref.watch(progressProvider);
    final pct = progress?.lessonProgress[lesson.id] ?? 0.0;
    final chapter = progress?.lessonCurrentChapter[lesson.id] ?? 0;

    return GestureDetector(
      onTap: () => context.go('/lesson/${lesson.id}'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: lesson.category.tileColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(lesson.category.emoji,
                    style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text(l.homeContinue,
                    style: AppTextStyles.label().copyWith(
                      color: lesson.category.accentColor,
                    )),
                const Spacer(),
                Text('${(pct * 100).round()}%',
                    style: AppTextStyles.label().copyWith(
                      color: lesson.category.accentColor,
                    )),
              ],
            ),
            const SizedBox(height: 10),
            Text(lesson.titleFor(langCode),
                style: AppTextStyles.title(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Text(l.lessonChapterProgress(chapter + 1, lesson.chapters.length),
                style: AppTextStyles.bodySmall().copyWith(
                  color: AppColors.textSecondary,
                )),
            const SizedBox(height: 12),
            ProgressIndicatorBar(
              value: pct,
              color: lesson.category.accentColor,
              backgroundColor:
                  lesson.category.accentColor.withValues(alpha: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}
