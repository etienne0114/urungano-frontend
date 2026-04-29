// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Urungano';

  @override
  String get langCode => 'en';

  @override
  String get greeting => 'Hello';

  @override
  String get greetingGoodMorning => 'GOOD MORNING';

  @override
  String get greetingGoodAfternoon => 'GOOD AFTERNOON';

  @override
  String get greetingGoodEvening => 'GOOD EVENING';

  @override
  String get continue_ => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get retry => 'Retry';

  @override
  String get submit => 'Submit';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading…';

  @override
  String get errorConnection => 'Could not connect. Check your internet.';

  @override
  String get chooseLang => 'Choose your language';

  @override
  String get langKinyarwanda => 'Kinyarwanda';

  @override
  String get langEnglish => 'English';

  @override
  String get langFrench => 'Français';

  @override
  String get a11yTitle => 'How do you learn best?';

  @override
  String get a11ySubtitle => 'Pick one or more. You can change this anytime.';

  @override
  String get a11yVoice => 'Voice narration';

  @override
  String get a11yVoiceSub => 'Audio descriptions read aloud';

  @override
  String get a11yCaptions => 'Captions';

  @override
  String get a11yCaptionsSub => 'Text subtitles on all narration';

  @override
  String get a11ySign => 'Sign language';

  @override
  String get a11ySignSub => 'ISL overlay on lessons';

  @override
  String get a11yGesture => 'Hand gesture control';

  @override
  String get a11yGestureSub => 'Navigate lessons with your hand';

  @override
  String get a11yContrast => 'High contrast';

  @override
  String get a11yContrastSub => 'Stronger colours for easier reading';

  @override
  String get a11yLargerText => 'Larger text';

  @override
  String get a11yLargerTextSub => 'Increase text size across the app';

  @override
  String get consentTitle => 'Your privacy matters';

  @override
  String get consentBody =>
      'Urungano is designed to be a safe space for your health journey.';

  @override
  String get consentAgree => 'I understand and agree to the privacy policy.';

  @override
  String get consentPoint1Title => 'Your data stays on your device';

  @override
  String get consentPoint1Body =>
      'All progress and settings are stored locally. Nothing is shared without your permission.';

  @override
  String get consentPoint2Title => 'Private mode available';

  @override
  String get consentPoint2Body =>
      'Enable Private Mode so the app shows a neutral screen if someone glances at your phone.';

  @override
  String get consentPoint3Title => 'No account required';

  @override
  String get consentPoint3Body =>
      'You start anonymously. An optional username helps track your learning streak.';

  @override
  String get consentPoint4Title => 'Delete anytime';

  @override
  String get consentPoint4Body =>
      'Uninstalling the app removes all stored data permanently.';

  @override
  String get pinTitle => 'Add an app lock';

  @override
  String get pinSubtitle => 'Set a 4-digit PIN to keep your progress private.';

  @override
  String get pinSkip => 'Skip for now';

  @override
  String get pinSave => 'Save PIN & continue';

  @override
  String get pinEnter => 'Enter PIN';

  @override
  String get pinConfirm => 'Confirm PIN';

  @override
  String get pinMismatch => 'PINs do not match. Try again.';

  @override
  String get pinVerifyTitle => 'Enter your PIN';

  @override
  String get pinVerifySubtitle => 'Enter your 4-digit PIN to unlock the app.';

  @override
  String get pinVerifySubtitleFull => 'Unlock URUNGANO to continue';

  @override
  String pinVerifyAttemptsLeft(int count) {
    return 'Incorrect PIN. $count attempt(s) left.';
  }

  @override
  String get pinVerifyTooManyAttempts =>
      'Too many attempts. Please restart the app.';

  @override
  String get pinForgot => 'Forgot PIN? Reset app';

  @override
  String get homeReady => 'Ready for today\'s lesson';

  @override
  String get homeWelcomeTitle => 'Welcome to Urungano';

  @override
  String get homeWelcomeSubtitle => 'Your safe space for reproductive health.';

  @override
  String homeWelcomeBack(String name) {
    return 'Welcome back, $name!';
  }

  @override
  String get homeStartJourney => 'START YOUR JOURNEY';

  @override
  String get homeExploreLessons => 'Explore Lessons';

  @override
  String get homeRecentProgress => 'YOUR RECENT PROGRESS';

  @override
  String get homeContinue => 'CONTINUE LEARNING';

  @override
  String get homeResume => 'Resume lesson';

  @override
  String get homePickLesson => 'Pick up a lesson';

  @override
  String get homeSeeAll => 'See all →';

  @override
  String get homeTodayChallenge => 'TODAY\'S CHALLENGE';

  @override
  String get homeQuizDesc => '5 questions on menstrual health';

  @override
  String get homeQuizMeta => '≈ 3 min · Earns a badge';

  @override
  String get homeGestureTry => 'Try gesture control';

  @override
  String get homeGestureSub => 'Move 3D models with your hand';

  @override
  String get homeGestureNew => 'NEW';

  @override
  String get homeCommunityLabel => 'PEER COMMUNITY';

  @override
  String homeCommunityOnline(int count) {
    return '$count peers online now';
  }

  @override
  String get homeCommunityCircles =>
      'Cycle talk · HIV & testing · Know your body';

  @override
  String get homeCommunityJoin => 'Join';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'all lessons';

  @override
  String get libraryFilter => 'Filter';

  @override
  String get libraryAll => 'All topics';

  @override
  String get libraryEmpty => 'No lessons found.';

  @override
  String lessonChapter(int number) {
    return 'Chapter $number';
  }

  @override
  String get lessonHotspots => 'Hotspots';

  @override
  String get lessonNarration => 'Narration';

  @override
  String get lessonPrev => 'Previous';

  @override
  String get lessonNext => 'Next';

  @override
  String get lessonPlay => 'Play';

  @override
  String get lessonPause => 'Pause';

  @override
  String lessonChapterProgress(int current, int total) {
    return 'CHAPTER $current OF $total';
  }

  @override
  String get lessonInteractive3D => 'INTERACTIVE 3D';

  @override
  String get lesson3DModel => '3D Model';

  @override
  String get lessonDragHint => 'Drag to rotate · Scroll to zoom';

  @override
  String lessonExplorePoints(int count) {
    return 'EXPLORE $count POINTS';
  }

  @override
  String get lessonNotFound => 'Lesson not found.';

  @override
  String get offline => 'Offline';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get quizNoQuestions => 'No quiz for this lesson yet.';

  @override
  String get quizBackHome => 'Back to Home';

  @override
  String get quizDailyChallenge => 'DAILY CHALLENGE';

  @override
  String get quizExplanation => 'EXPLANATION';

  @override
  String get quizReadAloud => 'READ ALOUD';

  @override
  String get quizSeeResults => 'SEE RESULTS';

  @override
  String get quizNextQuestion => 'NEXT QUESTION';

  @override
  String get quizCorrect => 'Correct!';

  @override
  String quizQuestion(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get quizCheck => 'Check answer';

  @override
  String get quizFinish => 'Finish quiz';

  @override
  String get quizResultTitle => 'Quiz complete!';

  @override
  String quizResultScore(int correct, int total) {
    return '$correct of $total correct';
  }

  @override
  String quizResultAccuracy(int pct) {
    return '$pct% accuracy';
  }

  @override
  String get quizHeadlinePerfect => '🎉 Perfect score!';

  @override
  String get quizHeadlineGreat => '👍 Great work!';

  @override
  String get quizHeadlineKeepLearning => '📚 Keep learning!';

  @override
  String get quizHeadlineTryAgain => '💪 Try again soon!';

  @override
  String get quizRetry => 'Try again';

  @override
  String get quizGoHome => 'Back to home';

  @override
  String get gestureTitle => 'Gesture control';

  @override
  String get gestureSubtitle => 'Navigate with your hand — no touch needed.';

  @override
  String get gestureCalibration => 'ACCESSIBILITY · CALIBRATION';

  @override
  String gestureStatusLive(double fps) {
    return 'MediaPipe live · $fps FPS';
  }

  @override
  String get gestureStatusOff => 'Camera off';

  @override
  String get gestureMapTitle => 'GESTURE MAP';

  @override
  String get gesturePrivacyTitle => 'Camera stays on your device.';

  @override
  String get gesturePrivacyBody =>
      'MediaPipe runs locally — frames never leave your phone or laptop. Turn off any time from Settings.';

  @override
  String get gestureRecalibrate => 'Recalibrate';

  @override
  String gestureDetected(String gesture) {
    return 'Detected gesture: $gesture';
  }

  @override
  String get gestureEnableHint => 'Enable gesture control to start';

  @override
  String get enable => 'Enable';

  @override
  String get disable => 'Disable';

  @override
  String get gesturePrivacy => 'Your camera feed never leaves this device.';

  @override
  String get gestureFps => 'FPS';

  @override
  String get gestureConfidence => 'Confidence';

  @override
  String get gestureOpen => 'Open hand — rotate model';

  @override
  String get gestureOpenSub => 'Rotate the 3D model';

  @override
  String get gesturePinch => 'Pinch — zoom in';

  @override
  String get gesturePinchSub => 'Zoom into details';

  @override
  String get gesturePoint => 'Point — select hotspot';

  @override
  String get gesturePointSub => 'Select a hotspot';

  @override
  String get gestureFist => 'Fist — pause narration';

  @override
  String get gestureFistSub => 'Pause the narration';

  @override
  String get communityTitle => 'Community';

  @override
  String get communitySubtitle => 'safe space,';

  @override
  String get communitySubtitleEnd => 'peer community';

  @override
  String get communityTabCircles => 'Peer circles';

  @override
  String get communityTabDebate => 'Open debate';

  @override
  String get communityTabAsk => 'Ask anonymously';

  @override
  String get communityModerated => 'Moderated';

  @override
  String communityOnline(int count) {
    return '$count online';
  }

  @override
  String communityMessages(int count) {
    return '$count messages';
  }

  @override
  String communityModeratedBy(String name) {
    return 'Moderated by $name';
  }

  @override
  String get communityVoteYes => 'Vote yes';

  @override
  String get communityVoteNo => 'Vote no';

  @override
  String communityVotes(int count) {
    return '$count votes';
  }

  @override
  String get communityAskHint => 'Ask anything — no name attached';

  @override
  String get communityAskPrivacy => 'Anonymous · routed to health educators';

  @override
  String get communityAskAnswered => 'Answered';

  @override
  String get communityAskAwaiting => 'Awaiting';

  @override
  String get communityAskAwaitingFull => 'Awaiting educator response';

  @override
  String get communityHealthEducator => 'Health educator';

  @override
  String get communitySendHint => 'Say something…';

  @override
  String get communityAlreadyVoted => 'You have already voted on this debate.';

  @override
  String get communityVoteError =>
      'Vote could not be saved — check your connection.';

  @override
  String get communityMsgError =>
      'Message could not be sent — check your connection.';

  @override
  String get communityQuestionMin => 'Question must be at least 10 characters.';

  @override
  String get communitySubmitError =>
      'Could not submit — check your connection.';

  @override
  String get communityLoadErrorCircles => 'Could not load circles';

  @override
  String get communityLoadErrorDebates => 'Could not load debates';

  @override
  String get communityLoadErrorQuestions => 'Could not load questions';

  @override
  String communityVotesDaily(int count) {
    return '$count votes · Daily Debate';
  }

  @override
  String get communityVoteYesLabel => 'VOTE YES';

  @override
  String get communityVoteNoLabel => 'VOTE NO';

  @override
  String communityTimeAgoMin(int count) {
    return '${count}m ago';
  }

  @override
  String communityTimeAgoHour(int count) {
    return '${count}h ago';
  }

  @override
  String communityTimeAgoDay(int count) {
    return '${count}d ago';
  }

  @override
  String get communityRulesTitle => 'Safe space rules';

  @override
  String get communityRulesBody => 'Be respectful. No names. No bullying.';

  @override
  String get communityOnlineNow => 'Online now';

  @override
  String get communitySelectCircle => 'Select a circle to start chatting';

  @override
  String communityPeerName(int id) {
    return 'Warrior $id';
  }

  @override
  String communityVoteYesPct(int pct) {
    return '$pct% YES';
  }

  @override
  String communityVoteNoPct(int pct) {
    return '$pct% NO';
  }

  @override
  String communityThreadHeader(int count, String moderator) {
    return '$count messages · $moderator';
  }

  @override
  String get profileTitle => 'Your journey';

  @override
  String get profileAnonymous => 'Anonymous warrior';

  @override
  String get profileChangeAvatar => 'Change avatar';

  @override
  String get profileLessons => 'Lessons';

  @override
  String get profileAccuracy => 'Accuracy';

  @override
  String get profileBadges => 'Badges';

  @override
  String profileEarnedCount(int earned, int total) {
    return '$earned of $total earned';
  }

  @override
  String get profileJourney => 'Journey Timeline';

  @override
  String get profileJourneyEmpty => 'Start a lesson to see your journey.';

  @override
  String get profilePrivate => 'Private';

  @override
  String get profileBadgeLocked => 'Locked';

  @override
  String timeAgoMonths(int count) {
    return '$count months ago';
  }

  @override
  String timeAgoDays(int count) {
    return '$count days ago';
  }

  @override
  String get timeAgoToday => 'today';

  @override
  String timeAgoHours(int count) {
    return '${count}h ago';
  }

  @override
  String get timeAgoJustNow => 'just now';

  @override
  String get journeyCompleted => 'Completed';

  @override
  String journeyQuiz(int pct) {
    return 'Quiz $pct%';
  }

  @override
  String get journeyStarted => 'Started';

  @override
  String get journeySetup => 'Account created';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsA11y => 'Accessibility';

  @override
  String get settingsDisplay => 'Display';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsPrivacy => 'Privacy & safety';

  @override
  String get settingsAppLock => 'App lock';

  @override
  String get settingsAppLockSub => 'Require PIN on startup';

  @override
  String get settingsPrivateMode => 'Private mode';

  @override
  String get settingsPrivateModeSub => 'Hide app from recent screens';

  @override
  String get settingsIncognito => 'Incognito lessons';

  @override
  String get settingsIncognitoSub => 'Skip progress tracking';

  @override
  String get settingsHotline => 'Need support?';

  @override
  String get settingsHotlineSub => 'Rwanda health hotline: 114';

  @override
  String get settingsCall => 'Call 114';

  @override
  String get splashTagline => 'Reproductive health, explained';

  @override
  String get errorNotFound => 'Not found';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get categoryMenstrual => 'Menstrual health';

  @override
  String get categoryHiv => 'HIV & STI';

  @override
  String get categoryAnatomy => 'Reproductive anatomy';

  @override
  String get categoryMental => 'Mental health';

  @override
  String get categoryRelations => 'Relationships';

  @override
  String minLeft(int min) {
    return '$min min left';
  }

  @override
  String minTotal(int min) {
    return '$min min';
  }

  @override
  String get dayStreak => 'Day streak';

  @override
  String get lessonsCompleted => 'Lessons done';

  @override
  String get quizAccuracy => 'Quiz accuracy';

  @override
  String homeStreakDays(int count) {
    return '$count day streak';
  }

  @override
  String get homeStreakEncouragement => 'Keep it up!';

  @override
  String get homeReadyForToday => 'Ready for today?';

  @override
  String homeNextChapter(String title) {
    return 'Next: $title';
  }

  @override
  String get homeGestureTryTitle => 'Try Gestures';

  @override
  String get homeGestureTrySub => 'Control with hand movements';

  @override
  String get homePrivacyTitle => 'Privacy First';

  @override
  String get homePrivacyHeadline => 'Nothing leaves this device.';

  @override
  String get homePrivacyBody =>
      'No tracking, no accounts, just learning. Your journey is yours alone.';

  @override
  String get navLearn => 'LEARN';

  @override
  String get navHome => 'Home';

  @override
  String get navLibrary => 'Library';

  @override
  String get navActiveLesson => 'Active lesson';

  @override
  String get navChapterBadge => 'Ch 2';

  @override
  String get navChallenges => 'Challenges';

  @override
  String get navCommunity => 'Community';

  @override
  String get navGesture => 'Gesture';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String navUserStreak(int count) {
    return 'Anonymous - ${count}d streak';
  }

  @override
  String get communityTyping => 'Someone is typing...';

  @override
  String get communityRecent => 'RECENT';

  @override
  String get communitySubmitSuccess => 'Question submitted anonymously!';

  @override
  String get communityAskDialogTitle => 'Ask a question';

  @override
  String get communityAskDialogBody =>
      'Your question is completely anonymous and will be routed to our health educators.';

  @override
  String get communityAskInputHint => 'Type here...';

  @override
  String get communityWideSubtitle =>
      'Peer circles, open debates, anonymous questions.';

  @override
  String get communityWeeklyCircle => 'New circle weekly.';

  @override
  String get communityWeeklyCircleNext =>
      'Next: \"Puberty, explained\" - opens Friday.';

  @override
  String get communityRuleAnonymous => 'Anonymous by default';

  @override
  String get communityRuleNoJudgment => 'No judgment, no shame';

  @override
  String get communityRuleModerated => 'Moderated by real health educators';

  @override
  String get communityRuleReport => 'Report anything that feels off';

  @override
  String get communityNeedPrivateChat => 'Need to talk 1-on-1?';

  @override
  String get communityPrivateChat => 'Private chat';

  @override
  String get communityPrivateChatBody =>
      'Free, confidential chat with a health educator in Kinyarwanda, English, or French.';

  @override
  String get communityStartPrivateChat => 'Start private chat';

  @override
  String get communityNoNamesNoPhotos => 'No names. No photos. Only vibes.';

  @override
  String get gestureSwipeRight => 'Swipe right';

  @override
  String get gestureSwipeLeft => 'Swipe left';

  @override
  String get gestureSwipeUp => 'Swipe up';

  @override
  String get gestureOpenPalm => 'Open palm';

  @override
  String get gestureThumbsUp => 'Thumbs up';

  @override
  String get gesturePinchLabel => 'Pinch';

  @override
  String get gestureActionNextChapter => 'Next chapter';

  @override
  String get gestureActionPrevChapter => 'Previous chapter';

  @override
  String get gestureActionScroll => 'Scroll content';

  @override
  String get gestureActionPauseNarration => 'Pause narration';

  @override
  String get gestureActionMarkUnderstood => 'Mark understood';

  @override
  String get gestureActionZoomModel => 'Zoom 3D model';

  @override
  String get gestureOverlayModel => 'Model';

  @override
  String get gestureOverlayLandmarks => 'Landmarks';

  @override
  String get gestureOverlayHand => 'Hand';

  @override
  String get gestureOverlayHandRight => 'Right';

  @override
  String get gestureOverlayLatency => 'Latency';

  @override
  String get lessonAutoRotateStart => 'Start auto-rotate';

  @override
  String get lessonAutoRotateStop => 'Stop auto-rotate';

  @override
  String get lessonZoomIn => 'Zoom in';

  @override
  String get lessonZoomOut => 'Zoom out';

  @override
  String get lessonResetView => 'Reset view';

  @override
  String get pinWeakError =>
      'PIN cannot be sequential (e.g. 1234) or repeated (e.g. 1111).';

  @override
  String get pinSyncFailed =>
      'Failed to sync PIN with server. Please try a different PIN.';

  @override
  String get pinUsernameHint => 'Enter your username';

  @override
  String get profileNameRequired => 'Please enter a username to continue';

  @override
  String get sttListening => 'Listening…';

  @override
  String get sttTapToSpeak => 'Tap to speak';

  @override
  String get sttSpeakNow => 'Speak now';

  @override
  String get sttNotAvailable => 'Voice input is not available on this device';

  @override
  String get sttNoPermission => 'Microphone permission denied';

  @override
  String get sttKinyarwandaNote =>
      'Kinyarwanda voice is limited — the app will do its best';

  @override
  String get sttVoiceInput => 'Voice input';

  @override
  String get sttVoiceSearch => 'Voice search';

  @override
  String get sttTryAgain => 'Try again';

  @override
  String get homeStreakTitle => 'Your streak';

  @override
  String homeStreakDaysLabel(int days) {
    return '$days day streak';
  }

  @override
  String get communityOfflineQueued => 'Message queued — will send when online';

  @override
  String get communityVoteOffline => 'You’re offline — vote when reconnected';

  @override
  String get communityQuestionQueued =>
      'Question queued — will send when online';

  @override
  String get communityEmptyChat =>
      'No messages yet. Be the first to say something!';

  @override
  String get cycleDragHint =>
      'Drag to rotate · Pinch to zoom · Double-tap to reset';

  @override
  String get cycleTapWheelHint => 'Tap any phase on the wheel';

  @override
  String get cycleHideLabels => 'Hide labels';

  @override
  String get cycleShowLabels => 'Labels';

  @override
  String get cyclePhasesBtn => 'Phases';

  @override
  String get cycleCloseBtn => 'Close';

  @override
  String cycleDayBadge(String day) {
    return 'Day $day';
  }

  @override
  String get cycleHormonesLabel => 'HORMONES';

  @override
  String get cycleOestrogen => 'Oestrogen';

  @override
  String get cycleProgesterone => 'Prog.';

  @override
  String get cycleLH => 'LH';

  @override
  String get cycleFSH => 'FSH';

  @override
  String get cyclePhaseMenstrual => 'Menstrual';

  @override
  String get cyclePhaseFollicular => 'Follicular';

  @override
  String get cyclePhaseOvulation => 'Ovulation';

  @override
  String get cyclePhaseLuteal => 'Luteal';

  @override
  String get cyclePhaseMenstrualDays => 'Days 1–5';

  @override
  String get cyclePhaseFollicularDays => 'Days 6–13';

  @override
  String get cyclePhaseOvulationDay => 'Day 14';

  @override
  String get cyclePhaseLutealDays => 'Days 15–28';

  @override
  String get cyclePhaseMenstrualDesc =>
      'The endometrial lining sheds. Prostaglandins cause uterine contractions. Hormone levels are at their lowest point in the cycle.';

  @override
  String get cyclePhaseFollicularDesc =>
      'FSH stimulates follicle growth. Rising oestrogen rebuilds the endometrium. Energy and mood often peak in this phase.';

  @override
  String get cyclePhaseOvulationDesc =>
      'LH surge triggers egg release from the dominant follicle. Peak fertility. Cervical mucus becomes clear and stretchy.';

  @override
  String get cyclePhaseLutealDesc =>
      'Corpus luteum secretes progesterone, maintaining the thickened endometrium. If no fertilisation, progesterone drops and menstruation begins.';

  @override
  String get cyclePhaseMenstrualDescAlt =>
      'The endometrium sheds. Prostaglandins cause uterine contractions expelling the lining. Hormone levels reach their lowest point.';

  @override
  String get cyclePhaseFollicularDescAlt =>
      'FSH stimulates several follicles. The dominant follicle produces oestrogen, rebuilding the endometrium and suppressing others.';

  @override
  String get cyclePhaseOvulationDescAlt =>
      'LH surge triggers rupture of the dominant follicle, releasing the egg into the fallopian tube. Peak fertility.';

  @override
  String get cyclePhaseLutealDescAlt =>
      'The corpus luteum produces progesterone, maintaining the endometrium. If no fertilisation, it degrades and the cycle restarts.';

  @override
  String get cycleHormoneMenstrualLevel => 'FSH ↓ LH ↓ Oestrogen ↓';

  @override
  String get cycleHormoneFollicularLevel => 'FSH ↑ Oestrogen ↑';

  @override
  String get cycleHormoneOvulationLevel => 'LH surge · Oestrogen peak';

  @override
  String get cycleHormoneLutealLevel => 'Progesterone ↑ Oestrogen ↑';

  @override
  String get cycleAnatomyFallopian => 'Fallopian tube';

  @override
  String get cycleAnatomyUterineFundus => 'Uterine fundus';

  @override
  String get cycleAnatomyOvary => 'Ovary';

  @override
  String get cycleAnatomyEndometrium => 'Endometrium';

  @override
  String get cycleAnatomyMyometrium => 'Myometrium';

  @override
  String get cycleAnatomyCervix => 'Cervix';

  @override
  String get cycleAnatomyVagina => 'Vagina';

  @override
  String get cycleAnatomyBroadLig => 'Broad ligament';

  @override
  String get cycleAnatomyOvarianLig => 'Ovarian lig.';

  @override
  String get cycleAnatomyPerimetrium => 'Perimetrium';

  @override
  String get cycleCh1HsOvaryDesc =>
      'Each ovary is ~3 cm and contains 300,000+ primordial follicles. Each month FSH stimulates several to grow — usually one matures and releases an egg at ovulation.';

  @override
  String get cycleCh1HsFallopianDesc =>
      '~10 cm long with finger-like fimbriae that sweep the released egg inward. Fertilisation by sperm most often occurs in the outer third of the tube.';

  @override
  String get cycleCh1HsEndometriumDesc =>
      'The inner mucosal lining. Thickness ranges from ~2 mm after menstruation to ~12 mm in the luteal phase. Shed as a period if no implantation occurs.';

  @override
  String get cycleCh1HsCervixDesc =>
      'Lower narrow neck of the uterus. Produces mucus that changes throughout the cycle — clear and stretchy at ovulation, thick and opaque at other times.';

  @override
  String get cycleCh3Title => 'Cramps & pain';

  @override
  String get cycleCh3PainIntensity => 'Pain intensity';

  @override
  String get cycleCh3Heat => 'Heat';

  @override
  String get cycleCh3HeatDesc =>
      'Relaxes muscle spasm, increases blood flow. Apply 15–20 min.';

  @override
  String get cycleCh3Ibuprofen => 'Ibuprofen';

  @override
  String get cycleCh3IbuprofenDesc =>
      'NSAIDs inhibit prostaglandin synthesis. Take 1–2h before peak pain.';

  @override
  String get cycleCh3Exercise => 'Exercise';

  @override
  String get cycleCh3ExerciseDesc =>
      'Endorphins reduce pain by ~50%. Walk, yoga, or light stretching.';

  @override
  String get cycleCh3Hydration => 'Hydration';

  @override
  String get cycleCh3HydrationDesc =>
      'Warm fluids reduce inflammation. Ginger and chamomile teas help.';

  @override
  String get cycleCh4Title => 'Your cycle calendar';

  @override
  String get cycleCh4Subtitle => 'Tap any day to log your period';

  @override
  String get cycleCh4DayM => 'M';

  @override
  String get cycleCh4DayT => 'T';

  @override
  String get cycleCh4DayW => 'W';

  @override
  String get cycleCh4DayTh => 'T';

  @override
  String get cycleCh4DayF => 'F';

  @override
  String get cycleCh4DayS => 'S';

  @override
  String get cycleCh4DaySu => 'S';

  @override
  String get cycleCh4NextPeriod => 'Next period predicted';

  @override
  String cycleCh4InXDays(String days) {
    return 'in $days days';
  }

  @override
  String get cycleCh4CycleLen => 'Cycle length';

  @override
  String get cycleCh4CycleLenNorm => '21–35 normal';

  @override
  String get cycleCh4PeriodLen => 'Period length';

  @override
  String get cycleCh4PeriodLenNorm => '3–7 normal';

  @override
  String get cycleCh4OvulationLabel => 'Ovulation';

  @override
  String get cycleCh4OvulationNorm => '±2 days';

  @override
  String get cycleCh4FertileWindow => 'Fertile window';

  @override
  String get cycleCh4FertileNorm => 'Sperm survives 5d';

  @override
  String get cycleCh4LegendPeriod => 'Period · tap to log/remove';

  @override
  String get cycleCh4LegendOvulation => 'Ovulation day (Day 14)';

  @override
  String get cycleCh4LegendFertile => 'Fertile window (Days 11–16)';

  @override
  String get cycleCh4LegendPredicted => 'Predicted next period';

  @override
  String cycleCh4DaysX(String days) {
    return '$days days';
  }

  @override
  String get cycleCh4DaysRange => 'Days 11–16';

  @override
  String get cycleCh5Title => 'Myth busters';

  @override
  String get cycleCh5Subtitle => 'Tap a card to reveal the medical fact';

  @override
  String get cycleCh5AllBusted => '🎉 All busted!';

  @override
  String cycleCh5XBusted(String count) {
    return '$count / 5 busted';
  }

  @override
  String get cycleCh5FactLabel => 'FACT ✓';

  @override
  String get cycleCh5MythLabel => 'MYTH ✗';

  @override
  String get cycleCh5TapFact => 'Tap again to see myth';

  @override
  String get cycleCh5TapMyth => 'Tap to reveal fact';

  @override
  String get cycleCh5Myth1 => 'You cannot exercise during your period.';

  @override
  String get cycleCh5Fact1 =>
      'Exercise releases endorphins, increasing blood flow and reducing cramp pain. Walking, yoga, and swimming are all safe and beneficial.';

  @override
  String get cycleCh5Myth2 => 'Period blood is dirty or impure.';

  @override
  String get cycleCh5Fact2 =>
      'Menstrual fluid is a healthy mix of blood, endometrial tissue, mucus, and vaginal secretions — a normal biological process with no toxins.';

  @override
  String get cycleCh5Myth3 => 'You cannot get pregnant during your period.';

  @override
  String get cycleCh5Fact3 =>
      'Sperm can survive 3–5 days in the reproductive tract. If ovulation follows soon after bleeding ends, pregnancy is possible.';

  @override
  String get cycleCh5Myth4 =>
      'Irregular periods always signal a health problem.';

  @override
  String get cycleCh5Fact4 =>
      'Stress, diet changes, travel, and exercise all affect cycle timing. A range of 21–35 days is entirely normal. Only persistent irregularity warrants investigation.';

  @override
  String get cycleCh5Myth5 =>
      'Period pain is just something to endure — nothing helps.';

  @override
  String get cycleCh5Fact5 =>
      'NSAIDs (ibuprofen/naproxen), heat therapy, and light exercise are clinically proven to significantly reduce dysmenorrhoea.';
}
