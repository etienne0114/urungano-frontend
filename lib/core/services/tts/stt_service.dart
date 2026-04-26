import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

/// Multilingual speech-to-text service.
///
/// Language support:
///   • English      (en) → en_US (native on all platforms)
///   • French       (fr) → fr_FR (native on all platforms)
///   • Kinyarwanda  (rw) → rw_RW if the device has Google Speech v3+ data;
///     falls back to en_US otherwise. Tested on Android 12+ with updated
///     Google Speech Services.
///
/// Usage:
///   final ok = await SttService.init();
///   if (ok) {
///     await SttService.start('rw',
///       onResult: (text, isFinal) { ... },
///       onListeningChanged: (listening) { setState(() => _isListening = listening); },
///     );
///   }
class SttService {
  SttService._();

  static final SpeechToText _stt = SpeechToText();
  static bool _initialized = false;
  static bool _available = false;
  static List<LocaleName> _locales = [];

  // Active callbacks (replaced each time start() is called)
  static void Function(String text, bool isFinal)? _onResult;
  static void Function(bool isListening)? _onListeningChanged;
  static void Function(String error)? _onError;

  // ── Initialization ─────────────────────────────────────────────────────────

  /// Initialize the STT engine. Returns true when voice input is available.
  /// Safe to call multiple times (no-op after first call).
  static Future<bool> init() async {
    if (_initialized) return _available;
    try {
      _available = await _stt.initialize(
        onError: _handleError,
        onStatus: _handleStatus,
        debugLogging: false,
      );
      if (_available) {
        _locales = await _stt.locales();
      }
      _initialized = true;
      debugPrint('[SttService] available=$_available locales=${_locales.length}');
    } catch (e) {
      debugPrint('[SttService] init failed: $e');
      _available = false;
      _initialized = true;
    }
    return _available;
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Start listening in the given [languageCode] ('en', 'fr', 'rw').
  static Future<void> start(
    String languageCode, {
    required void Function(String text, bool isFinal) onResult,
    void Function(bool isListening)? onListeningChanged,
    void Function(String error)? onError,
  }) async {
    if (!await init()) {
      onError?.call('sttNotAvailable');
      return;
    }
    if (_stt.isListening) await _stt.stop();

    _onResult = onResult;
    _onListeningChanged = onListeningChanged;
    _onError = onError;

    final localeId = await _bestLocale(languageCode);
    debugPrint('[SttService] starting locale=$localeId');

    // ignore: deprecated_member_use — using direct params (still supported in 6.6.x)
    await _stt.listen(
      onResult: _handleResult,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: localeId,
      partialResults: true,
      cancelOnError: false,
      listenMode: ListenMode.dictation,
    );
    _onListeningChanged?.call(true);
  }

  /// Stop and produce a final result.
  static Future<void> stop() async {
    if (_stt.isListening) await _stt.stop();
    _onListeningChanged?.call(false);
  }

  /// Cancel without producing a result.
  static Future<void> cancel() async {
    if (_stt.isListening) await _stt.cancel();
    _onListeningChanged?.call(false);
  }

  static bool get isListening => _initialized && _stt.isListening;
  static bool get isAvailable => _available;

  /// True when the device has a Kinyarwanda (rw-RW) STT locale available.
  static bool get supportsKinyarwanda =>
      _locales.any((l) => l.localeId.toLowerCase().startsWith('rw'));

  // ── Locale resolution ──────────────────────────────────────────────────────

  static Future<String?> _bestLocale(String code) async {
    if (_locales.isEmpty) {
      try {
        _locales = await _stt.locales();
      } catch (_) {}
    }

    final candidates = _preferredLocaleIds(code);
    for (final candidate in candidates) {
      // Exact match
      for (final locale in _locales) {
        if (locale.localeId == candidate) return locale.localeId;
      }
      // Prefix match (e.g., 'fr' matches 'fr_FR', 'fr-FR')
      final prefix = candidate.toLowerCase();
      for (final locale in _locales) {
        if (locale.localeId.toLowerCase().startsWith(prefix)) {
          return locale.localeId;
        }
      }
    }
    // Fallback: first English locale, then anything
    for (final locale in _locales) {
      if (locale.localeId.toLowerCase().startsWith('en')) return locale.localeId;
    }
    return null; // platform default
  }

  static List<String> _preferredLocaleIds(String code) {
    switch (code) {
      case 'fr':
        return ['fr_FR', 'fr-FR', 'fr_BE', 'fr'];
      case 'rw':
        return ['rw_RW', 'rw-RW', 'rw', 'en_US', 'en-US'];
      case 'en':
      default:
        return ['en_US', 'en-US', 'en_GB', 'en'];
    }
  }

  // ── Internal callbacks ──────────────────────────────────────────────────────

  static void _handleResult(SpeechRecognitionResult result) {
    _onResult?.call(result.recognizedWords, result.finalResult);
    if (result.finalResult) _onListeningChanged?.call(false);
  }

  static void _handleStatus(String status) {
    debugPrint('[SttService] status=$status');
    if (status == 'notListening' || status == 'done') {
      _onListeningChanged?.call(false);
    } else if (status == 'listening') {
      _onListeningChanged?.call(true);
    }
  }

  static void _handleError(SpeechRecognitionError error) {
    debugPrint('[SttService] error=${error.errorMsg} permanent=${error.permanent}');
    _onListeningChanged?.call(false);
    _onError?.call(error.errorMsg);
  }
}
