import 'package:flutter/material.dart';
import '../../../core/models/user_progress.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Single row in the journey timeline: coloured dot + description + timestamp.
class JourneyEventTile extends StatelessWidget {
  const JourneyEventTile({required this.event, super.key});

  final JourneyEvent event;

  Color _dotColor() {
    switch (event.type) {
      case 'completed': return AppColors.dotCompleted;
      case 'quiz':      return AppColors.dotQuiz;
      case 'started':   return AppColors.dotStarted;
      default:          return AppColors.dotSetup;
    }
  }

  IconData _icon() {
    switch (event.type) {
      case 'completed': return Icons.check_circle_rounded;
      case 'quiz':      return Icons.quiz_rounded;
      case 'started':   return Icons.play_circle_rounded;
      default:          return Icons.settings_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline dot
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _dotColor().withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon(), color: _dotColor(), size: 14),
            ),
          ],
        ),

        const SizedBox(width: 12),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.description,
                style: AppTextStyles.body().copyWith(fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                event.detail,
                style: AppTextStyles.caption(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Timestamp
        Text(
          _timeAgo(event.timestamp),
          style: AppTextStyles.caption(),
        ),
      ],
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0)    return '${diff.inDays}d ago';
    if (diff.inHours > 0)   return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}
