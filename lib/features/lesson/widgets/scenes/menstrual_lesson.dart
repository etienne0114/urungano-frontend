import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../lesson_animation_primitives.dart';
import '../lesson_animation_stage.dart';

/// Lesson 01 · Menstrual Cycle · 28s
/// Scene 1  0–7s   Hormones rise from ovary (FSH / LH / Estrogen spheres + chart)
/// Scene 2  7–14s  Ovulation — egg released from follicle, travels fallopian tube
/// Scene 3 14–21s  Uterine lining thickens (animated endometrium + mm readout)
/// Scene 4 21–28s  Cycle-wheel summary with all 4 phases
class MenstrualLesson extends StatelessWidget {
  const MenstrualLesson({required this.t, super.key});
  final double t;

  String get _caption {
    if (t < 7) return 'Day 1 to 14 estrogen and FSH rise. A follicle in your ovary starts to mature.';
    if (t < 14) return 'Around day 14 the mature egg is released. This is ovulation.';
    if (t < 21) return 'The uterine lining thickens, ready to receive an egg if fertilized.';
    return "If no fertilization, the lining sheds that's your period. The cycle begins again.";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        // Background
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [Color(0xFFFFE9DD), Color(0xFFF5C6A5), Color(0xFFE8A87C)],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
        ),
        // Ambient particles
        AmbientField(
          t: t,
          count: 24,
          colors: [
            kRose.withValues(alpha: 0.13),
            kAmber.withValues(alpha: 0.13),
            kSage.withValues(alpha: 0.13),
          ],
        ),

        // Scene 1 — Hormone rise
        SceneWindow(t: t, start: 0, end: 7.3,
            child: _HormoneRiseScene(t: (t - 0).clamp(0, 7))),

        // Scene 2 — Ovulation
        SceneWindow(t: t, start: 6.7, end: 14.3,
            child: _OvulationScene(t: (t - 6.7).clamp(0, 7.6))),

        // Scene 3 — Uterine lining
        SceneWindow(t: t, start: 13.7, end: 21.3,
            child: _UterineScene(t: (t - 13.7).clamp(0, 7.6))),

        // Scene 4 — Cycle wheel
        SceneWindow(t: t, start: 20.7, end: 28,
            child: _CycleWheelScene(t: (t - 20.7).clamp(0, 7.3))),

        // HUD (always on top)
        LessonHUD(
          title: 'Your cycle, explained',
          sub: 'Lesson 01 · Menstrual health · 28s',
          caption: _caption,
          t: t,
          accent: kRose,
        ),
      ],
    );
  }
}

// ── Scene 1 · Hormone rise ────────────────────────────────────────────────────
class _HormoneRiseScene extends StatelessWidget {
  const _HormoneRiseScene({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    const ovX = 280.0, ovY = 460.0;
    final ovScale = lerp(t, [0, 0, 0.8], [0.6, 0.6, 1.0], Ease.outBack);

    // Three hormone spheres: FSH (sage), LH (amber), Estrogen (rose)
    const hormones = [
      ('FSH', kSage, Color(0xFFA8C5BA)),
      ('LH',  kAmber, Color(0xFFFFD89A)),
      ('EST', kRose,  Color(0xFFFFC4D0)),
    ];

    return Stack(
      children: [
        // Ovary
        Positioned(
          left: ovX - 70,
          top: ovY - 55,
          child: Transform(
            transform: Matrix4.identity()
              ..scale(ovScale)
              ..rotateZ(-12 * math.pi / 180 + math.sin(t * 0.5) * 4 * math.pi / 180),
            alignment: Alignment.center,
            child: Container(
              width: 140,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.elliptical(72, 58),
                  topRight: Radius.elliptical(68, 58),
                  bottomLeft: Radius.elliptical(70, 50),
                  bottomRight: Radius.elliptical(70, 50),
                ),
                gradient: const RadialGradient(
                  center: Alignment(-0.3, -0.4),
                  radius: 1.2,
                  colors: [Color(0xFFFCE4E8), kRose, kRoseDark],
                  stops: [0.0, 0.55, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                      color: kRose.withValues(alpha: 0.4),
                      blurRadius: 60,
                      offset: const Offset(0, 30)),
                ],
              ),
            ),
          ),
        ),

        // Follicles on ovary
        ...List.generate(5, (i) {
          final ang = i * math.pi * 0.4 + 0.5;
          final fx = ovX + math.cos(ang) * 30;
          final fy = ovY + math.sin(ang) * 22;
          final grow = i == 2
              ? lerp(t, [2, 6], [0.6, 1.8], Ease.outCubic)
              : 0.6 + math.sin(t + i) * 0.1;
          return Positioned(
            left: fx - 12,
            top: fy - 12,
            child: Transform.scale(
              scale: grow,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment(-0.3, -0.25),
                    radius: 1.0,
                    colors: [Color(0xFFFFE0E8), Color(0xFFF47B95)],
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
                  ],
                ),
              ),
            ),
          );
        }),

        // Rising hormone spheres
        ...List.generate(3, (i) {
          final start = 1.0 + i * 0.5;
          final local = math.max(0.0, t - start);
          if (local <= 0) return const SizedBox.shrink();
          final yPos = lerp(local, [0, 4.5], [ovY - 80, 120.0], Ease.outCubic);
          final xOff = math.sin(local * 1.5 + i) * 30;
          final op = math.min(1.0, local * 2);
          final color = hormones[i].$2;
          final hi = hormones[i].$3;
          final name = hormones[i].$1;
          return Sphere3D(
            x: ovX + 60 + i * 40 + xOff,
            y: yPos,
            z: i * 15,
            r: 28,
            color: color,
            highlight: hi,
            label: name,
            glow: 20 * op,
          );
        }),

        // Hormone chart (right side)
        _HormoneChart(t: t),

        // Day counter
        DayCounter(day: math.min(14, (t * 2).round())),
      ],
    );
  }
}

class _HormoneChart extends StatelessWidget {
  const _HormoneChart({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    final op = math.min(1.0, t / 1.2);
    return Positioned(
      right: 40,
      top: 120,
      child: Opacity(
        opacity: op,
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x142A1A1F)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hormone levels · Days 1–14',
                  style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: kPlum)),
              const SizedBox(height: 4),
              Row(children: const [
                _Legend(color: kSage, label: 'FSH'),
                SizedBox(width: 12),
                _Legend(color: kAmber, label: 'LH'),
                SizedBox(width: 12),
                _Legend(color: kRose, label: 'Estrogen'),
              ]),
              const SizedBox(height: 8),
              SizedBox(
                width: 340,
                height: 160,
                child: CustomPaint(
                  painter: _ChartPainter(t: math.min(1.0, t / 6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 10, height: 3, color: color),
      const SizedBox(width: 4),
      Text(label,
          style: const TextStyle(fontSize: 10, color: kInk60)),
    ]);
  }
}

class _ChartPainter extends CustomPainter {
  const _ChartPainter({required this.t});
  final double t;

  double _fsh(double x) => 0.3 + math.sin(x * math.pi * 0.8) * 0.25 + (x > 0.45 ? -0.15 : 0);
  double _lh(double x)  => 0.1 + math.exp(-math.pow((x - 0.5) * 8, 2).toDouble()) * 0.85;
  double _est(double x) => 0.15 + (x < 0.5 ? math.pow(x * 2, 1.6).toDouble() * 0.7 : 0.7 - (x - 0.5) * 0.4);

  Path _buildPath(double Function(double) fn, Size size) {
    const samples = 50;
    final path = Path();
    for (int i = 0; i < samples; i++) {
      final xi = (i / (samples - 1)) * t;
      final x = (i / (samples - 1)) * size.width;
      final y = size.height - fn(xi) * size.height * 0.85;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0x0F2A1A1F)
      ..strokeWidth = 1;
    for (int i = 0; i < 4; i++) {
      final y = size.height - i * size.height / 3.5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final curves = [(_fsh, kSage), (_lh, kAmber), (_est, kRose)];
    for (final (fn, color) in curves) {
      final p = Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(_buildPath(fn, size), p);
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) => old.t != t;
}

// ── Scene 2 · Ovulation ───────────────────────────────────────────────────────
class _OvulationScene extends StatelessWidget {
  const _OvulationScene({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    final eggX = lerp(t, [0, 5], [340, 700], Ease.inOutCubic);
    final eggY = lerp(t, [0, 5], [400, 380], Ease.inOutCubic) + math.sin(t * 1.5) * 15;
    final eggR  = lerp(t, [0, 1.5], [10, 36], Ease.outBack);
    final burstOp = lerp(t, [0.5, 1.2, 2.5], [0, 1, 0], Ease.outCubic);

    return Stack(
      children: [
        // Ovary
        Positioned(
          left: 200,
          top: 380,
          child: Transform.rotate(
            angle: -15 * math.pi / 180,
            child: Container(
              width: 160,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.elliptical(83, 68),
                  topRight: Radius.elliptical(77, 68),
                  bottomLeft: Radius.elliptical(80, 65),
                  bottomRight: Radius.elliptical(80, 65),
                ),
                gradient: const RadialGradient(
                  center: Alignment(-0.3, -0.4),
                  radius: 1.2,
                  colors: [Color(0xFFFCE4E8), kRose, kRoseDark],
                ),
                boxShadow: [
                  BoxShadow(
                      color: kRose.withValues(alpha: 0.4),
                      blurRadius: 60,
                      offset: const Offset(0, 30))
                ],
              ),
            ),
          ),
        ),

        // Burst rays
        if (burstOp > 0)
          ...List.generate(12, (i) {
            final ang = (i / 12) * math.pi * 2;
            return Positioned(
              left: 290 + math.cos(ang) * 50,
              top:  440 + math.sin(ang) * 50,
              child: Opacity(
                opacity: burstOp,
                child: Transform.rotate(
                  angle: ang,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 60 + t * 30,
                    height: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      gradient: LinearGradient(
                        colors: [kAmber, kAmber.withValues(alpha: 0)],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

        // Fallopian tube (painted)
        CustomPaint(
          size: const Size(1280, 720),
          painter: _FallopianTubePainter(),
        ),

        // Egg sphere
        Sphere3D(x: eggX, y: eggY, r: eggR, color: kAmber,
            highlight: const Color(0xFFFFF4D9), glow: 30),

        // "OVUM · ovulation" label
        if (t > 1)
          Positioned(
            left: eggX + eggR + 10,
            top:  eggY - 20,
            child: Opacity(
              opacity: math.min(1.0, (t - 1) * 2),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: kPlum, borderRadius: BorderRadius.circular(100)),
                child: const Text('OVUM · ovulation',
                    style: TextStyle(
                        color: kCream,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5)),
              ),
            ),
          ),

        // Sperm cells (context)
        if (t > 3)
          ...List.generate(6, (i) {
            final local = t - 3 - i * 0.15;
            if (local <= 0) return const SizedBox.shrink();
            final sx = lerp(local, [0, 4], [1280, 800], Ease.outCubic);
            final sy = 400 + math.sin(local * 4 + i) * 30 + i * 6;
            return Positioned(
              left: sx,
              top: sy,
              child: Opacity(
                opacity: math.min(0.6, local),
                child: Transform.rotate(
                  angle: math.pi + math.sin(local * 4 + i) * 0.17,
                  child: _SpermCell(t: local),
                ),
              ),
            );
          }),

        DayCounter(day: 14),
      ],
    );
  }
}

class _FallopianTubePainter extends CustomPainter {
  const _FallopianTubePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final thick = Paint()
      ..color = const Color(0x8CF8B8C4)
      ..strokeWidth = 60
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final outline = Paint()
      ..color = kRose.withValues(alpha: 0.4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(340, 410)
      ..quadraticBezierTo(500, 340, 720, 380)
      ..quadraticBezierTo(860, 410, 1000, 360);
    canvas.drawPath(path, thick);
    canvas.drawPath(path, outline);

    // Fimbriae
    final fimbPaint = Paint()
      ..color = kRose.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 8; i++) {
      final p = Path()
        ..moveTo(340, 410)
        ..quadraticBezierTo(
            320 - i * 4, 390 + i * 6, 290 - i * 5, 380 + i * 8);
      canvas.drawPath(p, fimbPaint);
    }
  }

  @override
  bool shouldRepaint(_FallopianTubePainter _) => false;
}

class _SpermCell extends StatelessWidget {
  const _SpermCell({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 14,
      child: CustomPaint(painter: _SpermPainter(t: t)),
    );
  }
}

class _SpermPainter extends CustomPainter {
  const _SpermPainter({required this.t});
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kSage
      ..style = PaintingStyle.fill;
    // Head
    canvas.drawOval(const Rect.fromLTWH(0, 2, 12, 10), paint);
    // Tail
    final tail = Paint()
      ..color = kSage
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(12, 7)
      ..quadraticBezierTo(22, 5 + math.sin(t * 4) * 3, 30, 7)
      ..quadraticBezierTo(36, 9 + math.sin(t * 4 + 1) * 3, 40, 7);
    canvas.drawPath(path, tail);
  }

  @override
  bool shouldRepaint(_SpermPainter old) => old.t != t;
}

// ── Scene 3 · Uterine lining ──────────────────────────────────────────────────
class _UterineScene extends StatelessWidget {
  const _UterineScene({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    final thick = lerp(t, [0, 5], [4, 26], Ease.outCubic);
    final pulseR = (t * 2 % 2) * 60 + 20;
    final pulseOp = math.max(0.0, 0.5 - (t * 2 % 2) * 0.25);

    return Stack(
      children: [
        // Uterus cross-section
        CustomPaint(
          size: const Size(1280, 720),
          painter: _UterusPainter(thick: thick, pulseR: pulseR, pulseOp: pulseOp),
        ),

        // Thickness readout
        Positioned(
          right: 100,
          top: 200,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x142A1A1F)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Endometrium',
                    style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.2,
                        color: kInk60,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: kRose),
                    children: [
                      TextSpan(text: thick.toStringAsFixed(1)),
                      const TextSpan(
                          text: ' mm',
                          style: TextStyle(
                              fontSize: 14, color: kInk60,
                              fontFamily: 'DM Sans')),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 120,
                  height: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: thick / 28,
                      backgroundColor: kCream2,
                      valueColor: const AlwaysStoppedAnimation<Color>(kRose),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Day 14 → Day 21',
                    style: TextStyle(fontSize: 10, color: kInk60)),
              ],
            ),
          ),
        ),

        DayCounter(day: math.min(21, (14 + t * 1.5).round())),
      ],
    );
  }
}

class _UterusPainter extends CustomPainter {
  const _UterusPainter(
      {required this.thick, required this.pulseR, required this.pulseOp});

  final double thick;
  final double pulseR;
  final double pulseOp;

  @override
  void paint(Canvas canvas, Size size) {
    const cx = 640.0, cy = 360.0;
    // Cast shadow
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(cx + 10, cy + 250), width: 360, height: 40),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Uterus body
    final bodyPath = Path()
      ..moveTo(cx - 180, cy - 160)
      ..quadraticBezierTo(cx - 220, cy - 100, cx - 200, cy)
      ..quadraticBezierTo(cx - 150, cy + 200, cx, cy + 220)
      ..quadraticBezierTo(cx + 150, cy + 200, cx + 200, cy)
      ..quadraticBezierTo(cx + 220, cy - 100, cx + 180, cy - 160)
      ..quadraticBezierTo(cx + 100, cy - 200, cx, cy - 180)
      ..quadraticBezierTo(cx - 100, cy - 200, cx - 180, cy - 160)
      ..close();

    canvas.drawPath(bodyPath, Paint()..shader = const RadialGradient(
      center: Alignment(-0.2, -0.35),
      radius: 1.2,
      colors: [Color(0xFFFFE0E8), Color(0xFFF8B8C4), kRoseDark],
    ).createShader(Rect.fromCenter(center: const Offset(cx, cy), width: 400, height: 440)));

    canvas.drawPath(bodyPath, Paint()
      ..color = kRoseDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);

    // Fallopian tubes
    final tubePaint = Paint()
      ..color = const Color(0xFFF8B8C4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 36
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(Path()..moveTo(cx - 180, cy - 160)
        ..quadraticBezierTo(cx - 280, cy - 180, cx - 340, cy - 130), tubePaint);
    canvas.drawPath(Path()..moveTo(cx + 180, cy - 160)
        ..quadraticBezierTo(cx + 280, cy - 180, cx + 340, cy - 130), tubePaint);

    // Ovaries
    final ovaryPaint = Paint()..color = kRose;
    canvas.drawOval(Rect.fromCenter(
        center: const Offset(cx - 360, cy - 115), width: 64, height: 52), ovaryPaint);
    canvas.drawOval(Rect.fromCenter(
        center: const Offset(cx + 360, cy - 115), width: 64, height: 52), ovaryPaint);

    // Endometrium pulse rings
    final pulsePaint = Paint()
      ..color = kRose.withValues(alpha: pulseOp)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(const Offset(cx, cy), pulseR, pulsePaint);
    canvas.drawCircle(const Offset(cx, cy), pulseR * 0.6, pulsePaint..color = kRose.withValues(alpha: pulseOp * 0.6));

    // Endometrium layer outline (thickening)
    final innerPaint = Paint()
      ..color = kRose.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thick;
    final innerPath = Path()
      ..moveTo(cx - 100, cy - 80)
      ..quadraticBezierTo(cx - 130, cy, cx - 90, cy + 100)
      ..quadraticBezierTo(cx, cy + 150, cx + 90, cy + 100)
      ..quadraticBezierTo(cx + 130, cy, cx + 100, cy - 80)
      ..quadraticBezierTo(cx + 50, cy - 130, cx, cy - 110)
      ..quadraticBezierTo(cx - 50, cy - 130, cx - 100, cy - 80)
      ..close();
    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  bool shouldRepaint(_UterusPainter old) =>
      old.thick != thick || old.pulseR != pulseR || old.pulseOp != pulseOp;
}

// ── Scene 4 · Cycle wheel ─────────────────────────────────────────────────────
class _CycleWheelScene extends StatelessWidget {
  const _CycleWheelScene({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    final rotation = lerp(t, [0, 6.5], [0, 2 * math.pi], Ease.inOutCubic);
    final dayVal = ((rotation / (2 * math.pi)) * 28).clamp(0.0, 28.0);
    final selPhase = dayVal < 5 ? 0 : dayVal < 13 ? 1 : dayVal < 14 ? 2 : 3;

    final phases = [
      (name: 'Menstrual',  days: '1–5',   daysN: 5,   color: kRose),
      (name: 'Follicular', days: '6–13',  daysN: 8,   color: kAmber),
      (name: 'Ovulation',  days: '14',    daysN: 1,   color: kSage),
      (name: 'Luteal',     days: '15–28', daysN: 14,  color: kRoseDark),
    ];

    return Stack(
      children: [
        // Aurora background
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.3, -0.4),
              radius: 1.5,
              colors: [
                phases[selPhase].color.withValues(alpha: 0.18),
                const Color(0xFFFFF0F4),
                const Color(0xFFFDF4EC),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // Ambient particles
        AmbientField(
          t: t,
          count: 18,
          colors: [
            kRose.withValues(alpha: 0.10),
            kAmber.withValues(alpha: 0.10),
            kSage.withValues(alpha: 0.10),
          ],
        ),
        // 3D wheel centered
        Positioned.fill(
          child: CustomPaint(
            painter: _Pro3DCycleWheelPainter(
              day: dayVal, sel: selPhase,
              phases: phases, rotation: rotation,
            ),
          ),
        ),
        // Day counter in hub area
        Positioned(
          left: 600, top: 280,
          child: SizedBox(
            width: 120,
            child: Column(
              children: [
                const Text('DAY',
                    style: TextStyle(
                        fontSize: 11, letterSpacing: 1.5,
                        color: kPlum, fontWeight: FontWeight.w500)),
                Text(
                  dayVal.floor().toString().padLeft(2, '0'),
                  style: const TextStyle(
                      fontFamily: 'Fraunces', fontSize: 32,
                      fontWeight: FontWeight.w500, color: kRose),
                ),
              ],
            ),
          ),
        ),
        // Phase legend right
        Positioned(
          left: 800, top: 160,
          child: SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('One full cycle',
                    style: TextStyle(
                        fontFamily: 'Fraunces', fontSize: 26,
                        fontWeight: FontWeight.w500, color: kPlum,
                        letterSpacing: -0.5)),
                const SizedBox(height: 6),
                Text(
                  'On average 28 days, but 21–35 is normal.',
                  style: TextStyle(fontSize: 13, color: kInk60, height: 1.5),
                ),
                const SizedBox(height: 14),
                ...List.generate(phases.length, (i) {
                  final op = lerp(t,
                      [0.4 + i * 0.4, 0.8 + i * 0.4], [0, 1.0])
                      .clamp(0.0, 1.0);
                  final ph = phases[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Opacity(
                      opacity: op,
                      child: Transform.translate(
                        offset: Offset((1 - op) * 20, 0),
                        child: GlassCard(
                          opacity: op,
                          child: Row(children: [
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: ph.color,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: ph.color.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text('●',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ph.name,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: kPlum)),
                                  Text('Days ${ph.days}',
                                      style: const TextStyle(
                                          fontSize: 11, color: kInk60)),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Pro3DCycleWheelPainter extends CustomPainter {
  const _Pro3DCycleWheelPainter({
    required this.day, required this.sel,
    required this.phases, required this.rotation,
  });
  final double day, rotation;
  final int sel;
  final List phases;

  static const _cx = 480.0, _cy = 360.0;
  static const _R = 200.0, _inner = 80.0, _cellR = 248.0;
  static const _daysN = [5, 8, 1, 14];

  @override
  void paint(Canvas c, Size s) {
    // Drop shadow
    c.drawOval(
      Rect.fromCenter(
          center: const Offset(_cx + 4, _cy + _R + 16),
          width: _R * 2.1, height: 38),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    c.save();
    c.translate(_cx, _cy);
    c.rotate(rotation);

    // Phase sectors
    double acc = 0;
    for (int p = 0; p < 4; p++) {
      final start = (acc / 28) * 2 * math.pi - math.pi / 2;
      acc += _daysN[p];
      final end = (acc / 28) * 2 * math.pi - math.pi / 2;
      final mid = (start + end) / 2;
      final isSel = sel == p;
      final rOut = isSel ? _R + 20.0 : _R;
      final col = phases[p].color as Color;

      final arc = Path()
        ..moveTo(math.cos(start) * _inner, math.sin(start) * _inner)
        ..arcTo(Rect.fromCircle(center: Offset.zero, radius: rOut),
            start, end - start, false)
        ..lineTo(math.cos(end) * _inner, math.sin(end) * _inner)
        ..arcTo(Rect.fromCircle(center: Offset.zero, radius: _inner),
            end, start - end, false)
        ..close();

      c.drawPath(arc, Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.28),
          radius: 1.1,
          colors: [
            Color.lerp(col, Colors.white, 0.36)!,
            col,
            Color.lerp(col, Colors.black, 0.18)!,
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: rOut)));

      if (isSel) {
        c.drawPath(arc, Paint()
          ..color = col.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
      }
      c.drawPath(arc, Paint()
        ..color = Colors.white.withValues(alpha: 0.70)
        ..style = PaintingStyle.stroke..strokeWidth = 2);

      // Phase name (rotated upright)
      final labelR = (rOut + _inner) / 2;
      final lx = math.cos(mid) * labelR, ly = math.sin(mid) * labelR;
      final name = phases[p].name as String;
      final tp = TextPainter(
        text: TextSpan(
          text: name,
          style: const TextStyle(
              fontFamily: 'Fraunces', fontSize: 13,
              fontWeight: FontWeight.w700, color: Colors.white,
              shadows: [Shadow(blurRadius: 3, color: Colors.black38)]),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      c.save();
      c.translate(lx, ly);
      c.rotate(-rotation + mid + math.pi / 2);
      tp.paint(c, Offset(-tp.width / 2, -tp.height / 2));
      c.restore();
    }

    // Outer 28-day cells
    for (int d = 0; d < 28; d++) {
      final ang = (d / 28) * 2 * math.pi - math.pi / 2;
      final ang2 = ((d + 1) / 28) * 2 * math.pi - math.pi / 2;
      final mid = (ang + ang2) / 2;
      final pi = d < 5 ? 0 : d < 13 ? 1 : d == 13 ? 2 : 3;
      final col = phases[pi].color as Color;
      final isCur = d == (day.floor() % 28);

      final cell = Path()
        ..moveTo(math.cos(ang) * (_R + 3), math.sin(ang) * (_R + 3))
        ..arcTo(Rect.fromCircle(center: Offset.zero, radius: _cellR - 2),
            ang, ang2 - ang, false)
        ..lineTo(math.cos(ang2) * (_R + 3), math.sin(ang2) * (_R + 3))
        ..arcTo(Rect.fromCircle(center: Offset.zero, radius: _R + 3),
            ang2, ang - ang2, false)
        ..close();

      c.drawPath(cell,
          Paint()..color = isCur ? Colors.white : col.withValues(alpha: 0.18));
      c.drawPath(cell, Paint()
        ..color = col.withValues(alpha: isCur ? 0.85 : 0.38)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isCur ? 2.0 : 0.8);

      // Day number (upright)
      final nr = (_cellR - 2 + _R + 3) / 2;
      final tp = TextPainter(
        text: TextSpan(
          text: '${d + 1}',
          style: TextStyle(
              fontSize: 7.5,
              fontWeight: isCur ? FontWeight.w800 : FontWeight.w600,
              color: isCur ? col : col.withValues(alpha: 0.75)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      c.save();
      c.translate(math.cos(mid) * nr, math.sin(mid) * nr);
      c.rotate(-rotation + mid + math.pi / 2);
      tp.paint(c, Offset(-tp.width / 2, -tp.height / 2));
      c.restore();
    }

    c.restore(); // undo rotation

    // Specular rim
    c.drawArc(
      Rect.fromCircle(center: const Offset(_cx, _cy), radius: _R + 1),
      -math.pi * 1.1, math.pi * 0.55, false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Center hub
    c.drawCircle(const Offset(_cx, _cy), _inner,
        Paint()..color = const Color(0xFFFDF4EC));
    c.drawCircle(const Offset(_cx, _cy), _inner - 1,
        Paint()
          ..shader = const RadialGradient(
            center: Alignment(-0.3, -0.3),
            colors: [Colors.white, Color(0xFFFDF4EC)],
          ).createShader(Rect.fromCircle(
              center: Offset(_cx, _cy), radius: _inner)));
    c.drawCircle(const Offset(_cx, _cy), _inner,
        Paint()
          ..color = kPlum.withValues(alpha: 0.14)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    // Pointer needle (fixed, rotates counter to wheel)
    final dayAng = (day / 28) * 2 * math.pi - math.pi / 2;
    c.drawLine(
      Offset(_cx + math.cos(dayAng) * (_inner + 2),
          _cy + math.sin(dayAng) * (_inner + 2)),
      Offset(_cx + math.cos(dayAng) * (_cellR + 6),
          _cy + math.sin(dayAng) * (_cellR + 6)),
      Paint()
        ..color = kPlum.withValues(alpha: 0.82)
        ..strokeWidth = 2.8
        ..strokeCap = StrokeCap.round,
    );
    c.drawCircle(
      Offset(_cx + math.cos(dayAng) * (_cellR + 6),
          _cy + math.sin(dayAng) * (_cellR + 6)),
      6, Paint()..color = kPlum,
    );
    c.drawCircle(
      Offset(_cx + math.cos(dayAng) * (_cellR + 6),
          _cy + math.sin(dayAng) * (_cellR + 6)),
      2.2, Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_Pro3DCycleWheelPainter o) =>
      o.day != day || o.sel != sel || o.rotation != rotation;
}
