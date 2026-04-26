import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../core/data/lesson_catalogue.dart';
import '../../core/models/lesson.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/services/api/lesson_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/constrained_screen_wrapper.dart';
import '../../core/widgets/progress_indicator_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Lesson> _lessons = kLessonCatalogue;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    final result = await LessonService.fetchPaginated();
    if (mounted) setState(() => _lessons = result.data);
  }

  String _greeting(AppLocalizations l) {
    final h = DateTime.now().hour;
    if (h < 12) return l.greetingGoodMorning;
    if (h < 17) return l.greetingGoodAfternoon;
    return l.greetingGoodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final progress = ref.watch(progressProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    final continueLesson = _lessons.firstWhere(
      (lsn) =>
          (progress?.lessonProgress[lsn.id] ?? 0) > 0 &&
          !(progress?.completedLessons.contains(lsn.id) ?? false),
      orElse: () =>
          _lessons.isNotEmpty ? _lessons.first : kLessonCatalogue.first,
    );
    final continuePct = progress?.lessonProgress[continueLesson.id] ?? 0.0;
    final continueChapter =
        progress?.lessonCurrentChapter[continueLesson.id] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ConstrainedScreenWrapper(
          maxWidth: isWide ? 1200 : 600,
          padding: EdgeInsets.zero,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Top Bar ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_greeting(l).toUpperCase()} · ${progress?.username ?? l.profileAnonymous}',
                              style: AppTextStyles.label().copyWith(
                                letterSpacing: 1.5,
                                color: AppColors.ink60,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(l.homeReadyForToday,
                                  style: AppTextStyles.headline().copyWith(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const _StatsHeader(),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                ),
              ),

              // ── Hero Section ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: _ContinueLearningCard(
                                lesson: continueLesson,
                                progress: continuePct,
                                chapter: continueChapter,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  _TodaysChallengeCard(
                                      lessonId: continueLesson.id),
                                  const SizedBox(height: 24),
                                  const _GestureControlCard(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _ContinueLearningCard(
                              lesson: continueLesson,
                              progress: continuePct,
                              chapter: continueChapter,
                            ),
                            const SizedBox(height: 24),
                            _TodaysChallengeCard(lessonId: continueLesson.id),
                          ],
                        ),
                )
                    .animate(delay: 150.ms)
                    .fadeIn(duration: 450.ms)
                    .slideY(begin: 0.05, end: 0),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // ── Section Title ───────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l.homePickLesson,
                          style: AppTextStyles.headline().copyWith(
                              fontSize: 24, fontWeight: FontWeight.w800)),
                      GestureDetector(
                        onTap: () => context.go('/library'),
                        child: Text(l.homeSeeAll,
                            style: AppTextStyles.bodySmall().copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ],
                  ).animate(delay: 250.ms).fadeIn(duration: 400.ms),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // ── Lessons Horizontal List ─────────────────────
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemCount: _lessons.length,
                    itemBuilder: (context, i) {
                      final lesson = _lessons[i];
                      final pct = progress?.lessonProgress[lesson.id] ?? 0.0;
                      return SizedBox(
                        width: 240,
                        child: _LessonGridCard(lesson: lesson, progress: pct),
                      );
                    },
                  ),
                ).animate(delay: 300.ms).fadeIn(duration: 450.ms),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // ── Quick Access Cards ──────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: isWide
                      ? const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _QuickA11yCard()),
                            SizedBox(width: 24),
                            Expanded(child: _PrivacyDefaultCard()),
                          ],
                        )
                      : const Column(
                          children: [
                            _QuickA11yCard(),
                            SizedBox(height: 24),
                            _PrivacyDefaultCard(),
                          ],
                        ),
                ).animate(delay: 400.ms).fadeIn(duration: 450.ms),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _StatIcon(
            icon: Icons.local_fire_department_rounded,
            color: Color(0xFFD97B3A)),
        SizedBox(width: 8),
        _StatIcon(icon: Icons.menu_book_rounded, color: AppColors.primary),
        SizedBox(width: 8),
        _StatIcon(icon: Icons.stars_rounded, color: AppColors.sun),
      ],
    );
  }
}

class _StatIcon extends StatelessWidget {
  const _StatIcon({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.divider.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({
    required this.lesson,
    required this.progress,
    required this.chapter,
  });

  final Lesson lesson;
  final double progress;
  final int chapter;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final langCode = Localizations.localeOf(context).languageCode;
    final pct = (progress * 100).round();
    final chTitle =
        lesson.chapters.isNotEmpty && chapter < lesson.chapters.length
            ? lesson.chapters[chapter].titleFor(langCode)
            : '';

    return GestureDetector(
      onTap: () => context.go('/lesson/${lesson.slug}?chapter=$chapter'),
      child: Container(
        height: 240,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE85D75), Color(0xFFC8425C)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC8425C).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.play_circle_filled_rounded,
                    size: 20, color: AppColors.white),
                const SizedBox(width: 8),
                Text(l.homeContinue.toUpperCase(),
                    style: AppTextStyles.label().copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                        letterSpacing: 1.2,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Text(
                lesson.titleFor(langCode),
                style: AppTextStyles.display(italic: true).copyWith(
                  color: AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            if (chTitle.isNotEmpty)
              Text(
                l.homeNextChapter(chTitle),
                style: AppTextStyles.bodySmall().copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ProgressIndicatorBar(
                    value: progress,
                    color: AppColors.white,
                    backgroundColor: AppColors.white.withValues(alpha: 0.3),
                    height: 6,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$pct%',
                  style: AppTextStyles.caption().copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TodaysChallengeCard extends StatelessWidget {
  const _TodaysChallengeCard({required this.lessonId});
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => context.go('/quiz/$lessonId'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkSurface.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.sun,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.quiz_rounded,
                  color: AppColors.textPrimary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.homeTodayChallenge,
                    style: AppTextStyles.label().copyWith(
                      color: AppColors.white.withValues(alpha: 0.5),
                      letterSpacing: 1.0,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(l.homeQuizDesc,
                      style: AppTextStyles.title().copyWith(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.white, size: 24),
          ],
        ),
      ),
    );
  }
}

class _GestureControlCard extends StatelessWidget {
  const _GestureControlCard();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => context.go('/gesture'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.catHivSti.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: AppColors.catHivSti.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.front_hand_rounded,
                  color: AppColors.accHivSti, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.homeGestureTryTitle,
                      style: AppTextStyles.title()
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(l.homeGestureTrySub,
                      style: AppTextStyles.bodySmall()
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.accHivSti, size: 24),
          ],
        ),
      ),
    );
  }
}

class _LessonGridCard extends ConsumerWidget {
  const _LessonGridCard({
    required this.lesson,
    required this.progress,
  });

  final Lesson lesson;
  final double progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final displayTitle = lesson.titleFor(settings.language);

    return GestureDetector(
      onTap: () => context.go('/lesson/${lesson.slug}'),
      child: Container(
        decoration: BoxDecoration(
          color: lesson.category.tileColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: _LessonIcon(emoji: lesson.category.emoji),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.category.localizedLabel(settings.language),
                      style: AppTextStyles.label().copyWith(
                          fontSize: 10,
                          color: AppColors.ink60,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(displayTitle,
                      style: AppTextStyles.title()
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w800),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  ProgressIndicatorBar(
                    value: progress,
                    color: lesson.category.accentColor,
                    backgroundColor: AppColors.white.withValues(alpha: 0.3),
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonIcon extends StatelessWidget {
  const _LessonIcon({required this.emoji});
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 40)),
      ),
    );
  }
}

class _QuickA11yCard extends ConsumerWidget {
  const _QuickA11yCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.divider.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink10.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.settingsA11y.toUpperCase(),
              style: AppTextStyles.label()
                  .copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          _A11yRow(
            label: l.a11yVoice,
            icon: Icons.volume_up_rounded,
            active: settings.voiceNarration,
            onTap: () => notifier.setVoiceNarration(!settings.voiceNarration),
          ),
          const SizedBox(height: 12),
          _A11yRow(
            label: l.a11yContrast,
            icon: Icons.contrast_rounded,
            active: settings.highContrast,
            onTap: () => notifier.setHighContrast(!settings.highContrast),
          ),
        ],
      ),
    );
  }
}

class _A11yRow extends StatelessWidget {
  const _A11yRow({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primaryLight.withValues(alpha: 0.5)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: active ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(label,
                style: AppTextStyles.body().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.primary : AppColors.textPrimary,
                )),
            const Spacer(),
            Switch(
              value: active,
              onChanged: (_) => onTap(),
              activeThumbColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyDefaultCard extends StatelessWidget {
  const _PrivacyDefaultCard();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_rounded,
                  color: AppColors.white, size: 20),
              const SizedBox(width: 10),
              Text(l.homePrivacyTitle.toUpperCase(),
                  style: AppTextStyles.label().copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 20),
          Text(l.homePrivacyHeadline,
              style: AppTextStyles.headline().copyWith(
                  fontSize: 22,
                  color: AppColors.white,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(l.homePrivacyBody,
              style: AppTextStyles.bodySmall().copyWith(
                  color: AppColors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                  height: 1.5)),
        ],
      ),
    );
  }
}
