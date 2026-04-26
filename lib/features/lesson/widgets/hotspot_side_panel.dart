import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/models/lesson.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Slide-in panel that shows the title and description of the active hotspot.
/// Animates in/out based on [hotspot] being non-null.
class HotspotSidePanel extends StatelessWidget {
  const HotspotSidePanel({
    required this.hotspot,
    required this.accentColor,
    required this.onClose,
    super.key,
  });

  final Hotspot? hotspot;
  final Color accentColor;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    if (hotspot == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${hotspot!.number}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Title + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotspot!.title,
                  style: AppTextStyles.title().copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  hotspot!.description,
                  style: AppTextStyles.bodySmall(),
                ),
              ],
            ),
          ),

          // Close button
          GestureDetector(
            onTap: onClose,
            child: const Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 220.ms)
        .slideY(begin: 0.15, end: 0, duration: 220.ms, curve: Curves.easeOut);
  }
}
