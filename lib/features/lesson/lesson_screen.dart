import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../core/models/lesson.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/services/api/lesson_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/constrained_screen_wrapper.dart';
import 'widgets/lesson_model_viewer.dart';
import 'widgets/lesson_animation_stage.dart';
import 'widgets/narration_player_bar.dart';
import 'widgets/scenes/your_cycle_chapters.dart';

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({
    required this.lessonId,
    this.initialChapter = 0,
    super.key,
  });

  final String lessonId;
  final int initialChapter;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? _activeHotspotIdx;
  Lesson? _lesson;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    final lesson = await LessonService.fetchOne(widget.lessonId);
    if (!mounted) return;

    _tabController?.dispose();
    final chapterCount = lesson?.chapters.length ?? 0;
    final initialIndex = chapterCount == 0
        ? 0
        : widget.initialChapter.clamp(0, chapterCount - 1);
    _tabController = TabController(
      length: chapterCount == 0 ? 1 : chapterCount,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController?.addListener(() {
      final controller = _tabController;
      if (controller == null || controller.indexIsChanging) return;
      setState(() => _activeHotspotIdx = null);
      _syncProgress();
    });

    setState(() {
      _lesson = lesson;
      _loading = false;
    });
  }

  Future<void> _syncProgress() async {
    final lesson = _lesson;
    final controller = _tabController;
    if (lesson == null || controller == null || lesson.chapters.isEmpty) return;

    final idx = controller.index;
    await ref.read(progressProvider.notifier).updateLessonProgress(
          widget.lessonId,
          (idx + 1) / lesson.chapters.length,
          idx,
          completed: idx == lesson.chapters.length - 1,
        );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final lesson = _lesson;
    final tabController = _tabController;
    final settings = ref.watch(settingsProvider);
    if (lesson == null || tabController == null || lesson.chapters.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(l.lessonNotFound, style: AppTextStyles.body()),
        ),
      );
    }

    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final langCode = settings.language;
    final displayTitle = lesson.localizedTitle[langCode] ?? lesson.title;
    final chapter =
        lesson.chapters.isEmpty ? null : lesson.chapters[tabController.index];
    final narrationText =
        chapter?.localizedNarration[langCode] ?? chapter?.narrationText ?? '';
    final captionText = langCode == 'rw' ? narrationText : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ConstrainedScreenWrapper(
          maxWidth: isWide ? 1200 : 600,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/library'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.divider.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          size: 22,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.lessonChapterProgress(
                              tabController.index + 1,
                              lesson.chapters.length,
                            ),
                            style: AppTextStyles.label().copyWith(
                              fontSize: 10,
                              letterSpacing: 1.5,
                              color: AppColors.ink60,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            displayTitle,
                            style: AppTextStyles.body().copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 3D animated overview stage — removed for your_cycle (chapters handle it)
              if (lesson.slug != 'your_cycle' &&
                  kAnimatedLessons.any((a) => a.id == lesson.slug))
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1013),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: LessonAnimationPlayer(lessonId: lesson.slug),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  labelStyle: AppTextStyles.body().copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                  unselectedLabelStyle: AppTextStyles.body().copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.ink60,
                  indicatorColor: AppColors.primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  dividerColor: Colors.transparent,
                  tabs: lesson.chapters
                      .map((c) =>
                          Tab(text: c.localizedTitle[langCode] ?? c.title))
                      .toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: lesson.chapters.map((ch) {
                    return isWide
                        ? _WideChapterView(
                            chapter: ch,
                            lesson: lesson,
                            languageCode: langCode,
                            activeHotspotIdx: _activeHotspotIdx,
                            onHotspotTap: (idx) =>
                                setState(() => _activeHotspotIdx = idx),
                          )
                        : _NarrowChapterView(
                            chapter: ch,
                            lesson: lesson,
                            languageCode: langCode,
                            activeHotspotIdx: _activeHotspotIdx,
                            onHotspotTap: (idx) =>
                                setState(() => _activeHotspotIdx = idx),
                          );
                  }).toList(),
                ),
              ),
              if (settings.voiceNarration && chapter != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: NarrationPlayerBar(
                    key: ValueKey(
                      'narration-${tabController.index}-${settings.language}',
                    ),
                    text: narrationText,
                    languageCode: settings.language,
                    audioUrl: chapter.audioUrl,
                    captionText: captionText,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideChapterView extends StatelessWidget {
  const _WideChapterView({
    required this.chapter,
    required this.lesson,
    required this.languageCode,
    required this.activeHotspotIdx,
    required this.onHotspotTap,
  });

  final LessonChapter chapter;
  final Lesson lesson;
  final String languageCode;
  final int? activeHotspotIdx;
  final ValueChanged<int?> onHotspotTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final localizedNarration =
        chapter.localizedNarration[languageCode] ?? chapter.narrationText;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 12, 24),
            child: Container(
              decoration: BoxDecoration(
                color: lesson.category.tileColor.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(32),
              ),
              // Animated chapter scene for your_cycle; GLB model for all others
              child: lesson.slug == 'your_cycle'
                  ? SizedBox.expand(
                      child: YourCycleChapterAnimation(
                          chapterIndex: chapter.orderIndex),
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        LessonModelViewer(
                          chapter: chapter,
                          category: lesson.category,
                          activeHotspot: activeHotspotIdx,
                          onHotspotTap: onHotspotTap,
                        ),
                        Positioned(
                          bottom: 24,
                          left: 24,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.darkSurface.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.mouse_outlined,
                                    color: AppColors.white, size: 14),
                                const SizedBox(width: 10),
                                Text(l.lessonDragHint,
                                    style: AppTextStyles.caption().copyWith(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (chapter.hotspots.isNotEmpty) ...[
                  Text(
                    l.lessonExplorePoints(chapter.hotspots.length),
                    style: AppTextStyles.label().copyWith(
                      fontSize: 10,
                      color: AppColors.ink60,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (activeHotspotIdx != null) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: lesson.category.accentColor
                              .withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter.hotspots[activeHotspotIdx!]
                                    .localizedTitle[languageCode] ??
                                chapter.hotspots[activeHotspotIdx!].title,
                            style: AppTextStyles.headline().copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            chapter.hotspots[activeHotspotIdx!]
                                    .localizedDescription[languageCode] ??
                                chapter.hotspots[activeHotspotIdx!].description,
                            style: AppTextStyles.body().copyWith(
                              fontSize: 15,
                              height: 1.6,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: 24),
                  ],
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: chapter.hotspots.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        final hotspot = chapter.hotspots[idx];
                        final active = activeHotspotIdx == idx;
                        return GestureDetector(
                          onTap: () => onHotspotTap(active ? null : idx),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.darkSurface
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              hotspot.localizedTitle[languageCode] ??
                                  hotspot.title,
                              style: AppTextStyles.title().copyWith(
                                fontSize: 15,
                                fontWeight:
                                    active ? FontWeight.bold : FontWeight.w600,
                                color: active
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ] else
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          localizedNarration,
                          style: AppTextStyles.body().copyWith(
                            fontSize: 16,
                            height: 1.8,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NarrowChapterView extends StatelessWidget {
  const _NarrowChapterView({
    required this.chapter,
    required this.lesson,
    required this.languageCode,
    required this.activeHotspotIdx,
    required this.onHotspotTap,
  });

  final LessonChapter chapter;
  final Lesson lesson;
  final String languageCode;
  final int? activeHotspotIdx;
  final ValueChanged<int?> onHotspotTap;

  @override
  Widget build(BuildContext context) {
    final localizedNarration =
        chapter.localizedNarration[languageCode] ?? chapter.narrationText;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: lesson.slug == 'your_cycle' ? 420 : 280,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  color: lesson.category.tileColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: lesson.slug == 'your_cycle'
                    ? YourCycleChapterAnimation(
                        chapterIndex: chapter.orderIndex)
                    : LessonModelViewer(
                        chapter: chapter,
                        category: lesson.category,
                        activeHotspot: activeHotspotIdx,
                        onHotspotTap: onHotspotTap,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (activeHotspotIdx != null &&
              activeHotspotIdx! < chapter.hotspots.length) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lesson.category.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                chapter.hotspots[activeHotspotIdx!]
                        .localizedDescription[languageCode] ??
                    chapter.hotspots[activeHotspotIdx!].description,
                style: AppTextStyles.body().copyWith(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 20),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              localizedNarration,
              style: AppTextStyles.body().copyWith(
                fontSize: 15,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
