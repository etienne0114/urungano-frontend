import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../providers/progress_provider.dart';
import '../providers/settings_provider.dart';
import '../services/tts/narration_service.dart';

/// Wide (≥ 700 px) → persistent left sidebar, identical to the web design.
/// Narrow (< 700 px) → bottom nav bar (4 tabs) + left drawer (full nav + a11y).
///
/// The accessibility toolbar that previously floated over content has been
/// removed and its controls are now inside the drawer.
class AdaptiveScaffold extends ConsumerWidget {
  const AdaptiveScaffold({
    required this.child,
    required this.currentPath,
    super.key,
  });

  final Widget child;
  final String currentPath;

  static const double _breakpoint = 700;

  /// Show hamburger on any screen reachable from the bottom nav or drawer
  /// that does not have its own back button (lesson/quiz have AppBars).
  static bool _showHamburger(String path) {
    const tabRoots = [
      '/home', '/library', '/community', '/profile',
      '/settings', '/gesture',
    ];
    return tabRoots.any((r) => path == r || path.startsWith('$r/'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= _breakpoint;
    final progress = ref.watch(progressProvider);

    if (isWide) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          children: [
            _Sidebar(currentPath: currentPath, progress: progress),
            const VerticalDivider(width: 1, color: AppColors.divider),
            Expanded(child: child),
          ],
        ),
      );
    }

    // ── Mobile layout ──────────────────────────────────────────────────────────
    // • Scaffold.drawer       → left drawer (all nav + a11y toggles)
    // • Scaffold.body         → Builder wraps child in a Stack; hamburger button
    //   overlay sits in top-left so it can call Scaffold.of(ctx).openDrawer()
    //   even when the inner Scaffold would otherwise absorb the left-swipe.
    // • Scaffold.bottomNavBar → 4-tab bar (Home, Library, Community, Profile)
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _MobileDrawer(currentPath: currentPath, progress: progress),
      body: Builder(
        builder: (scaffoldCtx) => Stack(
          children: [
            child,
            if (_showHamburger(currentPath))
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: GestureDetector(
                      onTap: () => Scaffold.of(scaffoldCtx).openDrawer(),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.menu_rounded,
                          size: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _MobileBottomNav(currentPath: currentPath),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MOBILE BOTTOM NAV — 4 primary destinations
// ══════════════════════════════════════════════════════════════════════════════
class _MobileBottomNav extends StatelessWidget {
  const _MobileBottomNav({required this.currentPath});
  final String currentPath;

  static const _tabs = [
    _NavItem(icon: Icons.home_outlined,   activeIcon: Icons.home_rounded,
        label: 'Home',      path: '/home'),
    _NavItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book_rounded,
        label: 'Library',   path: '/library'),
    _NavItem(icon: Icons.forum_outlined,  activeIcon: Icons.forum_rounded,
        label: 'Community', path: '/community'),
    _NavItem(icon: Icons.person_outline,  activeIcon: Icons.person_rounded,
        label: 'Profile',   path: '/profile'),
  ];

  int get _activeIndex {
    for (int i = 0; i < _tabs.length; i++) {
      if (currentPath.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final active = _activeIndex;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final item = _tabs[i];
              final isActive = i == active;
              return Expanded(
                child: InkWell(
                  onTap: () => context.go(item.path),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primaryLight
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            isActive ? item.activeIcon : item.icon,
                            size: 22,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MOBILE DRAWER — slides from the left; full nav + accessibility controls
// ══════════════════════════════════════════════════════════════════════════════
class _MobileDrawer extends ConsumerWidget {
  const _MobileDrawer({required this.currentPath, required this.progress});
  final String currentPath;
  final dynamic progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final username = (progress?.username as String?) ?? l.profileAnonymous;
    final streak = (progress?.dayStreak as int?) ?? 0;

    final primaryNav = [
      _NavItem(icon: Icons.home_outlined,       activeIcon: Icons.home_rounded,
          label: l.navHome,      path: '/home'),
      _NavItem(icon: Icons.menu_book_outlined,  activeIcon: Icons.menu_book_rounded,
          label: l.navLibrary,   path: '/library'),
      _NavItem(icon: Icons.forum_outlined,      activeIcon: Icons.forum_rounded,
          label: l.navCommunity, path: '/community', badge: '127'),
      _NavItem(icon: Icons.play_circle_outlined, activeIcon: Icons.play_circle_rounded,
          label: l.navActiveLesson, path: '/lesson/your_cycle',
          badge: l.navChapterBadge),
      _NavItem(icon: Icons.help_outline,        activeIcon: Icons.help_rounded,
          label: l.navChallenges, path: '/quiz/your_cycle'),
      _NavItem(icon: Icons.back_hand_outlined,  activeIcon: Icons.back_hand_rounded,
          label: l.navGesture,   path: '/gesture'),
    ];

    final accountNav = [
      _NavItem(icon: Icons.person_outline,   activeIcon: Icons.person_rounded,
          label: l.navProfile,  path: '/profile'),
      _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded,
          label: l.navSettings, path: '/settings'),
    ];

    return Drawer(
      backgroundColor: AppColors.sidebarBg,
      width: 290,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: logo + close ──────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 0),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                    child: const Center(
                      child: Text('rh', style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Urungano',
                        style: AppTextStyles.headline()
                            .copyWith(fontSize: 17, height: 1.1)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: AppColors.textMuted,
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // ── Scrollable middle: nav + accessibility ────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _drawerSection(l.navLearn),
                    ...primaryNav.map((item) => _DrawerTile(
                        item: item,
                        isActive: currentPath.startsWith(item.path),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go(item.path);
                        })),
                    const SizedBox(height: 8),
                    _drawerSection('ACCOUNT'),
                    ...accountNav.map((item) => _DrawerTile(
                        item: item,
                        isActive: currentPath.startsWith(item.path),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go(item.path);
                        })),
                    const SizedBox(height: 8),
                    _drawerSection('ACCESSIBILITY'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 8, runSpacing: 8,
                        children: [
                          _A11yChip(
                            icon: Icons.volume_up_rounded,
                            label: l.a11yVoice,
                            active: settings.voiceNarration,
                            onTap: () => notifier.setVoiceNarration(!settings.voiceNarration),
                          ),
                          _A11yChip(
                            icon: Icons.closed_caption_rounded,
                            label: l.a11yCaptions,
                            active: settings.captions,
                            onTap: () => notifier.setCaptions(!settings.captions),
                          ),
                          _A11yChip(
                            icon: Icons.contrast_rounded,
                            label: l.a11yContrast,
                            active: settings.highContrast,
                            onTap: () => notifier.setHighContrast(!settings.highContrast),
                          ),
                          _A11yChip(
                            icon: Icons.text_fields_rounded,
                            label: l.a11yLargerText,
                            active: settings.largerText,
                            onTap: () => notifier.setLargerText(!settings.largerText),
                          ),
                          _A11yChip(
                            icon: Icons.stop_circle_outlined,
                            label: l.lessonPause,
                            active: false,
                            onTap: NarrationService.stop,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // ── Language switcher ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(l.settingsLanguage.toUpperCase(),
                  style: AppTextStyles.label().copyWith(
                    letterSpacing: 1.2,
                    color: AppColors.ink60.withValues(alpha: 0.7),
                    fontSize: 10,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: ['rw', 'en', 'fr'].map((lang) {
                    final active = lang == settings.language;
                    return Expanded(
                      child: _LangChip(
                        label: lang.toUpperCase(), active: active,
                        onTap: () => notifier.setLanguage(lang),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── User card ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/profile');
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.peach.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: const BoxDecoration(
                          color: AppColors.catMenstrual, shape: BoxShape.circle),
                        child: const Center(
                          child: Text('🌸', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username,
                                style: AppTextStyles.body().copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 13)),
                            Text(l.navUserStreak(streak),
                                style: AppTextStyles.caption()
                                    .copyWith(fontSize: 10)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          size: 18, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerSection(String label) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 6),
    child: Text(label,
        style: AppTextStyles.label().copyWith(
          letterSpacing: 1.2,
          color: AppColors.ink60.withValues(alpha: 0.7),
          fontSize: 10,
        )),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED — Desktop sidebar (unchanged)
// ══════════════════════════════════════════════════════════════════════════════
class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.currentPath, required this.progress});
  final String currentPath;
  final dynamic progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final navItems = [
      _NavItem(icon: Icons.home_outlined,       activeIcon: Icons.home_rounded,
          label: l.navHome,         path: '/home'),
      _NavItem(icon: Icons.menu_book_outlined,  activeIcon: Icons.menu_book_rounded,
          label: l.navLibrary,      path: '/library'),
      _NavItem(icon: Icons.play_circle_outlined, activeIcon: Icons.play_circle_rounded,
          label: l.navActiveLesson, path: '/lesson/your_cycle',
          badge: l.navChapterBadge),
      _NavItem(icon: Icons.help_outline,        activeIcon: Icons.help_rounded,
          label: l.navChallenges,   path: '/quiz/your_cycle'),
      _NavItem(icon: Icons.forum_outlined,      activeIcon: Icons.forum_rounded,
          label: l.navCommunity,    path: '/community', badge: '127'),
      _NavItem(icon: Icons.back_hand_outlined,  activeIcon: Icons.back_hand_rounded,
          label: l.navGesture,      path: '/gesture'),
      _NavItem(icon: Icons.person_outline,      activeIcon: Icons.person_rounded,
          label: l.navProfile,      path: '/profile'),
      _NavItem(icon: Icons.settings_outlined,   activeIcon: Icons.settings_rounded,
          label: l.navSettings,     path: '/settings'),
    ];

    final username = (progress?.username as String?) ?? l.profileAnonymous;
    final streak = (progress?.dayStreak as int?) ?? 0;
    final settings = ref.watch(settingsProvider);
    final language = settings.language;

    return SizedBox(
      width: 280,
      child: ColoredBox(
        color: AppColors.sidebarBg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                  child: const Center(
                    child: Text('rh', style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Urungano',
                      style: AppTextStyles.headline()
                          .copyWith(fontSize: 18, height: 1.1)),
                  Text('WEB', style: AppTextStyles.label()
                      .copyWith(fontSize: 10, color: AppColors.ink60)),
                ]),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text(l.navLearn,
                  style: AppTextStyles.label().copyWith(
                    letterSpacing: 1.2,
                    color: AppColors.ink60.withValues(alpha: 0.7),
                    fontSize: 10,
                  )),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: navItems
                    .map((item) => _SidebarNavTile(
                        item: item,
                        isActive: currentPath.startsWith(item.path)))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Text(l.settingsLanguage.toUpperCase(),
                  style: AppTextStyles.label().copyWith(
                    letterSpacing: 1.2,
                    color: AppColors.ink60.withValues(alpha: 0.7),
                    fontSize: 10,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: ['rw', 'en', 'fr'].map((lang) {
                    final active = lang == language;
                    return Expanded(
                      child: _LangChip(
                        label: lang.toUpperCase(), active: active,
                        onTap: () =>
                            ref.read(settingsProvider.notifier).setLanguage(lang),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: InkWell(
                onTap: () => context.go('/profile'),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.peach.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(children: [
                    Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(
                          color: AppColors.catMenstrual, shape: BoxShape.circle),
                      child: const Center(
                          child: Text('🌸', style: TextStyle(fontSize: 20))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username,
                              style: AppTextStyles.body().copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 13)),
                          Text(l.navUserStreak(streak),
                              style: AppTextStyles.caption()
                                  .copyWith(fontSize: 10)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        size: 18, color: AppColors.textMuted),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED DATA MODEL
// ══════════════════════════════════════════════════════════════════════════════
class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
    this.badge,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;
  final String? badge;
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ══════════════════════════════════════════════════════════════════════════════

class _SidebarNavTile extends StatelessWidget {
  const _SidebarNavTile({required this.item, required this.isActive});
  final _NavItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.go(item.path),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.sidebarActive : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Icon(isActive ? item.activeIcon : item.icon,
            size: 20,
            color: isActive ? AppColors.white : AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(item.label,
              style: AppTextStyles.body().copyWith(
                color: isActive ? AppColors.white : AppColors.textPrimary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14,
              )),
        ),
        if (item.badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.white.withValues(alpha: 0.2)
                  : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(item.badge!,
                style: AppTextStyles.label().copyWith(
                  fontSize: 10,
                  color: isActive ? AppColors.white : AppColors.primary,
                )),
          ),
      ]),
    ),
  );
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile(
      {required this.item, required this.isActive, required this.onTap});
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Icon(isActive ? item.activeIcon : item.icon,
            size: 20,
            color: isActive ? AppColors.primary : AppColors.textSecondary),
        const SizedBox(width: 14),
        Expanded(
          child: Text(item.label,
              style: AppTextStyles.body().copyWith(
                color: isActive ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14,
              )),
        ),
        if (item.badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(item.badge!,
                style: AppTextStyles.label()
                    .copyWith(fontSize: 10, color: AppColors.primary)),
          ),
      ]),
    ),
  );
}

class _A11yChip extends StatelessWidget {
  const _A11yChip({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? AppColors.primary : AppColors.divider,
          width: 1.5,
        ),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon,
            size: 14,
            color: active ? AppColors.white : AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: active ? AppColors.white : AppColors.textSecondary,
            )),
      ]),
    ),
  );
}

class _LangChip extends StatelessWidget {
  const _LangChip(
      {required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.darkSurface : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: active ? null : Border.all(color: AppColors.divider),
      ),
      child: Text(label,
          textAlign: TextAlign.center,
          style: AppTextStyles.label().copyWith(
            color: active ? AppColors.white : AppColors.textSecondary,
          )),
    ),
  );
}
