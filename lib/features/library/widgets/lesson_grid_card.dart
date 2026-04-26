import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/lesson.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LessonGridCard extends StatelessWidget {
  const LessonGridCard({
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
        decoration: BoxDecoration(
          color: lesson.category.tileColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // ── Content ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emoji
                  Text(
                    lesson.category.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),

                  const Spacer(),

                  // Category label
                  Text(
                    lesson.category.localizedLabel(langCode),
                    style: AppTextStyles.label().copyWith(
                      color: lesson.category.accentColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Title
                  Text(
                    lesson.titleFor(langCode),
                    style: AppTextStyles.title().copyWith(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Chapter count + duration
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_outlined,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.chapters.length} ch',
                        style: AppTextStyles.caption(),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.durationMinutes}m',
                        style: AppTextStyles.caption(),
                      ),
                    ],
                  ),

                  if (progress > 0) ...[
                    const SizedBox(height: 10),
                    _ProgressArc(
                      value: progress,
                      color: lesson.category.accentColor,
                    ),
                  ],
                ],
              ),
            ),

            // ── Completed badge ───────────────────────────────
            if (completed)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Thin arc progress indicator drawn with CustomPaint.
class _ProgressArc extends StatelessWidget {
  const _ProgressArc({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CustomPaint(
            painter: _ArcPainter(value: value, color: color),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${(value * 100).round()}%',
          style: AppTextStyles.caption().copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    const strokeWidth = 3.0;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    const startAngle = -1.5707963267948966; // -π/2 (top)
    final sweepAngle = 2 * 3.141592653589793 * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.value != value || old.color != color;
}
