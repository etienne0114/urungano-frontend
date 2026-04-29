import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_rw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('rw'),
    Locale('en'),
    Locale('fr')
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'Urungano'**
  String get appTitle;

  /// Current language code
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get langCode;

  /// Language greeting used on language screen
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get greeting;

  /// Time-based greeting
  ///
  /// In en, this message translates to:
  /// **'GOOD MORNING'**
  String get greetingGoodMorning;

  /// No description provided for @greetingGoodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'GOOD AFTERNOON'**
  String get greetingGoodAfternoon;

  /// No description provided for @greetingGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'GOOD EVENING'**
  String get greetingGoodEvening;

  /// Continue button label
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// Skip button label
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Back button label
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button label
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Submit button label
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Done button label
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Generic loading text
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// Generic connection error
  ///
  /// In en, this message translates to:
  /// **'Could not connect. Check your internet.'**
  String get errorConnection;

  /// Language selection screen title
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLang;

  /// No description provided for @langKinyarwanda.
  ///
  /// In en, this message translates to:
  /// **'Kinyarwanda'**
  String get langKinyarwanda;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get langFrench;

  /// Accessibility setup screen title
  ///
  /// In en, this message translates to:
  /// **'How do you learn best?'**
  String get a11yTitle;

  /// Accessibility setup screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Pick one or more. You can change this anytime.'**
  String get a11ySubtitle;

  /// Accessibility toggle label
  ///
  /// In en, this message translates to:
  /// **'Voice narration'**
  String get a11yVoice;

  /// No description provided for @a11yVoiceSub.
  ///
  /// In en, this message translates to:
  /// **'Audio descriptions read aloud'**
  String get a11yVoiceSub;

  /// No description provided for @a11yCaptions.
  ///
  /// In en, this message translates to:
  /// **'Captions'**
  String get a11yCaptions;

  /// No description provided for @a11yCaptionsSub.
  ///
  /// In en, this message translates to:
  /// **'Text subtitles on all narration'**
  String get a11yCaptionsSub;

  /// No description provided for @a11ySign.
  ///
  /// In en, this message translates to:
  /// **'Sign language'**
  String get a11ySign;

  /// No description provided for @a11ySignSub.
  ///
  /// In en, this message translates to:
  /// **'ISL overlay on lessons'**
  String get a11ySignSub;

  /// No description provided for @a11yGesture.
  ///
  /// In en, this message translates to:
  /// **'Hand gesture control'**
  String get a11yGesture;

  /// No description provided for @a11yGestureSub.
  ///
  /// In en, this message translates to:
  /// **'Navigate lessons with your hand'**
  String get a11yGestureSub;

  /// No description provided for @a11yContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get a11yContrast;

  /// No description provided for @a11yContrastSub.
  ///
  /// In en, this message translates to:
  /// **'Stronger colours for easier reading'**
  String get a11yContrastSub;

  /// No description provided for @a11yLargerText.
  ///
  /// In en, this message translates to:
  /// **'Larger text'**
  String get a11yLargerText;

  /// No description provided for @a11yLargerTextSub.
  ///
  /// In en, this message translates to:
  /// **'Increase text size across the app'**
  String get a11yLargerTextSub;

  /// Privacy consent screen title
  ///
  /// In en, this message translates to:
  /// **'Your privacy matters'**
  String get consentTitle;

  /// Privacy consent body text
  ///
  /// In en, this message translates to:
  /// **'Urungano is designed to be a safe space for your health journey.'**
  String get consentBody;

  /// Privacy consent agree button
  ///
  /// In en, this message translates to:
  /// **'I understand and agree to the privacy policy.'**
  String get consentAgree;

  /// No description provided for @consentPoint1Title.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on your device'**
  String get consentPoint1Title;

  /// No description provided for @consentPoint1Body.
  ///
  /// In en, this message translates to:
  /// **'All progress and settings are stored locally. Nothing is shared without your permission.'**
  String get consentPoint1Body;

  /// No description provided for @consentPoint2Title.
  ///
  /// In en, this message translates to:
  /// **'Private mode available'**
  String get consentPoint2Title;

  /// No description provided for @consentPoint2Body.
  ///
  /// In en, this message translates to:
  /// **'Enable Private Mode so the app shows a neutral screen if someone glances at your phone.'**
  String get consentPoint2Body;

  /// No description provided for @consentPoint3Title.
  ///
  /// In en, this message translates to:
  /// **'No account required'**
  String get consentPoint3Title;

  /// No description provided for @consentPoint3Body.
  ///
  /// In en, this message translates to:
  /// **'You start anonymously. An optional username helps track your learning streak.'**
  String get consentPoint3Body;

  /// No description provided for @consentPoint4Title.
  ///
  /// In en, this message translates to:
  /// **'Delete anytime'**
  String get consentPoint4Title;

  /// No description provided for @consentPoint4Body.
  ///
  /// In en, this message translates to:
  /// **'Uninstalling the app removes all stored data permanently.'**
  String get consentPoint4Body;

  /// PIN setup screen title
  ///
  /// In en, this message translates to:
  /// **'Add an app lock'**
  String get pinTitle;

  /// No description provided for @pinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a 4-digit PIN to keep your progress private.'**
  String get pinSubtitle;

  /// No description provided for @pinSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get pinSkip;

  /// No description provided for @pinSave.
  ///
  /// In en, this message translates to:
  /// **'Save PIN & continue'**
  String get pinSave;

  /// No description provided for @pinEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get pinEnter;

  /// No description provided for @pinConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get pinConfirm;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Try again.'**
  String get pinMismatch;

  /// No description provided for @pinVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get pinVerifyTitle;

  /// No description provided for @pinVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4-digit PIN to unlock the app.'**
  String get pinVerifySubtitle;

  /// No description provided for @pinVerifySubtitleFull.
  ///
  /// In en, this message translates to:
  /// **'Unlock URUNGANO to continue'**
  String get pinVerifySubtitleFull;

  /// No description provided for @pinVerifyAttemptsLeft.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. {count} attempt(s) left.'**
  String pinVerifyAttemptsLeft(int count);

  /// No description provided for @pinVerifyTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please restart the app.'**
  String get pinVerifyTooManyAttempts;

  /// No description provided for @pinForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN? Reset app'**
  String get pinForgot;

  /// No description provided for @homeReady.
  ///
  /// In en, this message translates to:
  /// **'Ready for today\'s lesson'**
  String get homeReady;

  /// No description provided for @homeWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Urungano'**
  String get homeWelcomeTitle;

  /// No description provided for @homeWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your safe space for reproductive health.'**
  String get homeWelcomeSubtitle;

  /// No description provided for @homeWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String homeWelcomeBack(String name);

  /// No description provided for @homeStartJourney.
  ///
  /// In en, this message translates to:
  /// **'START YOUR JOURNEY'**
  String get homeStartJourney;

  /// No description provided for @homeExploreLessons.
  ///
  /// In en, this message translates to:
  /// **'Explore Lessons'**
  String get homeExploreLessons;

  /// No description provided for @homeRecentProgress.
  ///
  /// In en, this message translates to:
  /// **'YOUR RECENT PROGRESS'**
  String get homeRecentProgress;

  /// No description provided for @homeContinue.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE LEARNING'**
  String get homeContinue;

  /// No description provided for @homeResume.
  ///
  /// In en, this message translates to:
  /// **'Resume lesson'**
  String get homeResume;

  /// No description provided for @homePickLesson.
  ///
  /// In en, this message translates to:
  /// **'Pick up a lesson'**
  String get homePickLesson;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all →'**
  String get homeSeeAll;

  /// No description provided for @homeTodayChallenge.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S CHALLENGE'**
  String get homeTodayChallenge;

  /// No description provided for @homeQuizDesc.
  ///
  /// In en, this message translates to:
  /// **'5 questions on menstrual health'**
  String get homeQuizDesc;

  /// No description provided for @homeQuizMeta.
  ///
  /// In en, this message translates to:
  /// **'≈ 3 min · Earns a badge'**
  String get homeQuizMeta;

  /// No description provided for @homeGestureTry.
  ///
  /// In en, this message translates to:
  /// **'Try gesture control'**
  String get homeGestureTry;

  /// No description provided for @homeGestureSub.
  ///
  /// In en, this message translates to:
  /// **'Move 3D models with your hand'**
  String get homeGestureSub;

  /// No description provided for @homeGestureNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get homeGestureNew;

  /// No description provided for @homeCommunityLabel.
  ///
  /// In en, this message translates to:
  /// **'PEER COMMUNITY'**
  String get homeCommunityLabel;

  /// No description provided for @homeCommunityOnline.
  ///
  /// In en, this message translates to:
  /// **'{count} peers online now'**
  String homeCommunityOnline(int count);

  /// No description provided for @homeCommunityCircles.
  ///
  /// In en, this message translates to:
  /// **'Cycle talk · HIV & testing · Know your body'**
  String get homeCommunityCircles;

  /// No description provided for @homeCommunityJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get homeCommunityJoin;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @librarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'all lessons'**
  String get librarySubtitle;

  /// No description provided for @libraryFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get libraryFilter;

  /// No description provided for @libraryAll.
  ///
  /// In en, this message translates to:
  /// **'All topics'**
  String get libraryAll;

  /// No description provided for @libraryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No lessons found.'**
  String get libraryEmpty;

  /// No description provided for @lessonChapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter {number}'**
  String lessonChapter(int number);

  /// No description provided for @lessonHotspots.
  ///
  /// In en, this message translates to:
  /// **'Hotspots'**
  String get lessonHotspots;

  /// No description provided for @lessonNarration.
  ///
  /// In en, this message translates to:
  /// **'Narration'**
  String get lessonNarration;

  /// No description provided for @lessonPrev.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get lessonPrev;

  /// No description provided for @lessonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get lessonNext;

  /// No description provided for @lessonPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get lessonPlay;

  /// No description provided for @lessonPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get lessonPause;

  /// No description provided for @lessonChapterProgress.
  ///
  /// In en, this message translates to:
  /// **'CHAPTER {current} OF {total}'**
  String lessonChapterProgress(int current, int total);

  /// No description provided for @lessonInteractive3D.
  ///
  /// In en, this message translates to:
  /// **'INTERACTIVE 3D'**
  String get lessonInteractive3D;

  /// No description provided for @lesson3DModel.
  ///
  /// In en, this message translates to:
  /// **'3D Model'**
  String get lesson3DModel;

  /// No description provided for @lessonDragHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to rotate · Scroll to zoom'**
  String get lessonDragHint;

  /// No description provided for @lessonExplorePoints.
  ///
  /// In en, this message translates to:
  /// **'EXPLORE {count} POINTS'**
  String lessonExplorePoints(int count);

  /// No description provided for @lessonNotFound.
  ///
  /// In en, this message translates to:
  /// **'Lesson not found.'**
  String get lessonNotFound;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @quizTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quizTitle;

  /// No description provided for @quizNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No quiz for this lesson yet.'**
  String get quizNoQuestions;

  /// No description provided for @quizBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get quizBackHome;

  /// No description provided for @quizDailyChallenge.
  ///
  /// In en, this message translates to:
  /// **'DAILY CHALLENGE'**
  String get quizDailyChallenge;

  /// No description provided for @quizExplanation.
  ///
  /// In en, this message translates to:
  /// **'EXPLANATION'**
  String get quizExplanation;

  /// No description provided for @quizReadAloud.
  ///
  /// In en, this message translates to:
  /// **'READ ALOUD'**
  String get quizReadAloud;

  /// No description provided for @quizSeeResults.
  ///
  /// In en, this message translates to:
  /// **'SEE RESULTS'**
  String get quizSeeResults;

  /// No description provided for @quizNextQuestion.
  ///
  /// In en, this message translates to:
  /// **'NEXT QUESTION'**
  String get quizNextQuestion;

  /// No description provided for @quizCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get quizCorrect;

  /// No description provided for @quizQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String quizQuestion(int current, int total);

  /// No description provided for @quizCheck.
  ///
  /// In en, this message translates to:
  /// **'Check answer'**
  String get quizCheck;

  /// No description provided for @quizFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish quiz'**
  String get quizFinish;

  /// No description provided for @quizResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz complete!'**
  String get quizResultTitle;

  /// No description provided for @quizResultScore.
  ///
  /// In en, this message translates to:
  /// **'{correct} of {total} correct'**
  String quizResultScore(int correct, int total);

  /// No description provided for @quizResultAccuracy.
  ///
  /// In en, this message translates to:
  /// **'{pct}% accuracy'**
  String quizResultAccuracy(int pct);

  /// No description provided for @quizHeadlinePerfect.
  ///
  /// In en, this message translates to:
  /// **'🎉 Perfect score!'**
  String get quizHeadlinePerfect;

  /// No description provided for @quizHeadlineGreat.
  ///
  /// In en, this message translates to:
  /// **'👍 Great work!'**
  String get quizHeadlineGreat;

  /// No description provided for @quizHeadlineKeepLearning.
  ///
  /// In en, this message translates to:
  /// **'📚 Keep learning!'**
  String get quizHeadlineKeepLearning;

  /// No description provided for @quizHeadlineTryAgain.
  ///
  /// In en, this message translates to:
  /// **'💪 Try again soon!'**
  String get quizHeadlineTryAgain;

  /// No description provided for @quizRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get quizRetry;

  /// No description provided for @quizGoHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get quizGoHome;

  /// No description provided for @gestureTitle.
  ///
  /// In en, this message translates to:
  /// **'Gesture control'**
  String get gestureTitle;

  /// No description provided for @gestureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Navigate with your hand — no touch needed.'**
  String get gestureSubtitle;

  /// No description provided for @gestureCalibration.
  ///
  /// In en, this message translates to:
  /// **'ACCESSIBILITY · CALIBRATION'**
  String get gestureCalibration;

  /// No description provided for @gestureStatusLive.
  ///
  /// In en, this message translates to:
  /// **'MediaPipe live · {fps} FPS'**
  String gestureStatusLive(double fps);

  /// No description provided for @gestureStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Camera off'**
  String get gestureStatusOff;

  /// No description provided for @gestureMapTitle.
  ///
  /// In en, this message translates to:
  /// **'GESTURE MAP'**
  String get gestureMapTitle;

  /// No description provided for @gesturePrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera stays on your device.'**
  String get gesturePrivacyTitle;

  /// No description provided for @gesturePrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'MediaPipe runs locally — frames never leave your phone or laptop. Turn off any time from Settings.'**
  String get gesturePrivacyBody;

  /// No description provided for @gestureRecalibrate.
  ///
  /// In en, this message translates to:
  /// **'Recalibrate'**
  String get gestureRecalibrate;

  /// No description provided for @gestureDetected.
  ///
  /// In en, this message translates to:
  /// **'Detected gesture: {gesture}'**
  String gestureDetected(String gesture);

  /// No description provided for @gestureEnableHint.
  ///
  /// In en, this message translates to:
  /// **'Enable gesture control to start'**
  String get gestureEnableHint;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @gesturePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your camera feed never leaves this device.'**
  String get gesturePrivacy;

  /// No description provided for @gestureFps.
  ///
  /// In en, this message translates to:
  /// **'FPS'**
  String get gestureFps;

  /// No description provided for @gestureConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get gestureConfidence;

  /// No description provided for @gestureOpen.
  ///
  /// In en, this message translates to:
  /// **'Open hand — rotate model'**
  String get gestureOpen;

  /// No description provided for @gestureOpenSub.
  ///
  /// In en, this message translates to:
  /// **'Rotate the 3D model'**
  String get gestureOpenSub;

  /// No description provided for @gesturePinch.
  ///
  /// In en, this message translates to:
  /// **'Pinch — zoom in'**
  String get gesturePinch;

  /// No description provided for @gesturePinchSub.
  ///
  /// In en, this message translates to:
  /// **'Zoom into details'**
  String get gesturePinchSub;

  /// No description provided for @gesturePoint.
  ///
  /// In en, this message translates to:
  /// **'Point — select hotspot'**
  String get gesturePoint;

  /// No description provided for @gesturePointSub.
  ///
  /// In en, this message translates to:
  /// **'Select a hotspot'**
  String get gesturePointSub;

  /// No description provided for @gestureFist.
  ///
  /// In en, this message translates to:
  /// **'Fist — pause narration'**
  String get gestureFist;

  /// No description provided for @gestureFistSub.
  ///
  /// In en, this message translates to:
  /// **'Pause the narration'**
  String get gestureFistSub;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityTitle;

  /// No description provided for @communitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'safe space,'**
  String get communitySubtitle;

  /// No description provided for @communitySubtitleEnd.
  ///
  /// In en, this message translates to:
  /// **'peer community'**
  String get communitySubtitleEnd;

  /// No description provided for @communityTabCircles.
  ///
  /// In en, this message translates to:
  /// **'Peer circles'**
  String get communityTabCircles;

  /// No description provided for @communityTabDebate.
  ///
  /// In en, this message translates to:
  /// **'Open debate'**
  String get communityTabDebate;

  /// No description provided for @communityTabAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask anonymously'**
  String get communityTabAsk;

  /// No description provided for @communityModerated.
  ///
  /// In en, this message translates to:
  /// **'Moderated'**
  String get communityModerated;

  /// No description provided for @communityOnline.
  ///
  /// In en, this message translates to:
  /// **'{count} online'**
  String communityOnline(int count);

  /// No description provided for @communityMessages.
  ///
  /// In en, this message translates to:
  /// **'{count} messages'**
  String communityMessages(int count);

  /// No description provided for @communityModeratedBy.
  ///
  /// In en, this message translates to:
  /// **'Moderated by {name}'**
  String communityModeratedBy(String name);

  /// No description provided for @communityVoteYes.
  ///
  /// In en, this message translates to:
  /// **'Vote yes'**
  String get communityVoteYes;

  /// No description provided for @communityVoteNo.
  ///
  /// In en, this message translates to:
  /// **'Vote no'**
  String get communityVoteNo;

  /// No description provided for @communityVotes.
  ///
  /// In en, this message translates to:
  /// **'{count} votes'**
  String communityVotes(int count);

  /// No description provided for @communityAskHint.
  ///
  /// In en, this message translates to:
  /// **'Ask anything — no name attached'**
  String get communityAskHint;

  /// No description provided for @communityAskPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Anonymous · routed to health educators'**
  String get communityAskPrivacy;

  /// No description provided for @communityAskAnswered.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get communityAskAnswered;

  /// No description provided for @communityAskAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Awaiting'**
  String get communityAskAwaiting;

  /// No description provided for @communityAskAwaitingFull.
  ///
  /// In en, this message translates to:
  /// **'Awaiting educator response'**
  String get communityAskAwaitingFull;

  /// No description provided for @communityHealthEducator.
  ///
  /// In en, this message translates to:
  /// **'Health educator'**
  String get communityHealthEducator;

  /// No description provided for @communitySendHint.
  ///
  /// In en, this message translates to:
  /// **'Say something…'**
  String get communitySendHint;

  /// No description provided for @communityAlreadyVoted.
  ///
  /// In en, this message translates to:
  /// **'You have already voted on this debate.'**
  String get communityAlreadyVoted;

  /// No description provided for @communityVoteError.
  ///
  /// In en, this message translates to:
  /// **'Vote could not be saved — check your connection.'**
  String get communityVoteError;

  /// No description provided for @communityMsgError.
  ///
  /// In en, this message translates to:
  /// **'Message could not be sent — check your connection.'**
  String get communityMsgError;

  /// No description provided for @communityQuestionMin.
  ///
  /// In en, this message translates to:
  /// **'Question must be at least 10 characters.'**
  String get communityQuestionMin;

  /// No description provided for @communitySubmitError.
  ///
  /// In en, this message translates to:
  /// **'Could not submit — check your connection.'**
  String get communitySubmitError;

  /// No description provided for @communityLoadErrorCircles.
  ///
  /// In en, this message translates to:
  /// **'Could not load circles'**
  String get communityLoadErrorCircles;

  /// No description provided for @communityLoadErrorDebates.
  ///
  /// In en, this message translates to:
  /// **'Could not load debates'**
  String get communityLoadErrorDebates;

  /// No description provided for @communityLoadErrorQuestions.
  ///
  /// In en, this message translates to:
  /// **'Could not load questions'**
  String get communityLoadErrorQuestions;

  /// No description provided for @communityVotesDaily.
  ///
  /// In en, this message translates to:
  /// **'{count} votes · Daily Debate'**
  String communityVotesDaily(int count);

  /// No description provided for @communityVoteYesLabel.
  ///
  /// In en, this message translates to:
  /// **'VOTE YES'**
  String get communityVoteYesLabel;

  /// No description provided for @communityVoteNoLabel.
  ///
  /// In en, this message translates to:
  /// **'VOTE NO'**
  String get communityVoteNoLabel;

  /// No description provided for @communityTimeAgoMin.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String communityTimeAgoMin(int count);

  /// No description provided for @communityTimeAgoHour.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String communityTimeAgoHour(int count);

  /// No description provided for @communityTimeAgoDay.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String communityTimeAgoDay(int count);

  /// No description provided for @communityRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe space rules'**
  String get communityRulesTitle;

  /// No description provided for @communityRulesBody.
  ///
  /// In en, this message translates to:
  /// **'Be respectful. No names. No bullying.'**
  String get communityRulesBody;

  /// No description provided for @communityOnlineNow.
  ///
  /// In en, this message translates to:
  /// **'Online now'**
  String get communityOnlineNow;

  /// No description provided for @communitySelectCircle.
  ///
  /// In en, this message translates to:
  /// **'Select a circle to start chatting'**
  String get communitySelectCircle;

  /// No description provided for @communityPeerName.
  ///
  /// In en, this message translates to:
  /// **'Warrior {id}'**
  String communityPeerName(int id);

  /// No description provided for @communityVoteYesPct.
  ///
  /// In en, this message translates to:
  /// **'{pct}% YES'**
  String communityVoteYesPct(int pct);

  /// No description provided for @communityVoteNoPct.
  ///
  /// In en, this message translates to:
  /// **'{pct}% NO'**
  String communityVoteNoPct(int pct);

  /// No description provided for @communityThreadHeader.
  ///
  /// In en, this message translates to:
  /// **'{count} messages · {moderator}'**
  String communityThreadHeader(int count, String moderator);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your journey'**
  String get profileTitle;

  /// No description provided for @profileAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous warrior'**
  String get profileAnonymous;

  /// No description provided for @profileChangeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Change avatar'**
  String get profileChangeAvatar;

  /// No description provided for @profileLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get profileLessons;

  /// No description provided for @profileAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get profileAccuracy;

  /// No description provided for @profileBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get profileBadges;

  /// No description provided for @profileEarnedCount.
  ///
  /// In en, this message translates to:
  /// **'{earned} of {total} earned'**
  String profileEarnedCount(int earned, int total);

  /// No description provided for @profileJourney.
  ///
  /// In en, this message translates to:
  /// **'Journey Timeline'**
  String get profileJourney;

  /// No description provided for @profileJourneyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Start a lesson to see your journey.'**
  String get profileJourneyEmpty;

  /// No description provided for @profilePrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get profilePrivate;

  /// No description provided for @profileBadgeLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get profileBadgeLocked;

  /// No description provided for @timeAgoMonths.
  ///
  /// In en, this message translates to:
  /// **'{count} months ago'**
  String timeAgoMonths(int count);

  /// No description provided for @timeAgoDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String timeAgoDays(int count);

  /// No description provided for @timeAgoToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get timeAgoToday;

  /// No description provided for @timeAgoHours.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String timeAgoHours(int count);

  /// No description provided for @timeAgoJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeAgoJustNow;

  /// No description provided for @journeyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get journeyCompleted;

  /// No description provided for @journeyQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz {pct}%'**
  String journeyQuiz(int pct);

  /// No description provided for @journeyStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get journeyStarted;

  /// No description provided for @journeySetup.
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get journeySetup;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsA11y.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsA11y;

  /// No description provided for @settingsDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settingsDisplay;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & safety'**
  String get settingsPrivacy;

  /// No description provided for @settingsAppLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get settingsAppLock;

  /// No description provided for @settingsAppLockSub.
  ///
  /// In en, this message translates to:
  /// **'Require PIN on startup'**
  String get settingsAppLockSub;

  /// No description provided for @settingsPrivateMode.
  ///
  /// In en, this message translates to:
  /// **'Private mode'**
  String get settingsPrivateMode;

  /// No description provided for @settingsPrivateModeSub.
  ///
  /// In en, this message translates to:
  /// **'Hide app from recent screens'**
  String get settingsPrivateModeSub;

  /// No description provided for @settingsIncognito.
  ///
  /// In en, this message translates to:
  /// **'Incognito lessons'**
  String get settingsIncognito;

  /// No description provided for @settingsIncognitoSub.
  ///
  /// In en, this message translates to:
  /// **'Skip progress tracking'**
  String get settingsIncognitoSub;

  /// No description provided for @settingsHotline.
  ///
  /// In en, this message translates to:
  /// **'Need support?'**
  String get settingsHotline;

  /// No description provided for @settingsHotlineSub.
  ///
  /// In en, this message translates to:
  /// **'Rwanda health hotline: 114'**
  String get settingsHotlineSub;

  /// No description provided for @settingsCall.
  ///
  /// In en, this message translates to:
  /// **'Call 114'**
  String get settingsCall;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Reproductive health, explained'**
  String get splashTagline;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get errorNotFound;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @categoryMenstrual.
  ///
  /// In en, this message translates to:
  /// **'Menstrual health'**
  String get categoryMenstrual;

  /// No description provided for @categoryHiv.
  ///
  /// In en, this message translates to:
  /// **'HIV & STI'**
  String get categoryHiv;

  /// No description provided for @categoryAnatomy.
  ///
  /// In en, this message translates to:
  /// **'Reproductive anatomy'**
  String get categoryAnatomy;

  /// No description provided for @categoryMental.
  ///
  /// In en, this message translates to:
  /// **'Mental health'**
  String get categoryMental;

  /// No description provided for @categoryRelations.
  ///
  /// In en, this message translates to:
  /// **'Relationships'**
  String get categoryRelations;

  /// No description provided for @minLeft.
  ///
  /// In en, this message translates to:
  /// **'{min} min left'**
  String minLeft(int min);

  /// No description provided for @minTotal.
  ///
  /// In en, this message translates to:
  /// **'{min} min'**
  String minTotal(int min);

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get dayStreak;

  /// No description provided for @lessonsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Lessons done'**
  String get lessonsCompleted;

  /// No description provided for @quizAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Quiz accuracy'**
  String get quizAccuracy;

  /// No description provided for @homeStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String homeStreakDays(int count);

  /// No description provided for @homeStreakEncouragement.
  ///
  /// In en, this message translates to:
  /// **'Keep it up!'**
  String get homeStreakEncouragement;

  /// No description provided for @homeReadyForToday.
  ///
  /// In en, this message translates to:
  /// **'Ready for today?'**
  String get homeReadyForToday;

  /// No description provided for @homeNextChapter.
  ///
  /// In en, this message translates to:
  /// **'Next: {title}'**
  String homeNextChapter(String title);

  /// No description provided for @homeGestureTryTitle.
  ///
  /// In en, this message translates to:
  /// **'Try Gestures'**
  String get homeGestureTryTitle;

  /// No description provided for @homeGestureTrySub.
  ///
  /// In en, this message translates to:
  /// **'Control with hand movements'**
  String get homeGestureTrySub;

  /// No description provided for @homePrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy First'**
  String get homePrivacyTitle;

  /// No description provided for @homePrivacyHeadline.
  ///
  /// In en, this message translates to:
  /// **'Nothing leaves this device.'**
  String get homePrivacyHeadline;

  /// No description provided for @homePrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'No tracking, no accounts, just learning. Your journey is yours alone.'**
  String get homePrivacyBody;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'LEARN'**
  String get navLearn;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navActiveLesson.
  ///
  /// In en, this message translates to:
  /// **'Active lesson'**
  String get navActiveLesson;

  /// No description provided for @navChapterBadge.
  ///
  /// In en, this message translates to:
  /// **'Ch 2'**
  String get navChapterBadge;

  /// No description provided for @navChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get navChallenges;

  /// No description provided for @navCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunity;

  /// No description provided for @navGesture.
  ///
  /// In en, this message translates to:
  /// **'Gesture'**
  String get navGesture;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navUserStreak.
  ///
  /// In en, this message translates to:
  /// **'Anonymous - {count}d streak'**
  String navUserStreak(int count);

  /// No description provided for @communityTyping.
  ///
  /// In en, this message translates to:
  /// **'Someone is typing...'**
  String get communityTyping;

  /// No description provided for @communityRecent.
  ///
  /// In en, this message translates to:
  /// **'RECENT'**
  String get communityRecent;

  /// No description provided for @communitySubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Question submitted anonymously!'**
  String get communitySubmitSuccess;

  /// No description provided for @communityAskDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get communityAskDialogTitle;

  /// No description provided for @communityAskDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Your question is completely anonymous and will be routed to our health educators.'**
  String get communityAskDialogBody;

  /// No description provided for @communityAskInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type here...'**
  String get communityAskInputHint;

  /// No description provided for @communityWideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Peer circles, open debates, anonymous questions.'**
  String get communityWideSubtitle;

  /// No description provided for @communityWeeklyCircle.
  ///
  /// In en, this message translates to:
  /// **'New circle weekly.'**
  String get communityWeeklyCircle;

  /// No description provided for @communityWeeklyCircleNext.
  ///
  /// In en, this message translates to:
  /// **'Next: \"Puberty, explained\" - opens Friday.'**
  String get communityWeeklyCircleNext;

  /// No description provided for @communityRuleAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous by default'**
  String get communityRuleAnonymous;

  /// No description provided for @communityRuleNoJudgment.
  ///
  /// In en, this message translates to:
  /// **'No judgment, no shame'**
  String get communityRuleNoJudgment;

  /// No description provided for @communityRuleModerated.
  ///
  /// In en, this message translates to:
  /// **'Moderated by real health educators'**
  String get communityRuleModerated;

  /// No description provided for @communityRuleReport.
  ///
  /// In en, this message translates to:
  /// **'Report anything that feels off'**
  String get communityRuleReport;

  /// No description provided for @communityNeedPrivateChat.
  ///
  /// In en, this message translates to:
  /// **'Need to talk 1-on-1?'**
  String get communityNeedPrivateChat;

  /// No description provided for @communityPrivateChat.
  ///
  /// In en, this message translates to:
  /// **'Private chat'**
  String get communityPrivateChat;

  /// No description provided for @communityPrivateChatBody.
  ///
  /// In en, this message translates to:
  /// **'Free, confidential chat with a health educator in Kinyarwanda, English, or French.'**
  String get communityPrivateChatBody;

  /// No description provided for @communityStartPrivateChat.
  ///
  /// In en, this message translates to:
  /// **'Start private chat'**
  String get communityStartPrivateChat;

  /// No description provided for @communityNoNamesNoPhotos.
  ///
  /// In en, this message translates to:
  /// **'No names. No photos. Only vibes.'**
  String get communityNoNamesNoPhotos;

  /// No description provided for @gestureSwipeRight.
  ///
  /// In en, this message translates to:
  /// **'Swipe right'**
  String get gestureSwipeRight;

  /// No description provided for @gestureSwipeLeft.
  ///
  /// In en, this message translates to:
  /// **'Swipe left'**
  String get gestureSwipeLeft;

  /// No description provided for @gestureSwipeUp.
  ///
  /// In en, this message translates to:
  /// **'Swipe up'**
  String get gestureSwipeUp;

  /// No description provided for @gestureOpenPalm.
  ///
  /// In en, this message translates to:
  /// **'Open palm'**
  String get gestureOpenPalm;

  /// No description provided for @gestureThumbsUp.
  ///
  /// In en, this message translates to:
  /// **'Thumbs up'**
  String get gestureThumbsUp;

  /// No description provided for @gesturePinchLabel.
  ///
  /// In en, this message translates to:
  /// **'Pinch'**
  String get gesturePinchLabel;

  /// No description provided for @gestureActionNextChapter.
  ///
  /// In en, this message translates to:
  /// **'Next chapter'**
  String get gestureActionNextChapter;

  /// No description provided for @gestureActionPrevChapter.
  ///
  /// In en, this message translates to:
  /// **'Previous chapter'**
  String get gestureActionPrevChapter;

  /// No description provided for @gestureActionScroll.
  ///
  /// In en, this message translates to:
  /// **'Scroll content'**
  String get gestureActionScroll;

  /// No description provided for @gestureActionPauseNarration.
  ///
  /// In en, this message translates to:
  /// **'Pause narration'**
  String get gestureActionPauseNarration;

  /// No description provided for @gestureActionMarkUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Mark understood'**
  String get gestureActionMarkUnderstood;

  /// No description provided for @gestureActionZoomModel.
  ///
  /// In en, this message translates to:
  /// **'Zoom 3D model'**
  String get gestureActionZoomModel;

  /// No description provided for @gestureOverlayModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get gestureOverlayModel;

  /// No description provided for @gestureOverlayLandmarks.
  ///
  /// In en, this message translates to:
  /// **'Landmarks'**
  String get gestureOverlayLandmarks;

  /// No description provided for @gestureOverlayHand.
  ///
  /// In en, this message translates to:
  /// **'Hand'**
  String get gestureOverlayHand;

  /// No description provided for @gestureOverlayHandRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get gestureOverlayHandRight;

  /// No description provided for @gestureOverlayLatency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get gestureOverlayLatency;

  /// No description provided for @lessonAutoRotateStart.
  ///
  /// In en, this message translates to:
  /// **'Start auto-rotate'**
  String get lessonAutoRotateStart;

  /// No description provided for @lessonAutoRotateStop.
  ///
  /// In en, this message translates to:
  /// **'Stop auto-rotate'**
  String get lessonAutoRotateStop;

  /// No description provided for @lessonZoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get lessonZoomIn;

  /// No description provided for @lessonZoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get lessonZoomOut;

  /// No description provided for @lessonResetView.
  ///
  /// In en, this message translates to:
  /// **'Reset view'**
  String get lessonResetView;

  /// No description provided for @pinWeakError.
  ///
  /// In en, this message translates to:
  /// **'PIN cannot be sequential (e.g. 1234) or repeated (e.g. 1111).'**
  String get pinWeakError;

  /// No description provided for @pinSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sync PIN with server. Please try a different PIN.'**
  String get pinSyncFailed;

  /// No description provided for @pinUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get pinUsernameHint;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a username to continue'**
  String get profileNameRequired;

  /// No description provided for @sttListening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get sttListening;

  /// No description provided for @sttTapToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap to speak'**
  String get sttTapToSpeak;

  /// No description provided for @sttSpeakNow.
  ///
  /// In en, this message translates to:
  /// **'Speak now'**
  String get sttSpeakNow;

  /// No description provided for @sttNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Voice input is not available on this device'**
  String get sttNotAvailable;

  /// No description provided for @sttNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get sttNoPermission;

  /// No description provided for @sttKinyarwandaNote.
  ///
  /// In en, this message translates to:
  /// **'Kinyarwanda voice is limited — the app will do its best'**
  String get sttKinyarwandaNote;

  /// No description provided for @sttVoiceInput.
  ///
  /// In en, this message translates to:
  /// **'Voice input'**
  String get sttVoiceInput;

  /// No description provided for @sttVoiceSearch.
  ///
  /// In en, this message translates to:
  /// **'Voice search'**
  String get sttVoiceSearch;

  /// No description provided for @sttTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get sttTryAgain;

  /// No description provided for @homeStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Your streak'**
  String get homeStreakTitle;

  /// No description provided for @homeStreakDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'{days} day streak'**
  String homeStreakDaysLabel(int days);

  /// No description provided for @communityOfflineQueued.
  ///
  /// In en, this message translates to:
  /// **'Message queued — will send when online'**
  String get communityOfflineQueued;

  /// No description provided for @communityVoteOffline.
  ///
  /// In en, this message translates to:
  /// **'You’re offline — vote when reconnected'**
  String get communityVoteOffline;

  /// No description provided for @communityQuestionQueued.
  ///
  /// In en, this message translates to:
  /// **'Question queued — will send when online'**
  String get communityQuestionQueued;

  /// Text shown when a community chat thread is empty
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Be the first to say something!'**
  String get communityEmptyChat;

  /// No description provided for @cycleDragHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to rotate · Pinch to zoom · Double-tap to reset'**
  String get cycleDragHint;

  /// No description provided for @cycleTapWheelHint.
  ///
  /// In en, this message translates to:
  /// **'Tap any phase on the wheel'**
  String get cycleTapWheelHint;

  /// No description provided for @cycleHideLabels.
  ///
  /// In en, this message translates to:
  /// **'Hide labels'**
  String get cycleHideLabels;

  /// No description provided for @cycleShowLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get cycleShowLabels;

  /// No description provided for @cyclePhasesBtn.
  ///
  /// In en, this message translates to:
  /// **'Phases'**
  String get cyclePhasesBtn;

  /// No description provided for @cycleCloseBtn.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get cycleCloseBtn;

  /// No description provided for @cycleDayBadge.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String cycleDayBadge(String day);

  /// No description provided for @cycleHormonesLabel.
  ///
  /// In en, this message translates to:
  /// **'HORMONES'**
  String get cycleHormonesLabel;

  /// No description provided for @cycleOestrogen.
  ///
  /// In en, this message translates to:
  /// **'Oestrogen'**
  String get cycleOestrogen;

  /// No description provided for @cycleProgesterone.
  ///
  /// In en, this message translates to:
  /// **'Prog.'**
  String get cycleProgesterone;

  /// No description provided for @cycleLH.
  ///
  /// In en, this message translates to:
  /// **'LH'**
  String get cycleLH;

  /// No description provided for @cycleFSH.
  ///
  /// In en, this message translates to:
  /// **'FSH'**
  String get cycleFSH;

  /// No description provided for @cyclePhaseMenstrual.
  ///
  /// In en, this message translates to:
  /// **'Menstrual'**
  String get cyclePhaseMenstrual;

  /// No description provided for @cyclePhaseFollicular.
  ///
  /// In en, this message translates to:
  /// **'Follicular'**
  String get cyclePhaseFollicular;

  /// No description provided for @cyclePhaseOvulation.
  ///
  /// In en, this message translates to:
  /// **'Ovulation'**
  String get cyclePhaseOvulation;

  /// No description provided for @cyclePhaseLuteal.
  ///
  /// In en, this message translates to:
  /// **'Luteal'**
  String get cyclePhaseLuteal;

  /// No description provided for @cyclePhaseMenstrualDays.
  ///
  /// In en, this message translates to:
  /// **'Days 1–5'**
  String get cyclePhaseMenstrualDays;

  /// No description provided for @cyclePhaseFollicularDays.
  ///
  /// In en, this message translates to:
  /// **'Days 6–13'**
  String get cyclePhaseFollicularDays;

  /// No description provided for @cyclePhaseOvulationDay.
  ///
  /// In en, this message translates to:
  /// **'Day 14'**
  String get cyclePhaseOvulationDay;

  /// No description provided for @cyclePhaseLutealDays.
  ///
  /// In en, this message translates to:
  /// **'Days 15–28'**
  String get cyclePhaseLutealDays;

  /// No description provided for @cyclePhaseMenstrualDesc.
  ///
  /// In en, this message translates to:
  /// **'The endometrial lining sheds. Prostaglandins cause uterine contractions. Hormone levels are at their lowest point in the cycle.'**
  String get cyclePhaseMenstrualDesc;

  /// No description provided for @cyclePhaseFollicularDesc.
  ///
  /// In en, this message translates to:
  /// **'FSH stimulates follicle growth. Rising oestrogen rebuilds the endometrium. Energy and mood often peak in this phase.'**
  String get cyclePhaseFollicularDesc;

  /// No description provided for @cyclePhaseOvulationDesc.
  ///
  /// In en, this message translates to:
  /// **'LH surge triggers egg release from the dominant follicle. Peak fertility. Cervical mucus becomes clear and stretchy.'**
  String get cyclePhaseOvulationDesc;

  /// No description provided for @cyclePhaseLutealDesc.
  ///
  /// In en, this message translates to:
  /// **'Corpus luteum secretes progesterone, maintaining the thickened endometrium. If no fertilisation, progesterone drops and menstruation begins.'**
  String get cyclePhaseLutealDesc;

  /// No description provided for @cyclePhaseMenstrualDescAlt.
  ///
  /// In en, this message translates to:
  /// **'The endometrium sheds. Prostaglandins cause uterine contractions expelling the lining. Hormone levels reach their lowest point.'**
  String get cyclePhaseMenstrualDescAlt;

  /// No description provided for @cyclePhaseFollicularDescAlt.
  ///
  /// In en, this message translates to:
  /// **'FSH stimulates several follicles. The dominant follicle produces oestrogen, rebuilding the endometrium and suppressing others.'**
  String get cyclePhaseFollicularDescAlt;

  /// No description provided for @cyclePhaseOvulationDescAlt.
  ///
  /// In en, this message translates to:
  /// **'LH surge triggers rupture of the dominant follicle, releasing the egg into the fallopian tube. Peak fertility.'**
  String get cyclePhaseOvulationDescAlt;

  /// No description provided for @cyclePhaseLutealDescAlt.
  ///
  /// In en, this message translates to:
  /// **'The corpus luteum produces progesterone, maintaining the endometrium. If no fertilisation, it degrades and the cycle restarts.'**
  String get cyclePhaseLutealDescAlt;

  /// No description provided for @cycleHormoneMenstrualLevel.
  ///
  /// In en, this message translates to:
  /// **'FSH ↓ LH ↓ Oestrogen ↓'**
  String get cycleHormoneMenstrualLevel;

  /// No description provided for @cycleHormoneFollicularLevel.
  ///
  /// In en, this message translates to:
  /// **'FSH ↑ Oestrogen ↑'**
  String get cycleHormoneFollicularLevel;

  /// No description provided for @cycleHormoneOvulationLevel.
  ///
  /// In en, this message translates to:
  /// **'LH surge · Oestrogen peak'**
  String get cycleHormoneOvulationLevel;

  /// No description provided for @cycleHormoneLutealLevel.
  ///
  /// In en, this message translates to:
  /// **'Progesterone ↑ Oestrogen ↑'**
  String get cycleHormoneLutealLevel;

  /// No description provided for @cycleAnatomyFallopian.
  ///
  /// In en, this message translates to:
  /// **'Fallopian tube'**
  String get cycleAnatomyFallopian;

  /// No description provided for @cycleAnatomyUterineFundus.
  ///
  /// In en, this message translates to:
  /// **'Uterine fundus'**
  String get cycleAnatomyUterineFundus;

  /// No description provided for @cycleAnatomyOvary.
  ///
  /// In en, this message translates to:
  /// **'Ovary'**
  String get cycleAnatomyOvary;

  /// No description provided for @cycleAnatomyEndometrium.
  ///
  /// In en, this message translates to:
  /// **'Endometrium'**
  String get cycleAnatomyEndometrium;

  /// No description provided for @cycleAnatomyMyometrium.
  ///
  /// In en, this message translates to:
  /// **'Myometrium'**
  String get cycleAnatomyMyometrium;

  /// No description provided for @cycleAnatomyCervix.
  ///
  /// In en, this message translates to:
  /// **'Cervix'**
  String get cycleAnatomyCervix;

  /// No description provided for @cycleAnatomyVagina.
  ///
  /// In en, this message translates to:
  /// **'Vagina'**
  String get cycleAnatomyVagina;

  /// No description provided for @cycleAnatomyBroadLig.
  ///
  /// In en, this message translates to:
  /// **'Broad ligament'**
  String get cycleAnatomyBroadLig;

  /// No description provided for @cycleAnatomyOvarianLig.
  ///
  /// In en, this message translates to:
  /// **'Ovarian lig.'**
  String get cycleAnatomyOvarianLig;

  /// No description provided for @cycleAnatomyPerimetrium.
  ///
  /// In en, this message translates to:
  /// **'Perimetrium'**
  String get cycleAnatomyPerimetrium;

  /// No description provided for @cycleCh1HsOvaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Each ovary is ~3 cm and contains 300,000+ primordial follicles. Each month FSH stimulates several to grow — usually one matures and releases an egg at ovulation.'**
  String get cycleCh1HsOvaryDesc;

  /// No description provided for @cycleCh1HsFallopianDesc.
  ///
  /// In en, this message translates to:
  /// **'~10 cm long with finger-like fimbriae that sweep the released egg inward. Fertilisation by sperm most often occurs in the outer third of the tube.'**
  String get cycleCh1HsFallopianDesc;

  /// No description provided for @cycleCh1HsEndometriumDesc.
  ///
  /// In en, this message translates to:
  /// **'The inner mucosal lining. Thickness ranges from ~2 mm after menstruation to ~12 mm in the luteal phase. Shed as a period if no implantation occurs.'**
  String get cycleCh1HsEndometriumDesc;

  /// No description provided for @cycleCh1HsCervixDesc.
  ///
  /// In en, this message translates to:
  /// **'Lower narrow neck of the uterus. Produces mucus that changes throughout the cycle — clear and stretchy at ovulation, thick and opaque at other times.'**
  String get cycleCh1HsCervixDesc;

  /// No description provided for @cycleCh3Title.
  ///
  /// In en, this message translates to:
  /// **'Cramps & pain'**
  String get cycleCh3Title;

  /// No description provided for @cycleCh3PainIntensity.
  ///
  /// In en, this message translates to:
  /// **'Pain intensity'**
  String get cycleCh3PainIntensity;

  /// No description provided for @cycleCh3Heat.
  ///
  /// In en, this message translates to:
  /// **'Heat'**
  String get cycleCh3Heat;

  /// No description provided for @cycleCh3HeatDesc.
  ///
  /// In en, this message translates to:
  /// **'Relaxes muscle spasm, increases blood flow. Apply 15–20 min.'**
  String get cycleCh3HeatDesc;

  /// No description provided for @cycleCh3Ibuprofen.
  ///
  /// In en, this message translates to:
  /// **'Ibuprofen'**
  String get cycleCh3Ibuprofen;

  /// No description provided for @cycleCh3IbuprofenDesc.
  ///
  /// In en, this message translates to:
  /// **'NSAIDs inhibit prostaglandin synthesis. Take 1–2h before peak pain.'**
  String get cycleCh3IbuprofenDesc;

  /// No description provided for @cycleCh3Exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get cycleCh3Exercise;

  /// No description provided for @cycleCh3ExerciseDesc.
  ///
  /// In en, this message translates to:
  /// **'Endorphins reduce pain by ~50%. Walk, yoga, or light stretching.'**
  String get cycleCh3ExerciseDesc;

  /// No description provided for @cycleCh3Hydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get cycleCh3Hydration;

  /// No description provided for @cycleCh3HydrationDesc.
  ///
  /// In en, this message translates to:
  /// **'Warm fluids reduce inflammation. Ginger and chamomile teas help.'**
  String get cycleCh3HydrationDesc;

  /// No description provided for @cycleCh4Title.
  ///
  /// In en, this message translates to:
  /// **'Your cycle calendar'**
  String get cycleCh4Title;

  /// No description provided for @cycleCh4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap any day to log your period'**
  String get cycleCh4Subtitle;

  /// No description provided for @cycleCh4DayM.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get cycleCh4DayM;

  /// No description provided for @cycleCh4DayT.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get cycleCh4DayT;

  /// No description provided for @cycleCh4DayW.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get cycleCh4DayW;

  /// No description provided for @cycleCh4DayTh.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get cycleCh4DayTh;

  /// No description provided for @cycleCh4DayF.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get cycleCh4DayF;

  /// No description provided for @cycleCh4DayS.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get cycleCh4DayS;

  /// No description provided for @cycleCh4DaySu.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get cycleCh4DaySu;

  /// No description provided for @cycleCh4NextPeriod.
  ///
  /// In en, this message translates to:
  /// **'Next period predicted'**
  String get cycleCh4NextPeriod;

  /// No description provided for @cycleCh4InXDays.
  ///
  /// In en, this message translates to:
  /// **'in {days} days'**
  String cycleCh4InXDays(String days);

  /// No description provided for @cycleCh4CycleLen.
  ///
  /// In en, this message translates to:
  /// **'Cycle length'**
  String get cycleCh4CycleLen;

  /// No description provided for @cycleCh4CycleLenNorm.
  ///
  /// In en, this message translates to:
  /// **'21–35 normal'**
  String get cycleCh4CycleLenNorm;

  /// No description provided for @cycleCh4PeriodLen.
  ///
  /// In en, this message translates to:
  /// **'Period length'**
  String get cycleCh4PeriodLen;

  /// No description provided for @cycleCh4PeriodLenNorm.
  ///
  /// In en, this message translates to:
  /// **'3–7 normal'**
  String get cycleCh4PeriodLenNorm;

  /// No description provided for @cycleCh4OvulationLabel.
  ///
  /// In en, this message translates to:
  /// **'Ovulation'**
  String get cycleCh4OvulationLabel;

  /// No description provided for @cycleCh4OvulationNorm.
  ///
  /// In en, this message translates to:
  /// **'±2 days'**
  String get cycleCh4OvulationNorm;

  /// No description provided for @cycleCh4FertileWindow.
  ///
  /// In en, this message translates to:
  /// **'Fertile window'**
  String get cycleCh4FertileWindow;

  /// No description provided for @cycleCh4FertileNorm.
  ///
  /// In en, this message translates to:
  /// **'Sperm survives 5d'**
  String get cycleCh4FertileNorm;

  /// No description provided for @cycleCh4LegendPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period · tap to log/remove'**
  String get cycleCh4LegendPeriod;

  /// No description provided for @cycleCh4LegendOvulation.
  ///
  /// In en, this message translates to:
  /// **'Ovulation day (Day 14)'**
  String get cycleCh4LegendOvulation;

  /// No description provided for @cycleCh4LegendFertile.
  ///
  /// In en, this message translates to:
  /// **'Fertile window (Days 11–16)'**
  String get cycleCh4LegendFertile;

  /// No description provided for @cycleCh4LegendPredicted.
  ///
  /// In en, this message translates to:
  /// **'Predicted next period'**
  String get cycleCh4LegendPredicted;

  /// No description provided for @cycleCh4DaysX.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String cycleCh4DaysX(String days);

  /// No description provided for @cycleCh4DaysRange.
  ///
  /// In en, this message translates to:
  /// **'Days 11–16'**
  String get cycleCh4DaysRange;

  /// No description provided for @cycleCh5Title.
  ///
  /// In en, this message translates to:
  /// **'Myth busters'**
  String get cycleCh5Title;

  /// No description provided for @cycleCh5Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap a card to reveal the medical fact'**
  String get cycleCh5Subtitle;

  /// No description provided for @cycleCh5AllBusted.
  ///
  /// In en, this message translates to:
  /// **'🎉 All busted!'**
  String get cycleCh5AllBusted;

  /// No description provided for @cycleCh5XBusted.
  ///
  /// In en, this message translates to:
  /// **'{count} / 5 busted'**
  String cycleCh5XBusted(String count);

  /// No description provided for @cycleCh5FactLabel.
  ///
  /// In en, this message translates to:
  /// **'FACT ✓'**
  String get cycleCh5FactLabel;

  /// No description provided for @cycleCh5MythLabel.
  ///
  /// In en, this message translates to:
  /// **'MYTH ✗'**
  String get cycleCh5MythLabel;

  /// No description provided for @cycleCh5TapFact.
  ///
  /// In en, this message translates to:
  /// **'Tap again to see myth'**
  String get cycleCh5TapFact;

  /// No description provided for @cycleCh5TapMyth.
  ///
  /// In en, this message translates to:
  /// **'Tap to reveal fact'**
  String get cycleCh5TapMyth;

  /// No description provided for @cycleCh5Myth1.
  ///
  /// In en, this message translates to:
  /// **'You cannot exercise during your period.'**
  String get cycleCh5Myth1;

  /// No description provided for @cycleCh5Fact1.
  ///
  /// In en, this message translates to:
  /// **'Exercise releases endorphins, increasing blood flow and reducing cramp pain. Walking, yoga, and swimming are all safe and beneficial.'**
  String get cycleCh5Fact1;

  /// No description provided for @cycleCh5Myth2.
  ///
  /// In en, this message translates to:
  /// **'Period blood is dirty or impure.'**
  String get cycleCh5Myth2;

  /// No description provided for @cycleCh5Fact2.
  ///
  /// In en, this message translates to:
  /// **'Menstrual fluid is a healthy mix of blood, endometrial tissue, mucus, and vaginal secretions — a normal biological process with no toxins.'**
  String get cycleCh5Fact2;

  /// No description provided for @cycleCh5Myth3.
  ///
  /// In en, this message translates to:
  /// **'You cannot get pregnant during your period.'**
  String get cycleCh5Myth3;

  /// No description provided for @cycleCh5Fact3.
  ///
  /// In en, this message translates to:
  /// **'Sperm can survive 3–5 days in the reproductive tract. If ovulation follows soon after bleeding ends, pregnancy is possible.'**
  String get cycleCh5Fact3;

  /// No description provided for @cycleCh5Myth4.
  ///
  /// In en, this message translates to:
  /// **'Irregular periods always signal a health problem.'**
  String get cycleCh5Myth4;

  /// No description provided for @cycleCh5Fact4.
  ///
  /// In en, this message translates to:
  /// **'Stress, diet changes, travel, and exercise all affect cycle timing. A range of 21–35 days is entirely normal. Only persistent irregularity warrants investigation.'**
  String get cycleCh5Fact4;

  /// No description provided for @cycleCh5Myth5.
  ///
  /// In en, this message translates to:
  /// **'Period pain is just something to endure — nothing helps.'**
  String get cycleCh5Myth5;

  /// No description provided for @cycleCh5Fact5.
  ///
  /// In en, this message translates to:
  /// **'NSAIDs (ibuprofen/naproxen), heat therapy, and light exercise are clinically proven to significantly reduce dysmenorrhoea.'**
  String get cycleCh5Fact5;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'rw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'rw':
      return AppLocalizationsRw();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
