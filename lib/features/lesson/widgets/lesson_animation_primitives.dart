import 'dart:math' as math;
import 'package:flutter/material.dart';

// ── Design tokens ────────────────────────────────────────────────────────────
const Color kRose    = Color(0xFFE85D75);
const Color kRoseDark= Color(0xFFC8425C);
const Color kRoseSoft= Color(0xFFFCE4E8);
const Color kPeach   = Color(0xFFF5C6A5);
const Color kAmber   = Color(0xFFF4B860);
const Color kSage    = Color(0xFF7FA99B);
const Color kSageDark= Color(0xFF5A8676);
const Color kPlum    = Color(0xFF2A1A1F);
const Color kCream   = Color(0xFFFDF4EC);
const Color kCream2  = Color(0xFFF8EADA);
const Color kInk60   = Color(0xFF6B5560);

// ── Easing ────────────────────────────────────────────────────────────────────
class Ease {
  static double linear(double t) => t;
  static double outQuad(double t) => t * (2 - t);
  static double inQuad(double t) => t * t;
  static double outCubic(double t) => (--t) * t * t + 1;
  static double inCubic(double t) => t * t * t;
  static double inOutCubic(double t) => t < .5 ? 4*t*t*t : (t-1)*(2*t-2)*(2*t-2)+1;
  static double outBack(double t) {
    const c1 = 1.70158, c3 = c1 + 1;
    final u = t - 1;
    return 1 + c3 * u * u * u + c1 * u * u;
  }
  static double outElastic(double t) {
    if (t == 0) return 0;
    if (t == 1) return 1;
    return math.pow(2, -10 * t).toDouble() *
        math.sin((t * 10 - 0.75) * (2 * math.pi / 3)) + 1;
  }
  static double outExpo(double t) => t == 1 ? 1 : 1 - math.pow(2, -10 * t).toDouble();
  static double inOutSine(double t) => -(math.cos(math.pi * t) - 1) / 2;
}

// interpolate(t, [i0,i1,...], [o0,o1,...], ease) — Popmotion-style keyframe interpolation
double lerp(double t, List<double> input, List<double> output,
    [double Function(double) ease = Ease.linear]) {
  if (t <= input.first) return output.first;
  if (t >= input.last) return output.last;
  for (int i = 0; i < input.length - 1; i++) {
    if (t >= input[i] && t <= input[i + 1]) {
      final span = input[i + 1] - input[i];
      if (span == 0) return output[i];
      final local = ease((t - input[i]) / span);
      return output[i] + (output[i + 1] - output[i]) * local;
    }
  }
  return output.last;
}

double clamp(double v, double lo, double hi) => v.clamp(lo, hi);

// ── Sphere3D ──────────────────────────────────────────────────────────────────
// Replicates the CSS radial-gradient sphere with cast shadow + optional glow label.
class Sphere3D extends StatelessWidget {
  const Sphere3D({
    required this.x,
    required this.y,
    this.z = 0,
    required this.r,
    required this.color,
    this.highlight,
    this.shadow = const Color(0x40000000),
    this.label,
    this.glow = 0,
    super.key,
  });

  final double x, y, z, r;
  final Color color;
  final Color? highlight;
  final Color shadow;
  final String? label;
  final double glow;

  @override
  Widget build(BuildContext context) {
    final scale = 1.0 + z / 600;
    final rr = r * scale;
    final hi = highlight ?? _lighten(color, 0.4);
    return Positioned(
      left: x - rr,
      top: y - rr,
      width: rr * 2,
      height: rr * 2,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.4, -0.44),
            radius: 1.0,
            colors: [hi, color, color],
            stops: const [0.0, 0.55, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: rr * 0.8,
              offset: Offset(0, rr * 0.4),
            ),
            if (glow > 0)
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: glow.toDouble(),
                spreadRadius: glow * 0.2,
              ),
          ],
        ),
        alignment: Alignment.center,
        child: label != null
            ? Text(
                label!,
                style: TextStyle(
                  fontSize: rr * 0.45,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  shadows: const [Shadow(blurRadius: 2, color: Colors.black38)],
                ),
              )
            : null,
      ),
    );
  }

  Color _lighten(Color c, double amt) {
    final r = (c.r * 255.0).round().clamp(0, 255);
    final g = (c.g * 255.0).round().clamp(0, 255);
    final b = (c.b * 255.0).round().clamp(0, 255);
    final a = (c.a * 255.0).round().clamp(0, 255);
    return Color.fromARGB(
      a,
      (r + (255 - r) * amt).round().clamp(0, 255),
      (g + (255 - g) * amt).round().clamp(0, 255),
      (b + (255 - b) * amt).round().clamp(0, 255),
    );
  }
}

// ── Particle ──────────────────────────────────────────────────────────────────
class Particle extends StatelessWidget {
  const Particle({
    required this.x,
    required this.y,
    this.z = 0,
    this.size = 8,
    required this.color,
    this.shape = ParticleShape.circle,
    this.opacity = 1,
    super.key,
  });

  final double x, y, z, size;
  final Color color;
  final ParticleShape shape;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final s = size * (1 + z / 800);
    return Positioned(
      left: x - s,
      top: y - s,
      width: s * 2,
      height: s * 2,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            shape: shape == ParticleShape.circle ? BoxShape.circle : BoxShape.rectangle,
            gradient: shape == ParticleShape.circle
                ? RadialGradient(
                    center: const Alignment(-0.4, -0.4),
                    radius: 1.0,
                    colors: [
                      Color.fromARGB(
                          (color.a * 255).round().clamp(0, 255),
                          ((color.r * 255).round() + 30).clamp(0, 255),
                          ((color.g * 255).round() + 30).clamp(0, 255),
                          ((color.b * 255).round() + 30).clamp(0, 255)),
                      color,
                    ],
                  )
                : null,
            color: shape != ParticleShape.circle ? color : null,
            boxShadow: [
              BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: s * 0.8),
            ],
          ),
        ),
      ),
    );
  }
}

enum ParticleShape { circle, donut }

// ── AmbientField ──────────────────────────────────────────────────────────────
// Floating ambient dust particles that drift with time.
class AmbientField extends StatelessWidget {
  const AmbientField({
    required this.t,
    this.count = 28,
    required this.colors,
    super.key,
  });

  final double t;
  final int count;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(count, (i) {
        final seed = i * 137;
        final baseX = (seed * 13) % 1280;
        final baseY = (seed * 7) % 720;
        final drift = math.sin(t * 0.5 + i) * 30;
        final driftY = math.cos(t * 0.3 + i * 1.3) * 20;
        final c = colors[i % colors.length];
        return Particle(
          x: (baseX + drift).toDouble(),
          y: (baseY + driftY).toDouble(),
          z: (i % 5) * 20.0 - 50,
          size: (3 + (i % 4)).toDouble(),
          color: c,
          opacity: 0.5,
        );
      }),
    );
  }
}

// ── DayCounter ────────────────────────────────────────────────────────────────
class DayCounter extends StatelessWidget {
  const DayCounter({required this.day, this.maxDay = 28, super.key});
  final int day;
  final int maxDay;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 110,
      left: 28,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xD92A1A1F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('DAY',
                style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.2,
                    color: kPeach,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            Text(day.toString().padLeft(2, '0'),
                style: const TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: kCream)),
            const SizedBox(width: 4),
            Text('/ $maxDay',
                style: TextStyle(
                    fontSize: 12,
                    color: kCream.withValues(alpha: 0.4))),
          ],
        ),
      ),
    );
  }
}

// ── InfoCallout ───────────────────────────────────────────────────────────────
class InfoCallout extends StatelessWidget {
  const InfoCallout({
    required this.label,
    required this.value,
    required this.sub,
    required this.opacity,
    this.right = 60,
    this.top = 200,
    super.key,
  });

  final String label;
  final String value;
  final String sub;
  final double opacity;
  final double right;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      top: top,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xD92A1A1F),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      textBaseline: TextBaseline.alphabetic,
                      color: kPeach,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: kCream)),
              const SizedBox(height: 6),
              Text(sub,
                  style: TextStyle(
                      fontSize: 11,
                      color: kCream.withValues(alpha: 0.7),
                      height: 1.4)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── GlassCard ─────────────────────────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.opacity = 1.0,
    this.slideX = 0,
    super.key,
  });

  final Widget child;
  final double opacity;
  final double slideX;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(slideX, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x142A1A1F)),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ── LabelBadge ────────────────────────────────────────────────────────────────
class LabelBadge extends StatelessWidget {
  const LabelBadge({
    required this.text,
    required this.opacity,
    this.color = kPlum,
    super.key,
  });

  final String text;
  final double opacity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: kCream,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5),
        ),
      ),
    );
  }
}

// ── Scene fade wrapper ────────────────────────────────────────────────────────
// Renders child only while time ∈ [start, end], fading in/out at ±0.6s.
class SceneWindow extends StatelessWidget {
  const SceneWindow({
    required this.t,
    required this.start,
    required this.end,
    required this.child,
    super.key,
  });

  final double t;
  final double start;
  final double end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (t < start - 0.6 || t > end + 0.1) return const SizedBox.shrink();
    double op;
    if (t < start) {
      op = ((t - (start - 0.6)) / 0.6).clamp(0.0, 1.0);
    } else if (t > end - 0.6) {
      op = ((end - t) / 0.6).clamp(0.0, 1.0);
    } else {
      op = 1.0;
    }
    return Opacity(opacity: op, child: child);
  }
}
