import 'package:flutter/material.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class _GestureItem {
  const _GestureItem({
    required this.icon,
    required this.label,
    required this.action,
  });
  final IconData icon;
  final String label;
  final String action;
}

/// 6-tile grid showing gesture icon + action label.
class GestureMapGrid extends StatelessWidget {
  const GestureMapGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = [
      _GestureItem(
          icon: Icons.swipe_right_rounded,
          label: l.gestureSwipeRight,
          action: l.gestureActionNextChapter),
      _GestureItem(
          icon: Icons.swipe_left_rounded,
          label: l.gestureSwipeLeft,
          action: l.gestureActionPrevChapter),
      _GestureItem(
          icon: Icons.swipe_up_rounded,
          label: l.gestureSwipeUp,
          action: l.gestureActionScroll),
      _GestureItem(
          icon: Icons.back_hand_outlined,
          label: l.gestureOpenPalm,
          action: l.gestureActionPauseNarration),
      _GestureItem(
          icon: Icons.thumb_up_outlined,
          label: l.gestureThumbsUp,
          action: l.gestureActionMarkUnderstood),
      _GestureItem(
          icon: Icons.pinch_outlined,
          label: l.gesturePinchLabel,
          action: l.gestureActionZoomModel),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _GestureTile(item: items[i]),
    );
  }
}

class _GestureTile extends StatelessWidget {
  const _GestureTile({required this.item});

  final _GestureItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(item.icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.title().copyWith(fontSize: 13),
                ),
                Text(
                  item.action,
                  style: AppTextStyles.caption(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
