import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool voiceNarration;
  final bool captions;
  final bool signLanguage;
  final bool gestureControl;
  final bool highContrast;
  final bool largerText;
  final bool appLock;
  final bool privateMode;
  final bool incognitoLessons;
  final String language; // 'rw' | 'en' | 'fr'
  final bool onboardingComplete;

  const AppSettings({
    required this.voiceNarration,
    required this.captions,
    required this.signLanguage,
    required this.gestureControl,
    required this.highContrast,
    required this.largerText,
    required this.appLock,
    required this.privateMode,
    required this.incognitoLessons,
    required this.language,
    required this.onboardingComplete,
  });

  static const AppSettings defaults = AppSettings(
    voiceNarration:     true,
    captions:           true,
    signLanguage:       false,
    gestureControl:     false,
    highContrast:       false,
    largerText:         false,
    appLock:            false,
    privateMode:        false,
    incognitoLessons:   false,
    language:           'rw',
    onboardingComplete: false,
  );

  double get textScaleFactor => largerText ? 1.18 : 1.0;

  AppSettings copyWith({
    bool? voiceNarration,
    bool? captions,
    bool? signLanguage,
    bool? gestureControl,
    bool? highContrast,
    bool? largerText,
    bool? appLock,
    bool? privateMode,
    bool? incognitoLessons,
    String? language,
    bool? onboardingComplete,
  }) =>
      AppSettings(
        voiceNarration:     voiceNarration ?? this.voiceNarration,
        captions:           captions ?? this.captions,
        signLanguage:       signLanguage ?? this.signLanguage,
        gestureControl:     gestureControl ?? this.gestureControl,
        highContrast:       highContrast ?? this.highContrast,
        largerText:         largerText ?? this.largerText,
        appLock:            appLock ?? this.appLock,
        privateMode:        privateMode ?? this.privateMode,
        incognitoLessons:   incognitoLessons ?? this.incognitoLessons,
        language:           language ?? this.language,
        onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      );

  @override
  List<Object?> get props => [
        voiceNarration, captions, signLanguage, gestureControl,
        highContrast, largerText, appLock, privateMode,
        incognitoLessons, language, onboardingComplete,
      ];
}
