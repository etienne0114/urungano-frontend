import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:urungano/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../providers/settings_provider.dart';
import '../services/tts/narration_service.dart';

/// Floating accessibility bar shown at the bottom on mobile screens.
/// Mirrors the dark toolbar visible in the Figma designs.
class AccessibilityToolbar extends ConsumerWidget {
  const AccessibilityToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // ── Voice narration ──────────────────────────────
            _ToolbarButton(
              icon: Icons.volume_up_rounded,
              active: settings.voiceNarration,
              tooltip: l.a11yVoice,
              onTap: () => notifier.setVoiceNarration(!settings.voiceNarration),
            ),
            // ── Captions ─────────────────────────────────────
            _ToolbarButton(
              icon: Icons.closed_caption_rounded,
              active: settings.captions,
              tooltip: l.a11yCaptions,
              onTap: () => notifier.setCaptions(!settings.captions),
            ),
            // ── Gesture control ───────────────────────────────
            _ToolbarButton(
              icon: Icons.back_hand_outlined,
              active: settings.gestureControl,
              tooltip: l.gestureTitle,
              onTap: () => context.push('/gesture'),
            ),
            // ── High contrast ─────────────────────────────────
            _ToolbarButton(
              icon: Icons.contrast_rounded,
              active: settings.highContrast,
              tooltip: l.a11yContrast,
              onTap: () => notifier.setHighContrast(!settings.highContrast),
            ),
            // ── Larger text ───────────────────────────────────
            _ToolbarButton(
              icon: Icons.text_fields_rounded,
              active: settings.largerText,
              tooltip: l.a11yLargerText,
              onTap: () => notifier.setLargerText(!settings.largerText),
            ),
            // ── Stop narration / help ─────────────────────────
            _ToolbarButton(
              icon: Icons.stop_circle_outlined,
              active: false,
              tooltip: l.lessonPause,
              onTap: NarrationService.stop,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.active,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: active ? AppColors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
