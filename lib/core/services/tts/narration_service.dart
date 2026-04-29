import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:dio/dio.dart';
import '../api/api_client.dart';

/// High-quality multilingual narration for lesson chapters.
///
/// Priority stack (best quality first):
///   1. Pre-generated Piper TTS audio URL provided by the chapter data
///   2. On-demand backend synthesis via GET /tts/synthesize (Piper → eSpeak-ng)
///   3. On-device flutter_tts (platform TTS — Android Google TTS / iOS AVSpeechSynthesizer)
///
/// Language notes:
///   • English (en)  → Piper en_US-lessac-high (neural, natural-sounding)
///   • French  (fr)  → Piper fr_FR-siwis-medium (neural, natural-sounding)
///   • Kinyarwanda (rw) → no bundled neural voice yet; backend falls back to
///     a non-neural regional voice for intelligible playback.
///
/// SSML note: flutter_tts on Android/iOS supports a subset of SSML.
/// We inject <break>, <prosody>, and <emphasis> tags to improve rhythm and
/// pronunciation quality when using on-device TTS.
class NarrationService {
  NarrationService._();

  // ── Backend config ─────────────────────────────────────────────────────────
  static String get _apiBaseUrl => ApiClient.instance.baseUrl;

  static String get _serverBaseUrl {
    final uri = Uri.parse(_apiBaseUrl);
    final authority = '${uri.scheme}://${uri.authority}';
    return authority;
  }

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: _apiBaseUrl,
    connectTimeout: const Duration(seconds: 4),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // ── On-device TTS ──────────────────────────────────────────────────────────
  static final FlutterTts _tts = FlutterTts();
  static bool _ttsReady = false;
  static String _currentLocale = 'en-US';

  // ── Network audio player ───────────────────────────────────────────────────
  static final AudioPlayer _player = AudioPlayer();
  static bool _playerActive = false;

  // ── Callbacks ──────────────────────────────────────────────────────────────
  static void Function()? _onCompleteCallback;
  // Keeps a single subscription so we never accumulate listeners.
  static StreamSubscription<PlayerState>? _playerStateSub;

  // ── Initialization ─────────────────────────────────────────────────────────

  static Future<void> _initTts() async {
    if (_ttsReady) return;
    try {
      await _tts.setVolume(1.0);
      // 0.40–0.46 is optimal for educational, non-native learners.
      // Google TTS "default" rate is 0.5; we slow slightly for clarity.
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.0);

      if (defaultTargetPlatform == TargetPlatform.android) {
        // Queue mode 1 = replace: stop current utterance immediately on new speak()
        await _tts.setQueueMode(1);
        // Request higher-quality network voice on Android if available
        await _tts.setSharedInstance(true);
      }

      // Completion bridge
      _tts.setCompletionHandler(() {
        _playerActive = false;
        _onCompleteCallback?.call();
      });

      _ttsReady = true;
    } catch (e) {
      debugPrint('[NarrationService] TTS init error: $e');
    }
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Speak [text] in [languageCode] ('en', 'fr', 'rw').
  ///
  /// [audioUrl] — optional pre-generated audio URL (served from backend).
  ///   If provided and reachable, it is used directly (best quality).
  ///   Otherwise falls through to backend on-demand synthesis, then on-device TTS.
  ///
  /// For Kinyarwanda, text is sent as RW to backend fallback TTS.
  static Future<void> speak(
    String text, {
    String languageCode = 'en',
    String? audioUrl,
  }) async {
    await stop();

    final lang = languageCode;
    final speakText = text;

    debugPrint('[NarrationService] Speaking: lang=$lang, audioUrl=$audioUrl');
    debugPrint('[NarrationService] Text preview: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');

    // 1. Pre-generated audio URL (fastest path)
    if (audioUrl != null && audioUrl.isNotEmpty) {
      final resolvedUrl = _resolveUrl(audioUrl);
      debugPrint('[NarrationService] Attempting pre-generated audio: $resolvedUrl');
      final ok = await _playNetworkAudio(resolvedUrl);
      if (ok) {
        debugPrint('[NarrationService] Successfully playing pre-generated audio');
        return;
      }
      debugPrint('[NarrationService] Pre-generated audio failed, falling back...');
    }

    // 2. Backend on-demand synthesis (Piper neural TTS)
    final backendUrl = await _fetchBackendAudioUrl(speakText, lang);
    if (backendUrl != null) {
      final resolvedUrl = _resolveUrl(backendUrl);
      debugPrint('[NarrationService] Attempting backend synthesis: $resolvedUrl');
      final ok = await _playNetworkAudio(resolvedUrl);
      if (ok) {
        debugPrint('[NarrationService] Successfully playing backend synthesis');
        return;
      }
      debugPrint('[NarrationService] Backend synthesis failed, falling back...');
    }

    // 3. On-device TTS (platform fallback)
    debugPrint('[NarrationService] Using on-device TTS');
    await _speakOnDevice(speakText, lang);
  }

  static Future<void> stop() async {
    _playerActive = false;
    try {
      await _player.stop();
    } catch (_) {}
    try {
      await _tts.stop();
    } catch (_) {}
  }

  static Future<void> pause() async {
    try {
      if (_playerActive) {
        await _player.pause();
      } else {
        await _tts.pause();
      }
    } catch (_) {}
  }

  static Future<void> resume() async {
    try {
      if (_playerActive) {
        await _player.play();
      } else {
        await _tts.speak('');
      }
    } catch (_) {}
  }

  /// Register callback fired when the current narration completes.
  /// Cancels any previous player-stream subscription so listeners don't pile up
  /// across chapter changes (each new NarrationPlayerBar calls this in initState).
  static void onComplete(void Function() cb) {
    _onCompleteCallback = cb;
    _tts.setCompletionHandler(() {
      _playerActive = false;
      cb();
    });
    _playerStateSub?.cancel();
    _playerStateSub = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed && _playerActive) {
        _playerActive = false;
        cb();
      }
    });
  }

  /// Word-level progress callback for on-device TTS caption highlighting.
  /// Not available when playing network audio.
  static void onProgress(void Function(String word, int start, int end) cb) {
    _tts.setProgressHandler(
      (text, start, end, word) => cb(word, start, end),
    );
  }

  /// Whether this language has a high-quality neural TTS voice available.
  /// Always true for en/fr (Piper models). False for rw (captions only).
  static bool hasNeuralTts(String languageCode) => languageCode != 'rw';

  // ── Private helpers ─────────────────────────────────────────────────────────

  /// Fetch an audio URL from the backend TTS synthesis endpoint.
  static Future<String?> _fetchBackendAudioUrl(String text, String lang) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        '/tts/synthesize',
        queryParameters: {'text': text, 'lang': lang},
        options: Options(
          // 204 = TTS temporarily unavailable; treat as soft no-op
          validateStatus: (s) => s != null && s < 600,
          receiveTimeout: const Duration(seconds: 25),
        ),
      );
      if (resp.statusCode != 200) return null;
      return resp.data?['url'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Play audio from a network or file URL via just_audio.
  static Future<bool> _playNetworkAudio(String url) async {
    try {
      // Stop any current playback and clear the audio source completely
      await _player.stop();
      
      // Add a small delay to ensure the player is fully stopped
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Set the new URL - this forces a fresh load from the network
      await _player.setUrl(url);
      
      _playerActive = true;
      await _player.play();
      return true;
    } catch (e) {
      debugPrint('[NarrationService] Network audio failed: $e');
      _playerActive = false;
      return false;
    }
  }

  /// On-device flutter_tts with SSML-enhanced text.
  static Future<void> _speakOnDevice(String text, String lang) async {
    await _initTts();
    final locale = _resolveLocale(lang);
    try {
      if (locale != _currentLocale) {
        await _tts.setLanguage(locale);
        _currentLocale = locale;
      }
      final ssml = _wrapSsml(text, lang);
      await _tts.speak(ssml);
    } catch (e) {
      debugPrint('[NarrationService] On-device TTS error: $e');
    }
  }

  /// Wrap text in SSML for better prosody on platform TTS engines.
  /// Android (Google TTS ≥ 3.x) and iOS support most SSML 1.1 tags.
  static String _wrapSsml(String text, String lang) {
    // Sentence-boundary pauses — work across EN, FR, RW
    final sentenced = text
        .replaceAllMapped(RegExp(r'\.(\s+)'),  (m) => '.<break time="420ms"/>${m[1]}')
        .replaceAllMapped(RegExp(r',(\s+)'),   (m) => ',<break time="180ms"/>${m[1]}')
        .replaceAllMapped(RegExp(r';(\s+)'),   (m) => ';<break time="280ms"/>${m[1]}')
        .replaceAllMapped(RegExp(r'\?(\s+)'),  (m) => '?<break time="380ms"/>${m[1]}')
        .replaceAllMapped(RegExp(r'!(\s+)'),   (m) => '!<break time="380ms"/>${m[1]}')
        // French guillemets / em-dashes deserve a slight pause
        .replaceAllMapped(RegExp(r'—(\s*)'),   (m) => '<break time="200ms"/>—${m[1]}');

    // Language-tuned prosody:
    //  EN: slightly slower (0.90) + gentle downward pitch — warm, educational
    //  FR: native-rate (0.92) + neutral pitch — French TTS sounds better at natural rate
    //  RW: slow (0.85) for clarity — learner-facing
    final (rate, pitch) = switch (lang) {
      'fr' => ('92%',  '0st'),
      'rw' => ('85%', '-1st'),
      _    => ('90%', '-1st'),  // en default
    };

    return '<speak>'
        '<prosody rate="$rate" pitch="$pitch" volume="loud">'
        '$sentenced'
        '</prosody>'
        '</speak>';
  }

  static String _resolveLocale(String code) {
    switch (code) {
      case 'fr': return 'fr-FR';
      case 'rw': return 'rw';   // Kinyarwanda — supported on some Android builds
      case 'en':
      default:   return 'en-US';
    }
  }

  static String _resolveUrl(String url) {
    if (url.startsWith('http')) return url;
    return '$_serverBaseUrl$url';
  }
}
