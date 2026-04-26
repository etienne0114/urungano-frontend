import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../../core/models/quiz_question.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Bottom sheet shown after quiz submission.
/// Shows accuracy ring, score, per-question breakdown, and a CTA.
class QuizResultSheet extends StatelessWidget {
  const QuizResultSheet({
    required this.result,
    super.key,
  });

  final QuizResult result;

  static Future<void> show(BuildContext context, QuizResult result) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuizResultSheet(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final pct = (result.accuracy * 100).round();

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // ── Score ring ──────────────────────────────────
              SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(
                  painter: _RingPainter(value: result.accuracy),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$pct%',
                          style: AppTextStyles.headline(),
                        ),
                        Text(
                          l.profileAccuracy.toLowerCase(),
                          style: AppTextStyles.caption(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                _headline(pct, l),
                style: AppTextStyles.title(),
              ),
              const SizedBox(height: 4),
              Text(
                l.quizResultScore(result.correctAnswers, result.totalQuestions),
                style: AppTextStyles.bodySmall(),
              ),

              const SizedBox(height: 20),

              // ── Breakdown list ──────────────────────────────
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: result.breakdown.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final item = result.breakdown[i];
                    return _BreakdownTile(item: item);
                  },
                ),
              ),

              // ── CTA ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: SafeArea(
                  top: false,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go('/home');
                    },
                    child: Text(
                      l.quizGoHome,
                      style: AppTextStyles.button()
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _headline(int pct, AppLocalizations l) {
    if (pct == 100) return l.quizHeadlinePerfect;
    if (pct >= 80)  return l.quizHeadlineGreat;
    if (pct >= 60)  return l.quizHeadlineKeepLearning;
    return l.quizHeadlineTryAgain;
  }
}

// ── Ring painter ──────────────────────────────────────────────────────────────

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.value});

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const stroke = 8.0;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.primaryLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}

// ── Breakdown tile ────────────────────────────────────────────────────────────

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile({required this.item});

  final QuestionBreakdown item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isCorrect
            ? const Color(0xFFD4EEE8)
            : const Color(0xFFF5DDD9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                item.isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: 18,
                color: item.isCorrect
                    ? AppColors.accHivSti
                    : AppColors.primaryDark,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.questionText,
                  style: AppTextStyles.body().copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
          if (!item.isCorrect) ...[
            const SizedBox(height: 6),
            Text(
              item.explanation,
              style: AppTextStyles.bodySmall().copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
