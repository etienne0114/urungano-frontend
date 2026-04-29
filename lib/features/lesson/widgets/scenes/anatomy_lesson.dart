import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../lesson_animation_primitives.dart';
import '../lesson_animation_stage.dart';

/// Lesson 03 · Know your body · 28s
/// Scene 1  0–7s   Rotating pelvis silhouette with cutaway label reveal
/// Scene 2  7–14s  Internal anatomy — uterus, ovaries, fallopian tubes, cervix, vagina
/// Scene 3 14–21s  External anatomy — vulva diagram + clitoris internal reveal
/// Scene 4 21–28s  Vocabulary cards  RW ↔ EN ↔ FR
class AnatomyLesson extends StatelessWidget {
  const AnatomyLesson({required this.t, super.key});
  final double t;

  String get _caption {
    if (t < 7)  return 'Reproductive anatomy is more diverse than the textbook diagrams suggest. Let\'s look at the parts.';
    if (t < 14) return 'Internal anatomy: ovaries, uterus, fallopian tubes, vagina each with a specific role.';
    if (t < 21) return 'External anatomy: vulva includes labia, clitoris, and urethral opening. The clitoris is much larger than what you can see.';
    return 'Knowing the names is power. You can describe what you feel to a doctor, to a partner, to yourself.';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.4),
              radius: 1.4,
              colors: [Color(0xFFFFE9DD), Color(0xFFF8DEC4), Color(0xFFF5C6A5)],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
        ),
        AmbientField(
          t: t,
          count: 20,
          colors: [
            kRose.withValues(alpha: 0.13),
            kAmber.withValues(alpha: 0.13),
          ],
        ),

        SceneWindow(t: t, start: 0,    end: 7.3,  child: _OverviewScene(t: (t - 0).clamp(0, 7))),
        SceneWindow(t: t, start: 6.7,  end: 14.3, child: _InternalScene(t: (t - 6.7).clamp(0, 7.6))),
        SceneWindow(t: t, start: 13.7, end: 21.3, child: _ExternalScene(t: (t - 13.7).clamp(0, 7.6))),
        SceneWindow(t: t, start: 20.7, end: 28,   child: _VocabScene(t: (t - 20.7).clamp(0, 7.3))),

        LessonHUD(
          title: 'Know your body',
          sub: 'Lesson 03 · Anatomy · 28s',
          caption: _caption,
          t: t,
          accent: kPeach,
        ),
      ],
    );
  }
}

// ── Scene 1 · Overview (rotating silhouette) ──────────────────────────────────
class _OverviewScene extends StatelessWidget {
  const _OverviewScene({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    final rotY = lerp(t, [0, 5], [-25.0, 0.0], Ease.outCubic);
    const cx = 640.0;

    final labels = [
      (y: 230.0, label: 'Ovaries',  side: 'left',  delay: 1.0),
      (y: 290.0, label: 'Uterus',   side: 'right', delay: 1.7),
      (y: 350.0, label: 'Vagina',   side: 'left',  delay: 2.4),
    ];

    return Stack(
      children: [
        // Body silhouette with perspective rotation
        Positioned(
          left: cx - 200,
          top: 80,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(rotY * math.pi / 180),
            child: SizedBox(
              width: 400,
              height: 480,
              child: CustomPaint(painter: _TorsoPainter(t: t)),
            ),
          ),
        ),

        // Labels
        ...labels.map((l) {
          final op = lerp(t, [l.delay, l.delay + 0.6], [0.0, 1.0]).clamp(0.0, 1.0);
          final isLeft = l.side == 'left';
          return Positioned(
            left: isLeft ? 320 : 740,
            top: l.y,
            child: Opacity(
              opacity: op,
              child: Transform.translate(
                offset: Offset((1 - op) * (isLeft ? -20 : 20), 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLeft) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xE52A1A1F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(l.label,
                            style: const TextStyle(
                                fontFamily: 'Fraunces',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: kCream)),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 80, height: 1.5,
                          color: kPlum.withValues(alpha: 0.5)),
                      Container(
                          width: 6, height: 6,
                          decoration: const BoxDecoration(
                              color: kRose, shape: BoxShape.circle)),
                    ] else ...[
                      Container(
                          width: 6, height: 6,
                          decoration: const BoxDecoration(
                              color: kRose, shape: BoxShape.circle)),
                      Container(width: 80, height: 1.5,
                          color: kPlum.withValues(alpha: 0.5)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xE52A1A1F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(l.label,
                            style: const TextStyle(
                                fontFamily: 'Fraunces',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: kCream)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _TorsoPainter extends CustomPainter {
  const _TorsoPainter({required this.t});
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 10, size.height - 20), width: 280, height: 28),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Torso
    final torsoPath = Path()
      ..moveTo(cx, 40)
      ..quadraticBezierTo(cx - 60, 60, cx - 70, 140)
      ..quadraticBezierTo(cx - 80, 220, cx - 70, 280)
      ..quadraticBezierTo(cx - 90, 320, cx - 80, 380)
      ..quadraticBezierTo(cx - 60, 440, cx, 460)
      ..quadraticBezierTo(cx + 60, 440, cx + 80, 380)
      ..quadraticBezierTo(cx + 90, 320, cx + 70, 280)
      ..quadraticBezierTo(cx + 80, 220, cx + 70, 140)
      ..quadraticBezierTo(cx + 60, 60, cx, 40)
      ..close();

    canvas.drawPath(
      torsoPath,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.35, -0.3),
          radius: 1.3,
          colors: [Color(0xFFFFE9DD), Color(0xFFF5C6A5), Color(0xFFC8825C)],
          stops: [0.0, 0.6, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    canvas.drawPath(
      torsoPath,
      Paint()
        ..color = kPlum.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Cutaway ellipse (pelvis region)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, 280), width: 160, height: 200),
      Paint()..color = kRose.withValues(alpha: 0.12),
    );

    // Internal preview (fades in)
    final internalOp = math.min(1.0, t / 1.5);
    if (internalOp > 0) {
      canvas.saveLayer(null, Paint()..color = Color.fromARGB((internalOp * 255).round(), 255, 255, 255));

      // Uterus
      final utPath = Path()
        ..moveTo(cx - 30, 225)
        ..quadraticBezierTo(cx - 50, 265, cx - 25, 315)
        ..quadraticBezierTo(cx, 340, cx + 25, 315)
        ..quadraticBezierTo(cx + 50, 265, cx + 30, 225)
        ..quadraticBezierTo(cx + 10, 210, cx, 215)
        ..quadraticBezierTo(cx - 10, 210, cx - 30, 225)
        ..close();
      canvas.drawPath(utPath, Paint()..color = kRose.withValues(alpha: 0.85));

      // Ovaries
      canvas.drawOval(Rect.fromCenter(
          center: Offset(cx - 45, 245), width: 28, height: 20),
          Paint()..color = kAmber);
      canvas.drawOval(Rect.fromCenter(
          center: Offset(cx + 45, 245), width: 28, height: 20),
          Paint()..color = kAmber);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_TorsoPainter old) => old.t != t;
}

// ── Scene 2 · Internal anatomy ────────────────────────────────────────────────
class _InternalScene extends StatelessWidget {
  const _InternalScene({required this.t});
  final double t;

  static const parts = [
    (name: 'Uterus',          sub: 'Where a pregnancy grows',    x: 640.0, y: 360.0, color: kRose),
    (name: 'Ovaries',         sub: 'Make eggs and hormones',     x: 480.0, y: 320.0, color: kAmber),
    (name: 'Fallopian tubes', sub: 'Path from ovary to uterus',  x: 800.0, y: 290.0, color: kSage),
    (name: 'Cervix',          sub: 'Doorway to the uterus',      x: 640.0, y: 480.0, color: kRoseDark),
    (name: 'Vagina',          sub: 'Passage from cervix outward',x: 640.0, y: 555.0, color: Color(0xFFF8B8C4)),
  ];

  @override
  Widget build(BuildContext context) {
    final focused = math.min(parts.length - 1, (t * 0.9).floor());

    return Stack(
      children: [
        // Cross-section diagram
        CustomPaint(
          size: const Size(1280, 720),
          painter: _InternalAnatomyPainter(t: t, focused: focused),
        ),

        // Active part label
        Positioned(
          left: 80,
          bottom: 130,
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xEB2A1A1F),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Part ${focused + 1} of ${parts.length}',
                  style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      color: parts[focused].color,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  parts[focused].name,
                  style: const TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: kCream),
                ),
                const SizedBox(height: 4),
                Text(
                  parts[focused].sub,
                  style: TextStyle(
                      fontSize: 13,
                      color: kCream.withValues(alpha: 0.75)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InternalAnatomyPainter extends CustomPainter {
  const _InternalAnatomyPainter({required this.t, required this.focused});
  final double t;
  final int focused;

  @override
  void paint(Canvas canvas, Size size) {
    const cx = 640.0, cy = 360.0;

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(cx + 10, cy + 250), width: 360, height: 28),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Uterus body
    final utPath = Path()
      ..moveTo(cx - 180, cy - 160)
      ..quadraticBezierTo(cx - 220, cy - 100, cx - 200, cy)
      ..quadraticBezierTo(cx - 150, cy + 200, cx, cy + 220)
      ..quadraticBezierTo(cx + 150, cy + 200, cx + 200, cy)
      ..quadraticBezierTo(cx + 220, cy - 100, cx + 180, cy - 160)
      ..quadraticBezierTo(cx + 100, cy - 200, cx, cy - 180)
      ..quadraticBezierTo(cx - 100, cy - 200, cx - 180, cy - 160)
      ..close();

    canvas.drawPath(
      utPath,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.2, -0.35),
          radius: 1.2,
          colors: [Color(0xFFFFE0E8), Color(0xFFF8B8C4), kRoseDark],
          stops: [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCenter(center: const Offset(cx, cy), width: 400, height: 440)),
    );
    canvas.drawPath(utPath, Paint()
      ..color = kRoseDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);

    // Fallopian tubes
    final tubePaint = Paint()
      ..color = const Color(0xFFF8B8C4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 32
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
        Path()..moveTo(cx - 180, cy - 160)
            ..quadraticBezierTo(cx - 280, cy - 180, cx - 340, cy - 130), tubePaint);
    canvas.drawPath(
        Path()..moveTo(cx + 180, cy - 160)
            ..quadraticBezierTo(cx + 280, cy - 180, cx + 340, cy - 130), tubePaint);

    // Fimbriae
    final fimbrPaint = Paint()
      ..color = kRose.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 8; i++) {
      canvas.drawPath(
          Path()..moveTo(cx - 340, cy - 130)
              ..quadraticBezierTo(cx - 350 - i * 3, cy - 115 + i * 4,
                  cx - 355 - i * 4, cy - 100 + i * 7),
          fimbrPaint);
      canvas.drawPath(
          Path()..moveTo(cx + 340, cy - 130)
              ..quadraticBezierTo(cx + 350 + i * 3, cy - 115 + i * 4,
                  cx + 355 + i * 4, cy - 100 + i * 7),
          fimbrPaint);
    }

    // Ovaries
    final ovaryPaint = Paint()..color = kRose;
    canvas.drawOval(Rect.fromCenter(
        center: const Offset(cx - 360, cy - 115), width: 64, height: 52), ovaryPaint);
    canvas.drawOval(Rect.fromCenter(
        center: const Offset(cx + 360, cy - 115), width: 64, height: 52), ovaryPaint);

    // Eggs
    final eggPaint = Paint()..color = kAmber;
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(cx - 360 + (i - 1) * 8, cy - 115 + i * 3), 3, eggPaint);
      canvas.drawCircle(Offset(cx + 360 + (i - 1) * 8, cy - 115 + i * 3), 3, eggPaint);
    }

    // Cervix
    canvas.drawOval(Rect.fromCenter(
        center: const Offset(cx, cy + 195), width: 44, height: 64),
        Paint()..color = kRoseDark);

    // Vaginal canal
    canvas.drawPath(
      Path()
        ..moveTo(cx - 18, cy + 225)
        ..quadraticBezierTo(cx - 26, cy + 270, cx - 18, cy + 320)
        ..lineTo(cx + 18, cy + 320)
        ..quadraticBezierTo(cx + 26, cy + 270, cx + 18, cy + 225)
        ..close(),
      Paint()..color = const Color(0xFFF8B8C4),
    );

    // Focus pulse on selected part
    if (focused < _InternalScene.parts.length) {
      final part = _InternalScene.parts[focused];
      final pulseR = 28 + math.sin(t * 4) * 4;
      final ripR = 50.0 + (t * 5 % 2) * 30;
      final ripOp = math.max(0.0, 0.6 - (t * 5 % 2) * 0.3);

      canvas.drawCircle(
        Offset(part.x, part.y),
        pulseR,
        Paint()
          ..color = part.color.withValues(alpha: 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
      canvas.drawCircle(
        Offset(part.x, part.y),
        ripR,
        Paint()
          ..color = part.color.withValues(alpha: ripOp)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(_InternalAnatomyPainter old) =>
      old.t != t || old.focused != focused;
}

// ── Scene 3 · External anatomy ────────────────────────────────────────────────
class _ExternalScene extends StatelessWidget {
  const _ExternalScene({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    final showInternal = t > 2.5;
    final internalOp = showInternal ? math.min(1.0, (t - 2.5)) : 0.0;

    final labelItems = [
      (y: 195.0, x: 880.0, label: 'Mons pubis',       delay: 0.0),
      (y: 280.0, x: 880.0, label: 'Clitoral hood',    delay: 0.4),
      (y: 295.0, x: 250.0, label: 'Clitoris (glans)', delay: 0.8),
      (y: 380.0, x: 250.0, label: 'Urethral opening', delay: 1.2),
      (y: 465.0, x: 880.0, label: 'Vaginal opening',  delay: 1.6),
      (y: 410.0, x: 880.0, label: 'Inner labia',      delay: 2.0),
    ];

    return Stack(
      children: [
        CustomPaint(
          size: const Size(1280, 720),
          painter: _ExternalAnatomyPainter(t: t, internalOp: internalOp),
        ),

        // Labels
        ...labelItems.map((l) {
          final op = lerp(t, [l.delay, l.delay + 0.5], [0.0, 1.0]).clamp(0.0, 1.0);
          return Positioned(
            left: l.x,
            top: l.y,
            child: Opacity(
              opacity: op,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xE52A1A1F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l.label,
                  style: const TextStyle(
                      color: kCream,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          );
        }),

        // Clitoris insight callout
        if (t > 3.5)
          Positioned(
            right: 60,
            bottom: 130,
            child: Opacity(
              opacity: math.min(1.0, (t - 3.5) / 0.8),
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kRose.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Did you know?',
                        style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 1.5,
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    const Text(
                      'The clitoris is mostly internal — about 9 cm long total.',
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ExternalAnatomyPainter extends CustomPainter {
  const _ExternalAnatomyPainter({required this.t, required this.internalOp});
  final double t, internalOp;

  @override
  void paint(Canvas canvas, Size size) {
    const cx = 640.0;

    // Outer labia
    final outerPath = Path()
      ..moveTo(cx - 100, 200)
      ..quadraticBezierTo(cx - 180, 280, cx - 170, 460)
      ..quadraticBezierTo(cx - 150, 580, cx - 60, 620)
      ..lineTo(cx, 630)
      ..lineTo(cx + 60, 620)
      ..quadraticBezierTo(cx + 150, 580, cx + 170, 460)
      ..quadraticBezierTo(cx + 180, 280, cx + 100, 200)
      ..quadraticBezierTo(cx + 50, 170, cx, 180)
      ..quadraticBezierTo(cx - 50, 170, cx - 100, 200)
      ..close();

    canvas.drawPath(
      outerPath,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, -0.3),
          radius: 1.2,
          colors: [Color(0xFFFFE0DD), Color(0xFFF5C6A5), Color(0xFFC8825C)],
          stops: [0.0, 0.6, 1.0],
        ).createShader(Rect.fromLTWH(cx - 200, 150, 400, 500)),
    );
    canvas.drawPath(outerPath, Paint()
      ..color = kPlum.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5);

    // Inner labia
    final innerPath = Path()
      ..moveTo(cx - 60, 280)
      ..quadraticBezierTo(cx - 100, 380, cx - 80, 500)
      ..lineTo(cx, 540)
      ..lineTo(cx + 80, 500)
      ..quadraticBezierTo(cx + 100, 380, cx + 60, 280)
      ..quadraticBezierTo(cx + 30, 250, cx, 260)
      ..quadraticBezierTo(cx - 30, 250, cx - 60, 280)
      ..close();
    canvas.drawPath(innerPath, Paint()..color = kRose.withValues(alpha: 0.7));

    // Vaginal opening
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(cx, 480), width: 44, height: 64),
      Paint()..color = const Color(0xFF8A002F),
    );

    // Urethral opening
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(cx, 380), width: 12, height: 8),
      Paint()..color = const Color(0xFF4A2F37),
    );

    // Clitoral hood
    final hoodPath = Path()
      ..moveTo(cx - 25, 280)
      ..quadraticBezierTo(cx, 270, cx + 25, 280)
      ..quadraticBezierTo(cx + 20, 310, cx, 320)
      ..quadraticBezierTo(cx - 20, 310, cx - 25, 280)
      ..close();
    canvas.drawPath(hoodPath, Paint()
      ..color = const Color(0xFFF8B8C4)
      ..style = PaintingStyle.fill);
    canvas.drawPath(hoodPath, Paint()
      ..color = kPlum.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);

    // Clitoris glans
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(cx, 298), width: 20, height: 24),
      Paint()..color = kRose,
    );

    // Internal clitoris reveal
    if (internalOp > 0) {
      final internal = Paint()
        ..color = kRose.withValues(alpha: 0.85 * internalOp)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;

      // Left crus
      canvas.drawPath(
        Path()..moveTo(cx, 298)
            ..quadraticBezierTo(cx - 60, 320, cx - 100, 380)
            ..quadraticBezierTo(cx - 130, 460, cx - 110, 540),
        internal,
      );
      // Right crus
      canvas.drawPath(
        Path()..moveTo(cx, 298)
            ..quadraticBezierTo(cx + 60, 320, cx + 100, 380)
            ..quadraticBezierTo(cx + 130, 460, cx + 110, 540),
        internal,
      );

      // Vestibular bulbs
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(cx - 110, 430), width: 40, height: 70),
        Paint()..color = kRose.withValues(alpha: 0.7 * internalOp),
      );
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(cx + 110, 430), width: 40, height: 70),
        Paint()..color = kRose.withValues(alpha: 0.7 * internalOp),
      );
    }
  }

  @override
  bool shouldRepaint(_ExternalAnatomyPainter old) =>
      old.t != t || old.internalOp != internalOp;
}

// ── Scene 4 · Vocabulary cards ────────────────────────────────────────────────
class _VocabScene extends StatelessWidget {
  const _VocabScene({required this.t});
  final double t;

  static const _words = [
    (rw: 'Igitsina',    en: 'Genitals',    fr: 'Organes génitaux', x: 200.0,  y: 200.0),
    (rw: 'Nyababyeyi',  en: 'Uterus',      fr: 'Utérus',           x: 480.0,  y: 280.0),
    (rw: 'Amagi',       en: 'Ova / Eggs',  fr: 'Ovules',           x: 800.0,  y: 200.0),
    (rw: 'Inkari',      en: 'Urethra',     fr: 'Urètre',           x: 1020.0, y: 320.0),
    (rw: 'Ibere',       en: 'Breast',      fr: 'Sein',             x: 200.0,  y: 450.0),
    (rw: 'Igisabo',     en: 'Vagina',      fr: 'Vagin',            x: 580.0,  y: 480.0),
    (rw: 'Hormoni',     en: 'Hormone',     fr: 'Hormone',          x: 820.0,  y: 460.0),
    (rw: 'Inkuta',      en: 'Labia',       fr: 'Lèvres',           x: 1020.0, y: 530.0),
  ];

  static const _colors = [kRose, kAmber, kSage, kRoseDark];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Header
        Positioned(
          left: 0,
          right: 0,
          top: 130,
          child: Column(
            children: [
              Text(
                'Vocabulary · RW ⟷ EN ⟷ FR',
                style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2,
                    color: kInk60,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              const Text(
                'Words give you power.',
                style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                    color: kPlum,
                    letterSpacing: -1),
              ),
            ],
          ),
        ),

        // Vocab cards
        ..._words.asMap().entries.map((e) {
          final i = e.key;
          final w = e.value;
          final op = lerp(t, [i * 0.25, i * 0.25 + 0.6], [0.0, 1.0],
              Ease.outBack).clamp(0.0, 1.0);
          final c = _colors[i % _colors.length];
          final tilt = (i % 2 == 0 ? -1 : 1) * 2.0;

          return Positioned(
            left: w.x,
            top: w.y,
            child: Opacity(
              opacity: op,
              child: Transform.scale(
                scale: op,
                child: Transform.rotate(
                  angle: tilt * math.pi / 180,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: c, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: c.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(w.rw,
                            style: const TextStyle(
                                fontFamily: 'Fraunces',
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: kPlum,
                                height: 1.1)),
                        const SizedBox(height: 2),
                        Text(w.en,
                            style: TextStyle(
                                fontSize: 11,
                                color: c,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5)),
                        Text(w.fr,
                            style: TextStyle(
                                fontSize: 10,
                                color: kInk60,
                                letterSpacing: 0.3)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
