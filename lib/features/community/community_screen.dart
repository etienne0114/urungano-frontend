import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urungano/l10n/app_localizations.dart';
import 'package:urungano/core/services/api/community_service.dart';
import 'package:urungano/core/providers/community_provider.dart';
import 'package:urungano/core/providers/settings_provider.dart';
import 'package:urungano/core/theme/app_colors.dart';
import 'package:urungano/core/theme/app_text_styles.dart';
import 'package:urungano/core/widgets/constrained_screen_wrapper.dart';
import 'package:urungano/features/community/widgets/circles_tab.dart';
import 'package:urungano/features/community/widgets/debate_tab.dart';
import 'package:urungano/features/community/widgets/ask_anon_tab.dart';
import 'package:urungano/features/community/community_thread_screen.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  String? _selectedCircleId;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() {
      if (!_tab.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final scale = settings.largerText ? 1.18 : 1.0;

    final tabs = [
      l.communityTabCircles,
      l.communityTabDebate,
      l.communityTabAsk
    ];
    final isWide = MediaQuery.sizeOf(context).width >= 1100;

    if (isWide) {
      return _buildWideLayout(context, l, scale);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────
            ConstrainedScreenWrapper(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.communityTitle.toUpperCase(),
                            style: AppTextStyles.label(scaleFactor: scale)
                                .copyWith(
                                    letterSpacing: 1.5,
                                    color: AppColors.ink60,
                                    fontWeight: FontWeight.w700))
                        .animate()
                        .fadeIn(duration: 350.ms),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.display(scaleFactor: scale)
                            .copyWith(
                                fontSize: 32,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800),
                        children: [
                          TextSpan(text: '${l.communitySubtitle}\n'),
                          TextSpan(
                            text: l.communitySubtitleEnd,
                            style: AppTextStyles.display(
                                    scaleFactor: scale, italic: true)
                                .copyWith(
                              fontSize: 32,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate(delay: 100.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),
            ),

            // ── Pill tab bar ────────────────────────────────────
            ConstrainedScreenWrapper(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _PillTabBar(
                  controller: _tab,
                  labels: tabs.map((t) => t.toString()).toList(),
                  scale: scale,
                ),
              ),
            ).animate(delay: 200.ms).fadeIn(duration: 350.ms),

            const SizedBox(height: 12),

            // ── Tab views ───────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  CirclesTab(),
                  DebateTab(),
                  AskAnonTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(
      BuildContext context, AppLocalizations l, double scale) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Global Header ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 24),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                          '${l.appTitle.toUpperCase()} · ${l.communityTitle.toUpperCase()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label(scaleFactor: scale)
                              .copyWith(
                                  letterSpacing: 1.2,
                                  fontSize: 9,
                                  color:
                                      AppColors.ink60.withValues(alpha: 0.6))),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: AppColors.sageSoft,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                  color: AppColors.sage,
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(l.communityOnline(127),
                              style: AppTextStyles.label(scaleFactor: scale)
                                  .copyWith(
                                      fontSize: 8, color: AppColors.sage)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l.communityWideSubtitle,
                    style: AppTextStyles.display(scaleFactor: scale)
                        .copyWith(fontSize: 32, fontWeight: FontWeight.w700)),
                const SizedBox(height: 24),
                // Pill Tab Bar
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _PillTabBar(
                    controller: _tab,
                    scale: scale,
                    labels: [
                      l.communityTabCircles,
                      l.communityTabDebate,
                      l.communityTabAsk
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Content Area ──────────────────────────────────────────────────
          Expanded(
            child: Row(
              children: [
                // Middle-Left column
                if (_tab.index == 0)
                  Container(
                    width: 320,
                    decoration: const BoxDecoration(
                      border:
                          Border(right: BorderSide(color: AppColors.divider)),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: CirclesTab(
                            onCircleSelected: (id) =>
                                setState(() => _selectedCircleId = id),
                            selectedCircleId: _selectedCircleId,
                            isSidePanel: true,
                          ),
                        ),
                        // Weekly Banner
                        Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.peachSoft.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.auto_awesome,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: AppTextStyles.bodySmall(
                                            scaleFactor: scale)
                                        .copyWith(
                                            color: AppColors.textPrimary,
                                            height: 1.4),
                                    children: [
                                      TextSpan(
                                          text: '${l.communityWeeklyCircle} ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800)),
                                      TextSpan(
                                          text: l.communityWeeklyCircleNext),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Main Column
                Expanded(
                  child: Container(
                    color: AppColors.white,
                    child: _tab.index == 0
                        ? (_selectedCircleId != null
                            ? CommunityThreadScreen(
                                circleId: _selectedCircleId!, isEmbedded: true)
                            : _buildPlaceholder(l, scale))
                        : TabBarView(
                            controller: _tab,
                            children: [
                              const SizedBox.shrink(),
                              const DebateTab(),
                              const AskAnonTab(),
                            ],
                          ),
                  ),
                ),

                // Right Sidebar
                Container(
                  width: 300,
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: AppColors.divider)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildSidebarCard(
                          l,
                          scale,
                          title: l.communityRulesTitle,
                          icon: Icons.shield_outlined,
                          backgroundColor:
                              AppColors.sageSoft.withValues(alpha: 0.5),
                          children: [
                            l.communityRuleAnonymous,
                            l.communityRuleNoJudgment,
                            l.communityRuleModerated,
                            l.communityRuleReport,
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSidebarCard(
                          l,
                          scale,
                          title: l.communityOnlineNow.toUpperCase(),
                          child: _buildOnlineAvatarGrid(),
                        ),
                        const SizedBox(height: 20),
                        _buildSidebarCard(
                          l,
                          scale,
                          backgroundColor:
                              AppColors.peachSoft.withValues(alpha: 0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.favorite_outline,
                                  color: AppColors.primary, size: 24),
                              const SizedBox(height: 16),
                              Text(l.communityNeedPrivateChat,
                                  style: AppTextStyles.title(scaleFactor: scale)
                                      .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              Text(l.communityPrivateChatBody,
                                  style:
                                      AppTextStyles.caption(scaleFactor: scale)
                                          .copyWith(
                                              color: AppColors.ink60,
                                              height: 1.4)),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.darkSurface,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(l.communityStartPrivateChat,
                                        style: AppTextStyles.button(
                                                scaleFactor: scale)
                                            .copyWith(fontSize: 13)),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward, size: 14),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(AppLocalizations l, double scale) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child:
                const Center(child: Text('💬', style: TextStyle(fontSize: 42))),
          ),
          const SizedBox(height: 32),
          Text(l.communitySubtitleEnd,
              style: AppTextStyles.headline(scaleFactor: scale)
                  .copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Text(l.communitySelectCircle,
              style: AppTextStyles.body(scaleFactor: scale)
                  .copyWith(color: AppColors.textMuted)),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSidebarCard(AppLocalizations l, double scale,
      {String? title,
      IconData? icon,
      List<String>? children,
      Widget? child,
      Color? backgroundColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: AppColors.sage),
                const SizedBox(width: 10),
              ],
              if (title != null)
                Text(title,
                    style: AppTextStyles.title(scaleFactor: scale)
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 16),
          if (children != null)
            ...children.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                              color: AppColors.ink40, shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(item,
                            style: AppTextStyles.bodySmall(scaleFactor: scale)
                                .copyWith(
                                    height: 1.4,
                                    color: AppColors.textSecondary)),
                      ),
                    ],
                  ),
                )),
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildOnlineAvatarGrid() {
    final l = AppLocalizations.of(context);
    final emojis = [
      '🌺',
      '🌱',
      '🌻',
      '🌿',
      '🌼',
      '💚',
      '🌷',
      '🌾',
      '🦋',
      '🏵️',
      '🐝',
      '🌊'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: emojis
              .map((e) => Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: AppColors.background, shape: BoxShape.circle),
                    child: Center(
                        child: Text(e, style: const TextStyle(fontSize: 16))),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
          child: Text('+115',
              style: AppTextStyles.label()
                  .copyWith(fontSize: 10, color: AppColors.ink60)),
        ),
        const SizedBox(height: 16),
        Text(l.communityNoNamesNoPhotos,
            style: AppTextStyles.caption()
                .copyWith(fontSize: 11, fontStyle: FontStyle.italic)),
      ],
    );
  }
}

class _PillTabBar extends StatefulWidget {
  const _PillTabBar(
      {required this.controller,
      required this.labels,
      required this.scale,
      this.compact = false});

  final TabController controller;
  final List<String> labels;
  final double scale;
  final bool compact;

  @override
  State<_PillTabBar> createState() => _PillTabBarState();
}

class _PillTabBarState extends State<_PillTabBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChanged);
  }

  void _onTabChanged() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(widget.labels.length, (i) {
          final active = widget.controller.index == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.controller.animateTo(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    EdgeInsets.symmetric(vertical: widget.compact ? 8 : 12),
                decoration: BoxDecoration(
                  color: active ? AppColors.darkSurface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    if (active)
                      BoxShadow(
                        color: AppColors.darkSurface.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.labels[i],
                    style:
                        AppTextStyles.label(scaleFactor: widget.scale).copyWith(
                      color: active ? Colors.white : AppColors.textSecondary,
                      letterSpacing: 0.8,
                      fontSize: 11,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
