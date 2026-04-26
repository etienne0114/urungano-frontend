import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urungano/l10n/app_localizations.dart';
import 'package:urungano/core/models/badge_definition.dart';
import 'package:urungano/core/models/user_progress.dart';
import 'package:urungano/core/providers/progress_provider.dart';
import 'package:urungano/core/providers/settings_provider.dart';
import 'package:urungano/core/theme/app_colors.dart';
import 'package:urungano/core/theme/app_text_styles.dart';
import 'package:urungano/core/widgets/constrained_screen_wrapper.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final settings = ref.watch(settingsProvider);
    final l = AppLocalizations.of(context);

    final scaleFactor = settings.largerText ? 1.18 : 1.0;

    if (progress == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body:
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 950;

            return ConstrainedScreenWrapper(
              maxWidth: 1100,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ─────────────────────────────────────
                  _ScreenHeader(
                      title: l.profileTitle, scaleFactor: scaleFactor),
                  const SizedBox(height: 24),

                  if (isWide)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: Profile Card
                          SizedBox(
                            width: 320,
                            child: _ProfileCard(
                                progress: progress, scaleFactor: scaleFactor),
                          ),
                          const SizedBox(width: 24),
                          // Right Column: Stats, Badges, Journey
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _StatsGrid(
                                      progress: progress,
                                      scaleFactor: scaleFactor),
                                  const SizedBox(height: 24),
                                  _BadgesCard(
                                      progress: progress,
                                      scaleFactor: scaleFactor),
                                  const SizedBox(height: 24),
                                  _JourneyCard(
                                      progress: progress,
                                      scaleFactor: scaleFactor),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _ProfileCard(
                                progress: progress, scaleFactor: scaleFactor),
                            const SizedBox(height: 24),
                            _StatsGrid(
                                progress: progress, scaleFactor: scaleFactor),
                            const SizedBox(height: 24),
                            _BadgesCard(
                                progress: progress, scaleFactor: scaleFactor),
                            const SizedBox(height: 24),
                            _JourneyCard(
                                progress: progress, scaleFactor: scaleFactor),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
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

// ── Header Widget ────────────────────────────────────────────────────────────

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({required this.title, required this.scaleFactor});
  final String title;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.chevron_left_rounded, size: 28),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.white,
            padding: const EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.display(scaleFactor: scaleFactor)
                .copyWith(fontSize: 32, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05);
  }
}

// ── Left Column: Profile Card ────────────────────────────────────────────────

class _ProfileCard extends ConsumerWidget {
  const _ProfileCard({required this.progress, required this.scaleFactor});
  final UserProgress progress;
  final double scaleFactor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.divider, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink10.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Large Avatar
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFDC094), // Warm orange
                  Color(0xFFE85D75), // Rose
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                _avatarEmoji(progress.avatarSeed),
                style: const TextStyle(fontSize: 64),
              ),
            ),
          )
              .animate(key: ValueKey(progress.avatarSeed))
              .scale(duration: 500.ms, curve: Curves.easeOutBack)
              .shimmer(delay: 200.ms, duration: 800.ms),

          const SizedBox(height: 24),

          Text(
            progress.username,
            style: AppTextStyles.headline(scaleFactor: scaleFactor)
                .copyWith(fontSize: 28, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            '${l.profileAnonymous} · Joined ${_timeAgo(context, progress.joinedDate)}',
            style: AppTextStyles.bodySmall(scaleFactor: scaleFactor)
                .copyWith(color: AppColors.textSecondary, fontSize: 14),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip(
                label: l.profilePrivate,
                icon: Icons.lock_outline_rounded,
                color: AppColors.catHivSti,
                textColor: AppColors.accHivSti,
                scaleFactor: scaleFactor,
              ),
              _Chip(
                label: '${progress.language.toUpperCase()} - primary',
                color: AppColors.catMenstrual,
                textColor: AppColors.primary,
                scaleFactor: scaleFactor,
              ),
            ],
          ),

          const SizedBox(height: 32),

          OutlinedButton(
            onPressed: () {
              final nextSeed = (int.tryParse(progress.avatarSeed) ?? 0) + 1;
              ref.read(progressProvider.notifier).updateAvatarSeed('$nextSeed');
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: const Color(0xFFF5EADA),
              side: BorderSide(color: AppColors.divider, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              l.profileChangeAvatar,
              style: AppTextStyles.body(scaleFactor: scaleFactor).copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  String _avatarEmoji(String seed) {
    const emojis = ['🌸', '🛡', '🫀', '🧠', '💙', '⭐', '🌿', '🦋'];
    return emojis[(int.tryParse(seed) ?? 0) % emojis.length];
  }

  String _timeAgo(BuildContext context, DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 7) return '${(diff.inDays / 7).floor()} weeks ago';
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    return 'today';
  }
}

// ── Stats Grid ───────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.progress, required this.scaleFactor});
  final UserProgress progress;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final earnedCount = kBadgeDefinitions
        .where((b) => progress.earnedBadges.contains(b.id))
        .length;

    return Row(
      children: [
        _StatCard(
            value: '${progress.completedLessons.length}',
            label: l.profileLessons,
            color: AppColors.primary,
            scaleFactor: scaleFactor),
        const SizedBox(width: 16),
        _StatCard(
            value: '${progress.dayStreak}',
            label: l.dayStreak,
            color: const Color(0xFFF4B860),
            scaleFactor: scaleFactor),
        const SizedBox(width: 16),
        _StatCard(
            value: '${progress.accuracyPercent}%',
            label: l.profileAccuracy,
            color: AppColors.accHivSti,
            scaleFactor: scaleFactor),
        const SizedBox(width: 16),
        _StatCard(
            value: '$earnedCount',
            label: l.profileBadges,
            color: AppColors.textPrimary,
            scaleFactor: scaleFactor),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.value,
      required this.label,
      required this.color,
      required this.scaleFactor});
  final String value;
  final String label;
  final Color color;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value,
                  style: AppTextStyles.display(scaleFactor: scaleFactor)
                      .copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: color)),
            ),
            const SizedBox(height: 4),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption(scaleFactor: scaleFactor)
                    .copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ── Badges Section ───────────────────────────────────────────────────────────

class _BadgesCard extends StatelessWidget {
  const _BadgesCard({required this.progress, required this.scaleFactor});
  final UserProgress progress;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final earnedCount = kBadgeDefinitions
        .where((b) => progress.earnedBadges.contains(b.id))
        .length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l.profileBadges,
                    style: AppTextStyles.headline(scaleFactor: scaleFactor)
                        .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Text(l.profileEarnedCount(earnedCount, kBadgeDefinitions.length),
                  style: AppTextStyles.bodySmall(scaleFactor: scaleFactor)
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: kBadgeDefinitions.map((badge) {
                final earned = progress.earnedBadges.contains(badge.id);
                return _BadgeItem(
                    badge: badge, earned: earned, scaleFactor: scaleFactor);
              }).toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }
}

class _BadgeItem extends StatelessWidget {
  const _BadgeItem(
      {required this.badge, required this.earned, required this.scaleFactor});
  final BadgeDefinition badge;
  final bool earned;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: earned
            ? AppColors.catMenstrual
            : AppColors.divider.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(badge.emoji,
              style: TextStyle(
                  fontSize: 28,
                  color: earned ? null : Colors.grey.withValues(alpha: 0.5))),
          const SizedBox(height: 8),
          Text(
            badge.title,
            style: AppTextStyles.caption(scaleFactor: scaleFactor).copyWith(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: earned ? AppColors.textPrimary : AppColors.textMuted),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (!earned)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(Icons.lock_outline_rounded,
                  size: 12, color: AppColors.textMuted.withValues(alpha: 0.5)),
            ),
        ],
      ),
    );
  }
}

// ── Journey Section ──────────────────────────────────────────────────────────

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({required this.progress, required this.scaleFactor});
  final UserProgress progress;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.profileJourney,
              style: AppTextStyles.headline(scaleFactor: scaleFactor)
                  .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          if (progress.journeyEvents.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text(l.profileJourneyEmpty)),
            )
          else
            ...progress.journeyEvents
                .take(5)
                .map((e) => _JourneyItem(event: e, scaleFactor: scaleFactor)),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms);
  }
}

class _JourneyItem extends StatelessWidget {
  const _JourneyItem({required this.event, required this.scaleFactor});
  final JourneyEvent event;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    Color color() {
      switch (event.type) {
        case 'completed':
          return AppColors.accHivSti;
        case 'quiz':
          return AppColors.primary;
        case 'started':
          return const Color(0xFFF4B860);
        default:
          return AppColors.textPrimary;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(color: color(), shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.description,
                    style: AppTextStyles.body(scaleFactor: scaleFactor)
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(event.detail,
                    style: AppTextStyles.caption(scaleFactor: scaleFactor)
                        .copyWith(fontSize: 13)),
              ],
            ),
          ),
          Text(
            _formatTime(event.timestamp),
            style: AppTextStyles.caption(scaleFactor: scaleFactor)
                .copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    return 'just now';
  }
}

// ── Shared UI Components ─────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  const _Chip(
      {required this.label,
      this.icon,
      required this.color,
      required this.textColor,
      required this.scaleFactor});
  final String label;
  final IconData? icon;
  final Color color;
  final Color textColor;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.label(scaleFactor: scaleFactor).copyWith(
                color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
