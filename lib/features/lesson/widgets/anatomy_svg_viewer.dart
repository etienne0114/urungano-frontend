import 'package:flutter/material.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../../core/models/lesson.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Offline anatomical diagram placeholder.
/// Renders the category emoji as a large centrepiece with tappable
/// numbered hotspot circles positioned around it.
/// When a real SVG asset is added, swap the [_DiagramPlaceholder]
/// for an SvgPicture widget — the hotspot overlay layer stays the same.
class AnatomySvgViewer extends StatelessWidget {
  const AnatomySvgViewer({
    required this.chapter,
    required this.category,
    required this.activeHotspot,
    required this.onHotspotTap,
    super.key,
  });

  final LessonChapter chapter;
  final LessonCategory category;
  final int? activeHotspot; // index into chapter.hotspots, or null
  final ValueChanged<int?> onHotspotTap; // null = deselect

  // Fixed positions for up to 6 hotspots (left%, top% of container)
  static const _positions = [
    Offset(0.18, 0.20),
    Offset(0.72, 0.18),
    Offset(0.15, 0.62),
    Offset(0.70, 0.60),
    Offset(0.42, 0.78),
    Offset(0.55, 0.35),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: [
            // ── Diagram background ──────────────────────────
            _DiagramPlaceholder(category: category),

            // ── Hotspot circles ─────────────────────────────
            ...chapter.hotspots.asMap().entries.map((entry) {
              final idx     = entry.key;
              final hotspot = entry.value;
              final pos     = _positions[idx % _positions.length];
              final active  = activeHotspot == idx;

              return Positioned(
                left: w * pos.dx - 16,
                top:  h * pos.dy - 16,
                child: _HotspotCircle(
                  number: hotspot.number,
                  active: active,
                  accentColor: category.accentColor,
                  onTap: () => onHotspotTap(active ? null : idx),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

// ── Diagram placeholder ───────────────────────────────────────────────────────

class _DiagramPlaceholder extends StatelessWidget {
  const _DiagramPlaceholder({required this.category});

  final LessonCategory category;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: category.tileColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category.emoji,
              style: const TextStyle(fontSize: 72),
            ),
            const SizedBox(height: 8),
            Text(
              l.lesson3DModel,
              style: AppTextStyles.label().copyWith(
                color: category.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hotspot circle ────────────────────────────────────────────────────────────

class _HotspotCircle extends StatelessWidget {
  const _HotspotCircle({
    required this.number,
    required this.active,
    required this.accentColor,
    required this.onTap,
  });

  final int number;
  final bool active;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: active ? accentColor : AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: accentColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: active ? 0.4 : 0.15),
              blurRadius: active ? 10 : 4,
              spreadRadius: active ? 2 : 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: active ? AppColors.white : accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
