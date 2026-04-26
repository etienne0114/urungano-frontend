import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../../core/models/lesson.dart';
import '../../../core/services/api/api_client.dart';
import '../../../core/theme/app_colors.dart';

class LessonModelViewer extends StatefulWidget {
  const LessonModelViewer({
    required this.chapter,
    required this.category,
    this.activeHotspot,
    this.onHotspotTap,
    super.key,
  });

  final LessonChapter chapter;
  final LessonCategory category;
  final int? activeHotspot;
  final ValueChanged<int?>? onHotspotTap;

  @override
  State<LessonModelViewer> createState() => _LessonModelViewerState();
}

class _LessonModelViewerState extends State<LessonModelViewer> {
  static const _positions = [
    Offset(0.18, 0.20),
    Offset(0.72, 0.18),
    Offset(0.15, 0.62),
    Offset(0.70, 0.60),
    Offset(0.42, 0.78),
    Offset(0.55, 0.35),
  ];

  static const Map<LessonCategory, String> _defaultModelPaths = {
    LessonCategory.menstrualHealth: '/models/uterus.glb',
    LessonCategory.hivSti: '/models/cd4-cell.glb',
    LessonCategory.anatomy: '/models/female-anatomy.glb',
    LessonCategory.mentalHealth: '/models/female-anatomy.glb',
    LessonCategory.relationships: '/models/male-anatomy.glb',
  };

  static const double _minRadius = 1.2;
  static const double _maxRadius = 4.0;
  static const double _defaultRadius = 2.2;

  double _radius = _defaultRadius;
  bool _autoRotate = true;

  String get _cameraOrbit => '0deg 75deg ${_radius.toStringAsFixed(2)}m';

  void _zoomIn() {
    setState(() => _radius = (_radius - 0.25).clamp(_minRadius, _maxRadius));
  }

  void _zoomOut() {
    setState(() => _radius = (_radius + 0.25).clamp(_minRadius, _maxRadius));
  }

  void _resetView() {
    setState(() {
      _radius = _defaultRadius;
      _autoRotate = true;
    });
  }

  String _resolveModelUrl() {
    final chapterUrl = widget.chapter.modelUrl;
    if (chapterUrl != null &&
        chapterUrl.isNotEmpty &&
        widget.chapter.modelReady) {
      return _resolveWithServerOrigin(chapterUrl);
    }

    final localFallback = _defaultModelPaths[widget.category];
    if (localFallback != null) return localFallback;

    return '/models/uterus.glb';
  }

  String _resolveWithServerOrigin(String url) {
    if (url.startsWith('http')) return url;
    final apiUrl = Uri.parse(ApiClient.instance.baseUrl);
    final serverOrigin = '${apiUrl.scheme}://${apiUrl.authority}';
    return '$serverOrigin$url';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final modelUrl = _resolveModelUrl();

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: [
            ModelViewer(
              key: ValueKey(
                '${modelUrl}_${widget.chapter.id}_${_cameraOrbit}_${_autoRotate ? "auto" : "manual"}',
              ),
              src: modelUrl,
              alt: widget.chapter.title,
              cameraControls: true,
              autoRotate: _autoRotate && widget.activeHotspot == null,
              disableZoom: false,
              cameraOrbit: _cameraOrbit,
              minCameraOrbit: 'auto auto ${_minRadius.toStringAsFixed(1)}m',
              maxCameraOrbit: 'auto auto ${_maxRadius.toStringAsFixed(1)}m',
              backgroundColor: Colors.transparent,
              loading: Loading.eager,
              ar: true,
              arModes: const ['scene-viewer', 'webxr', 'quick-look'],
            ),
            ...widget.chapter.hotspots.asMap().entries.map((entry) {
              final idx = entry.key;
              final hotspot = entry.value;
              final pos = _positions[idx % _positions.length];
              final active = widget.activeHotspot == idx;

              return Positioned(
                left: w * pos.dx - 16,
                top: h * pos.dy - 16,
                child: _HotspotCircle(
                  number: hotspot.number,
                  active: active,
                  accentColor: widget.category.accentColor,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onHotspotTap?.call(active ? null : idx);
                  },
                ),
              );
            }),
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: [
                  _ControlButton(
                    icon: _autoRotate ? Icons.sync_disabled : Icons.sync,
                    onTap: () => setState(() => _autoRotate = !_autoRotate),
                    tooltip: _autoRotate
                        ? l.lessonAutoRotateStop
                        : l.lessonAutoRotateStart,
                  ),
                  const SizedBox(width: 8),
                  _ControlButton(
                    icon: Icons.zoom_in_rounded,
                    onTap: _zoomIn,
                    tooltip: l.lessonZoomIn,
                  ),
                  const SizedBox(width: 8),
                  _ControlButton(
                    icon: Icons.zoom_out_rounded,
                    onTap: _zoomOut,
                    tooltip: l.lessonZoomOut,
                  ),
                  const SizedBox(width: 8),
                  _ControlButton(
                    icon: Icons.refresh_rounded,
                    onTap: _resetView,
                    tooltip: l.lessonResetView,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

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

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
          ),
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
