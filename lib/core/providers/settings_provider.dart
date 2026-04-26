import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import '../services/storage/hive_storage.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier([AppSettings? initial]) : super(initial ?? HiveStorage.loadSettings());

  Future<void> _persist(AppSettings updated) async {
    state = updated;
    await HiveStorage.saveSettings(updated);
  }

  Future<void> setVoiceNarration(bool v)   => _persist(state.copyWith(voiceNarration: v));
  Future<void> setCaptions(bool v)         => _persist(state.copyWith(captions: v));
  Future<void> setSignLanguage(bool v)     => _persist(state.copyWith(signLanguage: v));
  Future<void> setGestureControl(bool v)   => _persist(state.copyWith(gestureControl: v));
  Future<void> setHighContrast(bool v)     => _persist(state.copyWith(highContrast: v));
  Future<void> setLargerText(bool v)       => _persist(state.copyWith(largerText: v));
  Future<void> setAppLock(bool v)          => _persist(state.copyWith(appLock: v));
  Future<void> setPrivateMode(bool v)      => _persist(state.copyWith(privateMode: v));
  Future<void> setIncognitoLessons(bool v) => _persist(state.copyWith(incognitoLessons: v));
  Future<void> setLanguage(String lang)    => _persist(state.copyWith(language: lang));

  Future<void> completeOnboarding() =>
      _persist(state.copyWith(onboardingComplete: true));
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>(
  (_) => SettingsNotifier(),
);
