import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../lesson_animation_primitives.dart';
import '../lesson_animation_stage.dart';

/// Lesson 02 · HIV Prevention · 28s
/// Scene 1  0–7s   Virus approaches CD4 T-cell
/// Scene 2  7–14s  Replication inside the cell, DNA helix, copies emerge
/// Scene 3 14–21s  Prevention shield with 4 methods
/// Scene 4 21–28s  U=U — Undetectable = Untransmittable
class HIVLesson extends StatelessWidget {
  const HIVLesson({required this.t, super.key});
  final double t;

  String get _caption {
    if (t < 7)  return 'HIV is a virus. It enters the bloodstream and looks for a specific cell — the CD4 T-cell.';
    if (t < 14) return 'Once inside, the virus uses the cell to make copies of itself, weakening your immune system over time.';
    if (t < 21) return 'Prevention works. Condoms, PrEP, testing, and treatment as prevention all reduce risk to near zero.';
    return 'Undetectable equals untransmittable. With effective treatment, HIV cannot be passed on.';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.4, -0.4),
              radius: 1.5,
              colors: [Color(0xFFE0EBE5), Color(0xFFB6CFC4), kSage],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
        ),
        AmbientField(
          t: t,
          count: 24,
          colors: [
            kSage.withValues(alpha: 0.13),
            kPlum.withValues(alpha: 0.08),
            kRose.withValues(alpha: 0.08),
          ],
        ),

        SceneWindow(t: t, start: 0,    end: 7.3,  child: _HIVApproachScene(t: (t - 0).clamp(0, 7))),
        SceneWindow(t: t, start: 6.7,  end: 14.3, child: _HIVReplicationScene(t: (t - 6.7).clamp(0, 7.6))),
        SceneWindow(t: t, start: 13.7, end: 21.3, child: _HIVPreventionScene(t: (t - 13.7).clamp(0, 7.6))),
        SceneWindow(t: t, start: 20.7, end: 28,   child: _HIVUUScene(t: (t - 20.7).clamp(0, 7.3))),

        LessonHUD(
          title: 'HIV: how it works, how to stop it',
          sub: 'Lesson 02 · HIV & STI · 28s',
          caption: _caption,
          t: t,
          accent: kSage,
        ),
      ],
    );
  }
}

// ── Scene 1 · Virus approaches T-cell ────────────────────────────────────────
class _HIVApproachScene extends StatelessWidget {
  const _HIVApproachScene({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    const cx = 700.0, cy = 380.0;
    final virusX = lerp(t, [0, 5], [1100, cx + 80], Ease.inOutCubic);
    final tcellScale = 1.0 + math.sin(t * 1.2) * 0.015;

    return Stack(
      children: [
        // T-cell body
        Positioned(
          left: cx - 130,
          top: cy - 130,
          child: Transform.scale(
            scale: tcellScale,
            child: SizedBox(
              width: 260,
              height: 260,
              child: CustomPaint(painter: _TCellPainter(t: t)),
            ),
          ),
        ),

        // CD4 label
        Positioned(
          left: cx - 90,
          top: cy + 160,
          child: Opacity(
            opacity: math.min(1.0, t),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                  color: kPlum, borderRadius: BorderRadius.circular(100)),
              child: const Text('CD4 T-cell · immune system',
                  style: TextStyle(
                      color: kCream, fontSize: 12, fontWeight: FontWeight.w500)),
            ),
          ),
        ),

        // HIV virus
        _Virus3D(x: virusX, y: cy + math.sin(t * 2) * 15, size: 45, t: t),

        // "HIV virus" label
        Positioned(
          left: virusX - 30,
          top: cy - 80,
          child: Opacity(
            opacity: math.min(1.0, t / 0.5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: kRoseDark, borderRadius: BorderRadius.circular(100)),
              child: const Text('HIV virus',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5)),
            ),
          ),
        ),

        // Stats card on left
        Positioned(
          left: 60,
          top: 200,
          child: Opacity(
            opacity: math.min(1.0, t / 1.5),
            child: Container(
              width: 260,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xD92A1A1F),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('VIRUS STRUCTURE',
                      style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.5,
                          color: kPeach,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  const Text('gp120 spikes',
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kCream)),
                  const SizedBox(height: 6),
                  Text('Surface glycoprotein that binds to CD4 receptors on T-cells.',
                      style: TextStyle(
                          fontSize: 11,
                          color: kCream.withValues(alpha: 0.7),
                          height: 1.4)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TCellPainter extends CustomPainter {
  const _TCellPainter({required this.t});
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;

    // Outer cell body
    canvas.drawCircle(
      Offset(cx, cy),
      cx,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.4),
          radius: 1.2,
          colors: [Colors.white, Color(0xFFC8E0D6), kSage],
          stops: [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: cx))
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      cx,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Nucleus
    canvas.drawCircle(
      Offset(cx + 5, cy - 10),
      35,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.3),
          radius: 1.0,
          colors: [Color(0xFFE0EBE5), Color(0xFF5A8676)],
        ).createShader(Rect.fromCircle(center: Offset(cx + 5, cy - 10), radius: 35)),
    );

    // CD4 receptors (golden dots on surface)
    for (int i = 0; i < 14; i++) {
      final ang = (i / 14) * math.pi * 2 + t * 0.1;
      final rx = cx + math.cos(ang) * cx;
      final ry = cy + math.sin(ang) * cy;
      canvas.drawCircle(
        Offset(rx, ry),
        7,
        Paint()
          ..color = kAmber
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        Offset(rx, ry),
        7,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(_TCellPainter old) => old.t != t;
}

class _Virus3D extends StatelessWidget {
  const _Virus3D({required this.x, required this.y, required this.size, required this.t});
  final double x, y, size, t;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x - size,
      top:  y - size,
      child: Transform.rotate(
        angle: t * 0.52, // 30 deg/s in radians
        child: SizedBox(
          width: size * 2,
          height: size * 2,
          child: CustomPaint(painter: _VirusPainter(size: size)),
        ),
      ),
    );
  }
}

class _VirusPainter extends CustomPainter {
  const _VirusPainter({required this.size});
  final double size;

  @override
  void paint(Canvas canvas, Size sz) {
    final cx = sz.width / 2, cy = sz.height / 2;

    // Envelope
    canvas.drawCircle(
      Offset(cx, cy),
      size,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.45),
          radius: 1.1,
          colors: const [Color(0xFFFFC4D0), kRoseDark, Color(0xFF8A002F)],
          stops: const [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size)),
    );

    // Inner capsid
    canvas.drawCircle(
      Offset(cx, cy),
      size * 0.5,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 1.0,
          colors: const [Color(0xFF4A2F37), kPlum],
        ).createShader(
            Rect.fromCircle(center: Offset(cx, cy), radius: size * 0.5)),
    );

    // gp120 spikes
    final spikePaint = Paint()..color = kSageDark..style = PaintingStyle.fill;
    final knobPaint = Paint()..color = kSage..style = PaintingStyle.fill;
    for (int i = 0; i < 12; i++) {
      final ang = (i / 12) * math.pi * 2;
      final sx = cx + math.cos(ang) * size;
      final sy = cy + math.sin(ang) * size;
      canvas.save();
      canvas.translate(sx, sy);
      canvas.rotate(ang - math.pi / 2);
      final spike = Path()
        ..moveTo(-3, 0)
        ..lineTo(3, 0)
        ..lineTo(0, -14)
        ..close();
      canvas.drawPath(spike, spikePaint);
      canvas.drawCircle(const Offset(0, -14), 5, knobPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_VirusPainter old) => old.size != size;
}

// ── Scene 2 · Replication ─────────────────────────────────────────────────────
class _HIVReplicationScene extends StatelessWidget {
  const _HIVReplicationScene({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    const cx = 640.0, cy = 360.0;
    final phase = t < 2 ? 'enter' : t < 4 ? 'reverse' : 'replicate';

    return Stack(
      children: [
        // Large T-cell background
        Positioned(
          left: cx - 250,
          top:  cy - 250,
          child: Container(
            width: 500,
            height: 500,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment(-0.3, -0.3),
                radius: 1.2,
                colors: [Colors.white, Color(0xFFC8E0D6), kSage],
              ),
              boxShadow: [
                BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 80,
                    offset: Offset(0, 40)),
              ],
            ),
          ),
        ),

        // Phase 1: Virus entering
        if (phase == 'enter')
          _Virus3D(
            x: lerp(t, [0, 2], [cx + 400, cx], Ease.inQuad),
            y: cy,
            size: 40,
            t: t,
          ),

        // Phase 2 & 3: DNA helix
        if (phase != 'enter')
          CustomPaint(
            size: const Size(1280, 720),
            painter: _DNAHelixPainter(t: t, cx: cx, cy: cy),
          ),

        // Phase 3: New copies emerging
        if (phase == 'replicate')
          ...List.generate(6, (i) {
            final local = t - 4 - i * 0.2;
            if (local < 0) return const SizedBox.shrink();
            final ang = (i / 6) * math.pi * 2;
            final dist = lerp(local, [0, 3], [0, 280]);
            return _Virus3D(
              x: cx + math.cos(ang) * dist,
              y: cy + math.sin(ang) * dist,
              size: 20 + math.min(15, local * 8),
              t: local,
            );
          }),

        // Stat callout
        InfoCallout(
          label: 'REPLICATION',
          value: '10⁹ / day',
          sub: 'Without treatment, the virus makes a billion copies a day.',
          opacity: math.min(1.0, t / 1.5),
          right: 60,
          top: 200,
        ),
      ],
    );
  }
}

class _DNAHelixPainter extends CustomPainter {
  const _DNAHelixPainter({required this.t, required this.cx, required this.cy});
  final double t, cx, cy;

  @override
  void paint(Canvas canvas, Size size) {
    const samples = 20;
    final linePaint = Paint()
      ..color = kSage.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;
    final dotA = Paint()..color = kRose..style = PaintingStyle.fill;
    final dotB = Paint()..color = kAmber..style = PaintingStyle.fill;

    for (int i = 0; i < samples; i++) {
      final xi = i / (samples - 1);
      final xPos = cx - 100 + xi * 200;
      final yA = cy + math.sin(xi * math.pi * 4 + t) * 24;
      final yB = cy + math.sin(xi * math.pi * 4 + t + math.pi) * 24;
      canvas.drawLine(Offset(xPos, yA), Offset(xPos, yB), linePaint);
      canvas.drawCircle(Offset(xPos, yA), 4, dotA);
      canvas.drawCircle(Offset(xPos, yB), 4, dotB);
    }
  }

  @override
  bool shouldRepaint(_DNAHelixPainter old) => old.t != t;
}

// ── Scene 3 · Prevention ──────────────────────────────────────────────────────
class _HIVPreventionScene extends StatelessWidget {
  const _HIVPreventionScene({required this.t});
  final double t;

  static const methods = [
    (name: 'Condoms',  sub: '99% effective',       icon: '🛡', color: kRose),
    (name: 'PrEP',     sub: 'Daily pill, 99%+',    icon: '💊', color: kAmber),
    (name: 'Testing',  sub: 'Know your status',    icon: '🔬', color: kSage),
    (name: 'TasP',     sub: 'Treatment as prevention', icon: '⚕', color: kRoseDark),
  ];

  @override
  Widget build(BuildContext context) {
    const cx = 400.0, cy = 360.0;
    final shieldR = lerp(t, [0, 1.5], [50, 200], Ease.outBack);
    final virusOp = math.max(0.0, 1.0 - t * 0.15);

    return Stack(
      children: [
        // Central virus fading
        Opacity(
          opacity: virusOp,
          child: _Virus3D(x: cx, y: cy, size: 50, t: t),
        ),

        // Shield
        CustomPaint(
          size: const Size(1280, 720),
          painter: _ShieldPainter(t: t, cx: cx, cy: cy, shieldR: shieldR),
        ),

        // Prevention cards on the right
        Positioned(
          right: 60,
          top: 120,
          child: SizedBox(
            width: 380,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Four shields, all real',
                    style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: kPlum,
                        letterSpacing: -0.5)),
                const SizedBox(height: 16),
                ...List.generate(methods.length, (i) {
                  final op = lerp(t, [1.2 + i * 0.5, 1.7 + i * 0.5],
                      [0.0, 1.0]).clamp(0.0, 1.0);
                  final m = methods[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Opacity(
                      opacity: op,
                      child: Transform.translate(
                        offset: Offset((1 - op) * 40, 0),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: const Color(0x142A1A1F)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: m.color,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                        color: m.color.withValues(alpha: 0.4),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6))
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(m.icon,
                                    style: const TextStyle(fontSize: 22)),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(m.name,
                                        style: const TextStyle(
                                            fontFamily: 'Fraunces',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: kPlum)),
                                    Text(m.sub,
                                        style: const TextStyle(
                                            fontSize: 12, color: kInk60)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.check_rounded,
                                  color: kSage, size: 20),
                            ],
                          ),
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

class _ShieldPainter extends CustomPainter {
  const _ShieldPainter(
      {required this.t, required this.cx, required this.cy, required this.shieldR});
  final double t, cx, cy, shieldR;

  @override
  void paint(Canvas canvas, Size size) {
    // Filled shield bubble
    canvas.drawCircle(
      Offset(cx, cy),
      shieldR,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.2, -0.3),
          radius: 1.1,
          colors: [
            kSage.withValues(alpha: 0.5),
            kSage.withValues(alpha: 0.2),
            kPlum.withValues(alpha: 0.05),
          ],
        ).createShader(
            Rect.fromCircle(center: Offset(cx, cy), radius: shieldR)),
    );
    // Dashed border
    final dash = Paint()
      ..color = kSage
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    const dashCount = 24;
    for (int i = 0; i < dashCount; i++) {
      if (i % 2 == 0) {
        final a0 = (i / dashCount) * math.pi * 2;
        final a1 = ((i + 0.7) / dashCount) * math.pi * 2;
        canvas.drawArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: shieldR),
          a0, a1 - a0, false, dash,
        );
      }
    }

    // Pulse rings
    for (int i = 0; i < 3; i++) {
      final phase = (t * 0.8 + i * 0.4) % 2;
      final pOp = (2 - phase) / 2 * 0.5;
      canvas.drawCircle(
        Offset(cx, cy),
        200 + phase * 40,
        Paint()
          ..color = kSage.withValues(alpha: pOp)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_ShieldPainter old) =>
      old.t != t || old.shieldR != shieldR;
}

// ── Scene 4 · U=U ─────────────────────────────────────────────────────────────
class _HIVUUScene extends StatelessWidget {
  const _HIVUUScene({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    final scale = lerp(t, [0, 1.2], [0.5, 1.0], Ease.outBack);

    return Stack(
      children: [
        // Background particles
        ...List.generate(12, (i) {
          final ang = (i / 12) * math.pi * 2 + t * 0.3;
          final r = 280 + math.sin(t + i) * 20;
          return Particle(
            x: 640 + math.cos(ang) * r,
            y: 360 + math.sin(ang) * r,
            size: 6,
            color: kSage,
            opacity: math.min(1.0, t),
          );
        }),

        // U=U main text
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'U=U',
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 200 * scale,
                      fontWeight: FontWeight.w500,
                      color: kPlum,
                      letterSpacing: -8,
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Undetectable = Untransmittable',
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: kPlum,
                      letterSpacing: -1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: 600,
                    child: Text(
                      'When someone with HIV takes effective treatment, the virus '
                      'level becomes so low it cannot be passed to a partner. '
                      'Science. Not stigma.',
                      style: TextStyle(
                        fontSize: 16,
                        color: kInk60,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
