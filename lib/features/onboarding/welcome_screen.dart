import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

const _kLiveGreen = Color(0xFF22C55E);

/// First screen a brand-new user sees — a full marketing landing page that
/// mirrors the "Urungano — Learn your body, in 3D" web design: hero, stats,
/// features, lessons, accessibility, community, closing CTA and footer.
///
/// Responsive (web + mobile) and functional: the nav links scroll to their
/// section, and every call-to-action begins onboarding (→ language selection).
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _featuresKey = GlobalKey();
  final _lessonsKey = GlobalKey();
  final _accessKey = GlobalKey();
  final _communityKey = GlobalKey();

  void _start() => context.go('/language');

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
        alignment: 0.02,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 900;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ── Nav + hero (no full-bleed background) ──
                  _Band(
                    padTop: 0,
                    padBottom: wide ? 44 : 30,
                    child: Column(
                      children: [
                        _Nav(
                          wide: wide,
                          onStart: _start,
                          onFeatures: () => _scrollTo(_featuresKey),
                          onLessons: () => _scrollTo(_lessonsKey),
                          onAccess: () => _scrollTo(_accessKey),
                          onCommunity: () => _scrollTo(_communityKey),
                        ),
                        SizedBox(height: wide ? 24 : 12),
                        wide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 105,
                                    child: _HeroCopy(onStart: _start, wide: true),
                                  ),
                                  const SizedBox(width: 48),
                                  const Expanded(
                                    flex: 95,
                                    child: Center(
                                        child: _PhoneMock(showFloats: true)),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _HeroCopy(onStart: _start, wide: false),
                                  const SizedBox(height: 40),
                                  const _PhoneMock(showFloats: false),
                                ],
                              ),
                      ],
                    ),
                  ),

                  // ── Stats ──
                  _Band(
                    color: AppColors.surface,
                    border: true,
                    padTop: 30,
                    padBottom: 30,
                    child: _StatsBar(wide: wide),
                  ),

                  // ── Features ──
                  _Band(
                    key: _featuresKey,
                    child: _FeaturesSection(wide: wide),
                  ),

                  // ── Lessons ──
                  _Band(
                    key: _lessonsKey,
                    color: AppColors.surface,
                    child: _LessonsSection(wide: wide, onStart: _start),
                  ),

                  // ── Accessibility ──
                  _Band(
                    key: _accessKey,
                    child: _AccessibilitySection(wide: wide),
                  ),

                  // ── Community ──
                  _Band(
                    key: _communityKey,
                    color: AppColors.surface,
                    child: _CommunitySection(wide: wide),
                  ),

                  // ── Closing CTA ──
                  _FinalCta(onStart: _start),

                  // ── Footer ──
                  _Footer(
                    wide: wide,
                    onStart: _start,
                    onFeatures: () => _scrollTo(_featuresKey),
                    onLessons: () => _scrollTo(_lessonsKey),
                    onAccess: () => _scrollTo(_accessKey),
                    onCommunity: () => _scrollTo(_communityKey),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  LAYOUT HELPERS
// ══════════════════════════════════════════════════════════════

/// Full-width band with an optional background, centering its child at 1200px.
class _Band extends StatelessWidget {
  const _Band({
    required this.child,
    this.color,
    this.border = false,
    this.padTop = 60,
    this.padBottom = 60,
    super.key,
  });

  final Widget child;
  final Color? color;
  final bool border;
  final double padTop;
  final double padBottom;

  @override
  Widget build(BuildContext context) {
    final hPad = MediaQuery.of(context).size.width < 640 ? 22.0 : 32.0;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        border: border
            ? const Border(
                top: BorderSide(color: AppColors.divider),
                bottom: BorderSide(color: AppColors.divider),
              )
            : null,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, padTop, hPad, padBottom),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Section eyebrow + title (+ optional subtitle), centered.
class _SectionHead extends StatelessWidget {
  const _SectionHead({
    required this.tag,
    required this.title,
    this.sub,
    this.wide = true,
  });
  final String tag;
  final String title;
  final String? sub;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(tag.toUpperCase(),
            style: AppTextStyles.label().copyWith(
              color: AppColors.primary,
              fontSize: 12,
              letterSpacing: 2,
            )),
        const SizedBox(height: 14),
        Text(title,
            textAlign: TextAlign.center,
            style: AppTextStyles.display().copyWith(
              fontSize: wide ? 40 : 30,
              fontWeight: FontWeight.w600,
              height: 1.1,
              letterSpacing: -0.8,
            )),
        if (sub != null) ...[
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(sub!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body().copyWith(
                  fontSize: 16,
                  height: 1.6,
                  color: AppColors.ink60,
                )),
          ),
        ],
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  NAV
// ══════════════════════════════════════════════════════════════

class _Nav extends StatelessWidget {
  const _Nav({
    required this.wide,
    required this.onStart,
    required this.onFeatures,
    required this.onLessons,
    required this.onAccess,
    required this.onCommunity,
  });

  final bool wide;
  final VoidCallback onStart;
  final VoidCallback onFeatures;
  final VoidCallback onLessons;
  final VoidCallback onAccess;
  final VoidCallback onCommunity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Row(
        children: [
          Text('Urungano',
              style: AppTextStyles.headline().copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
          const Spacer(),
          if (wide) ...[
            _NavLink('Features', onFeatures),
            _NavLink('Lessons', onLessons),
            _NavLink('Accessibility', onAccess),
            _NavLink('Community', onCommunity),
            const SizedBox(width: 10),
            _PrimaryCta(label: 'Open the app', onTap: onStart, compact: true),
          ] else
            TextButton(
              onPressed: onStart,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                textStyle: AppTextStyles.button()
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              child: const Text('Sign in'),
            ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          textStyle:
              AppTextStyles.body().copyWith(fontWeight: FontWeight.w500, fontSize: 14.5),
        ),
        child: Text(label),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  HERO COPY (left column)
// ══════════════════════════════════════════════════════════════

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.onStart, required this.wide});
  final VoidCallback onStart;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final align = wide ? CrossAxisAlignment.start : CrossAxisAlignment.center;
    final textAlign = wide ? TextAlign.start : TextAlign.center;

    return Column(
      crossAxisAlignment: align,
      children: [
        const _LiveBadge(),
        const SizedBox(height: 22),
        Text.rich(
          const TextSpan(
            children: [
              TextSpan(text: 'Learn your body,\nin '),
              TextSpan(
                text: 'interactive 3D',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(text: '.'),
            ],
          ),
          textAlign: textAlign,
          style: AppTextStyles.display().copyWith(
            fontSize: wide ? 54 : 38,
            fontWeight: FontWeight.w600,
            height: 1.03,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Text(
            'Urungano makes sexual and reproductive health education clear, '
            'private, and inclusive — through hands-on 3D lessons, voice '
            'narration, and a safe peer community.',
            textAlign: textAlign,
            style: AppTextStyles.body().copyWith(
              fontSize: wide ? 17 : 15.5,
              height: 1.6,
              color: AppColors.ink60,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: wide ? WrapAlignment.start : WrapAlignment.center,
          children: [
            _PrimaryCta(label: "Start learning — it's free", onTap: onStart),
            _GhostCta(label: '▸  Watch a lesson', onTap: onStart),
          ],
        ),
        const SizedBox(height: 28),
        _TrustRow(wide: wide),
      ],
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.divider2),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink10.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _kLiveGreen,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text('Now live for youth in Rwanda',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall().copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                )),
          ),
        ],
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({
    required this.label,
    required this.onTap,
    this.compact = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.textPrimary,
        foregroundColor: AppColors.background,
        elevation: 0,
        // Hug content — override the theme's full-width (infinite) minimumSize,
        // which would crash when the button sits in an unbounded-width Row.
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 18 : 26,
          vertical: compact ? 12 : 17,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.all(
          AppColors.primaryDark.withValues(alpha: 0.4),
        ),
      ),
      child: Text(label,
          style: AppTextStyles.button().copyWith(
            fontWeight: FontWeight.w600,
            fontSize: compact ? 14 : 15,
          )),
    );
  }
}

class _GhostCta extends StatelessWidget {
  const _GhostCta({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 17),
        side: const BorderSide(color: AppColors.divider2, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text(label,
          style: AppTextStyles.button().copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          )),
    );
  }
}

class _TrustRow extends StatelessWidget {
  const _TrustRow({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.shield_outlined, 'Private by default'),
      (Icons.check_rounded, 'No name needed'),
      (Icons.public_rounded, 'RW · EN · FR'),
    ];
    return Wrap(
      spacing: 22,
      runSpacing: 10,
      alignment: wide ? WrapAlignment.start : WrapAlignment.center,
      children: [
        for (final (icon, label) in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.sage),
              const SizedBox(width: 8),
              Text(label,
                  style: AppTextStyles.bodySmall().copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  )),
            ],
          ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  PHONE MOCK
// ══════════════════════════════════════════════════════════════

class _PhoneMock extends StatelessWidget {
  const _PhoneMock({required this.showFloats});
  final bool showFloats;

  @override
  Widget build(BuildContext context) {
    const w = 280.0;
    const h = 570.0;

    final phone = Container(
      width: w,
      height: h,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A2529), Color(0xFF1A0E11)],
        ),
        borderRadius: BorderRadius.circular(42),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink10.withValues(alpha: 0.5),
            blurRadius: 90,
            offset: const Offset(0, 45),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Container(
          color: AppColors.background,
          child: const _PhoneScreen(),
        ),
      ),
    );

    if (!showFloats) {
      return Center(child: phone);
    }

    return SizedBox(
      width: w + 130,
      height: h + 20,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          phone,
          const Positioned(
            top: 54,
            left: -6,
            child: _FloatCard(
              bg: AppColors.sage,
              emoji: '🔊',
              title: 'Voice narration',
              sub: 'Kinyarwanda',
            ),
          ),
          const Positioned(
            bottom: 120,
            right: -8,
            child: _FloatCard(
              bg: AppColors.primary,
              emoji: '✋',
              title: 'Gesture control',
              sub: 'MediaPipe',
            ),
          ),
          const Positioned(
            bottom: 26,
            left: 0,
            child: _FloatCard(
              bg: AppColors.sun,
              emoji: '✓',
              title: '86% accuracy',
              sub: 'Quiz streak',
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatCard extends StatelessWidget {
  const _FloatCard({
    required this.bg,
    required this.emoji,
    required this.title,
    required this.sub,
  });
  final Color bg;
  final String emoji;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink10.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 11),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: AppTextStyles.bodySmall().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  )),
              Text(sub,
                  style: AppTextStyles.bodySmall().copyWith(
                    fontSize: 10.5,
                    color: AppColors.ink60,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhoneScreen extends StatelessWidget {
  const _PhoneScreen();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 34, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Center(
                  child: Text('rh',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Muraho 👋',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall()
                          .copyWith(fontSize: 11, color: AppColors.ink60)),
                  Text('Ready to learn?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      )),
                ],
              ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CONTINUE LEARNING',
                    style: AppTextStyles.label().copyWith(
                      color: AppColors.white.withValues(alpha: 0.85),
                      fontSize: 9,
                      letterSpacing: 1,
                    )),
                const SizedBox(height: 4),
                Text('Reproductive anatomy 101',
                    style: AppTextStyles.body().copyWith(
                      color: AppColors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 6,
                    backgroundColor: AppColors.white.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation(AppColors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: _MiniTile(
                  bg: AppColors.sageSoft,
                  emoji: '🔥',
                  big: '4',
                  small: 'day streak',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _MiniTile(
                  bg: AppColors.white,
                  emoji: '✋',
                  big: 'Gestures',
                  small: 'Try it',
                  bordered: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _RowCard(
            bg: AppColors.primaryLight,
            leadColor: AppColors.primary,
            leadEmoji: '💬',
            overline: 'COMMUNITY · 127 ONLINE',
            overlineColor: AppColors.primary,
            title: 'Talk with peers',
          ),
          const SizedBox(height: 10),
          const _RowCard(
            bg: AppColors.surface,
            leadColor: AppColors.amber,
            leadEmoji: '🩸',
            overline: 'MENSTRUAL · 8 MIN',
            overlineColor: AppColors.ink60,
            title: 'Your cycle, explained',
          ),
        ],
      ),
    );
  }
}

class _MiniTile extends StatelessWidget {
  const _MiniTile({
    required this.bg,
    required this.emoji,
    required this.big,
    required this.small,
    this.bordered = false,
  });
  final Color bg;
  final String emoji;
  final String big;
  final String small;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: bordered
            ? Border.all(color: AppColors.divider.withValues(alpha: 0.7))
            : null,
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(big,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (big.length <= 2
                            ? AppTextStyles.display()
                            : AppTextStyles.body())
                        .copyWith(
                      fontSize: big.length <= 2 ? 16 : 12,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: 2),
                Text(small,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall()
                        .copyWith(fontSize: 10, color: AppColors.ink60)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  const _RowCard({
    required this.bg,
    required this.leadColor,
    required this.leadEmoji,
    required this.overline,
    required this.overlineColor,
    required this.title,
  });
  final Color bg;
  final Color leadColor;
  final String leadEmoji;
  final String overline;
  final Color overlineColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: leadColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
                child: Text(leadEmoji, style: const TextStyle(fontSize: 15))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(overline,
                    style: AppTextStyles.label().copyWith(
                      fontSize: 8.5,
                      letterSpacing: 0.6,
                      color: overlineColor,
                    )),
                const SizedBox(height: 2),
                Text(title,
                    style: AppTextStyles.body().copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  STATS
// ══════════════════════════════════════════════════════════════

class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.wide});
  final bool wide;

  static const _stats = [
    ('3D', 'Interactive lessons'),
    ('6', 'Accessibility modes'),
    ('3', 'Languages, native voice'),
    ('100%', 'Anonymous & private'),
  ];

  @override
  Widget build(BuildContext context) {
    return wide
        ? Row(
            children: [
              for (final s in _stats)
                Expanded(child: _Stat(num: s.$1, label: s.$2)),
            ],
          )
        : Wrap(
            runSpacing: 24,
            children: [
              for (final s in _stats)
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 44) / 2,
                  child: _Stat(num: s.$1, label: s.$2),
                ),
            ],
          );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.num, required this.label});
  final String num;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(num,
            style: AppTextStyles.display().copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              height: 1,
            )),
        const SizedBox(height: 8),
        Text(label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall()
                .copyWith(fontSize: 13, color: AppColors.ink60)),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  FEATURES
// ══════════════════════════════════════════════════════════════

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection({required this.wide});
  final bool wide;

  static const _features = <_Feature>[
    _Feature(Icons.star_rounded, AppColors.primary, 'Interactive 3D models',
        'Rotate, zoom, and tap real anatomy. Explore the menstrual cycle, HIV, and reproductive systems from every angle.'),
    _Feature(Icons.back_hand_outlined, AppColors.sage, 'Gesture control',
        'Move models with your hand through the camera — no touching required. Built for everyone, powered by MediaPipe.'),
    _Feature(Icons.volume_up_rounded, AppColors.sun, 'Voice & captions',
        'Every lesson is narrated in Kinyarwanda, English, and French — with captions and sign-language support built in.'),
    _Feature(Icons.chat_bubble_outline_rounded, AppColors.textPrimary,
        'Safe peer community',
        'Chat circles, open debates, and anonymous questions — all moderated by real health educators. No judgment, ever.'),
    _Feature(Icons.lock_outline_rounded, AppColors.primaryDark,
        'Private by design',
        'No name, no email, no tracking. Progress stays on your device. Add an app lock or go fully incognito anytime.'),
    _Feature(Icons.download_rounded, AppColors.amber, 'Works offline',
        'Download lessons and learn without data. Designed for low-bandwidth realities across Rwanda.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHead(
          tag: 'Why Urungano',
          title: 'Health education that actually reaches you.',
          sub: 'Most SRH tools are dense text no one reads. Urungano turns '
              'learning into something you can see, touch, hear, and talk about.',
          wide: wide,
        ),
        const SizedBox(height: 40),
        LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth >= 860 ? 3 : (c.maxWidth >= 560 ? 2 : 1);
            const gap = 20.0;
            final cardW = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final f in _features)
                  SizedBox(
                    width: cardW,
                    child: _FeatureCard(data: f),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Feature {
  const _Feature(this.icon, this.color, this.title, this.body);
  final IconData icon;
  final Color color;
  final String title;
  final String body;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.data});
  final _Feature data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: data.color.withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(data.icon, color: AppColors.white, size: 25),
          ),
          const SizedBox(height: 18),
          Text(data.title,
              style: AppTextStyles.headline().copyWith(fontSize: 19)),
          const SizedBox(height: 8),
          Text(data.body,
              style: AppTextStyles.body().copyWith(
                fontSize: 14.5,
                height: 1.55,
                color: AppColors.ink60,
              )),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  LESSONS
// ══════════════════════════════════════════════════════════════

class _LessonsSection extends StatelessWidget {
  const _LessonsSection({required this.wide, required this.onStart});
  final bool wide;
  final VoidCallback onStart;

  static const _lessons = <_Lesson>[
    _Lesson('Menstrual health', 'Your cycle, explained',
        'Hormones, ovulation, and the uterine lining — visualized across all 28 days.',
        [AppColors.primary, AppColors.primaryDark]),
    _Lesson('HIV & prevention', 'How HIV works',
        'Follow the virus, the immune response, and four proven ways to stay protected.',
        [AppColors.sageSoft, AppColors.sage]),
    _Lesson('Anatomy', 'Know your body',
        'Internal and external anatomy, named clearly — in Kinyarwanda and English.',
        [AppColors.peachSoft, AppColors.amber]),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHead(
          tag: 'The Library',
          title: 'Lessons that move.',
          sub: 'Professionally animated 3D lessons with chapter markers, live '
              'captions, and native narration. Watch one now.',
          wide: wide,
        ),
        const SizedBox(height: 40),
        LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth >= 780 ? 3 : (c.maxWidth >= 520 ? 2 : 1);
            const gap = 20.0;
            final cardW = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final l in _lessons)
                  SizedBox(
                    width: cardW,
                    child: _LessonCard(data: l, onTap: onStart),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Lesson {
  const _Lesson(this.topic, this.title, this.body, this.gradient);
  final String topic;
  final String title;
  final String body;
  final List<Color> gradient;
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.data, required this.onTap});
  final _Lesson data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink10.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visual header with a play affordance.
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: data.gradient,
                ),
              ),
              child: Center(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: AppColors.textPrimary, size: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.topic.toUpperCase(),
                      style: AppTextStyles.label().copyWith(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: AppColors.primary,
                      )),
                  const SizedBox(height: 8),
                  Text(data.title,
                      style: AppTextStyles.headline().copyWith(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text(data.body,
                      style: AppTextStyles.body().copyWith(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.ink60,
                      )),
                  const SizedBox(height: 14),
                  Text('▸ 28s · 4 chapters',
                      style: AppTextStyles.bodySmall().copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  ACCESSIBILITY
// ══════════════════════════════════════════════════════════════

class _AccessibilitySection extends StatelessWidget {
  const _AccessibilitySection({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final left = Column(
      crossAxisAlignment:
          wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text('ACCESSIBILITY FIRST',
            style: AppTextStyles.label().copyWith(
              color: AppColors.primary,
              fontSize: 12,
              letterSpacing: 2,
            )),
        const SizedBox(height: 14),
        Text("Inclusion isn't a setting.\nIt's the first screen.",
            textAlign: wide ? TextAlign.start : TextAlign.center,
            style: AppTextStyles.display().copyWith(
              fontSize: wide ? 38 : 28,
              fontWeight: FontWeight.w600,
              height: 1.1,
              letterSpacing: -0.8,
            )),
        const SizedBox(height: 16),
        Text(
          'Urungano is built for every young person — including those who are '
          'blind, deaf, or hard of hearing. You choose how you learn before '
          'you ever start.',
          textAlign: wide ? TextAlign.start : TextAlign.center,
          style: AppTextStyles.body().copyWith(
            fontSize: 16,
            height: 1.6,
            color: AppColors.ink60,
          ),
        ),
        const SizedBox(height: 24),
        const _A11yRow(Icons.volume_up_rounded, 'Voice narration',
            'Full audio lessons for blind and low-vision learners'),
        const SizedBox(height: 12),
        const _A11yRow(Icons.subtitles_outlined, 'Captions & sign language',
            'Subtitles plus RSL interpreter video for deaf learners'),
        const SizedBox(height: 12),
        const _A11yRow(Icons.contrast_rounded, 'High contrast & large text',
            'Bolder colors and bigger type for easier reading'),
      ],
    );

    final panel = _A11yPanel();

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: left),
          const SizedBox(width: 48),
          Expanded(child: panel),
        ],
      );
    }
    return Column(
      children: [left, const SizedBox(height: 32), panel],
    );
  }
}

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.title().copyWith(fontSize: 15.5)),
                const SizedBox(height: 2),
                Text(body,
                    style: AppTextStyles.bodySmall().copyWith(
                      fontSize: 13,
                      color: AppColors.ink60,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _A11yPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.sageSoft,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose how you learn best',
              style: AppTextStyles.headline().copyWith(fontSize: 16)),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: _LearnTile(
                    Icons.volume_up_rounded, AppColors.primary, 'Voice',
                    'I prefer to listen'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _LearnTile(Icons.back_hand_outlined, AppColors.sun,
                    'Gestures', 'Hands-free control',
                    selected: true),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _LearnTile(Icons.subtitles_outlined, AppColors.sage,
                    'Captions', 'Show subtitles'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _LearnTile(Icons.text_fields_rounded, AppColors.sun,
                    'Large text', 'Easier to read'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LearnTile extends StatelessWidget {
  const _LearnTile(this.icon, this.iconColor, this.title, this.sub,
      {this.selected = false});
  final IconData icon;
  final Color iconColor;
  final String title;
  final String sub;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.white : AppColors.textPrimary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? AppColors.textPrimary : AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.white, size: 18),
          ),
          const SizedBox(height: 12),
          Text(title,
              style: AppTextStyles.title().copyWith(fontSize: 14, color: fg)),
          const SizedBox(height: 2),
          Text(sub,
              style: AppTextStyles.bodySmall().copyWith(
                fontSize: 11,
                color: selected
                    ? AppColors.white.withValues(alpha: 0.7)
                    : AppColors.ink60,
              )),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  COMMUNITY
// ══════════════════════════════════════════════════════════════

class _CommunitySection extends StatelessWidget {
  const _CommunitySection({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    const chat = _ChatMock();
    final copy = Column(
      crossAxisAlignment:
          wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text('URUNGANO COMMUNITY',
            style: AppTextStyles.label().copyWith(
              color: AppColors.primary,
              fontSize: 12,
              letterSpacing: 2,
            )),
        const SizedBox(height: 14),
        Text("You're not the only one\nwondering.",
            textAlign: wide ? TextAlign.start : TextAlign.center,
            style: AppTextStyles.display().copyWith(
              fontSize: wide ? 38 : 28,
              fontWeight: FontWeight.w600,
              height: 1.1,
              letterSpacing: -0.8,
            )),
        const SizedBox(height: 16),
        Text(
          'Ask anything anonymously, join topic circles, or weigh in on open '
          'debates. Every space is moderated by health educators — so answers '
          'are safe and real.',
          textAlign: wide ? TextAlign.start : TextAlign.center,
          style: AppTextStyles.body().copyWith(
            fontSize: 16,
            height: 1.6,
            color: AppColors.ink60,
          ),
        ),
        const SizedBox(height: 22),
        const _CommItem('💬', AppColors.primary, 'Chat circles by topic'),
        const SizedBox(height: 12),
        const _CommItem('⚖️', AppColors.sun, 'Open debates & polls'),
        const SizedBox(height: 12),
        const _CommItem('🔒', AppColors.sage, 'Anonymous questions'),
      ],
    );

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(child: chat),
          const SizedBox(width: 48),
          Expanded(child: copy),
        ],
      );
    }
    return Column(children: [chat, const SizedBox(height: 32), copy]);
  }
}

class _CommItem extends StatelessWidget {
  const _CommItem(this.emoji, this.color, this.label);
  final String emoji;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 14))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body().copyWith(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
        ),
      ],
    );
  }
}

class _ChatMock extends StatelessWidget {
  const _ChatMock();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink10.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header.
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Center(
                      child: Text('🌸', style: TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cycle talk',
                          style:
                              AppTextStyles.headline().copyWith(fontSize: 16)),
                      Text('Menstrual health · moderated by Nurse Ange',
                          style: AppTextStyles.bodySmall()
                              .copyWith(fontSize: 11, color: AppColors.ink60)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.sageSoft,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.sage,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('24 online',
                          style: AppTextStyles.bodySmall().copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.sage,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          // Messages.
          const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _Msg(
                  who: 'Umuntu 12',
                  text:
                      'Ubwo ni ryari period igabanuka? Mine feels irregular lately.',
                  kind: _MsgKind.them,
                ),
                SizedBox(height: 10),
                _Msg(
                  who: 'Nurse Ange ✓',
                  text:
                      "It's normal to vary by a few days, especially with stress. If it's more than 7 days off regularly, worth a checkup.",
                  kind: _MsgKind.nurse,
                ),
                SizedBox(height: 10),
                _Msg(
                  who: null,
                  text:
                      'Murakoze! The cycle tracker really helps me see the pattern 💙',
                  kind: _MsgKind.you,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _MsgKind { them, nurse, you }

class _Msg extends StatelessWidget {
  const _Msg({required this.who, required this.text, required this.kind});
  final String? who;
  final String text;
  final _MsgKind kind;

  @override
  Widget build(BuildContext context) {
    final isYou = kind == _MsgKind.you;
    final bg = switch (kind) {
      _MsgKind.them => AppColors.primaryLight,
      _MsgKind.nurse => AppColors.sageSoft,
      _MsgKind.you => AppColors.textPrimary,
    };
    final fg = isYou ? AppColors.white : AppColors.textPrimary;
    final whoColor = kind == _MsgKind.nurse ? AppColors.sage : AppColors.ink60;

    return Align(
      alignment: isYou ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (who != null) ...[
                Text(who!,
                    style: AppTextStyles.bodySmall().copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: whoColor,
                    )),
                const SizedBox(height: 3),
              ],
              Text(text,
                  style: AppTextStyles.body()
                      .copyWith(fontSize: 13.5, height: 1.45, color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  CLOSING CTA
// ══════════════════════════════════════════════════════════════

class _FinalCta extends StatelessWidget {
  const _FinalCta({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryLight, AppColors.background],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            children: [
              Text('Your body. Your questions.\nYour space.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.display().copyWith(
                    fontSize: 42,
                    fontWeight: FontWeight.w600,
                    height: 1.08,
                    letterSpacing: -1,
                  )),
              const SizedBox(height: 18),
              Text(
                'Join thousands of young people across Rwanda learning about '
                'their health — privately, confidently, and for free.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body().copyWith(
                  fontSize: 16.5,
                  height: 1.6,
                  color: AppColors.ink60,
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _PrimaryCta(label: 'Open Urungano', onTap: onStart),
                  _GhostCta(label: 'See the mobile app', onTap: onStart),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  FOOTER
// ══════════════════════════════════════════════════════════════

class _Footer extends StatelessWidget {
  const _Footer({
    required this.wide,
    required this.onStart,
    required this.onFeatures,
    required this.onLessons,
    required this.onAccess,
    required this.onCommunity,
  });

  final bool wide;
  final VoidCallback onStart;
  final VoidCallback onFeatures;
  final VoidCallback onLessons;
  final VoidCallback onAccess;
  final VoidCallback onCommunity;

  @override
  Widget build(BuildContext context) {
    final brand = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Urungano',
            style: AppTextStyles.headline().copyWith(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            'Interactive, inclusive sexual and reproductive health education '
            'for youth in Rwanda.',
            style: AppTextStyles.body().copyWith(
              fontSize: 14,
              height: 1.6,
              color: AppColors.background.withValues(alpha: 0.65),
            ),
          ),
        ),
      ],
    );

    final columns = [
      _FooterCol('Product', [
        ('Features', onFeatures),
        ('3D Lessons', onLessons),
        ('Accessibility', onAccess),
        ('Web app', onStart),
      ]),
      _FooterCol('Community', [
        ('Chat circles', onCommunity),
        ('Open debate', onCommunity),
        ('Ask anonymously', onCommunity),
      ]),
      _FooterCol('Support', [
        ('Youth hotlines', onStart),
        ('Privacy', onStart),
        ('Find a clinic', onStart),
      ]),
    ];

    return Container(
      width: double.infinity,
      color: AppColors.textPrimary,
      padding: EdgeInsets.symmetric(
          vertical: 48, horizontal: wide ? 32 : 22),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: brand),
                        for (final col in columns) Expanded(child: col),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        brand,
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 48,
                          runSpacing: 28,
                          children: columns,
                        ),
                      ],
                    ),
              const SizedBox(height: 36),
              Divider(color: AppColors.background.withValues(alpha: 0.15)),
              const SizedBox(height: 18),
              Flex(
                direction: wide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('© 2026 Urungano · Built for youth in Rwanda',
                      style: AppTextStyles.bodySmall().copyWith(
                        fontSize: 12.5,
                        color: AppColors.background.withValues(alpha: 0.5),
                      )),
                  if (wide) const Spacer() else const SizedBox(height: 8),
                  Text('Kinyarwanda · English · Français',
                      style: AppTextStyles.bodySmall().copyWith(
                        fontSize: 12.5,
                        color: AppColors.background.withValues(alpha: 0.5),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterCol extends StatelessWidget {
  const _FooterCol(this.title, this.links);
  final String title;
  final List<(String, VoidCallback)> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(),
            style: AppTextStyles.label().copyWith(
              color: AppColors.amber,
              fontSize: 11,
              letterSpacing: 1.2,
            )),
        const SizedBox(height: 16),
        for (final (label, tap) in links)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: tap,
              child: Text(label,
                  style: AppTextStyles.body().copyWith(
                    fontSize: 14,
                    color: AppColors.background.withValues(alpha: 0.8),
                  )),
            ),
          ),
      ],
    );
  }
}
