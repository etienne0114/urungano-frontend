import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../../core/models/lesson.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/sync_provider.dart';
import '../../core/services/api/lesson_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/constrained_screen_wrapper.dart';
import '../../core/widgets/progress_indicator_bar.dart';
import '../../core/widgets/voice_mic_button.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final ScrollController _scrollController = ScrollController();

  LessonCategory? _filter;
  String _searchQuery = '';
  List<Lesson> _lessons = [];

  List<Lesson> get _filteredLessons {
    if (_searchQuery.isEmpty) return _lessons;
    final q = _searchQuery.toLowerCase();
    return _lessons.where((l) {
      return l.title.toLowerCase().contains(q) ||
          l.localizedTitle.values.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadInitial() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _lessons = [];
    });

    try {
      final result = await LessonService.fetchPaginated(
        category: _filter,
        page: _currentPage,
      );

      if (mounted) {
        setState(() {
          _lessons = result.data;
          _hasMore = result.meta.currentPage < result.meta.totalPages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final nextPage = _currentPage + 1;
      final result = await LessonService.fetchPaginated(
        category: _filter,
        page: nextPage,
      );

      if (mounted) {
        setState(() {
          _lessons.addAll(result.data);
          _currentPage = nextPage;
          _hasMore = result.meta.currentPage < result.meta.totalPages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final progress = ref.watch(progressProvider);
    final syncState = ref.watch(syncProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ConstrainedScreenWrapper(
          maxWidth: isWide ? 1200 : 600,
          padding: EdgeInsets.zero,
          child: RefreshIndicator(
            onRefresh: _loadInitial,
            color: AppColors.primary,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              slivers: [
                // ── Header ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(l.libraryTitle,
                            style: AppTextStyles.display().copyWith(
                                fontSize: isWide ? 42 : 36,
                                fontWeight: FontWeight.w800)),
                        if (syncState.status == SyncStatus.syncing)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary.withValues(alpha: 0.5)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 350.ms),
                ),

                // ── Voice search bar ─────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: _VoiceSearchBar(
                      languageCode: ref.read(settingsProvider).language,
                      onChanged: (q) => setState(() => _searchQuery = q),
                    ),
                  ).animate(delay: 80.ms).fadeIn(duration: 350.ms),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // ── Category filter chips ────────────────────────
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _CategoryChip(
                          label: l.libraryAll,
                          active: _filter == null,
                          onTap: () {
                            if (_filter != null) {
                              setState(() => _filter = null);
                              _loadInitial();
                            }
                          },
                        ),
                        ...LessonCategory.values.map((cat) => _CategoryChip(
                              label: cat.localizedLabel(
                                  Localizations.localeOf(context).languageCode),
                              active: _filter == cat,
                              onTap: () {
                                if (_filter != cat) {
                                  setState(() => _filter = cat);
                                  _loadInitial();
                                }
                              },
                            )),
                      ],
                    ),
                  ).animate(delay: 100.ms).fadeIn(duration: 350.ms),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // ── Grid ─────────────────────────────────────────
                if (_lessons.isEmpty && _isLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_lessons.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.library_books_outlined,
                              size: 64, color: AppColors.ink40),
                          const SizedBox(height: 16),
                          Text(l.libraryEmpty,
                              style: AppTextStyles.body()
                                  .copyWith(color: AppColors.ink60)),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: _loadInitial,
                            child: Text(l.retry),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWide ? 4 : 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: isWide ? 0.8 : 0.75,
                      ),
                      itemCount: _filteredLessons.length,
                      itemBuilder: (context, i) {
                        final lesson = _filteredLessons[i];
                        final pct = progress?.lessonProgress[lesson.id] ?? 0.0;
                        return _LibraryCard(
                          lesson: lesson,
                          progress: pct,
                        )
                            .animate(
                                delay:
                                    Duration(milliseconds: 50 + (i % 8) * 30))
                            .fadeIn(duration: 350.ms)
                            .slideY(begin: 0.05, end: 0);
                      },
                    ),
                  ),

                // ── Loading more indicator ──────────────────────
                if (_isLoading && _lessons.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 60)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active
                ? AppColors.darkSurface
                : AppColors.divider.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            if (active)
              BoxShadow(
                color: AppColors.darkSurface.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.label().copyWith(
              color: active ? AppColors.white : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

class _LibraryCard extends ConsumerWidget {
  const _LibraryCard({
    required this.lesson,
    required this.progress,
  });

  final Lesson lesson;
  final double progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l = AppLocalizations.of(context);
    final displayTitle = lesson.titleFor(settings.language);

    return GestureDetector(
      onTap: () => context.go('/lesson/${lesson.slug}'),
      child: Container(
        decoration: BoxDecoration(
          color: lesson.category.tileColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: lesson.category.accentColor.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  lesson.category.localizedLabel(settings.language),
                  style: AppTextStyles.label().copyWith(
                    color: AppColors.ink60,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(lesson.category.emoji,
                        style: const TextStyle(fontSize: 40)),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayTitle,
                    style: AppTextStyles.title().copyWith(
                        fontSize: 16, fontWeight: FontWeight.w800, height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${l.minTotal(lesson.durationMinutes)} · ${l.lessonChapter(lesson.chapters.length)}',
                    style: AppTextStyles.bodySmall()
                        .copyWith(fontSize: 12, color: AppColors.ink60),
                  ),
                  const SizedBox(height: 16),
                  ProgressIndicatorBar(
                    value: progress,
                    color: lesson.category.accentColor,
                    backgroundColor: AppColors.white.withValues(alpha: 0.4),
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

/// Search bar with inline voice mic that filters lessons in EN / FR / RW.
class _VoiceSearchBar extends StatefulWidget {
  const _VoiceSearchBar({
    required this.languageCode,
    required this.onChanged,
  });

  final String languageCode;
  final ValueChanged<String> onChanged;

  @override
  State<_VoiceSearchBar> createState() => _VoiceSearchBarState();
}

class _VoiceSearchBarState extends State<_VoiceSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, size: 18, color: AppColors.ink40),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              style: AppTextStyles.body().copyWith(fontSize: 14),
              decoration: InputDecoration(
                hintText: l.libraryFilter,
                hintStyle:
                    AppTextStyles.body().copyWith(color: AppColors.ink40, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (v) {
                widget.onChanged(v);
                setState(() {});
              },
            ),
          ),
          // Clear button
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                widget.onChanged('');
                setState(() {});
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.close_rounded, size: 16, color: AppColors.ink40),
              ),
            ),
          // Voice mic
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: VoiceMicButton(
              languageCode: widget.languageCode,
              size: 36,
              iconSize: 16,
              onResult: (text, isFinal) {
                _controller.text = text;
                widget.onChanged(text);
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
