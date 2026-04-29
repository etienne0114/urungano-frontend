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
  bool _isPaused = false;
  String _highlightedWord = '';

  /// Dual-track: a separate caption text is provided (e.g. RW captions + EN audio).
  bool get _isDualTrack =>
      widget.captionText != null && widget.captionText!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    NarrationService.onComplete(() {
      if (mounted) {
        setState(() {
          _playing = false;
          _isPaused = false;
        });
      }
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
        _isPaused = false;
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
    setState(() {
      _playing = true;
      _isPaused = false;
    });
    await NarrationService.speak(
      widget.text,
      languageCode: widget.languageCode,
      audioUrl: widget.audioUrl,
    );
  }

  Future<void> _pause() async {
    await NarrationService.pause();
    if (mounted) {
      setState(() {
        _playing = false;
        _isPaused = true;
      });
    }
  }

  Future<void> _resume() async {
    setState(() {
      _playing = true;
      _isPaused = false;
    });
    await NarrationService.resume();
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _pause();
    } else {
      if (_isPaused) {
        await _resume();
      } else {
        await _play();
      }
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

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: SafeArea(
        top: false,
        child: Row(
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

            // Audio narration label
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.volume_up_rounded,
                      size: 16,
                      color: AppColors.white.withValues(alpha: 0.6)),
                  const SizedBox(width: 8),
                  Text(
                    'Audio narration',
                    style: AppTextStyles.body().copyWith(
                      color: AppColors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // Mute/Unmute toggle
            GestureDetector(
              onTap: () => ref
                  .read(settingsProvider.notifier)
                  .setVoiceNarration(!settings.voiceNarration),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: settings.voiceNarration
                      ? Colors.transparent
                      : AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: settings.voiceNarration
                        ? AppColors.white.withValues(alpha: 0.2)
                        : AppColors.primary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  settings.voiceNarration
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded,
                  size: 20,
                  color: settings.voiceNarration
                      ? AppColors.white.withValues(alpha: 0.8)
                      : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
