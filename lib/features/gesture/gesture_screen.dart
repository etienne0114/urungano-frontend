import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class GestureScreen extends ConsumerWidget {
  const GestureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final enabled = settings.gestureControl;
    final isWide = MediaQuery.sizeOf(context).width >= 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isWide
            ? _WideLayout(enabled: enabled, notifier: notifier)
            : _NarrowLayout(enabled: enabled, notifier: notifier),
      ),
    );
  }
}

// ── Wide layout ───────────────────────────────────────────────────────────────

class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.enabled, required this.notifier});

  final bool enabled;
  final dynamic notifier;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                onPressed: () => context.go('/home'),
              ),
              Text(l.gestureCalibration,
                  style: AppTextStyles.label().copyWith(fontSize: 9)),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.gestureTitle,
                      style: AppTextStyles.display().copyWith(fontSize: 32))
                  .animate()
                  .fadeIn(duration: 350.ms),
              // Status indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: enabled
                      ? AppColors.accHivSti.withValues(alpha: 0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: enabled ? AppColors.accHivSti : AppColors.divider,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color:
                            enabled ? AppColors.accHivSti : AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      enabled ? l.gestureStatusLive(29.7) : l.gestureStatusOff,
                      style: AppTextStyles.label().copyWith(
                        color:
                            enabled ? AppColors.accHivSti : AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Camera feed
                Expanded(
                  flex: 3,
                  child: _CameraFeed(enabled: enabled),
                ),
                const SizedBox(width: 20),
                // Gesture map
                SizedBox(
                  width: 300,
                  child: _GestureMapPanel(
                    enabled: enabled,
                    onToggle: (v) => notifier.setGestureControl(v),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Narrow layout ─────────────────────────────────────────────────────────────

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({required this.enabled, required this.notifier});

  final bool enabled;
  final dynamic notifier;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                onPressed: () => context.go('/home'),
              ),
              Text(l.gestureTitle,
                      style: AppTextStyles.headline().copyWith(fontSize: 22))
                  .animate()
                  .fadeIn(duration: 350.ms),
            ],
          ),
          const SizedBox(height: 16),
          _CameraFeed(enabled: enabled),
          const SizedBox(height: 16),
          _GestureMapPanel(
            enabled: enabled,
            onToggle: (v) => notifier.setGestureControl(v),
          ),
        ],
      ),
    );
  }
}

// ── Camera feed ───────────────────────────────────────────────────────────────

class _CameraFeed extends StatelessWidget {
  const _CameraFeed({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Corner brackets
          ..._corners(),

          // Hand skeleton (when enabled)
          if (enabled) const Center(child: _HandSkeleton()),

          // Stats overlay (when enabled)
          if (enabled) ...[
            Positioned(
              top: 14,
              left: 14,
              child: _OverlayText(
                '${l.gestureFps}: 29.7\n${l.gestureConfidence}: 0.94\n${l.gestureOverlayModel}: HANDLM v2.4',
              ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: _OverlayText(
                '${l.gestureOverlayLandmarks}: 21\n${l.gestureOverlayHand}: ${l.gestureOverlayHandRight}\n${l.gestureOverlayLatency}: 34ms',
                align: TextAlign.right,
              ),
            ),
          ],

          // Detected gesture pill
          if (enabled)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(l.gestureDetected('point'),
                          style: AppTextStyles.body().copyWith(fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),

          // Disabled state
          if (!enabled)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.videocam_off_rounded,
                      color: AppColors.textMuted, size: 36),
                  const SizedBox(height: 12),
                  Text(l.gestureStatusOff,
                      style: AppTextStyles.body()
                          .copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  Text(l.gestureEnableHint, style: AppTextStyles.caption()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _corners() {
    const size = 20.0;
    const thick = 2.0;
    const color = Color(0xFF444444);
    return [
      const Positioned(
          top: 12,
          left: 12,
          child: _Corner(
              size: size, thick: thick, color: color, top: true, left: true)),
      const Positioned(
          top: 12,
          right: 12,
          child: _Corner(
              size: size, thick: thick, color: color, top: true, left: false)),
      const Positioned(
          bottom: 12,
          left: 12,
          child: _Corner(
              size: size, thick: thick, color: color, top: false, left: true)),
      const Positioned(
          bottom: 12,
          right: 12,
          child: _Corner(
              size: size, thick: thick, color: color, top: false, left: false)),
    ];
  }
}

class _Corner extends StatelessWidget {
  const _Corner({
    required this.size,
    required this.thick,
    required this.color,
    required this.top,
    required this.left,
  });

  final double size, thick;
  final Color color;
  final bool top, left;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter:
            _CornerPainter(color: color, thick: thick, top: top, left: left),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  const _CornerPainter({
    required this.color,
    required this.thick,
    required this.top,
    required this.left,
  });

  final Color color;
  final double thick;
  final bool top, left;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = thick
      ..style = PaintingStyle.stroke;
    final x = left ? 0.0 : size.width;
    final y = top ? 0.0 : size.height;
    final dx = left ? size.width : -size.width;
    final dy = top ? size.height : -size.height;
    canvas.drawLine(Offset(x, y), Offset(x + dx, y), p);
    canvas.drawLine(Offset(x, y), Offset(x, y + dy), p);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}

class _OverlayText extends StatelessWidget {
  const _OverlayText(this.text, {this.align = TextAlign.left});

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 9,
        color: Color(0xFF888888),
        height: 1.6,
      ),
    );
  }
}

// ── Hand skeleton ─────────────────────────────────────────────────────────────

class _HandSkeleton extends StatelessWidget {
  const _HandSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 180,
      child: CustomPaint(painter: _HandPainter()),
    );
  }
}

class _HandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF3B9E94).withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // Simplified hand skeleton points
    final wrist = Offset(size.width * 0.5, size.height * 0.9);
    final fingers = [
      [
        Offset(size.width * 0.2, size.height * 0.5),
        Offset(size.width * 0.15, size.height * 0.3),
        Offset(size.width * 0.12, size.height * 0.15)
      ],
      [
        Offset(size.width * 0.35, size.height * 0.4),
        Offset(size.width * 0.32, size.height * 0.2),
        Offset(size.width * 0.3, size.height * 0.05)
      ],
      [
        Offset(size.width * 0.5, size.height * 0.38),
        Offset(size.width * 0.5, size.height * 0.18),
        Offset(size.width * 0.5, size.height * 0.02)
      ],
      [
        Offset(size.width * 0.65, size.height * 0.42),
        Offset(size.width * 0.68, size.height * 0.22),
        Offset(size.width * 0.7, size.height * 0.08)
      ],
      [
        Offset(size.width * 0.8, size.height * 0.55),
        Offset(size.width * 0.85, size.height * 0.4),
        Offset(size.width * 0.88, size.height * 0.28)
      ],
    ];

    for (final finger in fingers) {
      canvas.drawLine(wrist, finger[0], linePaint);
      for (int i = 0; i < finger.length - 1; i++) {
        canvas.drawLine(finger[i], finger[i + 1], linePaint);
      }
    }

    // Draw dots
    canvas.drawCircle(wrist, 5, dotPaint);
    for (final finger in fingers) {
      for (final pt in finger) {
        canvas.drawCircle(pt, 3.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_HandPainter old) => false;
}

// ── Gesture map panel ─────────────────────────────────────────────────────────

class _GestureMapPanel extends StatelessWidget {
  const _GestureMapPanel({
    required this.enabled,
    required this.onToggle,
  });

  final bool enabled;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final gestures = [
      (l.gestureOpen, l.gestureOpenSub, Icons.back_hand_outlined),
      (l.gesturePinch, l.gesturePinchSub, Icons.pinch_outlined),
      (l.gesturePoint, l.gesturePointSub, Icons.touch_app_outlined),
      (l.gestureFist, l.gestureFistSub, Icons.stop_circle_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.gestureMapTitle, style: AppTextStyles.label()),
        const SizedBox(height: 10),

        // 2×2 grid
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: gestures.asMap().entries.map((e) {
            final idx = e.key;
            final gesture = e.value;
            final active = enabled && idx == 2; // "Point" active in demo
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.primaryDark : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: active ? AppColors.primaryDark : AppColors.divider,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(gesture.$3,
                      size: 20,
                      color:
                          active ? AppColors.white : AppColors.textSecondary),
                  const Spacer(),
                  Text(gesture.$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title().copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: active ? AppColors.white : AppColors.textPrimary,
                      )),
                  const SizedBox(height: 2),
                  Text(gesture.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption().copyWith(
                        fontSize: 10,
                        color: active
                            ? AppColors.white.withValues(alpha: 0.7)
                            : AppColors.textMuted,
                      )),
                ],
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Privacy note
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.textMuted),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(l.gesturePrivacyTitle,
                      style: AppTextStyles.body()
                          .copyWith(color: AppColors.white, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l.gesturePrivacyBody,
                style: AppTextStyles.caption()
                    .copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Recalibrate + enable buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(l.gestureRecalibrate,
                    style: AppTextStyles.body().copyWith(fontSize: 13)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => onToggle(!enabled),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  enabled ? l.disable : l.enable,
                  style: AppTextStyles.button()
                      .copyWith(color: AppColors.white, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
