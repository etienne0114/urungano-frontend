import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../lesson_animation_primitives.dart';

// ─── Canvas ──────────────────────────────────────────────────────────────────
const double _cW = 900.0, _cH = 480.0;

Widget _stage(Widget child) => LayoutBuilder(builder: (_, box) {
      final pw = box.maxWidth.isFinite  ? box.maxWidth  : _cW;
      final ph = box.maxHeight.isFinite ? box.maxHeight : _cH;
      final s  = math.min(pw / _cW, ph / _cH);
      return SizedBox(width: pw, height: ph,
        child: ClipRect(child: Transform.scale(scale: s, alignment: Alignment.topLeft,
          child: SizedBox(width: _cW, height: _cH, child: child))));
    });

// ─── HIV palette ─────────────────────────────────────────────────────────────
const _bgDark    = Color(0xFF0D1F1A);
const _bgMid     = Color(0xFF1A3530);
const _cd4Green  = Color(0xFF7FA99B);
const _cd4Light  = Color(0xFFA8C5BA);
const _cd4Dark   = Color(0xFF4A7A6E);
const _hivRed    = Color(0xFFE85D75);
const _hivPink   = Color(0xFFFCE4E8);
const _spikeAmb  = Color(0xFFE8A050);
const _artBlue   = Color(0xFF4A90D9);

// ═══════════════════════════════════════════════════════════════════════════════
// DISPATCHER
// ═══════════════════════════════════════════════════════════════════════════════
class HivChapterAnimation extends StatelessWidget {
  const HivChapterAnimation({required this.chapterIndex, super.key});
  final int chapterIndex;

  @override
  Widget build(BuildContext context) => switch (chapterIndex) {
        0 => const HivCh0WhatIsHIV(),
        1 => const HivCh1HowItSpreads(),
        2 => const HivCh2Prevention(),
        3 => const HivCh3ArtAndUU(),
        4 => const HivCh3ArtAndUU(), // ch4 = testing → reuse UU scene
        _ => const SizedBox.shrink(),
      };
}

// ═══════════════════════════════════════════════════════════════════════════════
// CH 0 — What is HIV?
// 3D HIV virion with gp120 spikes approaching a CD4 T-cell. Tap to see details.
// ═══════════════════════════════════════════════════════════════════════════════
class HivCh0WhatIsHIV extends StatefulWidget {
  const HivCh0WhatIsHIV({super.key});
  @override State<HivCh0WhatIsHIV> createState() => _HivCh0State();
}

class _HivCh0State extends State<HivCh0WhatIsHIV>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  int _selected = -1; // -1=none, 0=gp120, 1=RNA core, 2=CD4 receptor

  static const _parts = [
    _Part('gp120 Spikes', _spikeAmb,
        'Surface glycoproteins that bind to CD4 receptors on T-cells. First point of contact between HIV and the immune system.'),
    _Part('RNA Core', kRose,
        'Two strands of RNA — the virus\'s genetic material — plus reverse transcriptase enzyme that converts RNA into DNA inside the host cell.'),
    _Part('CD4 T-cell', _cd4Green,
        'A white blood cell critical to the immune response. HIV specifically targets and destroys CD4 cells, gradually weakening immunity.'),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..addListener(() => setState(() {}))..repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = _ctrl.value;
    return _stage(Stack(clipBehavior: Clip.hardEdge, children: [
      // Dark background
      Container(decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.3, -0.3), radius: 1.4,
          colors: [_bgMid, _bgDark],
        ),
      )),

      // Ambient particles
      ..._ambientParticles(t),

      // CD4 T-cell (large, center-left)
      Positioned(left: 60, top: 80, child: GestureDetector(
        onTap: () => setState(() => _selected = _selected == 2 ? -1 : 2),
        child: CustomPaint(
          painter: _TcellPainter(t: t, glowing: _selected == 2),
          child: const SizedBox(width: 340, height: 320),
        ),
      )),

      // HIV virion (right side, slowly approaching)
      Positioned(right: 80, top: 110, child: GestureDetector(
        onTap: () => setState(() => _selected = _selected == 0 ? -1 : 0),
        child: CustomPaint(
          painter: _HivVirionPainter(t: t, glowSpikes: _selected == 0,
              glowCore: _selected == 1),
          child: const SizedBox(width: 220, height: 220),
        ),
      )),

      // RNA core tap zone
      Positioned(right: 148, top: 178, child: GestureDetector(
        onTap: () => setState(() => _selected = _selected == 1 ? -1 : 1),
        child: const SizedBox(width: 80, height: 80),
      )),

      // Top title
      Positioned(top: 18, left: 20,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('HIV Virus Structure',
              style: TextStyle(fontFamily: 'Fraunces', fontSize: 20,
                  fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 3),
          Text('Tap any structure to explore',
              style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5))),
        ]),
      ),

      // Part selector chips (top-right)
      Positioned(top: 16, right: 16,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(3, (i) => GestureDetector(
            onTap: () => setState(() => _selected = _selected == i ? -1 : i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _selected == i
                    ? _parts[i].color
                    : _parts[i].color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: _parts[i].color.withValues(alpha: 0.6)),
              ),
              child: Text(_parts[i].name,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      color: _selected == i ? Colors.white : _parts[i].color)),
            ),
          )),
        ),
      ),

      // Info bottom strip
      AnimatedPositioned(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        bottom: 0, left: 0, right: 0,
        height: _selected >= 0 ? 100 : 0,
        child: _selected >= 0
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: BoxDecoration(
                color: _parts[_selected].color.withValues(alpha: 0.12),
                border: Border(top: BorderSide(
                    color: _parts[_selected].color, width: 2)),
              ),
              child: Row(children: [
                Container(width: 38, height: 38,
                  decoration: BoxDecoration(color: _parts[_selected].color, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 18)),
                const SizedBox(width: 14),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_parts[_selected].name, style: TextStyle(fontFamily: 'Fraunces',
                        fontSize: 14, fontWeight: FontWeight.w700, color: _parts[_selected].color)),
                    const SizedBox(height: 3),
                    Text(_parts[_selected].detail, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8), height: 1.4)),
                  ],
                )),
                GestureDetector(onTap: () => setState(() => _selected = -1),
                  child: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.4), size: 18)),
              ]),
            )
          : const SizedBox.shrink(),
      ),
    ]));
  }

  List<Widget> _ambientParticles(double t) {
    return List.generate(18, (i) {
      final seed = i * 137.5;
      final x = (seed * 7.3) % _cW;
      final y = (seed * 4.1) % (_cH - 100);
      final drift = math.sin(t * math.pi * 2 + i * 0.7) * 25;
      return Positioned(
        left: x + drift,
        top: y + math.cos(t * math.pi * 1.5 + i) * 15,
        child: Container(
          width: 3 + (i % 3).toDouble(),
          height: 3 + (i % 3).toDouble(),
          decoration: BoxDecoration(
            color: (i % 3 == 0 ? _spikeAmb : i % 3 == 1 ? _cd4Green : _hivRed)
                .withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),
      );
    });
  }
}

class _Part {
  const _Part(this.name, this.color, this.detail);
  final String name, detail;
  final Color color;
}

class _TcellPainter extends CustomPainter {
  const _TcellPainter({required this.t, required this.glowing});
  final double t;
  final bool glowing;

  @override
  void paint(Canvas c, Size s) {
    final cx = s.width * 0.5, cy = s.height * 0.5;
    final pulse = 1.0 + math.sin(t * math.pi * 2) * 0.02;

    if (glowing) {
      c.drawCircle(Offset(cx, cy), 145 * pulse,
          Paint()..color = _cd4Green.withValues(alpha: 0.2)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15));
    }

    // Main body
    c.drawCircle(Offset(cx, cy), 130 * pulse,
        Paint()..shader = RadialGradient(
          center: const Alignment(-0.3, -0.35), radius: 1.0,
          colors: [Colors.white.withValues(alpha: 0.9), _cd4Light, _cd4Green],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 130)));
    c.drawCircle(Offset(cx, cy), 130 * pulse,
        Paint()..color = _cd4Dark.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke..strokeWidth = 2);

    // CD4 surface receptors
    for (int i = 0; i < 16; i++) {
      final ang = (i / 16) * math.pi * 2 + t * 0.15;
      final rx = cx + math.cos(ang) * 130 * pulse;
      final ry = cy + math.sin(ang) * 130 * pulse;
      c.drawCircle(Offset(rx, ry), 7,
          Paint()..color = _spikeAmb..style = PaintingStyle.fill);
      c.drawCircle(Offset(rx, ry), 7,
          Paint()..color = Colors.white.withValues(alpha: 0.4)
            ..style = PaintingStyle.stroke..strokeWidth = 1.5);
    }

    // Nucleus
    c.drawCircle(Offset(cx, cy), 45,
        Paint()..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3), radius: 1.0,
          colors: [_cd4Light, _cd4Dark],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 45)));
    c.drawCircle(Offset(cx, cy), 45,
        Paint()..color = _cd4Dark.withValues(alpha: 0.6)
          ..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Label
    final tp = TextPainter(
      text: TextSpan(text: 'CD4 T-cell',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.9))),
      textDirection: TextDirection.ltr)..layout();
    tp.paint(c, Offset(cx - tp.width / 2, cy + 148));

    final sub = TextPainter(
      text: TextSpan(text: 'Immune system guardian',
          style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.5))),
      textDirection: TextDirection.ltr)..layout();
    sub.paint(c, Offset(cx - sub.width / 2, cy + 164));
  }

  @override bool shouldRepaint(_TcellPainter o) => o.t != t || o.glowing != glowing;
}

class _HivVirionPainter extends CustomPainter {
  const _HivVirionPainter({required this.t, required this.glowSpikes,
      required this.glowCore});
  final double t;
  final bool glowSpikes, glowCore;

  @override
  void paint(Canvas c, Size s) {
    final cx = s.width * 0.5, cy = s.height * 0.5;
    final pulse = 1.0 + math.sin(t * math.pi * 2.5) * 0.03;

    // Outer glow
    if (glowSpikes) {
      c.drawCircle(Offset(cx, cy), 95 * pulse,
          Paint()..color = _hivRed.withValues(alpha: 0.25)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
    }

    // Viral envelope
    c.drawCircle(Offset(cx, cy), 82 * pulse,
        Paint()..shader = RadialGradient(
          center: const Alignment(-0.3, -0.35), radius: 1.0,
          colors: [_hivPink, _hivRed, const Color(0xFFA01830)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 82)));
    c.drawCircle(Offset(cx, cy), 82 * pulse,
        Paint()..color = Colors.white.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke..strokeWidth = 2);

    // gp120 spikes
    for (int i = 0; i < 14; i++) {
      final ang = (i / 14) * math.pi * 2 + t * 0.2;
      final sr = 82 * pulse;
      final sx = cx + math.cos(ang) * sr;
      final sy = cy + math.sin(ang) * sr;
      final ex = cx + math.cos(ang) * (sr + 18);
      final ey = cy + math.sin(ang) * (sr + 18);

      c.drawLine(Offset(sx, sy), Offset(ex, ey),
          Paint()..color = _spikeAmb..strokeWidth = 3.5..strokeCap = StrokeCap.round);
      c.drawCircle(Offset(ex, ey), 6,
          Paint()..color = glowSpikes ? _spikeAmb : _spikeAmb.withValues(alpha: 0.8));
    }

    // RNA core
    if (glowCore) {
      c.drawCircle(Offset(cx, cy), 32,
          Paint()..color = kRose.withValues(alpha: 0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    }
    c.drawCircle(Offset(cx, cy), 28,
        Paint()..color = const Color(0xFF8B1A2C));

    // RNA helix (simplified)
    for (int i = 0; i < 12; i++) {
      final ang = (i / 12) * math.pi * 2 + t * math.pi;
      c.drawCircle(
        Offset(cx + math.cos(ang) * 14, cy + math.sin(ang) * 8),
        3, Paint()..color = kRose.withValues(alpha: 0.8));
    }

    // Label
    final tp = TextPainter(
      text: TextSpan(text: 'HIV virus',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.9))),
      textDirection: TextDirection.ltr)..layout();
    tp.paint(c, Offset(cx - tp.width / 2, cy + 94));
  }

  @override bool shouldRepaint(_HivVirionPainter o) => o.t != t;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CH 1 — How HIV spreads
// Transmission routes diagram — tap each route to see risk level
// ═══════════════════════════════════════════════════════════════════════════════
class HivCh1HowItSpreads extends StatefulWidget {
  const HivCh1HowItSpreads({super.key});
  @override State<HivCh1HowItSpreads> createState() => _HivCh1State();
}

class _HivCh1State extends State<HivCh1HowItSpreads>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  int _sel = -1;

  static const _routes = [
    _Route('🩸', 'Blood', 'HIGH RISK', _hivRed,
        'Sharing needles or syringes directly introduces HIV into the bloodstream. Blood has the highest HIV concentration of any body fluid.'),
    _Route('💉', 'Injection', 'HIGH RISK', _hivRed,
        'Contaminated medical equipment or needles. All Rwanda public health facilities use sterile single-use syringes.'),
    _Route('🤝', 'Sexual contact', 'HIGH→LOW', const Color(0xFFE8703A),
        'Unprotected sex is the most common route. Risk varies by act: receptive anal sex is highest risk. Condoms reduce risk by >98%.'),
    _Route('🤱', 'Mother-to-child', 'PREVENTABLE', kAmber,
        'HIV can pass during pregnancy, birth, or breastfeeding. With ART started early, risk falls below 1%. Rwanda\'s PMTCT programme has achieved near-zero transmission.'),
    _Route('🤧', 'Saliva / Sweat', 'NO RISK', kSage,
        'HIV is NOT transmitted through saliva, tears, sweat, urine, or faeces. Sharing food, hugging, handshakes, and insect bites carry zero risk.'),
    _Route('🦟', 'Insect bites', 'NO RISK', kSage,
        'Mosquitoes and other insects cannot transmit HIV. The virus cannot survive or replicate inside an insect.'),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..addListener(() => setState(() {}))..repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return _stage(Stack(clipBehavior: Clip.hardEdge, children: [
      Container(decoration: const BoxDecoration(gradient: RadialGradient(
        center: Alignment(-0.2, -0.2), radius: 1.4,
        colors: [_bgMid, _bgDark],
      ))),

      // Title
      Positioned(top: 16, left: 20, child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('How HIV spreads', style: TextStyle(fontFamily: 'Fraunces',
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          Text('Tap a route to see transmission risk',
              style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5))),
        ],
      )),

      // Route cards grid
      Positioned(left: 16, top: 60, right: 16, bottom: _sel >= 0 ? 110 : 10,
        child: GridView.count(
          crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: List.generate(_routes.length, (i) {
            final r = _routes[i];
            final on = _sel == i;
            return GestureDetector(
              onTap: () => setState(() => _sel = _sel == i ? -1 : i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: on ? r.color.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: on ? r.color : Colors.white.withValues(alpha: 0.1),
                    width: on ? 2 : 1),
                  boxShadow: on ? [BoxShadow(color: r.color.withValues(alpha: 0.2), blurRadius: 12)] : [],
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(r.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 5),
                  Text(r.name, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.9))),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: r.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(r.risk, style: TextStyle(fontSize: 8.5,
                        fontWeight: FontWeight.w800, color: r.color, letterSpacing: 0.5)),
                  ),
                ]),
              ),
            );
          }),
        ),
      ),

      // Info strip
      AnimatedPositioned(
        duration: const Duration(milliseconds: 250), curve: Curves.easeOutCubic,
        bottom: 0, left: 0, right: 0,
        height: _sel >= 0 ? 108 : 0,
        child: _sel >= 0 ? Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: _routes[_sel].color.withValues(alpha: 0.1),
            border: Border(top: BorderSide(color: _routes[_sel].color, width: 2)),
          ),
          child: Row(children: [
            Text(_routes[_sel].emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(children: [
                Text(_routes[_sel].name, style: TextStyle(fontFamily: 'Fraunces',
                    fontSize: 14, fontWeight: FontWeight.w700, color: _routes[_sel].color)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: _routes[_sel].color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100)),
                  child: Text(_routes[_sel].risk, style: TextStyle(fontSize: 9,
                      fontWeight: FontWeight.w800, color: _routes[_sel].color)),
                ),
              ]),
              const SizedBox(height: 4),
              Text(_routes[_sel].detail, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8), height: 1.4)),
            ])),
            GestureDetector(onTap: () => setState(() => _sel = -1),
              child: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.35), size: 18)),
          ]),
        ) : const SizedBox.shrink(),
      ),
    ]));
  }
}

class _Route {
  const _Route(this.emoji, this.name, this.risk, this.color, this.detail);
  final String emoji, name, risk, detail;
  final Color color;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CH 2 — Prevention methods
// 4 prevention shields — interactive, animated particle effects
// ═══════════════════════════════════════════════════════════════════════════════
class HivCh2Prevention extends StatefulWidget {
  const HivCh2Prevention({super.key});
  @override State<HivCh2Prevention> createState() => _HivCh2State();
}

class _HivCh2State extends State<HivCh2Prevention>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final Set<int> _active = {0, 1, 2, 3}; // all on by default

  static const _methods = [
    _Prevention('🛡', 'Condoms', '>98%\neffective', _cd4Green,
        'Used correctly every time, condoms block HIV transmission during sex. Available free at all Rwanda health centres and pharmacies.'),
    _Prevention('💊', 'PrEP', '>99%\neffective', _artBlue,
        'Pre-Exposure Prophylaxis — a daily pill for HIV-negative people at substantial risk. Reduces transmission risk by over 99% when taken consistently.'),
    _Prevention('🧪', 'Regular testing', 'Know\nyour status', kAmber,
        'Knowing your HIV status is the foundation of prevention. Rwanda offers free rapid HIV tests at all health centres — result in 20 minutes.'),
    _Prevention('💉', 'TasP / ART', 'U=U', kRose,
        'Treatment as Prevention: people on effective ART with undetectable viral load cannot sexually transmit HIV (U=U). Free ART at all Rwanda health centres.'),
  ];

  double get _protection => _active.length / 4.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..addListener(() => setState(() {}))..repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = _ctrl.value;
    return _stage(Stack(clipBehavior: Clip.hardEdge, children: [
      Container(decoration: const BoxDecoration(gradient: RadialGradient(
        center: Alignment(0.2, -0.3), radius: 1.5,
        colors: [Color(0xFF1A2F3A), _bgDark],
      ))),

      // Protection meter (top)
      Positioned(top: 16, left: 20, right: 20, child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Prevention methods', style: TextStyle(fontFamily: 'Fraunces',
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          Text('Tap to toggle each method on/off',
              style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5))),
        ])),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('Protection level', style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.5),
              letterSpacing: 0.8, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          SizedBox(width: 120, height: 8, child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _protection,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(
                  Color.lerp(kRose, _cd4Green, _protection)!)),
          )),
          const SizedBox(height: 3),
          Text('${(_protection * 100).round()}%',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                  color: Color.lerp(kRose, _cd4Green, _protection)!)),
        ]),
      ])),

      // Shield animation (center background)
      Positioned(left: 0, top: 60, width: _cW, height: 140,
        child: CustomPaint(painter: _ShieldPainter(t: t, protection: _protection)),
      ),

      // Method cards (bottom 3/5)
      Positioned(left: 14, top: 200, right: 14, bottom: 12,
        child: Row(
          children: List.generate(4, (i) {
            final m = _methods[i];
            final on = _active.contains(i);
            return Expanded(child: GestureDetector(
              onTap: () => setState(() => on ? _active.remove(i) : _active.add(i)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: on ? m.color.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: on ? m.color : Colors.white.withValues(alpha: 0.08),
                    width: on ? 2 : 1),
                  boxShadow: on ? [BoxShadow(color: m.color.withValues(alpha: 0.2), blurRadius: 14)] : [],
                ),
                child: Column(children: [
                  Text(m.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 8),
                  Text(m.name, style: TextStyle(fontFamily: 'Fraunces', fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: on ? m.color : Colors.white.withValues(alpha: 0.4))),
                  const SizedBox(height: 5),
                  Text(m.efficacy, textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Fraunces', fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: on ? Colors.white : Colors.white.withValues(alpha: 0.2))),
                  const SizedBox(height: 8),
                  Text(m.detail, textAlign: TextAlign.center, maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 9.5,
                          color: on ? Colors.white.withValues(alpha: 0.75)
                              : Colors.white.withValues(alpha: 0.2), height: 1.4)),
                ]),
              ),
            ));
          }),
        ),
      ),
    ]));
  }
}

class _Prevention {
  const _Prevention(this.emoji, this.name, this.efficacy, this.color, this.detail);
  final String emoji, name, efficacy, detail;
  final Color color;
}

class _ShieldPainter extends CustomPainter {
  const _ShieldPainter({required this.t, required this.protection});
  final double t, protection;

  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = 50.0;

    // Shield rings spreading out
    for (int i = 0; i < 4; i++) {
      final phase = (t + i * 0.25) % 1.0;
      final r = 20 + phase * 80;
      final alpha = (1 - phase) * 0.15 * protection;
      if (alpha > 0.01) {
        c.drawCircle(Offset(cx, cy), r,
            Paint()..color = _cd4Green.withValues(alpha: alpha)
              ..style = PaintingStyle.stroke..strokeWidth = 2);
      }
    }

    // HIV particles blocked by shield
    for (int i = 0; i < (8 * (1 - protection)).round(); i++) {
      final ang = (i / 8) * math.pi * 2 + t * math.pi;
      final dist = 110 + math.sin(t * 3 + i) * 15;
      c.drawCircle(
        Offset(cx + math.cos(ang) * dist, cy + math.sin(ang) * dist * 0.4),
        4, Paint()..color = kRose.withValues(alpha: 0.6));
    }
  }

  @override bool shouldRepaint(_ShieldPainter o) => o.t != t || o.protection != protection;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CH 3 — ART & U=U
// Viral load graph dropping to undetectable + U=U celebration
// ═══════════════════════════════════════════════════════════════════════════════
class HivCh3ArtAndUU extends StatefulWidget {
  const HivCh3ArtAndUU({super.key});
  @override State<HivCh3ArtAndUU> createState() => _HivCh3State();
}

class _HivCh3State extends State<HivCh3ArtAndUU>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..addListener(() => setState(() {}))..repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = _ctrl.value;
    final artProgress = (t * 1.2).clamp(0.0, 1.0);

    return _stage(Stack(children: [
      Container(decoration: const BoxDecoration(gradient: LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(0xFF0A1A28), _bgDark],
      ))),

      // Viral load chart (left half)
      Positioned(left: 30, top: 55, width: 460, bottom: 30,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Viral Load Over Time', style: TextStyle(fontFamily: 'Fraunces',
              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 4),
          Text('ART started → viral load drops to undetectable',
              style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5))),
          const SizedBox(height: 14),
          Expanded(child: CustomPaint(
            painter: _ViralLoadChart(t: artProgress),
            child: const SizedBox.expand(),
          )),
        ]),
      ),

      // ART started indicator line
      Positioned(left: 175, top: 55, bottom: 30,
        child: Column(children: [
          Container(width: 1.5, height: 6, color: kAmber.withValues(alpha: 0.6)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(color: kAmber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kAmber.withValues(alpha: 0.5))),
            child: const Text('ART started', style: TextStyle(fontSize: 9,
                color: kAmber, fontWeight: FontWeight.w700)),
          ),
        ]),
      ),

      // U=U badge (right half)
      Positioned(right: 30, top: 50, width: 370, bottom: 30,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // U=U
          AnimatedOpacity(
            opacity: artProgress > 0.6 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Column(children: [
              Container(
                width: 180, height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [_cd4Green, _artBlue]),
                  boxShadow: artProgress > 0.8 ? [
                    BoxShadow(color: _cd4Green.withValues(alpha: 0.35), blurRadius: 30, spreadRadius: 4)
                  ] : [],
                ),
                alignment: Alignment.center,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('U=U', style: TextStyle(fontFamily: 'Fraunces',
                      fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text('Undetectable =\nUntransmittable',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10.5,
                          color: Colors.white.withValues(alpha: 0.9), height: 1.3)),
                ]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Column(children: [
                  _uuRow(Icons.check_circle_rounded, _cd4Green, 'Free ART at all Rwanda health centres'),
                  const SizedBox(height: 8),
                  _uuRow(Icons.check_circle_rounded, _artBlue, 'People on ART live long, healthy lives'),
                  const SizedBox(height: 8),
                  _uuRow(Icons.check_circle_rounded, kAmber, 'Cannot sexually transmit HIV when undetectable'),
                ]),
              ),
            ]),
          ),

          if (artProgress <= 0.6)
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 30),
              CircularProgressIndicator(
                value: artProgress / 0.6,
                color: _cd4Green,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                strokeWidth: 3,
              ),
              const SizedBox(height: 14),
              Text('ART reducing viral load…',
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5))),
            ]),
        ]),
      ),

      // Title
      Positioned(top: 16, left: 20,
        child: const Text('ART & Living with HIV', style: TextStyle(
            fontFamily: 'Fraunces', fontSize: 22,
            fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    ]));
  }

  Widget _uuRow(IconData icon, Color color, String text) => Row(children: [
    Icon(icon, size: 14, color: color),
    const SizedBox(width: 8),
    Expanded(child: Text(text, style: TextStyle(fontSize: 11,
        color: Colors.white.withValues(alpha: 0.8), height: 1.3))),
  ]);
}

class _ViralLoadChart extends CustomPainter {
  const _ViralLoadChart({required this.t});
  final double t;

  @override
  void paint(Canvas c, Size s) {
    // Grid
    for (int i = 0; i < 5; i++) {
      final y = s.height - i * s.height / 4;
      c.drawLine(Offset(0, y), Offset(s.width, y),
          Paint()..color = Colors.white.withValues(alpha: 0.06)..strokeWidth = 1);
      final label = TextPainter(
        text: TextSpan(text: ['0', '50k', '100k', '200k', '500k'][i],
            style: TextStyle(fontSize: 8.5, color: Colors.white.withValues(alpha: 0.35))),
        textDirection: TextDirection.ltr)..layout();
      label.paint(c, Offset(-label.width - 4, y - label.height / 2));
    }

    // ART start line
    const artX = 0.35;
    c.drawLine(Offset(artX * s.width, 0), Offset(artX * s.width, s.height),
        Paint()..color = kAmber.withValues(alpha: 0.5)..strokeWidth = 1.5);

    // Undetectable threshold
    c.drawLine(Offset(0, s.height * 0.08), Offset(s.width, s.height * 0.08),
        Paint()..color = _cd4Green.withValues(alpha: 0.4)..strokeWidth = 1);
    final ut = TextPainter(
      text: TextSpan(text: 'Undetectable',
          style: TextStyle(fontSize: 8.5, color: _cd4Green.withValues(alpha: 0.7))),
      textDirection: TextDirection.ltr)..layout();
    ut.paint(c, Offset(4, s.height * 0.08 - ut.height - 2));

    // Viral load curve
    final path = Path();
    const n = 80;
    bool started = false;
    for (int i = 0; i <= n; i++) {
      final xi = (i / n) * t;
      if (xi > t) break;
      final x = xi * s.width;
      double yNorm;
      if (xi < artX) {
        // Before ART: high viral load
        yNorm = 0.85 + math.sin(xi * 20) * 0.06;
      } else {
        // After ART: rapid decline to undetectable
        final drop = (xi - artX) / (1 - artX);
        yNorm = 0.85 * math.exp(-drop * 5) + 0.05;
      }
      final y = s.height - yNorm * s.height;
      if (!started) { path.moveTo(x, y); started = true; }
      else path.lineTo(x, y);
    }

    // Fill under curve
    if (started) {
      final fillPath = Path.from(path)
        ..lineTo(t * s.width, s.height)
        ..lineTo(0, s.height)
        ..close();
      c.drawPath(fillPath, Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [kRose.withValues(alpha: 0.25), kRose.withValues(alpha: 0.02)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)));
    }

    c.drawPath(path, Paint()
      ..color = kRose..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);

    // CD4 count (inverse) in green
    if (t > artX) {
      final cd4Path = Path();
      bool cd4Started = false;
      for (int i = 0; i <= n; i++) {
        final xi = (i / n) * t;
        if (xi > t || xi < artX) continue;
        final x = xi * s.width;
        final rise = (xi - artX) / (1 - artX);
        final yNorm = 0.8 - rise * 0.65;
        final y = s.height - yNorm.clamp(0.0, 1.0) * s.height;
        if (!cd4Started) { cd4Path.moveTo(x, y); cd4Started = true; }
        else cd4Path.lineTo(x, y);
      }
      c.drawPath(cd4Path, Paint()
        ..color = _cd4Green..strokeWidth = 2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    }

    // Axis labels
    final xl = TextPainter(text: const TextSpan(text: 'Months on ART →',
        style: TextStyle(fontSize: 9, color: Colors.white38)),
        textDirection: TextDirection.ltr)..layout();
    xl.paint(c, Offset(s.width / 2 - xl.width / 2, s.height + 6));

    // Legend
    final items = [
      (_hivRed, 'Viral load (HIV)'),
      (_cd4Green, 'CD4 count (immunity)'),
    ];
    for (int i = 0; i < items.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: items[i].$2,
            style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.55))),
        textDirection: TextDirection.ltr)..layout();
      c.drawLine(Offset(0, -20 + i * 13), Offset(18, -20 + i * 13),
          Paint()..color = items[i].$1..strokeWidth = 2);
      tp.paint(c, Offset(22, -24 + i * 13));
    }
  }

  @override bool shouldRepaint(_ViralLoadChart o) => o.t != t;
}
