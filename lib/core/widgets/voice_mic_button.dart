import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../services/tts/stt_service.dart';
import '../providers/settings_provider.dart';

/// A microphone button that activates speech-to-text in the current app language.
///
/// When tapped:
///   1. Requests microphone permission (handled by speech_to_text)
///   2. Starts listening (pulsing rose ring animation)
///   3. Calls [onResult] with the recognised text on each word change
///   4. Stops on second tap, silence, or 30-second timeout
///
/// Language routing:
///   • en → en_US Google/Apple Speech
///   • fr → fr_FR Google/Apple Speech
///   • rw → rw_RW if available; otherwise en_US with caption note
class VoiceMicButton extends ConsumerStatefulWidget {
  const VoiceMicButton({
    required this.onResult,
    this.languageCode,
    this.size = 44.0,
    this.iconSize = 20.0,
    super.key,
  });

  /// Called with each recognised text update. [isFinal] is true on the last result.
  final void Function(String text, bool isFinal) onResult;

  /// Override language; defaults to the current app language from settings.
  final String? languageCode;

  /// Outer button diameter.
  final double size;

  /// Mic icon size.
  final double iconSize;

  @override
  ConsumerState<VoiceMicButton> createState() => _VoiceMicButtonState();
}

class _VoiceMicButtonState extends ConsumerState<VoiceMicButton>
    with SingleTickerProviderStateMixin {
  bool _listening = false;
  String _errorCode = '';
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    SttService.cancel();
    super.dispose();
  }

  String get _effectiveLang =>
      widget.languageCode ??
      ref.read(settingsProvider).language;

  Future<void> _toggle() async {
    if (_listening) {
      await SttService.stop();
      _setListening(false);
      return;
    }

    _setListening(true);
    _errorCode = '';

    await SttService.start(
      _effectiveLang,
      onResult: (text, isFinal) {
        widget.onResult(text, isFinal);
        if (isFinal) _setListening(false);
      },
      onListeningChanged: (active) {
        if (mounted) _setListening(active);
      },
      onError: (code) {
        if (mounted) {
          setState(() => _errorCode = code);
          _setListening(false);
        }
      },
    );
  }

  void _setListening(bool value) {
    if (!mounted) return;
    setState(() => _listening = value);
    if (value) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRw = _effectiveLang == 'rw';

    return Tooltip(
      message: _listening
          ? 'Listening…'
          : (isRw && !SttService.supportsKinyarwanda
              ? 'Voice (English fallback — no rw-RW engine)'
              : 'Voice input'),
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final pulse = _listening
                ? 1.0 + (_pulseController.value * 0.35)
                : 1.0;
            return Stack(
              alignment: Alignment.center,
              children: [
                // Pulsing ring
                if (_listening)
                  Transform.scale(
                    scale: pulse,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(
                          alpha: 0.25 * (1.0 - _pulseController.value),
                        ),
                      ),
                    ),
                  ),
                // Core button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _listening
                        ? AppColors.primary
                        : (_errorCode.isNotEmpty
                            ? AppColors.amber.withValues(alpha: 0.15)
                            : AppColors.ink40.withValues(alpha: 0.10)),
                  ),
                  child: Icon(
                    _listening
                        ? Icons.mic_rounded
                        : (_errorCode.isNotEmpty
                            ? Icons.mic_off_rounded
                            : Icons.mic_none_rounded),
                    size: widget.iconSize,
                    color: _listening
                        ? Colors.white
                        : (_errorCode.isNotEmpty
                            ? AppColors.amber
                            : AppColors.ink60),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    )
        .animate(target: _listening ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(1.08, 1.08),
            duration: 200.ms, curve: Curves.easeOut);
  }
}
