import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/tts/narration_service.dart';

/// Bottom bar shown during a lesson chapter.
/// Controls narration playback with three-tier priority:
///   1. Pre-generated audio URL (Piper neural TTS, served from backend)
///   2. Backend on-demand synthesis via /tts/synthesize
///   3. On-device platform TTS (flutter_tts) with SSML prosody
///
/// For Kinyarwanda: displays captions in RW while playing EN audio.
class NarrationPlayerBar extends ConsumerStatefulWidget {
  const NarrationPlayerBar({
    required this.text,
    required this.languageCode,
    this.audioUrl,
    this.captionText,
    super.key,
  });

  /// The narration text in the display language (used as captions and TTS fallback).
  final String text;

  /// BCP-47 language code: 'en', 'fr', or 'rw'.
  final String languageCode;

  /// Optional pre-generated audio URL from backend (best quality path).
  final String? audioUrl;

  /// Optional override caption text (e.g. Kinyarwanda text when audio is in EN).
  final String? captionText;

  @override
  ConsumerState<NarrationPlayerBar> createState() =>
      _NarrationPlayerBarState();
}

class _NarrationPlayerBarState extends ConsumerState<NarrationPlayerBar> {
  bool _playing = false;
  String _highlightedWord = '';

  /// Kinyarwanda uses dual-track: RW captions + EN audio.
  bool get _isDualTrack => widget.languageCode == 'rw';

  @override
  void initState() {
    super.initState();
    NarrationService.onComplete(() {
      if (mounted) setState(() => _playing = false);
    });
    NarrationService.onProgress((word, _, __) {
      if (mounted) setState(() => _highlightedWord = word);
    });
    _autoPlay();
  }

  @override
  void didUpdateWidget(NarrationPlayerBar old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text || old.audioUrl != widget.audioUrl) {
      setState(() {
        _playing = false;
        _highlightedWord = '';
      });
      _autoPlay();
    }
  }

  void _autoPlay() {
    final settings = ref.read(settingsProvider);
    if (settings.voiceNarration) _play();
  }

  Future<void> _play() async {
    setState(() => _playing = true);
    await NarrationService.speak(
      widget.text,
      languageCode: widget.languageCode,
      audioUrl: widget.audioUrl,
    );
  }

  Future<void> _pause() async {
    await NarrationService.pause();
    setState(() => _playing = false);
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _pause();
    } else {
      await _play();
    }
  }

  @override
  void dispose() {
    NarrationService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    // Caption line: prefer explicit captionText override, then highlighted word
    final captionLine = widget.captionText ?? _highlightedWord;
    final showCaption = settings.captions && captionLine.isNotEmpty;

    // Kinyarwanda dual-track badge
    final showDualTrackBadge = _isDualTrack;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Kinyarwanda dual-track notice ─────────────────
            if (showDualTrackBadge)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.subtitles_rounded,
                        size: 14,
                        color: AppColors.amber.withValues(alpha: 0.9)),
                    const SizedBox(width: 5),
                    Text(
                      'Ibyo biboneka mu Kinyarwanda · narration mu cyongereza',
                      style: AppTextStyles.caption().copyWith(
                        color: AppColors.amber.withValues(alpha: 0.9),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

            // ── Caption / highlighted word ────────────────────
            if (showCaption) ...[
              Text(
                captionLine,
                style: AppTextStyles.body().copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
            ],

            // ── Playback controls ─────────────────────────────
            Row(
              children: [
                // Play / Pause button
                GestureDetector(
                  onTap: _toggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _playing
                          ? AppColors.primary
                          : AppColors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: AppColors.white,
                      size: 22,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Narration preview text
                Expanded(
                  child: Text(
                    widget.text,
                    style: AppTextStyles.bodySmall().copyWith(
                      color: AppColors.white.withValues(alpha: 0.55),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: 14),

                // Captions toggle
                GestureDetector(
                  onTap: () => ref
                      .read(settingsProvider.notifier)
                      .setCaptions(!settings.captions),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: settings.captions
                          ? AppColors.primary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.closed_caption_rounded,
                      size: 18,
                      color: settings.captions
                          ? AppColors.white
                          : AppColors.textMuted,
                    ),
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
