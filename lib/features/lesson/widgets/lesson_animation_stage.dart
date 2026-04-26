import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lesson_animation_primitives.dart';
import 'scenes/menstrual_lesson.dart';
import 'scenes/hiv_lesson.dart';
import 'scenes/anatomy_lesson.dart';

// ── Lesson catalogue ──────────────────────────────────────────────────────────
class AnimatedLesson {
  const AnimatedLesson({
    required this.id,
    required this.label,
    required this.topic,
    required this.accentColor,
    required this.buildScene,
  });
  final String id;
  final String label;
  final String topic;
  final Color accentColor;
  final Widget Function(double t) buildScene;
}

final kAnimatedLessons = [
  AnimatedLesson(
    id: 'your_cycle',
    label: 'Your cycle',
    topic: 'Menstrual health',
    accentColor: kRose,
    buildScene: (t) => MenstrualLesson(t: t),
  ),
  AnimatedLesson(
    id: 'hiv_prevention',
    label: 'HIV',
    topic: 'HIV & prevention',
    accentColor: kSage,
    buildScene: (t) => HIVLesson(t: t),
  ),
  AnimatedLesson(
    id: 'anatomy_101',
    label: 'Anatomy',
    topic: 'Know your body',
    accentColor: kPeach,
    buildScene: (t) => AnatomyLesson(t: t),
  ),
];

// ── Main stage widget ─────────────────────────────────────────────────────────
class LessonAnimationPlayer extends StatefulWidget {
  /// If [lessonId] matches a known animated lesson, that lesson is shown.
  /// Otherwise the tab bar lets the user choose.
  const LessonAnimationPlayer({this.lessonId, super.key});
  final String? lessonId;

  @override
  State<LessonAnimationPlayer> createState() => _LessonAnimationPlayerState();
}

class _LessonAnimationPlayerState extends State<LessonAnimationPlayer>
    with SingleTickerProviderStateMixin {
  static const double _duration = 28.0; // seconds per lesson

  late AnimationController _ctrl;
  int _activeIndex = 0;
  bool _playing = true;

  @override
  void initState() {
    super.initState();
    // Find the lesson matching lessonId
    if (widget.lessonId != null) {
      final idx = kAnimatedLessons.indexWhere((l) => l.id == widget.lessonId);
      if (idx >= 0) _activeIndex = idx;
    }
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28), // matches _duration
    )..addListener(() => setState(() {}));
    _ctrl.repeat(); // auto-play + loop
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double get _t => _ctrl.value * _duration;

  void _seekFraction(double frac) {
    _ctrl.value = frac.clamp(0.0, 1.0);
    if (_playing) {
      _ctrl.forward(from: _ctrl.value);
      _ctrl.repeat();
    }
  }

  void _togglePlay() {
    setState(() => _playing = !_playing);
    if (_playing) {
      _ctrl.repeat();
    } else {
      _ctrl.stop();
    }
  }

  void _switchLesson(int idx) {
    setState(() => _activeIndex = idx);
    _ctrl.reset();
    if (_playing) _ctrl.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = kAnimatedLessons[_activeIndex];
    return Focus(
      autofocus: true,
      onKeyEvent: (_, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        if (event.logicalKey == LogicalKeyboardKey.space) {
          _togglePlay();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _seekFraction(_ctrl.value - 0.1 / _duration);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _seekFraction(_ctrl.value + 0.1 / _duration);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab bar
          _TabBar(
            lessons: kAnimatedLessons,
            activeIndex: _activeIndex,
            onSelect: _switchLesson,
          ),
          const SizedBox(height: 12),
          // Stage
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1280 / 720,
              child: LayoutBuilder(builder: (context, box) {
                final scaleX = box.maxWidth / 1280;
                final scaleY = box.maxHeight / 720;
                final scale = scaleX < scaleY ? scaleX : scaleY;
                return ColoredBox(
                  color: Colors.black,
                  child: Center(
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 1280,
                        height: 720,
                        child: Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            lesson.buildScene(_t),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          // Playback bar
          _PlaybackBar(
            t: _t,
            duration: _duration,
            playing: _playing,
            onPlayPause: _togglePlay,
            onSeek: (frac) => _seekFraction(frac),
            onReset: () => _seekFraction(0),
          ),
          const SizedBox(height: 16),
          // Info grid
          _InfoGrid(lesson: lesson),
        ],
      ),
    );
  }
}

// ── Tab bar ───────────────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.lessons,
    required this.activeIndex,
    required this.onSelect,
  });

  final List<AnimatedLesson> lessons;
  final int activeIndex;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(lessons.length, (i) {
          final active = i == activeIndex;
          final l = lessons[i];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: active ? kRose : Colors.transparent,
                  border: Border.all(
                    color: active ? kRose : Colors.white.withValues(alpha: 0.15),
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        (i + 1).toString().padLeft(2, '0'),
                        style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: active
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '· 28s',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.5)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Playback bar ──────────────────────────────────────────────────────────────
class _PlaybackBar extends StatelessWidget {
  const _PlaybackBar({
    required this.t,
    required this.duration,
    required this.playing,
    required this.onPlayPause,
    required this.onSeek,
    required this.onReset,
  });

  final double t;
  final double duration;
  final bool playing;
  final VoidCallback onPlayPause;
  final void Function(double frac) onSeek;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final pct = duration > 0 ? (t / duration).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xEB141414),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          // Reset
          _BarButton(
            onTap: onReset,
            child: const Icon(Icons.skip_previous_rounded,
                size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          // Play/Pause
          _BarButton(
            onTap: onPlayPause,
            child: Icon(
              playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          // Current time
          SizedBox(
            width: 60,
            child: Text(
              _fmt(t),
              style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()]),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          // Scrub track
          Expanded(
            child: GestureDetector(
              onTapDown: (d) {
                final box = context.findRenderObject() as RenderBox?;
                if (box != null) {
                  // approximate track width (full width minus fixed elements)
                  final trackWidth = box.size.width - 180;
                  final dx = d.localPosition.dx - 150;
                  onSeek((dx / trackWidth).clamp(0.0, 1.0));
                }
              },
              onHorizontalDragUpdate: (d) {
                final box = context.findRenderObject() as RenderBox?;
                if (box != null) {
                  final trackWidth = box.size.width - 180;
                  final dx = d.localPosition.dx - 150;
                  onSeek((dx / trackWidth).clamp(0.0, 1.0));
                }
              },
              child: SizedBox(
                height: 20,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Track background
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Fill
                    FractionallySizedBox(
                      widthFactor: pct,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: kRose,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Thumb
                    Positioned(
                      left: pct * (MediaQuery.sizeOf(context).width - 300) - 6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: 4,
                                offset: Offset(0, 2))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Duration
          SizedBox(
            width: 54,
            child: Text(
              _fmt(duration),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.55),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double t) {
    final total = t.clamp(0.0, double.infinity);
    final m = total ~/ 60;
    final s = (total % 60).floor();
    final cs = ((total * 100) % 100).floor();
    return '${m}:${s.toString().padLeft(2, '0')}.${cs.toString().padLeft(2, '0')}';
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      );
}

// ── Info grid ─────────────────────────────────────────────────────────────────
class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.lesson});
  final AnimatedLesson lesson;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _InfoCard(label: 'Topic', value: lesson.topic,
          meta: 'Rwanda Education Board SRH curriculum'),
      const _InfoCard(label: 'Format', value: '3D animated · 1280×720',
          meta: 'CustomPaint · 60 fps · WCAG-AA captions'),
      const _InfoCard(label: 'Languages',
          value: 'Kinyarwanda · English · Français',
          meta: 'Narration recorded by native speakers'),
    ];
    return Row(
      children: cards
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: c,
                ),
              ))
          .toList(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard(
      {required this.label, required this.value, required this.meta});

  final String label;
  final String value;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: kPeach.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: kCream)),
          const SizedBox(height: 4),
          Text(meta,
              style: TextStyle(
                  fontSize: 11,
                  color: kCream.withValues(alpha: 0.5))),
        ],
      ),
    );
  }
}

// ── HUD (used by each lesson scene) ──────────────────────────────────────────
class LessonHUD extends StatelessWidget {
  const LessonHUD({
    required this.title,
    required this.sub,
    required this.caption,
    required this.t,
    this.total = 28.0,
    this.accent = kRose,
    super.key,
  });

  final String title;
  final String sub;
  final String caption;
  final double t;
  final double total;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Brand top-left
        Positioned(
          top: 24,
          left: 28,
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [kPeach, kRose],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text('U',
                    style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Urungano',
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: kPlum)),
                  Text('3D Lesson',
                      style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1,
                          color: kInk60)),
                ],
              ),
            ],
          ),
        ),

        // Title top-right
        Positioned(
          top: 24,
          right: 28,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(sub,
                  style: const TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      color: kInk60,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(title,
                  style: const TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: kPlum,
                      letterSpacing: -0.5)),
            ],
          ),
        ),

        // Chapter progress dots
        Positioned(
          top: 84,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final seg = total / 4;
              final segT = ((t - i * seg) / seg).clamp(0.0, 1.0);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: SizedBox(
                  width: 60,
                  height: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: segT,
                      backgroundColor: kPlum.withValues(alpha: 0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(kPlum),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Caption strip
        Positioned(
          bottom: 24,
          left: 28,
          right: 28,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xD92A1A1F),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.volume_up_rounded,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    caption,
                    style: const TextStyle(
                        fontSize: 14,
                        color: kCream,
                        height: 1.45,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${t.toStringAsFixed(1)}s / ${total.toStringAsFixed(0)}s',
                  style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: kCream.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
