import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urungano/l10n/app_localizations.dart';
import 'package:urungano/core/services/api/community_service.dart';
import 'package:urungano/core/providers/community_provider.dart';
import 'package:urungano/core/providers/settings_provider.dart';
import 'package:urungano/core/theme/app_colors.dart';
import 'package:urungano/core/theme/app_text_styles.dart';

class CirclesTab extends ConsumerWidget {
  const CirclesTab({
    this.onCircleSelected,
    this.selectedCircleId,
    this.isSidePanel = false,
    super.key,
  });

  final Function(String)? onCircleSelected;
  final String? selectedCircleId;
  final bool isSidePanel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final circlesAsync = ref.watch(circlesProvider);
    final settings = ref.watch(settingsProvider);
    final scale = settings.largerText ? 1.18 : 1.0;

    return circlesAsync.when(
      data: (circles) => ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: isSidePanel ? 16 : 20,
          vertical: 12,
        ),
        itemCount: circles.length,
        itemBuilder: (context, i) {
          final circle = circles[i];
          final active = selectedCircleId == circle.slug;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CircleCard(
              circle: circle,
              active: active,
              scale: scale,
              timeAgoLabel: l.communityTimeAgoMin(1),
              onTap: () => onCircleSelected?.call(circle.slug),
            )
                .animate(delay: (i * 50).ms)
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.05, end: 0),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded,
                color: AppColors.primary.withValues(alpha: 0.5), size: 48),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l.communityLoadErrorCircles,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium().copyWith(
                  color: AppColors.ink60,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(circlesProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleCard extends StatelessWidget {
  const _CircleCard({
    required this.circle,
    this.active = false,
    required this.scale,
    required this.timeAgoLabel,
    this.onTap,
  });

  final CircleDto circle;
  final bool active;
  final double scale;
  final String timeAgoLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Parse colors
    final bgColor = Color(
        int.parse('FF${circle.bgColor.replaceFirst('#', '')}', radix: 16));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: active ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? AppColors.divider2 : Colors.transparent,
          ),
          boxShadow: [
            if (active)
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            // Emoji container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(circle.emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(circle.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.title(scaleFactor: scale)
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w800)),
                      ),
                      if (circle.onlineCount > 0) ...[
                        const SizedBox(width: 8),
                        Text('· ${circle.onlineCount}',
                            style: AppTextStyles.label(scaleFactor: scale)
                                .copyWith(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(circle.topic.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.label(scaleFactor: scale).copyWith(
                          fontSize: 9,
                          color: AppColors.ink60,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(circle.moderator,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption(scaleFactor: scale)
                                .copyWith(
                                    fontSize: 11,
                                    color: AppColors.sage,
                                    fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle_rounded,
                          size: 10, color: AppColors.sage),
                      const SizedBox(width: 4),
                      Text(timeAgoLabel,
                          style: AppTextStyles.caption(scaleFactor: scale)
                              .copyWith(fontSize: 11, color: AppColors.ink40)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: AppColors.divider2),
          ],
        ),
      ),
    );
  }
}
