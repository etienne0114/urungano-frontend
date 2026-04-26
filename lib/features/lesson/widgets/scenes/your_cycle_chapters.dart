import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../lesson_animation_primitives.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// DISPATCHER
// ═══════════════════════════════════════════════════════════════════════════════
class YourCycleChapterAnimation extends StatelessWidget {
  const YourCycleChapterAnimation({required this.chapterIndex, super.key});
  final int chapterIndex;

  @override
  Widget build(BuildContext context) => switch (chapterIndex) {
        0 => const Ch0WhatIsMenstruation(),
        1 => const Ch1UterusAndOvaries(),
        2 => const Ch2TheFourPhases(),
        3 => const Ch3CrampsAndPain(),
        4 => const Ch4TrackingYourCycle(),
        5 => const Ch5CommonMyths(),
        _ => const SizedBox.shrink(),
      };
}

// ─── Canvas scaling ─────────────────────────────────────────────────────────
// All scenes are designed at 900×480 logical px and scaled to fit any parent.
const double _cW = 900.0, _cH = 480.0;

Widget _stage(Widget child) => LayoutBuilder(builder: (_, box) {
      final pw = box.maxWidth.isFinite  ? box.maxWidth  : _cW;
      final ph = box.maxHeight.isFinite ? box.maxHeight : _cH;
      final s  = math.min(pw / _cW, ph / _cH);
      return SizedBox(
        width: pw, height: ph,
        child: ClipRect(
          child: Transform.scale(
            scale: s, alignment: Alignment.topLeft,
            child: SizedBox(width: _cW, height: _cH, child: child),
          ),
        ),
      );
    });

// ─── Medical palette ─────────────────────────────────────────────────────────
const _myometrium  = Color(0xFFD94A68);
const _myoDark     = Color(0xFFC0304F);
const _endoLight   = Color(0xFFFFE0EA);
const _cervixCol   = Color(0xFF9E2244);
const _ovaryCol    = Color(0xFFE8A050);
const _ovaryLight  = Color(0xFFFDCE8A);
const _tubeCol     = Color(0xFFF5C6A5);
const _tubeDark    = Color(0xFFE8A87C);
const _bloodRed    = Color(0xFFC8203C);
const _corpusYel   = Color(0xFFE8C040);
const _bgCream     = Color(0xFFFDF4EC);
const _bgPink      = Color(0xFFFFF0F4);
const _leaderCol   = Color(0xFF8A6070);

// ─── Shared label helper (canvas) ───────────────────────────────────────────
void _canvasLabel(Canvas c, String text, Offset dot, Offset end,
    {double sz = 10.5, bool right = true}) {
  final p = Paint()..color = _leaderCol..strokeWidth = 0.9;
  c.drawCircle(dot, 2.8, Paint()..color = _leaderCol..style = PaintingStyle.fill);
  c.drawLine(dot, end, p);

  final tp = TextPainter(
    text: TextSpan(
        text: text,
        style: TextStyle(
            fontSize: sz, color: const Color(0xFF2A1A1F),
            fontWeight: FontWeight.w500, height: 1.2)),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: 140);
  tp.paint(c, Offset(right ? end.dx + 3 : end.dx - tp.width - 3, end.dy - tp.height / 2));
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED UTERUS PAINTER — medically accurate cross-section (centered)
// cx/cy are passed in so each chapter can place the figure freely.
// ═══════════════════════════════════════════════════════════════════════════════
class UterusPainter extends CustomPainter {
  const UterusPainter({
    this.cx = 450, this.cy = 240,
    this.endoThickness = 8.0, this.phase = 0,
    this.t = 0.0, this.bleed = 0.0,
    this.rotateY = 0.0, this.glowIdx = -1,
    this.showLabels = false, this.scale = 1.0,
  });

  final double cx, cy, endoThickness, t, bleed, rotateY, scale;
  final int phase, glowIdx;
  final bool showLabels;

  double get _sc => math.cos(rotateY * math.pi / 180).abs().clamp(0.3, 1.0) * scale;

  @override
  void paint(Canvas c, Size s) {
    final sc = _sc;
    _shadow(c, sc);
    _vagina(c, sc);
    _cervix(c, sc);
    _body(c, sc);
    _tubes(c, sc);
    _ovaries(c, sc);
    _endometrium(c, sc);
    if (bleed > 0) _bleeding(c);
    _specular(c, sc);
    if (showLabels) _labels(c, sc, s.width);
  }

  void _shadow(Canvas c, double sc) => c.drawOval(
        Rect.fromCenter(
            center: Offset(cx + 5, cy + 210 * scale), width: 250 * sc, height: 20 * scale),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.09)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );

  void _vagina(Canvas c, double sc) {
    final p = Path()
      ..moveTo(cx - 20 * sc, cy + 192 * scale)
      ..cubicTo(cx - 24 * sc, cy + 225 * scale, cx - 21 * sc, cy + 275 * scale,
          cx - 17 * sc, cy + 310 * scale)
      ..lineTo(cx + 17 * sc, cy + 310 * scale)
      ..cubicTo(cx + 21 * sc, cy + 275 * scale, cx + 24 * sc, cy + 225 * scale,
          cx + 20 * sc, cy + 192 * scale)
      ..close();
    c.drawPath(p, Paint()..color = const Color(0xFFF0A0B8));
    c.drawPath(p, Paint()
      ..color = _myoDark.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke..strokeWidth = 1.0);
  }

  void _cervix(Canvas c, double sc) {
    if (glowIdx == 3) {
      c.drawOval(
          Rect.fromCenter(
              center: Offset(cx, cy + 175 * scale),
              width: 68 * sc, height: 56 * scale),
          Paint()
            ..color = _cervixCol.withValues(alpha: 0.25)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    }
    c.drawOval(
        Rect.fromCenter(
            center: Offset(cx, cy + 175 * scale),
            width: 56 * sc, height: 52 * scale),
        Paint()..color = _cervixCol);
    c.drawOval(
        Rect.fromCenter(
            center: Offset(cx, cy + 175 * scale),
            width: 17 * sc, height: 40 * scale),
        Paint()..color = _endoLight);
  }

  void _body(Canvas c, double sc) {
    final outer = _uPath(sc, inflate: 9);
    c.drawPath(outer, Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.15, -0.25), radius: 1.3,
        colors: const [Color(0xFFF5C6C0), _myoDark],
      ).createShader(Rect.fromCenter(
          center: Offset(cx, cy), width: 320 * scale, height: 360 * scale)));

    final myo = _uPath(sc);
    c.drawPath(myo, Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.25, -0.3), radius: 1.1,
        colors: [_endoLight, _myometrium, _myoDark],
      ).createShader(Rect.fromCenter(
          center: Offset(cx, cy), width: 290 * scale, height: 340 * scale)));
    c.drawPath(myo, Paint()
      ..color = _myoDark
      ..style = PaintingStyle.stroke..strokeWidth = 1.8);
    c.drawPath(outer, Paint()
      ..color = _myoDark.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke..strokeWidth = 0.8);
  }

  void _tubes(Canvas c, double sc) {
    final paint = Paint()
      ..color = _tubeCol..style = PaintingStyle.stroke
      ..strokeWidth = 20 * scale..strokeCap = StrokeCap.round;
    final outline = Paint()
      ..color = _tubeDark..style = PaintingStyle.stroke
      ..strokeWidth = 21 * scale..strokeCap = StrokeCap.round;
    for (final side in [-1.0, 1.0]) {
      final bx = cx + side * 98 * sc;
      final ex = cx + side * 220 * sc;
      final wave = math.sin(t * math.pi * 2 + side) * 4 * scale;
      final path = Path()
        ..moveTo(bx, cy - 108 * scale)
        ..quadraticBezierTo(
            cx + side * 165 * sc, cy - 130 * scale + wave, ex, cy - 90 * scale);
      c.drawPath(path, outline);
      c.drawPath(path, paint);

      // fimbriae
      for (int f = 0; f < 8; f++) {
        final base = (side < 0 ? math.pi : 0.0);
        final ang = base + (f / 7) * math.pi * 0.9 - math.pi * 0.45;
        c.drawPath(
          Path()
            ..moveTo(ex, cy - 90 * scale)
            ..quadraticBezierTo(
              ex + math.cos(ang) * 12 * scale, cy - 90 * scale + math.sin(ang) * 12 * scale,
              ex + math.cos(ang) * 22 * scale, cy - 90 * scale + math.sin(ang) * 22 * scale),
          Paint()
            ..color = _tubeDark..style = PaintingStyle.stroke
            ..strokeWidth = 1.5 * scale..strokeCap = StrokeCap.round,
        );
      }

      if (glowIdx == 1) {
        c.drawPath(path, Paint()
          ..color = kSage.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke..strokeWidth = 28 * scale
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      }
    }
  }

  void _ovaries(Canvas c, double sc) {
    for (final side in [-1.0, 1.0]) {
      final ox = cx + side * 228 * sc;
      final oy = cy - 72 * scale;
      if (glowIdx == 0 || phase == 2) {
        c.drawOval(
            Rect.fromCenter(center: Offset(ox, oy), width: 66 * scale, height: 52 * scale),
            Paint()
              ..color = _ovaryCol.withValues(alpha: 0.3)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
      }
      c.drawOval(
          Rect.fromCenter(center: Offset(ox, oy), width: 50 * scale, height: 40 * scale),
          Paint()..shader = RadialGradient(
            center: const Alignment(-0.3, -0.35), radius: 1.0,
            colors: [_ovaryLight, _ovaryCol],
          ).createShader(Rect.fromCenter(
              center: Offset(ox, oy), width: 50 * scale, height: 40 * scale)));
      c.drawOval(
          Rect.fromCenter(center: Offset(ox, oy), width: 50 * scale, height: 40 * scale),
          Paint()
            ..color = _tubeDark.withValues(alpha: 0.6)
            ..style = PaintingStyle.stroke..strokeWidth = 1.2);

      for (int f = 0; f < 4; f++) {
        final fa = f * math.pi * 0.5 + math.pi * 0.25;
        final fR = (f == 2 && (phase == 1 || phase == 2)) ? 8.0 : 4.0;
        c.drawCircle(
          Offset(ox + math.cos(fa) * 12 * scale, oy + math.sin(fa) * 8 * scale),
          fR * scale,
          Paint()..shader = RadialGradient(colors: [Colors.white70, _ovaryLight])
              .createShader(Rect.fromCenter(
                  center: Offset(ox + math.cos(fa) * 12 * scale,
                      oy + math.sin(fa) * 8 * scale),
                  width: fR * 2 * scale, height: fR * 2 * scale)),
        );
      }
      if (phase == 3) {
        c.drawCircle(Offset(ox + 8 * scale, oy - 5 * scale),
            7 * scale, Paint()..color = _corpusYel);
      }
    }
  }

  void _endometrium(Canvas c, double sc) {
    final thick = endoThickness.clamp(2.0, 28.0) * scale;
    final endoColor = switch (phase) {
      0 => _bloodRed.withValues(alpha: 0.85),
      1 => const Color(0xFFF8B8C8).withValues(alpha: 0.7),
      2 => const Color(0xFFF8B8C8),
      _ => const Color(0xFFF8B8C8).withValues(alpha: 0.95),
    };

    final inner = _innerPath(sc);
    c.drawPath(inner, Paint()
      ..color = endoColor..style = PaintingStyle.stroke
      ..strokeWidth = thick..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);
    c.drawPath(inner, Paint()
      ..color = (phase == 0 ? _bloodRed : _endoLight).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill);

    if ((phase == 2 || phase == 3) && t > 0) {
      for (int i = 0; i < 3; i++) {
        final wave = (t * 2 + i * 0.9) % 2.0;
        if (wave < 1.5) {
          c.drawPath(inner, Paint()
            ..color = _myometrium.withValues(alpha: (1 - wave / 1.5) * 0.18)
            ..style = PaintingStyle.stroke..strokeWidth = 4 + wave * 10);
        }
      }
    }

    if (glowIdx == 2) {
      c.drawPath(inner, Paint()
        ..color = kRose.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke..strokeWidth = thick + 8
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
    }
  }

  void _bleeding(Canvas c) {
    final rng = math.Random(7);
    for (int i = 0; i < (bleed * 12).round(); i++) {
      c.drawOval(
        Rect.fromCenter(
            center: Offset(cx + (rng.nextDouble() - 0.5) * 16 * scale,
                cy + 192 * scale + rng.nextDouble() * 60 * scale),
            width: 5 * scale, height: 8 * scale),
        Paint()..color = _bloodRed.withValues(alpha: 0.55 + rng.nextDouble() * 0.35),
      );
    }
  }

  void _specular(Canvas c, double sc) {
    c.drawPath(
      _uPath(sc),
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.5, -0.55), radius: 0.45,
          colors: [Colors.white.withValues(alpha: 0.28), Colors.transparent],
        ).createShader(Rect.fromCenter(
            center: Offset(cx - 42 * scale, cy - 82 * scale),
            width: 120 * scale, height: 100 * scale))
        ..style = PaintingStyle.fill,
    );
  }

  void _labels(Canvas c, double sc, double canvasWidth) {
    final rightX = canvasWidth - 14;
    final leftX = 14.0;

    void r(String label, double dot1x, double dot1y, double endY) =>
        _canvasLabel(c, label, Offset(cx + dot1x * sc, cy + dot1y * scale),
            Offset(rightX, cy + endY * scale), right: true);
    void l(String label, double dot1x, double dot1y, double endY) =>
        _canvasLabel(c, label, Offset(cx + dot1x * sc, cy + dot1y * scale),
            Offset(leftX, cy + endY * scale), right: false);

    r('Fallopian tube',  162,  -118, -150);
    r('Uterine fundus',  22,   -142, -185);
    r('Ovary',           222,  -72,  -90 );
    r('Endometrium',     30,    0,    10 );
    r('Myometrium',      80,   45,    65 );
    r('Cervix',          28,   175,  175 );
    r('Vagina',          16,   250,  245 );
    l('Broad ligament', -88,  -80,  -65 );
    l('Ovarian lig.',   -148, -55,  -25 );
    l('Perimetrium',    -102,  10,   30 );
  }

  Path _uPath(double sc, {double inflate = 0}) {
    final i = inflate * scale;
    return Path()
      ..moveTo(cx - (112 + i) * sc, cy - (108 + i) * scale)
      ..cubicTo(cx - (150 + i) * sc, cy - 50 * scale,
          cx - (136 + i) * sc, cy + 28 * scale,
          cx - (102 + i) * sc, cy + 148 * scale)
      ..quadraticBezierTo(cx - 56 * sc, cy + (190 + i) * scale,
          cx, cy + (202 + i) * scale)
      ..quadraticBezierTo(cx + 56 * sc, cy + (190 + i) * scale,
          cx + (102 + i) * sc, cy + 148 * scale)
      ..cubicTo(cx + (136 + i) * sc, cy + 28 * scale,
          cx + (150 + i) * sc, cy - 50 * scale,
          cx + (112 + i) * sc, cy - (108 + i) * scale)
      ..quadraticBezierTo(cx + 66 * sc, cy - (150 + i) * scale,
          cx, cy - (138 + i) * scale)
      ..quadraticBezierTo(cx - 66 * sc, cy - (150 + i) * scale,
          cx - (112 + i) * sc, cy - (108 + i) * scale)
      ..close();
  }

  Path _innerPath(double sc) => Path()
    ..moveTo(cx - 64 * sc, cy - 56 * scale)
    ..cubicTo(cx - 86 * sc, cy - 10 * scale, cx - 82 * sc, cy + 68 * scale,
        cx - 52 * sc, cy + 122 * scale)
    ..quadraticBezierTo(cx, cy + 148 * scale, cx + 52 * sc, cy + 122 * scale)
    ..cubicTo(cx + 82 * sc, cy + 68 * scale, cx + 86 * sc, cy - 10 * scale,
        cx + 64 * sc, cy - 56 * scale)
    ..quadraticBezierTo(cx + 33 * sc, cy - 100 * scale, cx, cy - 86 * scale)
    ..quadraticBezierTo(cx - 33 * sc, cy - 100 * scale, cx - 64 * sc, cy - 56 * scale)
    ..close();

  @override
  bool shouldRepaint(UterusPainter o) =>
      o.endoThickness != endoThickness || o.phase != phase || o.t != t ||
      o.bleed != bleed || o.rotateY != rotateY || o.glowIdx != glowIdx ||
      o.showLabels != showLabels || o.scale != scale;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CH 0 — What is menstruation?
// Large centered uterus. Phase info as BOTTOM STRIP — no card over the figure.
// ═══════════════════════════════════════════════════════════════════════════════
class Ch0WhatIsMenstruation extends StatefulWidget {
  const Ch0WhatIsMenstruation({super.key});
  @override State<Ch0WhatIsMenstruation> createState() => _Ch0State();
}

class _Ch0State extends State<Ch0WhatIsMenstruation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  int _selPhase = 0;
  bool _panels = false;

  static const _phases = [
    _PD('Menstrual',   'Days 1–5',   kRose,      3.0, 0.8,
        'The endometrial lining sheds. Prostaglandins cause uterine contractions. Hormone levels are at their lowest point in the cycle.'),
    _PD('Follicular',  'Days 6–13',  kAmber,    10.0, 0.0,
        'FSH stimulates follicle growth. Rising oestrogen rebuilds the endometrium. Energy and mood often peak in this phase.'),
    _PD('Ovulation',   'Day 14',     kSage,     14.0, 0.0,
        'LH surge triggers egg release from the dominant follicle. Peak fertility. Cervical mucus becomes clear and stretchy.'),
    _PD('Luteal',      'Days 15–28', kRoseDark, 22.0, 0.0,
        'Corpus luteum secretes progesterone, maintaining the thickened endometrium. If no fertilisation, progesterone drops and menstruation begins.'),
  ];

  double get _day => _ctrl.value * 28;
  int get _autoPhase {
    final d = _day;
    if (d < 5) return 0; if (d < 13) return 1;
    if (d < 14) return 2; return 3;
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 18))
      ..addListener(() => setState(() {}))..repeat();
  }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final phase = _selPhase >= 0 ? _selPhase : _autoPhase;
    final pd = _phases[phase];

    return _stage(Stack(children: [
      // Background
      Container(decoration: BoxDecoration(gradient: LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [_bgCream, pd.color.withValues(alpha: 0.07)],
      ))),

      if (!_panels) ...[
        // ── FULL-WIDTH centered uterus ──────────────────────────
        Positioned.fill(
          bottom: 120,
          child: CustomPaint(
            painter: UterusPainter(
              cx: _cW / 2, cy: _cH * 0.44,
              endoThickness: pd.endoThick, phase: phase,
              t: _ctrl.value, bleed: pd.bleed * (phase == 0 ? 1.0 : 0.0),
              scale: 1.0,
            ),
          ),
        ),

        // Day badge top-left
        Positioned(top: 16, left: 18,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
            decoration: BoxDecoration(
              color: pd.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: pd.color, width: 1.5),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(
                  color: pd.color, shape: BoxShape.circle)),
              const SizedBox(width: 7),
              Text('Day ${_day.floor()} · ${pd.name}',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700,
                      color: pd.color)),
            ]),
          ),
        ),

        // Day timeline top-right
        Positioned(top: 20, right: 120, left: 180,
          child: _DayTimeline(day: _day),
        ),

        // Phase panels toggle top-right
        Positioned(top: 14, right: 16,
          child: GestureDetector(
            onTap: () => setState(() => _panels = true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6)],
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.grid_view_rounded, size: 13, color: kPlum),
                SizedBox(width: 5),
                Text('Phases', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kPlum)),
              ]),
            ),
          ),
        ),

        // ── BOTTOM INFO STRIP ─────────────────────────────────
        Positioned(bottom: 0, left: 0, right: 0,
          child: Container(
            height: 115,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.93),
              border: Border(top: BorderSide(color: pd.color.withValues(alpha: 0.25), width: 1.5)),
            ),
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
            child: Row(children: [
              // Description
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    Container(width: 9, height: 9, decoration: BoxDecoration(
                        color: pd.color, shape: BoxShape.circle)),
                    const SizedBox(width: 7),
                    Text(pd.name, style: TextStyle(fontFamily: 'Fraunces', fontSize: 14,
                        fontWeight: FontWeight.w700, color: pd.color)),
                    const SizedBox(width: 6),
                    Text(pd.days, style: const TextStyle(fontSize: 10, color: kInk60)),
                  ]),
                  const SizedBox(height: 4),
                  Text(pd.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, color: kPlum, height: 1.4)),
                ],
              )),
              const SizedBox(width: 16),
              // Hormone mini chart
              SizedBox(width: 170, height: 65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hormones', style: TextStyle(fontSize: 9,
                        letterSpacing: 0.8, color: kInk60, fontWeight: FontWeight.w600)),
                    Expanded(child: CustomPaint(
                        painter: _HormoneChart(day: _day, t: _ctrl.value))),
                    Row(children: const [
                      _Leg(kRose, 'Oestrogen'), SizedBox(width: 8),
                      _Leg(kSage, 'Prog.'), SizedBox(width: 8),
                      _Leg(kAmber, 'LH'),
                    ]),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Phase selector
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) => GestureDetector(
                  onTap: () => setState(() => _selPhase = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: phase == i ? _phases[i].color : _phases[i].color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(_phases[i].name, style: TextStyle(fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: phase == i ? Colors.white : _phases[i].color)),
                  ),
                )),
              ),
            ]),
          ),
        ),
      ] else ...[
        // ── 4-PANEL PHASE GRID ────────────────────────────────
        Positioned(top: 12, right: 16,
          child: GestureDetector(
            onTap: () => setState(() => _panels = false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: kPlum, borderRadius: BorderRadius.circular(100),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.close_rounded, size: 13, color: Colors.white),
                SizedBox(width: 5),
                Text('Close', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
              ]),
            ),
          ),
        ),
        Positioned.fill(top: 50,
          child: Row(
            children: List.generate(4, (i) => Expanded(
              child: _MiniPhasePanel(
                pd: _phases[i], idx: i, t: _ctrl.value,
                onTap: () => setState(() { _selPhase = i; _panels = false; }),
              ),
            )),
          ),
        ),
      ],
    ]));
  }
}

class _PD {
  const _PD(this.name, this.days, this.color, this.endoThick, this.bleed, this.description);
  final String name, days, description;
  final Color color;
  final double endoThick, bleed;
}

class _MiniPhasePanel extends StatelessWidget {
  const _MiniPhasePanel({required this.pd, required this.idx,
      required this.t, required this.onTap});
  final _PD pd;
  final int idx;
  final double t;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: pd.color.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [BoxShadow(color: pd.color.withValues(alpha: 0.12), blurRadius: 8)],
      ),
      child: Column(children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              color: pd.color.withValues(alpha: 0.05),
              child: CustomPaint(
                painter: UterusPainter(
                  cx: 100, cy: 140, endoThickness: pd.endoThick,
                  phase: idx, t: t, bleed: idx == 0 ? pd.bleed : 0, scale: 0.55),
                child: const SizedBox.expand()),
            ),
          ),
        ),
        Container(padding: const EdgeInsets.symmetric(vertical: 7), child: Column(children: [
          Text(pd.name, style: TextStyle(fontFamily: 'Fraunces', fontSize: 11,
              fontWeight: FontWeight.w700, color: pd.color)),
          Text(pd.days, style: const TextStyle(fontSize: 9, color: kInk60)),
        ])),
      ]),
    ),
  );
}

class _Leg extends StatelessWidget {
  const _Leg(this.color, this.label);
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 10, height: 2.5, color: color),
    const SizedBox(width: 3),
    Text(label, style: const TextStyle(fontSize: 8.5, color: kInk60)),
  ]);
}

class _HormoneChart extends CustomPainter {
  const _HormoneChart({required this.day, required this.t});
  final double day, t;
  @override
  void paint(Canvas c, Size s) {
    final prog = (day / 28).clamp(0.0, 1.0);
    const n = 60;
    double oe(double x) => 0.08 + (x < 0.5 ? math.pow(x * 2, 1.5) * 0.78 : 0.78 - (x - 0.5) * 0.6).toDouble();
    double pr(double x) => x > 0.52 ? math.pow((x - 0.52) * 2, 1.2).toDouble() * 0.75 : 0.04;
    double lh(double x) => 0.04 + math.exp(-math.pow((x - 0.47) * 11, 2)) * 0.9;

    void curve(double Function(double) fn, Color col) {
      final p = Path();
      for (int i = 0; i <= n; i++) {
        final xi = (i / n) * prog, x = (i / n) * s.width;
        final y = s.height - fn(xi) * s.height * 0.88;
        i == 0 ? p.moveTo(x, y) : p.lineTo(x, y);
      }
      c.drawPath(p, Paint()..color = col..strokeWidth = 1.8
          ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    }

    c.drawLine(Offset(0, s.height), Offset(s.width, s.height),
        Paint()..color = Colors.black.withValues(alpha: 0.07)..strokeWidth = 1);
    curve(oe, kRose); curve(pr, kSage); curve(lh, kAmber);

    final cx = prog * s.width;
    c.drawLine(Offset(cx, 0), Offset(cx, s.height),
        Paint()..color = kPlum.withValues(alpha: 0.3)..strokeWidth = 1.2);
  }
  @override
  bool shouldRepaint(_HormoneChart o) => o.day != day;
}

class _DayTimeline extends StatelessWidget {
  const _DayTimeline({required this.day});
  final double day;
  @override
  Widget build(BuildContext context) => SizedBox(height: 18,
    child: Row(children: List.generate(28, (i) {
      final c = i < 5 ? kRose : i < 13 ? kAmber : i == 13 ? kSage : kRoseDark;
      return Expanded(child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        height: i == day.floor() ? 16 : 7,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: i <= day.floor() ? c : c.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(3)),
      ));
    })),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// CH 1 — The uterus and ovaries
// Centered figure + labeled anatomy. Info appears as bottom slide-up strip.
// ═══════════════════════════════════════════════════════════════════════════════
class Ch1UterusAndOvaries extends StatefulWidget {
  const Ch1UterusAndOvaries({super.key});
  @override State<Ch1UterusAndOvaries> createState() => _Ch1State();
}

class _Ch1State extends State<Ch1UterusAndOvaries>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  double _rotY = 0, _dragStart = 0;
  int _glow = -1;

  static const _hs = [
    _HS(0, 'Ovaries', kAmber,
        'Each ovary is ~3 cm and contains 300,000+ primordial follicles. Each month FSH stimulates several to grow — usually one matures and releases an egg at ovulation.'),
    _HS(1, 'Fallopian tube', kSage,
        '~10 cm long with finger-like fimbriae that sweep the released egg inward. Fertilisation by sperm most often occurs in the outer third of the tube.'),
    _HS(2, 'Endometrium', kRose,
        'The inner mucosal lining. Thickness ranges from ~2 mm after menstruation to ~12 mm in the luteal phase. Shed as a period if no implantation occurs.'),
    _HS(3, 'Cervix', kRoseDark,
        'Lower narrow neck of the uterus. Produces mucus that changes throughout the cycle — clear and stretchy at ovulation, thick and opaque at other times.'),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..addListener(() => setState(() {}))..repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  // Hit-test anatomical areas (in logical 900×480 space)
  void _onTap(Offset pos) {
    const cx = 450.0, cy = 225.0;
    final d = (pos - Offset(cx, cy)).distance;

    // Ovaries
    if ((pos - Offset(cx - 228, cy - 72)).distance < 40 ||
        (pos - Offset(cx + 228, cy - 72)).distance < 40) {
      setState(() => _glow = _glow == 0 ? -1 : 0); return;
    }
    // Fallopian tubes (upper wing zone)
    if (pos.dy < cy - 80 && (pos.dx < cx - 100 || pos.dx > cx + 100)) {
      setState(() => _glow = _glow == 1 ? -1 : 1); return;
    }
    // Endometrium (inner body region)
    if (d < 85) { setState(() => _glow = _glow == 2 ? -1 : 2); return; }
    // Cervix
    if ((pos - Offset(cx, cy + 175)).distance < 38) {
      setState(() => _glow = _glow == 3 ? -1 : 3); return;
    }
    setState(() => _glow = -1);
  }

  @override
  Widget build(BuildContext context) {
    final autoY = math.sin(_ctrl.value * math.pi * 2) * 12;
    final totalY = _rotY + autoY;

    return _stage(Stack(children: [
      Container(decoration: const BoxDecoration(gradient: LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [_bgCream, Color(0xFFF8EAE0)],
      ))),

      // Hotspot dots legend (top strip)
      Positioned(top: 14, left: 0, right: 0,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.swipe_rounded, size: 12, color: kInk60),
          const SizedBox(width: 6),
          const Text('Drag to rotate', style: TextStyle(fontSize: 10, color: kInk60)),
          const SizedBox(width: 18),
          ..._hs.map((h) => GestureDetector(
            onTap: () => setState(() => _glow = _glow == h.id ? -1 : h.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: _glow == h.id ? h.color : h.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: h.color.withValues(alpha: 0.5)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('${h.id + 1}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                    color: _glow == h.id ? Colors.white : h.color)),
                const SizedBox(width: 4),
                Text(h.label, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600,
                    color: _glow == h.id ? Colors.white : h.color)),
              ]),
            ),
          )),
        ]),
      ),

      // Full canvas anatomy (centered)
      Positioned.fill(top: 40, bottom: _glow >= 0 ? 110 : 0,
        child: GestureDetector(
          onTapDown: (d) => _onTap(d.localPosition + const Offset(0, 40)),
          onHorizontalDragStart: (d) => _dragStart = d.localPosition.dx,
          onHorizontalDragUpdate: (d) {
            setState(() {
              _rotY += (d.localPosition.dx - _dragStart) * 0.35;
              _dragStart = d.localPosition.dx;
            });
          },
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0008)..rotateY(totalY * math.pi / 180),
            child: CustomPaint(
              painter: UterusPainter(
                cx: _cW / 2, cy: _cH * 0.46,
                endoThickness: 12, phase: 1,
                t: _ctrl.value, rotateY: totalY,
                glowIdx: _glow, showLabels: true,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),

      // Bottom info strip (slides up on hotspot tap)
      AnimatedPositioned(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        bottom: 0, left: 0, right: 0,
        height: _glow >= 0 ? 108 : 0,
        child: _glow >= 0
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.97),
                border: Border(top: BorderSide(color: _hs[_glow].color, width: 2)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(
                    color: _hs[_glow].color, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('${_hs[_glow].id + 1}', style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white))),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(_hs[_glow].label, style: TextStyle(fontFamily: 'Fraunces',
                      fontSize: 15, fontWeight: FontWeight.w700, color: _hs[_glow].color)),
                  const SizedBox(height: 3),
                  Text(_hs[_glow].detail, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, color: kPlum, height: 1.4)),
                ])),
                GestureDetector(
                  onTap: () => setState(() => _glow = -1),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, size: 14, color: kInk60),
                  ),
                ),
              ]),
            )
          : const SizedBox.shrink(),
      ),
    ]));
  }
}

class _HS {
  const _HS(this.id, this.label, this.color, this.detail);
  final int id;
  final String label, detail;
  final Color color;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CH 2 — The 4 phases
// Full-canvas wheel (left) + phase info right column (no overlap with wheel)
// ═══════════════════════════════════════════════════════════════════════════════
class Ch2TheFourPhases extends StatefulWidget {
  const Ch2TheFourPhases({super.key});
  @override State<Ch2TheFourPhases> createState() => _Ch2State();
}

class _Ch2State extends State<Ch2TheFourPhases>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  int _sel = 0;

  static const _phases = [
    _P2('Menstrual',  'Iminsi 1–5',  'Days 1–5',  5,  kRose,    'FSH ↓ LH ↓ Oestrogen ↓', 3.0,  0.8,
        'The endometrium sheds. Prostaglandins cause uterine contractions expelling the lining. Hormone levels reach their lowest point.'),
    _P2('Follicular', 'Iminsi 6–13', 'Days 6–13', 8,  kAmber,   'FSH ↑ Oestrogen ↑',       10.0, 0.0,
        'FSH stimulates several follicles. The dominant follicle produces oestrogen, rebuilding the endometrium and suppressing others.'),
    _P2('Ovulation',  'Ovulation',   'Day 14',    1,  kSage,    'LH surge · Oestrogen peak',14.0, 0.0,
        'LH surge triggers rupture of the dominant follicle, releasing the egg into the fallopian tube. Peak fertility.'),
    _P2('Luteal',     'Iminsi 15–28','Days 15–28',14, kRoseDark,'Progesterone ↑ Oestrogen ↑',22.0,0.0,
        'The corpus luteum produces progesterone, maintaining the endometrium. If no fertilisation, it degrades and the cycle restarts.'),
  ];

  double get _day => _ctrl.value * 28;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))
      ..addListener(() => setState(() {}))..repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  void _hitTest(Offset pos) {
    const cx = 260.0, cy = 240.0;
    final dx = pos.dx - cx, dy = pos.dy - cy;
    final dist = math.sqrt(dx * dx + dy * dy);
    if (dist < 68 || dist > 198) return;
    var ang = math.atan2(dy, dx) * 180 / math.pi + 90;
    if (ang < 0) ang += 360;
    final day = ang / 360 * 28;
    setState(() {
      if (day < 5) _sel = 0;
      else if (day < 13) _sel = 1;
      else if (day < 14) _sel = 2;
      else _sel = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ph = _phases[_sel];
    final tilt = math.sin(_ctrl.value * math.pi * 2) * 0.04;
    return _stage(Stack(children: [
      // Aurora phase-tinted background
      AnimatedContainer(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.4, -0.35),
            radius: 1.7,
            colors: [
              ph.color.withValues(alpha: 0.22),
              _bgPink,
              _bgCream,
            ],
            stops: const [0.0, 0.48, 1.0],
          ),
        ),
      ),
      // 3D-tilted wheel — left 58%
      Positioned(
        left: 0, top: 0, width: 530, bottom: 0,
        child: GestureDetector(
          onTapDown: (d) => _hitTest(d.localPosition),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0006)
              ..rotateX(tilt),
            child: CustomPaint(
              painter: _Pro3DWheelPainter(
                day: _day, sel: _sel,
                phases: _phases, t: _ctrl.value,
              ),
            ),
          ),
        ),
      ),
      // Professional phase strip — right panel
      Positioned(
        right: 10, top: 18, bottom: 12, width: 346,
        child: _ProPhaseStrip(ph: ph, sel: _sel, t: _ctrl.value),
      ),
      Positioned(
        bottom: 11, left: 18,
        child: Text(
          'Tap any phase on the wheel',
          style: TextStyle(
              fontSize: 10.5,
              color: kInk60.withValues(alpha: 0.62),
              fontWeight: FontWeight.w500),
        ),
      ),
    ]));
  }
}

class _P2 {
  const _P2(this.name, this.rw, this.days, this.daysN, this.color,
      this.hormones, this.endoThick, this.bleed, this.detail);
  final String name, rw, days, hormones, detail;
  final int daysN;
  final Color color;
  final double endoThick, bleed;
}

class _ProPhaseStrip extends StatelessWidget {
  const _ProPhaseStrip({
    required this.ph, required this.sel, required this.t,
  });
  final _P2 ph;
  final int sel;
  final double t;

  double _lvl(int h) => switch (h) {
    0 => switch (sel) { 0 => 0.28, 1 => 0.88, 2 => 0.42, _ => 0.28 },
    1 => sel == 2 ? 0.95 : 0.12,
    2 => sel == 3 ? 0.84 : 0.08,
    _ => switch (sel) { 0 => 0.12, 1 => 0.76, 2 => 0.96, _ => 0.62 },
  };

  @override
  Widget build(BuildContext context) {
    // Canvas is 900×480. Right panel: right:10, top:18, bottom:12, width:346
    // Available height = 480 - 18 - 12 = 450px
    // Phase card = 205px, gap = 10px, uterus panel = 235px  => total 450px
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Phase info card (fixed 205px)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOut,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                  begin: const Offset(0.06, 0), end: Offset.zero)
                  .animate(anim),
              child: child,
            ),
          ),
          child: SizedBox(
            key: ValueKey(sel),
            height: 205,
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              decoration: BoxDecoration(
                color: ph.color.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: ph.color.withValues(alpha: 0.38), width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: ph.color.withValues(alpha: 0.12),
                      blurRadius: 14, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(children: [
                      Container(
                          width: 9, height: 9,
                          decoration: BoxDecoration(
                              color: ph.color, shape: BoxShape.circle)),
                      const SizedBox(width: 7),
                      Text(ph.name,
                          style: TextStyle(
                              fontFamily: 'Fraunces', fontSize: 16,
                              fontWeight: FontWeight.w700, color: ph.color)),
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: ph.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(100)),
                        child: Text(ph.days,
                            style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: ph.color)),
                      ),
                    ]),
                    Text(ph.rw,
                        style:
                            const TextStyle(fontSize: 9.5, color: kInk60)),
                    const SizedBox(height: 5),
                    Text(ph.detail,
                        maxLines: 3, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: kPlum, height: 1.4)),
                    const SizedBox(height: 8),
                    // Hormone bars
                    const Text('HORMONE LEVELS',
                        style: TextStyle(
                            fontSize: 7.5, letterSpacing: 1.1,
                            color: kInk60, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    for (final (label, color, idx) in [
                      ('FSH', kSage, 0),
                      ('LH', kAmber, 1),
                      ('Progesterone', kRoseDark, 2),
                      ('Oestrogen', kRose, 3),
                    ]) ...
                    [
                      Row(children: [
                        SizedBox(
                            width: 74,
                            child: Text(label,
                                style: const TextStyle(
                                    fontSize: 9, color: kInk60))),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: _lvl(idx)),
                              duration: const Duration(milliseconds: 480),
                              curve: Curves.easeOut,
                              builder: (_, v, __) => LinearProgressIndicator(
                                value: v, minHeight: 5,
                                backgroundColor:
                                    Colors.black.withValues(alpha: 0.07),
                                valueColor: AlwaysStoppedAnimation(color),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 4),
                    ],
                  ]),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // ── Uterus panel (fixed 235px — remaining space)
        SizedBox(
          height: 235,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                color: ph.color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: ph.color.withValues(alpha: 0.18), width: 1.5),
              ),
              child: CustomPaint(
                painter: UterusPainter(
                  cx: 173, cy: 142,
                  endoThickness: ph.endoThick,
                  phase: [kRose, kAmber, kSage, kRoseDark]
                      .indexOf(ph.color),
                  t: t, bleed: ph.bleed, scale: 0.68),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Pro3DWheelPainter extends CustomPainter {
  const _Pro3DWheelPainter({
    required this.day, required this.sel,
    required this.phases, required this.t,
  });
  final double day, t;
  final int sel;
  final List<_P2> phases;

  static const _R = 155.0, _inner = 66.0, _cellR = 196.0;
  static const _days = [5, 8, 1, 14];

  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = s.height * 0.50;

    // ── Drop shadow
    c.drawOval(
      Rect.fromCenter(center: Offset(cx + 3, cy + _R + 10), width: _R * 2.0, height: 28),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // ── Phase sectors (radial-gradient, 3-D depth)
    double acc = 0;
    for (int p = 0; p < 4; p++) {
      final start = (acc / 28) * 2 * math.pi - math.pi / 2;
      acc += _days[p];
      final end = (acc / 28) * 2 * math.pi - math.pi / 2;
      final mid = (start + end) / 2;
      final isSel = sel == p;
      final rOut = isSel ? _R + 16.0 : _R;
      final col = phases[p].color;

      final arc = Path()
        ..moveTo(cx + math.cos(start) * _inner, cy + math.sin(start) * _inner)
        ..arcTo(Rect.fromCircle(center: Offset(cx, cy), radius: rOut),
            start, end - start, false)
        ..lineTo(cx + math.cos(end) * _inner, cy + math.sin(end) * _inner)
        ..arcTo(Rect.fromCircle(center: Offset(cx, cy), radius: _inner),
            end, start - end, false)
        ..close();

      // Radial gradient fill for 3-D depth
      c.drawPath(
        arc,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(0, -0.3),
            radius: 1.1,
            colors: [
              Color.lerp(col, Colors.white, 0.38)!,
              col,
              Color.lerp(col, Colors.black, 0.20)!,
            ],
            stops: const [0.0, 0.55, 1.0],
          ).createShader(
            Rect.fromCircle(center: Offset(cx, cy), radius: rOut),
          ),
      );

      // Glow halo for selected
      if (isSel) {
        c.drawPath(
          arc,
          Paint()
            ..color = col.withValues(alpha: 0.38)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 7
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }
      c.drawPath(arc,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.72)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.8);

      // Curved phase name
      _arcText(c, cx, cy, phases[p].name, mid, (rOut + _inner) / 2,
          rot: mid + math.pi / 2);
      // Days label nearer outer edge
      _arcText(c, cx, cy, phases[p].days, mid, rOut - 18,
          rot: mid + math.pi / 2, sz: 8.5,
          col: Colors.white.withValues(alpha: 0.85));
    }

    // ── Outer anatomy ring: 28 day cells
    for (int d = 0; d < 28; d++) {
      final ang  = (d / 28) * 2 * math.pi - math.pi / 2;
      final ang2 = ((d + 1) / 28) * 2 * math.pi - math.pi / 2;
      final mid  = (ang + ang2) / 2;
      final pi = d < 5 ? 0 : d < 13 ? 1 : d == 13 ? 2 : 3;
      final col  = phases[pi].color;
      final isCur = d == (day.floor() % 28);

      final cell = Path()
        ..moveTo(cx + math.cos(ang) * (_R + 3), cy + math.sin(ang) * (_R + 3))
        ..arcTo(Rect.fromCircle(center: Offset(cx, cy), radius: _cellR - 2),
            ang, ang2 - ang, false)
        ..lineTo(cx + math.cos(ang2) * (_R + 3), cy + math.sin(ang2) * (_R + 3))
        ..arcTo(Rect.fromCircle(center: Offset(cx, cy), radius: _R + 3),
            ang2, ang - ang2, false)
        ..close();

      c.drawPath(cell,
          Paint()..color = isCur ? Colors.white : col.withValues(alpha: 0.18));
      c.drawPath(cell,
          Paint()
            ..color = col.withValues(alpha: isCur ? 0.85 : 0.40)
            ..style = PaintingStyle.stroke
            ..strokeWidth = isCur ? 2.0 : 0.8);

      // Day number
      final nr = (_cellR - 2 + _R + 3) / 2;
      final tp = TextPainter(
        text: TextSpan(
          text: '${d + 1}',
          style: TextStyle(
            fontSize: 7.5,
            fontWeight: isCur ? FontWeight.w800 : FontWeight.w600,
            color: isCur ? col : col.withValues(alpha: 0.78),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      c.save();
      c.translate(cx + math.cos(mid) * nr, cy + math.sin(mid) * nr);
      c.rotate(mid + math.pi / 2);
      tp.paint(c, Offset(-tp.width / 2, -tp.height / 2));
      c.restore();

      // Anatomy glyph at midpoint of anatomy band
      _glyph(c, cx + math.cos(mid) * (_R + 14), cy + math.sin(mid) * (_R + 14), d, col, mid);
    }

    // ── Specular rim highlight (3-D light)
    c.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: _R + 1),
      -math.pi * 1.1, math.pi * 0.55, false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // ── Center hub
    c.drawCircle(Offset(cx, cy), _inner,
        Paint()..color = const Color(0xFFFDF4EC));
    // Gradient fill
    c.drawCircle(
      Offset(cx, cy), _inner - 1,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: [Colors.white, const Color(0xFFFDF4EC)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: _inner)),
    );
    c.drawCircle(Offset(cx, cy), _inner,
        Paint()
          ..color = kPlum.withValues(alpha: 0.14)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    // Hub uterus silhouette
    final uPaint = Paint()
      ..color = kRose.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final sc = 0.26;
    final ubody = Path()
      ..moveTo(cx - 44 * sc, cy - 108 * sc)
      ..cubicTo(cx - 58 * sc, cy - 50 * sc, cx - 52 * sc, cy + 28 * sc,
          cx - 40 * sc, cy + 148 * sc)
      ..quadraticBezierTo(cx, cy + 172 * sc, cx + 40 * sc, cy + 148 * sc)
      ..cubicTo(cx + 52 * sc, cy + 28 * sc, cx + 58 * sc, cy - 50 * sc,
          cx + 44 * sc, cy - 108 * sc)
      ..quadraticBezierTo(cx + 26 * sc, cy - 138 * sc, cx, cy - 126 * sc)
      ..quadraticBezierTo(cx - 26 * sc, cy - 138 * sc, cx - 44 * sc, cy - 108 * sc)
      ..close();
    c.drawPath(ubody, uPaint..color = kRose.withValues(alpha: 0.25));
    // Tubes
    for (final sd in [-1.0, 1.0]) {
      c.drawPath(
        Path()
          ..moveTo(cx + sd * 44 * sc, cy - 108 * sc)
          ..quadraticBezierTo(
              cx + sd * 68 * sc, cy - 118 * sc, cx + sd * 88 * sc, cy - 88 * sc),
        Paint()
          ..color = kRose.withValues(alpha: 0.22)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7 * sc
          ..strokeCap = StrokeCap.round,
      );
    }

    // Day text in hub
    final dayTxt = TextPainter(
      text: TextSpan(children: [
        const TextSpan(
          text: 'DAY\n',
          style: TextStyle(
              fontSize: 9, letterSpacing: 1.6,
              color: kInk60, fontWeight: FontWeight.w600),
        ),
        TextSpan(
          text: day.floor().toString().padLeft(2, '0'),
          style: const TextStyle(
              fontFamily: 'Fraunces', fontSize: 26,
              fontWeight: FontWeight.w700, color: kRose, height: 1.0),
        ),
      ]),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: _inner * 1.8);
    dayTxt.paint(c, Offset(cx - dayTxt.width / 2, cy - dayTxt.height / 2 + 4));

    // ── Day pointer needle (fixed bug: correct start offset)
    final dayAng = (day / 28) * 2 * math.pi - math.pi / 2;
    c.drawLine(
      Offset(cx + math.cos(dayAng) * (_inner + 2),
          cy + math.sin(dayAng) * (_inner + 2)),
      Offset(cx + math.cos(dayAng) * (_cellR + 7),
          cy + math.sin(dayAng) * (_cellR + 7)),
      Paint()
        ..color = kPlum.withValues(alpha: 0.85)
        ..strokeWidth = 2.8
        ..strokeCap = StrokeCap.round,
    );
    // Needle tip glow
    c.drawCircle(
      Offset(cx + math.cos(dayAng) * (_cellR + 7),
          cy + math.sin(dayAng) * (_cellR + 7)),
      6,
      Paint()
        ..color = kPlum.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    c.drawCircle(
      Offset(cx + math.cos(dayAng) * (_cellR + 7),
          cy + math.sin(dayAng) * (_cellR + 7)),
      5,
      Paint()..color = kPlum,
    );
    c.drawCircle(
      Offset(cx + math.cos(dayAng) * (_cellR + 7),
          cy + math.sin(dayAng) * (_cellR + 7)),
      2,
      Paint()..color = Colors.white,
    );
  }

  void _arcText(Canvas c, double cx, double cy, String text, double midAng,
      double radius, {required double rot, double sz = 12.5, Color? col}) {
    final chars = text.split('');
    if (chars.isEmpty) return;
    final span = (chars.length > 1 ? 1.4 / radius : 0.0);
    for (int i = 0; i < chars.length; i++) {
      final frac = chars.length == 1 ? 0.0 : (i / (chars.length - 1) - 0.5);
      final ang = midAng + frac * span * chars.length;
      final tp = TextPainter(
        text: TextSpan(
          text: chars[i],
          style: TextStyle(
            fontFamily: 'Fraunces', fontSize: sz,
            fontWeight: FontWeight.w700,
            color: col ?? Colors.white,
            shadows: const [Shadow(blurRadius: 3, color: Colors.black38)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      c.save();
      c.translate(cx + math.cos(ang) * radius, cy + math.sin(ang) * radius);
      c.rotate(ang + math.pi / 2);
      tp.paint(c, Offset(-tp.width / 2, -tp.height / 2));
      c.restore();
    }
  }

  void _glyph(Canvas c, double x, double y, int d, Color col, double ang) {
    c.save();
    c.translate(x, y);
    c.rotate(ang + math.pi / 2);
    if (d < 5) {
      // Menstrual – blood drop
      c.drawOval(Rect.fromCenter(center: Offset(0, 1), width: 5, height: 8),
          Paint()..color = kRose.withValues(alpha: 0.88));
    } else if (d < 13) {
      // Follicular – growing follicle
      final r = 2.5 + (d - 5) * 0.45;
      c.drawCircle(Offset.zero, r,
          Paint()
            ..color = kAmber.withValues(alpha: 0.35)
            ..style = PaintingStyle.fill);
      c.drawCircle(Offset.zero, r,
          Paint()
            ..color = kAmber.withValues(alpha: 0.8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2);
    } else if (d == 13) {
      // Ovulation – star burst
      for (int s = 0; s < 6; s++) {
        final sa = s * math.pi / 3;
        c.drawLine(Offset(math.cos(sa) * 1.5, math.sin(sa) * 1.5),
            Offset(math.cos(sa) * 6, math.sin(sa) * 6),
            Paint()
              ..color = kSage.withValues(alpha: 0.9)
              ..strokeWidth = 1.4
              ..strokeCap = StrokeCap.round);
      }
      c.drawCircle(Offset.zero, 2.8, Paint()..color = kSage);
    } else {
      // Luteal – corpus luteum shrinking
      final r = math.max(2.0, 5.5 - (d - 14) * 0.22);
      c.drawCircle(Offset.zero, r,
          Paint()..color = const Color(0xFFE8C040).withValues(alpha: 0.82));
      c.drawCircle(Offset.zero, r,
          Paint()
            ..color = const Color(0xFFD4A830)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1);
    }
    c.restore();
  }

  @override
  bool shouldRepaint(_Pro3DWheelPainter o) =>
      o.day != day || o.sel != sel || o.t != t;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CH 3 — Cramps & pain management
// Full-canvas uterus. Remedies shown as bottom horizontal button row.
// ═══════════════════════════════════════════════════════════════════════════════
class Ch3CrampsAndPain extends StatefulWidget {
  const Ch3CrampsAndPain({super.key});
  @override State<Ch3CrampsAndPain> createState() => _Ch3State();
}

class _Ch3State extends State<Ch3CrampsAndPain>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final Set<int> _active = {};

  static const _remedies = [
    (icon:'🌡', label:'Heat', detail:'Relaxes muscle spasm, increases blood flow. Apply 15–20 min.', color: Color(0xFFE8703A)),
    (icon:'💊', label:'Ibuprofen', detail:'NSAIDs inhibit prostaglandin synthesis. Take 1–2h before peak pain.', color: kSage),
    (icon:'🧘', label:'Exercise', detail:'Endorphins reduce pain by ~50%. Walk, yoga, or light stretching.', color: kAmber),
    (icon:'💧', label:'Hydration', detail:'Warm fluids reduce inflammation. Ginger and chamomile teas help.', color: Color(0xFF5B8DC8)),
  ];

  double get _pain => math.max(0.0, 1.0 - _active.length * 0.26);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..addListener(() => setState(() {}))..repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => _stage(Stack(children: [
    Container(decoration: BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color.lerp(_bgPink, Colors.white, _active.length * 0.25)!, _bgCream],
    ))),

    // Full-canvas uterus (centered)
    Positioned.fill(bottom: 120,
      child: CustomPaint(
        painter: _CrampPainter(t: _ctrl.value, pain: _pain, heatOn: _active.contains(0)),
      ),
    ),

    // Pain meter (top-left badge)
    Positioned(top: 16, left: 18,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Color.lerp(kRose, kSage, 1 - _pain)!.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Color.lerp(kRose, kSage, 1 - _pain)!.withValues(alpha: 0.45)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(_pain > 0.7 ? '😣' : _pain > 0.35 ? '😐' : '😊',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            const Text('Pain intensity', style: TextStyle(fontSize: 9, color: kInk60, fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            SizedBox(width: 100, height: 5, child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: _pain,
                backgroundColor: Colors.black.withValues(alpha: 0.07),
                valueColor: AlwaysStoppedAnimation(Color.lerp(kSage, kRose, _pain)!)),
            )),
          ]),
        ]),
      ),
    ),

    // Title (top-center)
    Positioned(top: 18, left: 0, right: 0,
      child: Center(child: Text('Cramps & pain',
          style: TextStyle(fontFamily: 'Fraunces', fontSize: 16,
              fontWeight: FontWeight.w700, color: kPlum.withValues(alpha: 0.7)))),
    ),

    // Bottom remedy row
    Positioned(bottom: 0, left: 0, right: 0,
      child: Container(
        height: 118,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          border: const Border(top: BorderSide(color: Color(0x1A2A1A1F), width: 1)),
        ),
        child: Row(
          children: _remedies.indexed.map((e) {
            final (i, r) = e;
            final on = _active.contains(i);
            return Expanded(child: GestureDetector(
              onTap: () => setState(() => on ? _active.remove(i) : _active.add(i)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(7),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: on ? r.color.withValues(alpha: 0.12) : const Color(0xFFF8F3F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: on ? r.color : Colors.black.withValues(alpha: 0.07),
                      width: on ? 2 : 1),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(r.icon, style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 4),
                  Text(r.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      color: on ? r.color : kPlum)),
                  if (on) ...[
                    const SizedBox(height: 2),
                    Text(r.detail, style: TextStyle(fontSize: 8.5, color: kInk60, height: 1.3),
                        textAlign: TextAlign.center, maxLines: 2),
                  ],
                ]),
              ),
            ));
          }).toList(),
        ),
      ),
    ),
  ]));
}

class _CrampPainter extends CustomPainter {
  const _CrampPainter({required this.t, required this.pain, required this.heatOn});
  final double t, pain;
  final bool heatOn;

  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = s.height * 0.50;
    final sq = 1.0 + math.sin(t * math.pi * 2) * 0.06 * pain;

    if (pain > 0.15) {
      c.drawCircle(Offset(cx, cy), 155 + math.sin(t * math.pi * 2) * 8 * pain,
          Paint()..color = kRose.withValues(alpha: 0.05 * pain)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28));
    }

    final body = Path()
      ..moveTo(cx - 112 * sq, cy - 108 / sq)
      ..cubicTo(cx - 148 * sq, cy - 50, cx - 132 * sq, cy + 30, cx - 102 * sq, cy + 152)
      ..quadraticBezierTo(cx - 56 * sq, cy + 192, cx, cy + 205)
      ..quadraticBezierTo(cx + 56 * sq, cy + 192, cx + 102 * sq, cy + 152)
      ..cubicTo(cx + 132 * sq, cy + 30, cx + 148 * sq, cy - 50, cx + 112 * sq, cy - 108 / sq)
      ..quadraticBezierTo(cx + 66 * sq, cy - 150 / sq, cx, cy - 136 / sq)
      ..quadraticBezierTo(cx - 66 * sq, cy - 150 / sq, cx - 112 * sq, cy - 108 / sq)
      ..close();

    c.drawPath(body, Paint()..shader = RadialGradient(
      center: const Alignment(-0.2, -0.3), radius: 1.2,
      colors: [
        Color.lerp(const Color(0xFFFFE0E8), Colors.white, 1 - pain)!,
        Color.lerp(_myometrium, const Color(0xFFFFCCD8), 1 - pain)!,
        Color.lerp(_myoDark, kRose.withValues(alpha: 0.6), 1 - pain)!,
      ],
    ).createShader(Rect.fromCenter(center: Offset(cx, cy), width: 290, height: 350)));
    c.drawPath(body, Paint()
      ..color = _myoDark.withValues(alpha: 0.4 + 0.5 * pain)
      ..style = PaintingStyle.stroke..strokeWidth = 2);

    for (final side in [-1.0, 1.0]) {
      c.drawPath(
        Path()..moveTo(cx + side * 112 * sq, cy - 108 / sq)
          ..quadraticBezierTo(cx + side * 182, cy - 128, cx + side * 218, cy - 90),
        Paint()..color = _tubeCol..style = PaintingStyle.stroke..strokeWidth = 18..strokeCap = StrokeCap.round);
      c.drawOval(Rect.fromCenter(center: Offset(cx + side * 225, cy - 72), width: 46, height: 36),
          Paint()..color = _ovaryCol);
    }

    if (pain > 0.05) {
      final rng = math.Random(42);
      for (int i = 0; i < (pain * 22).round(); i++) {
        final ang = rng.nextDouble() * math.pi * 2;
        final r = 28 + rng.nextDouble() * 95;
        final px = cx + math.cos(ang + t * math.pi * 0.8) * r;
        final py = cy + 22 + math.sin(ang + t * math.pi * 0.8) * r * 0.6;
        c.drawCircle(Offset(px, py), 2.5 + rng.nextDouble() * 2,
            Paint()..color = kRose.withValues(alpha: 0.6 * pain));
        c.drawLine(Offset(px, py), Offset(px + math.cos(t * 4) * 5, py + math.sin(t * 4) * 5),
            Paint()..color = _myoDark.withValues(alpha: 0.35 * pain)..strokeWidth = 1.1);
      }
    }

    if (heatOn) {
      for (int i = 0; i < 4; i++) {
        final wave = (t + i * 0.25) % 1.0;
        c.drawOval(
          Rect.fromCenter(center: Offset(cx, cy + 22), width: 65 + wave * 175, height: 42 + wave * 105),
          Paint()..color = const Color(0xFFE8703A).withValues(alpha: (1 - wave) * 0.2)
            ..style = PaintingStyle.stroke..strokeWidth = 2.5);
      }
    }

    if (pain > 0.3) {
      for (int i = 0; i < 3; i++) {
        final wave = (t * 1.5 + i * 0.7) % 2.5;
        if (wave < 1.8) {
          c.drawPath(body, Paint()
            ..color = _myoDark.withValues(alpha: (1 - wave / 1.8) * 0.13 * pain)
            ..style = PaintingStyle.stroke..strokeWidth = 4 + wave * 9);
        }
      }
    }
    c.drawOval(Rect.fromCenter(center: Offset(cx, cy + 205), width: 30, height: 38),
        Paint()..color = _cervixCol);
  }

  @override bool shouldRepaint(_CrampPainter o) =>
      o.t != t || o.pain != pain || o.heatOn != heatOn;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CH 4 — Tracking your cycle
// ═══════════════════════════════════════════════════════════════════════════════
class Ch4TrackingYourCycle extends StatefulWidget {
  const Ch4TrackingYourCycle({super.key});
  @override State<Ch4TrackingYourCycle> createState() => _Ch4State();
}

class _Ch4State extends State<Ch4TrackingYourCycle> {
  final Set<int> _period = {1, 2, 3, 4, 5};
  final int _ov = 14, _len = 28;

  bool _fert(int d) => d >= 11 && d <= 16;
  String _type(int d) {
    if (_period.contains(d)) return 'period';
    if (d == _ov) return 'ovulation';
    if (_fert(d)) return 'fertile';
    final n = _len + 1;
    if (d >= n && d <= n + 1) return 'predicted';
    return 'none';
  }
  Color _col(String t) => switch (t) {
    'period' => kRose, 'ovulation' => kSage,
    'fertile' => kAmber, 'predicted' => kRose.withValues(alpha: 0.35), _ => Colors.transparent,
  };
  String _emoji(String t) => switch (t) {
    'period' => '🩸', 'ovulation' => '🥚', 'fertile' => '🌱', 'predicted' => '🔮', _ => '',
  };

  @override
  Widget build(BuildContext context) => _stage(Stack(children: [
    Container(decoration: const BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_bgCream, _bgPink],
    ))),

    // Calendar — left 60%
    Positioned(left: 14, top: 14, right: 340, bottom: 14,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Your cycle calendar', style: TextStyle(fontFamily: 'Fraunces',
            fontSize: 18, fontWeight: FontWeight.w700, color: kPlum)),
        const Text('Tap any day to log your period',
            style: TextStyle(fontSize: 11, color: kInk60)),
        const SizedBox(height: 8),
        Row(children: ['M','T','W','T','F','S','S'].map((d) => Expanded(
          child: Center(child: Text(d, style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: kInk60))),
        )).toList()),
        const SizedBox(height: 4),
        Expanded(child: GridView.count(
          crossAxisCount: 7, crossAxisSpacing: 3, mainAxisSpacing: 3,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(35, (i) {
            final day = i + 1;
            final type = _type(day);
            final bg = _col(type);
            return GestureDetector(
              onTap: () => setState(() {
                if (_period.contains(day)) _period.remove(day);
                else if (type == 'none') _period.add(day);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                decoration: BoxDecoration(
                  color: bg == Colors.transparent
                      ? Colors.white.withValues(alpha: 0.7)
                      : bg.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: bg == Colors.transparent
                        ? Colors.black.withValues(alpha: 0.06)
                        : bg,
                    width: bg == Colors.transparent ? 1 : 1.5,
                  ),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (type != 'none') Text(_emoji(type),
                      style: const TextStyle(fontSize: 13)),
                  Text('$day', style: TextStyle(fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: type == 'none' ? kInk60 : kPlum)),
                ]),
              ),
            );
          }),
        )),
      ]),
    ),

    // Right stats column
    Positioned(right: 10, top: 14, bottom: 14, width: 318,
      child: Column(children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [kRose, kRoseDark]),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Next period predicted',
                style: TextStyle(fontSize: 11, color: Colors.white70)),
            const SizedBox(height: 4),
            Text('Day ${_len + 1}', style: const TextStyle(fontFamily: 'Fraunces',
                fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
            Text('in ${_len - (_period.isNotEmpty ? _period.reduce(math.max) : 5)} days',
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ]),
        ),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
          child: Column(children: [
            _s('Cycle length', '$_len days', '21–35 normal'),
            _s('Period length', '${_period.length} days', '3–7 normal'),
            _s('Ovulation', 'Day $_ov', '±2 days'),
            _s('Fertile window', 'Days 11–16', 'Sperm survives 5d'),
          ]),
        ),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12)),
          child: const Column(children: [
            _LR('🩸', 'Period · tap to log/remove'),
            _LR('🥚', 'Ovulation day (Day 14)'),
            _LR('🌱', 'Fertile window (Days 11–16)'),
            _LR('🔮', 'Predicted next period'),
          ]),
        ),
      ]),
    ),
  ]));

  Widget _s(String l, String v, String n) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      Expanded(child: Text(l, style: const TextStyle(fontSize: 11.5, color: kInk60))),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(v, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kPlum)),
        Text(n, style: const TextStyle(fontSize: 9, color: kInk60)),
      ]),
    ]),
  );
}

class _LR extends StatelessWidget {
  const _LR(this.e, this.l);
  final String e, l;
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(children: [
      Text(e, style: const TextStyle(fontSize: 15)),
      const SizedBox(width: 7),
      Text(l, style: const TextStyle(fontSize: 10.5, color: kInk60)),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// CH 5 — Common myths (flip cards)
// ═══════════════════════════════════════════════════════════════════════════════
class Ch5CommonMyths extends StatefulWidget {
  const Ch5CommonMyths({super.key});
  @override State<Ch5CommonMyths> createState() => _Ch5State();
}

class _Ch5State extends State<Ch5CommonMyths> with TickerProviderStateMixin {
  final List<AnimationController> _flips = [];
  final List<bool> _rev = List.filled(5, false);

  static const _cards = [
    _MC('You cannot exercise during your period.',
        'Exercise releases endorphins, increasing blood flow and reducing cramp pain. Walking, yoga, and swimming are all safe and beneficial.', '🏃‍♀️'),
    _MC('Period blood is dirty or impure.',
        'Menstrual fluid is a healthy mix of blood, endometrial tissue, mucus, and vaginal secretions — a normal biological process with no toxins.', '🩸'),
    _MC('You cannot get pregnant during your period.',
        'Sperm can survive 3–5 days in the reproductive tract. If ovulation follows soon after bleeding ends, pregnancy is possible.', '🤔'),
    _MC('Irregular periods always signal a health problem.',
        'Stress, diet changes, travel, and exercise all affect cycle timing. A range of 21–35 days is entirely normal. Only persistent irregularity warrants investigation.', '📅'),
    _MC('Period pain is just something to endure — nothing helps.',
        'NSAIDs (ibuprofen/naproxen), heat therapy, and light exercise are clinically proven to significantly reduce dysmenorrhoea.', '💊'),
  ];

  int get _busted => _rev.where((r) => r).length;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _cards.length; i++) {
      _flips.add(AnimationController(vsync: this,
          duration: const Duration(milliseconds: 480)));
    }
  }
  @override void dispose() { for (final c in _flips) c.dispose(); super.dispose(); }

  void _flip(int i) {
    if (_flips[i].status == AnimationStatus.completed) {
      _flips[i].reverse(); setState(() => _rev[i] = false);
    } else {
      _flips[i].forward(); setState(() => _rev[i] = true);
    }
  }

  @override
  Widget build(BuildContext context) => _stage(Stack(children: [
    Container(decoration: const BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [_bgCream, Color(0xFFF0F8F4)],
    ))),

    // Header
    Positioned(left: 20, top: 16, right: 20,
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('Myth busters', style: TextStyle(fontFamily: 'Fraunces',
              fontSize: 22, fontWeight: FontWeight.w700, color: kPlum)),
          Text('Tap a card to reveal the medical fact',
              style: TextStyle(fontSize: 11, color: kInk60)),
        ])),
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _busted == 5 ? kSage : _busted > 0
                ? kAmber.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: _busted == 5 ? kSage
                : _busted > 0 ? kAmber : Colors.black.withValues(alpha: 0.08)),
          ),
          child: Text(_busted == 5 ? '🎉 All busted!' : '$_busted / 5 busted',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                  color: _busted == 5 ? Colors.white : kPlum)),
        ),
      ]),
    ),

    // Cards — wrap grid
    Positioned(left: 12, top: 68, right: 12, bottom: 12,
      child: Wrap(spacing: 10, runSpacing: 10,
        children: List.generate(_cards.length, (i) => _FC(
          card: _cards[i], ctrl: _flips[i], rev: _rev[i], onTap: () => _flip(i),
        )),
      ),
    ),
  ]));
}

class _MC { const _MC(this.myth, this.fact, this.icon); final String myth, fact, icon; }

class _FC extends StatelessWidget {
  const _FC({required this.card, required this.ctrl, required this.rev, required this.onTap});
  final _MC card;
  final AnimationController ctrl;
  final bool rev;
  final VoidCallback onTap;

  static const _m = Color(0xFFC8425C);
  static const _f = kSage;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedBuilder(animation: ctrl, builder: (_, __) {
      final angle = ctrl.value * math.pi;
      final showFact = angle > math.pi / 2;
      final da = showFact ? angle - math.pi : angle;
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..setEntry(3, 2, 0.0018)..rotateY(da),
        child: Container(
          width: 266, height: 150,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: showFact ? _f : _m, width: 2),
            boxShadow: [BoxShadow(
                color: (showFact ? _f : _m).withValues(alpha: 0.13),
                blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(card.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (showFact ? _f : _m).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100)),
                child: Text(showFact ? 'FACT ✓' : 'MYTH ✗',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                        letterSpacing: 1, color: showFact ? _f : _m)),
              ),
            ]),
            const SizedBox(height: 8),
            Text(showFact ? card.fact : card.myth,
                style: const TextStyle(fontSize: 11.5, color: kPlum, height: 1.4),
                maxLines: 3, overflow: TextOverflow.ellipsis),
            const Spacer(),
            Text(showFact ? 'Tap again to see myth' : 'Tap to reveal fact',
                style: TextStyle(fontSize: 9,
                    color: (showFact ? _f : _m).withValues(alpha: 0.65),
                    fontWeight: FontWeight.w500)),
          ]),
        ),
      );
    }),
  );
}
