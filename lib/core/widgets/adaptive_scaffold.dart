import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../providers/progress_provider.dart';
import '../providers/settings_provider.dart';
import 'accessibility_toolbar.dart';

/// Renders a persistent left sidebar on wide screens (≥ 700 px)
/// and a floating [AccessibilityToolbar] on narrow screens.
class AdaptiveScaffold extends ConsumerWidget {
  const AdaptiveScaffold({
    required this.child,
    required this.currentPath,
    super.key,
  });

  final Widget child;
  final String currentPath;

  static const double _breakpoint = 700;

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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          child,
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AccessibilityToolbar(),
          ),
        ],
      ),
    );
  }
}

// ── Sidebar ───────────────────────────────────────────────────────────────────

class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.currentPath, required this.progress});

  final String currentPath;
  final dynamic progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final navItems = [
      _NavItem(icon: Icons.home_outlined, label: l.navHome, path: '/home'),
      _NavItem(
          icon: Icons.menu_book_outlined,
          label: l.navLibrary,
          path: '/library'),
      _NavItem(
          icon: Icons.play_circle_outlined,
          label: l.navActiveLesson,
          path: '/lesson/your_cycle',
          badge: l.navChapterBadge),
      _NavItem(
          icon: Icons.help_outline,
          label: l.navChallenges,
          path: '/quiz/your_cycle'),
      _NavItem(
          icon: Icons.forum_outlined,
          label: l.navCommunity,
          path: '/community',
          badge: '127'),
      _NavItem(
          icon: Icons.back_hand_outlined,
          label: l.navGesture,
          path: '/gesture'),
      _NavItem(
          icon: Icons.person_outline, label: l.navProfile, path: '/profile'),
      _NavItem(
          icon: Icons.settings_outlined,
          label: l.navSettings,
          path: '/settings'),
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
            // ── Logo ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'rh',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Urungano',
                          style: AppTextStyles.headline()
                              .copyWith(fontSize: 18, height: 1.1)),
                      Text('WEB',
                          style: AppTextStyles.label()
                              .copyWith(fontSize: 10, color: AppColors.ink60)),
                    ],
                  ),
                ],
              ),
            ),

            // ── Nav section label ────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text(l.navLearn,
                  style: AppTextStyles.label().copyWith(
                    letterSpacing: 1.2,
                    color: AppColors.ink60.withValues(alpha: 0.7),
                    fontSize: 10,
                  )),
            ),

            // ── Nav items ────────────────────────────────────
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: navItems
                    .map((item) => _SidebarNavTile(
                          item: item,
                          isActive: currentPath.startsWith(item.path),
                        ))
                    .toList(),
              ),
            ),

            // ── Language switcher ────────────────────────────
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: ['rw', 'en', 'fr'].map((lang) {
                    final active = lang == language;
                    return Expanded(
                      child: _LangChip(
                        label: lang.toUpperCase(),
                        active: active,
                        onTap: () {
                          // Import settings provider at the top if not already imported
                          ref.read(settingsProvider.notifier).setLanguage(lang);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── User card ────────────────────────────────────
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
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.catMenstrual,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🌸', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: AppTextStyles.body().copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
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
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.path,
    this.badge,
  });

  final IconData icon;
  final String label;
  final String path;
  final String? badge;
}

class _SidebarNavTile extends StatelessWidget {
  const _SidebarNavTile({required this.item, required this.isActive});

  final _NavItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(item.path),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.sidebarActive : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(item.icon,
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
          ],
        ),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.darkSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: active ? null : Border.all(color: AppColors.divider),
        ),
        child: Text(label,
            style: AppTextStyles.label().copyWith(
              color: active ? AppColors.white : AppColors.textSecondary,
            )),
      ),
    );
  }
}
