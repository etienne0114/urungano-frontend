// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Urungano';

  @override
  String get langCode => 'fr';

  @override
  String get greeting => 'Bonjour';

  @override
  String get greetingGoodMorning => 'BONJOUR';

  @override
  String get greetingGoodAfternoon => 'BON APRÈS-MIDI';

  @override
  String get greetingGoodEvening => 'BONSOIR';

  @override
  String get continue_ => 'Continuer';

  @override
  String get skip => 'Passer';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get retry => 'Réessayer';

  @override
  String get submit => 'Envoyer';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get done => 'Terminé';

  @override
  String get loading => 'Chargement…';

  @override
  String get errorConnection => 'Connexion impossible. Vérifiez votre réseau.';

  @override
  String get chooseLang => 'Choisissez votre langue';

  @override
  String get langKinyarwanda => 'Kinyarwanda';

  @override
  String get langEnglish => 'Anglais';

  @override
  String get langFrench => 'Français';

  @override
  String get a11yTitle => 'Comment apprenez-vous le mieux ?';

  @override
  String get a11ySubtitle =>
      'Choisissez-en un ou plusieurs. Vous pouvez modifier à tout moment.';

  @override
  String get a11yVoice => 'Narration vocale';

  @override
  String get a11yVoiceSub => 'Descriptions audio lues à voix haute';

  @override
  String get a11yCaptions => 'Sous-titres';

  @override
  String get a11yCaptionsSub => 'Sous-titres texte sur toute narration';

  @override
  String get a11ySign => 'Langue des signes';

  @override
  String get a11ySignSub => 'Superposition ISL sur les leçons';

  @override
  String get a11yGesture => 'Contrôle par geste de la main';

  @override
  String get a11yGestureSub => 'Naviguez dans les leçons avec votre main';

  @override
  String get a11yContrast => 'Contraste élevé';

  @override
  String get a11yContrastSub =>
      'Couleurs plus fortes pour une lecture facilitée';

  @override
  String get a11yLargerText => 'Texte agrandi';

  @override
  String get a11yLargerTextSub =>
      'Augmenter la taille du texte dans l\'application';

  @override
  String get consentTitle => 'Un espace privé, rien que pour vous';

  @override
  String get consentBody =>
      'Urungano ne demande jamais votre nom. Votre progression est enregistrée uniquement sur cet appareil. Rien n\'est partagé sans votre accord.';

  @override
  String get consentAgree => 'Je comprends, commençons';

  @override
  String get consentPoint1Title => 'Vos données restent sur votre appareil';

  @override
  String get consentPoint1Body =>
      'Toute progression et tous paramètres sont stockés localement. Rien n\'est partagé sans votre permission.';

  @override
  String get consentPoint2Title => 'Mode privé disponible';

  @override
  String get consentPoint2Body =>
      'Activez le mode privé pour que l\'application affiche un écran neutre si quelqu\'un regarde votre téléphone.';

  @override
  String get consentPoint3Title => 'Aucun compte requis';

  @override
  String get consentPoint3Body =>
      'Vous commencez anonymement. Un pseudonyme optionnel aide à suivre votre série d\'apprentissage.';

  @override
  String get consentPoint4Title => 'Supprimer à tout moment';

  @override
  String get consentPoint4Body =>
      'La désinstallation de l\'application supprime toutes les données stockées définitivement.';

  @override
  String get pinTitle => 'Ajouter un verrouillage';

  @override
  String get pinSubtitle =>
      'Définissez un code PIN à 4 chiffres pour garder votre progression privée.';

  @override
  String get pinSkip => 'Passer pour l\'instant';

  @override
  String get pinSave => 'Enregistrer le PIN et continuer';

  @override
  String get pinEnter => 'Entrez le PIN';

  @override
  String get pinConfirm => 'Confirmez le PIN';

  @override
  String get pinMismatch => 'Les PINs ne correspondent pas. Réessayez.';

  @override
  String get pinVerifyTitle => 'Entrez votre PIN';

  @override
  String get pinVerifySubtitle =>
      'Saisissez votre code PIN à 4 chiffres pour déverrouiller.';

  @override
  String get pinVerifySubtitleFull => 'Déverrouillez URUNGANO pour continuer';

  @override
  String pinVerifyAttemptsLeft(int count) {
    return 'PIN incorrect. $count tentative(s) restante(s).';
  }

  @override
  String get pinVerifyTooManyAttempts =>
      'Trop de tentatives. Veuillez redémarrer l\'application.';

  @override
  String get pinForgot => 'PIN oublié ? Réinitialiser l\'appli';

  @override
  String get homeReady => 'Prêt pour la leçon du jour';

  @override
  String get homeContinue => 'CONTINUER L\'APPRENTISSAGE';

  @override
  String get homeResume => 'Reprendre la leçon';

  @override
  String get homePickLesson => 'Choisir une leçon';

  @override
  String get homeSeeAll => 'Voir tout →';

  @override
  String get homeTodayChallenge => 'DÉFI DU JOUR';

  @override
  String get homeQuizDesc => '5 questions sur la santé menstruelle';

  @override
  String get homeQuizMeta => '≈ 3 min · Gagne un badge';

  @override
  String get homeGestureTry => 'Essayez le contrôle gestuel';

  @override
  String get homeGestureSub => 'Déplacez les modèles 3D avec votre main';

  @override
  String get homeGestureNew => 'NOUVEAU';

  @override
  String get homeCommunityLabel => 'COMMUNAUTÉ DE PAIRS';

  @override
  String homeCommunityOnline(int count) {
    return '$count pairs en ligne maintenant';
  }

  @override
  String get homeCommunityCircles =>
      'Parler du cycle · VIH & dépistage · Connaître son corps';

  @override
  String get homeCommunityJoin => 'Rejoindre';

  @override
  String get libraryTitle => 'Bibliothèque';

  @override
  String get librarySubtitle => 'toutes les leçons';

  @override
  String get libraryFilter => 'Filtrer';

  @override
  String get libraryAll => 'Tous les sujets';

  @override
  String get libraryEmpty => 'Aucune leçon trouvée.';

  @override
  String lessonChapter(int number) {
    return 'Chapitre $number';
  }

  @override
  String get lessonHotspots => 'Points chauds';

  @override
  String get lessonNarration => 'Narration';

  @override
  String get lessonPrev => 'Précédent';

  @override
  String get lessonNext => 'Suivant';

  @override
  String get lessonPlay => 'Lire';

  @override
  String get lessonPause => 'Pause';

  @override
  String lessonChapterProgress(int current, int total) {
    return 'CHAPITRE $current SUR $total';
  }

  @override
  String get lessonInteractive3D => '3D INTERACTIF';

  @override
  String get lesson3DModel => 'Modèle 3D';

  @override
  String get lessonDragHint =>
      'Faire glisser pour pivoter · Défiler pour zoomer';

  @override
  String lessonExplorePoints(int count) {
    return 'EXPLORER $count POINTS';
  }

  @override
  String get lessonNotFound => 'Leçon introuvable.';

  @override
  String get offline => 'Hors ligne';

  @override
  String get quizTitle => 'Défi du jour';

  @override
  String get quizNoQuestions => 'Pas encore de quiz pour cette leçon.';

  @override
  String get quizBackHome => 'Retour à l\'accueil';

  @override
  String get quizDailyChallenge => 'DÉFI DU JOUR';

  @override
  String get quizExplanation => 'EXPLICATION';

  @override
  String get quizReadAloud => 'LIRE À VOIX HAUTE';

  @override
  String get quizSeeResults => 'VOIR LES RÉSULTATS';

  @override
  String get quizNextQuestion => 'Question suivante';

  @override
  String get quizCorrect => 'Correct !';

  @override
  String quizQuestion(int current, int total) {
    return 'Question $current sur $total';
  }

  @override
  String get quizCheck => 'Vérifier la réponse';

  @override
  String get quizFinish => 'Terminer le quiz';

  @override
  String get quizResultTitle => 'Quiz terminé !';

  @override
  String quizResultScore(int correct, int total) {
    return '$correct sur $total correctes';
  }

  @override
  String quizResultAccuracy(int pct) {
    return '$pct% de précision';
  }

  @override
  String get quizHeadlinePerfect => '🎉 Score parfait !';

  @override
  String get quizHeadlineGreat => '👍 Bon travail !';

  @override
  String get quizHeadlineKeepLearning => '📚 Continuez à apprendre !';

  @override
  String get quizHeadlineTryAgain => '💪 Réessayez bientôt !';

  @override
  String get quizRetry => 'Réessayer';

  @override
  String get quizGoHome => 'Retour à l\'accueil';

  @override
  String get gestureTitle => 'Contrôle gestuel';

  @override
  String get gestureSubtitle =>
      'Naviguez avec la main — sans toucher l\'écran.';

  @override
  String get gestureCalibration => 'ACCESSIBILITÉ · CALIBRATION';

  @override
  String gestureStatusLive(double fps) {
    return 'MediaPipe en direct · $fps FPS';
  }

  @override
  String get gestureStatusOff => 'Caméra éteinte';

  @override
  String get gestureMapTitle => 'CARTE DES GESTES';

  @override
  String get gesturePrivacyTitle => 'La caméra reste sur votre appareil.';

  @override
  String get gesturePrivacyBody =>
      'MediaPipe fonctionne localement — les images ne quittent jamais votre téléphone ou ordinateur. Désactivez à tout moment dans Paramètres.';

  @override
  String get gestureRecalibrate => 'Recalibrer';

  @override
  String gestureDetected(String gesture) {
    return 'Geste détecté : $gesture';
  }

  @override
  String get gestureEnableHint => 'Activez le contrôle gestuel pour commencer';

  @override
  String get enable => 'Activer';

  @override
  String get disable => 'Désactiver';

  @override
  String get gesturePrivacy =>
      'Votre flux caméra ne quitte jamais cet appareil.';

  @override
  String get gestureFps => 'IPS';

  @override
  String get gestureConfidence => 'Confiance';

  @override
  String get gestureOpen => 'Main ouverte — faire pivoter le modèle';

  @override
  String get gestureOpenSub => 'Faire pivoter le modèle 3D';

  @override
  String get gesturePinch => 'Pincer — zoomer';

  @override
  String get gesturePinchSub => 'Zoomer sur les détails';

  @override
  String get gesturePoint => 'Pointer — sélectionner un hotspot';

  @override
  String get gesturePointSub => 'Sélectionner un point chaud';

  @override
  String get gestureFist => 'Poing — mettre en pause la narration';

  @override
  String get gestureFistSub => 'Mettre en pause la narration';

  @override
  String get communityTitle => 'Communauté';

  @override
  String get communitySubtitle => 'espace sécurisé,';

  @override
  String get communitySubtitleEnd => 'communauté de pairs';

  @override
  String get communityTabCircles => 'Cercles de pairs';

  @override
  String get communityTabDebate => 'Débat ouvert';

  @override
  String get communityTabAsk => 'Demander anonymement';

  @override
  String get communityModerated => 'Modéré';

  @override
  String communityOnline(int count) {
    return '$count en ligne';
  }

  @override
  String communityMessages(int count) {
    return '$count messages';
  }

  @override
  String communityModeratedBy(String name) {
    return 'Modéré par $name';
  }

  @override
  String get communityVoteYes => 'Voter oui';

  @override
  String get communityVoteNo => 'Voter non';

  @override
  String communityVotes(int count) {
    return '$count votes';
  }

  @override
  String get communityAskHint =>
      'Posez n\'importe quelle question — sans nom attaché';

  @override
  String get communityAskPrivacy =>
      'Anonyme · transmis aux éducateurs de santé';

  @override
  String get communityAskAnswered => 'Répondu';

  @override
  String get communityAskAwaiting => 'En attente';

  @override
  String get communityAskAwaitingFull =>
      'En attente de réponse d\'un éducateur';

  @override
  String get communityHealthEducator => 'Éducateur de santé';

  @override
  String get communitySendHint => 'Dites quelque chose…';

  @override
  String get communityAlreadyVoted => 'Vous avez déjà voté sur ce débat.';

  @override
  String get communityVoteError =>
      'Vote non enregistré — vérifiez votre connexion.';

  @override
  String get communityMsgError =>
      'Message non envoyé — vérifiez votre connexion.';

  @override
  String get communityQuestionMin =>
      'La question doit comporter au moins 10 caractères.';

  @override
  String get communitySubmitError =>
      'Impossible d\'envoyer — vérifiez votre connexion.';

  @override
  String get communityLoadErrorCircles => 'Impossible de charger les cercles';

  @override
  String get communityLoadErrorDebates => 'Impossible de charger les débats';

  @override
  String get communityLoadErrorQuestions =>
      'Impossible de charger les questions';

  @override
  String communityVotesDaily(int count) {
    return '$count votes · Débat du jour';
  }

  @override
  String get communityVoteYesLabel => 'VOTER OUI';

  @override
  String get communityVoteNoLabel => 'VOTER NON';

  @override
  String communityTimeAgoMin(int count) {
    return 'il y a ${count}min';
  }

  @override
  String communityTimeAgoHour(int count) {
    return 'il y a ${count}h';
  }

  @override
  String communityTimeAgoDay(int count) {
    return 'il y a ${count}j';
  }

  @override
  String get communityRulesTitle => 'Règles de l\'espace sécurisé';

  @override
  String get communityRulesBody =>
      'Soyez respectueux. Pas de noms. Pas d\'intimidation.';

  @override
  String get communityOnlineNow => 'En ligne maintenant';

  @override
  String get communitySelectCircle =>
      'Sélectionnez un cercle pour commencer à discuter';

  @override
  String communityPeerName(int id) {
    return 'Guerrier $id';
  }

  @override
  String communityVoteYesPct(int pct) {
    return '$pct% OUI';
  }

  @override
  String communityVoteNoPct(int pct) {
    return '$pct% NON';
  }

  @override
  String communityThreadHeader(int count, String moderator) {
    return '$count messages · $moderator';
  }

  @override
  String get profileTitle => 'Mon profil';

  @override
  String get profileAnonymous => 'Anonyme';

  @override
  String get profileChangeAvatar => 'Changer d\'avatar';

  @override
  String get profileLessons => 'Leçons';

  @override
  String get profileAccuracy => 'Précision';

  @override
  String get profileBadges => 'Badges';

  @override
  String profileEarnedCount(int earned, int total) {
    return '$earned sur $total obtenus';
  }

  @override
  String get profileJourney => 'Parcours';

  @override
  String get profileJourneyEmpty =>
      'Commencez une leçon pour voir votre parcours.';

  @override
  String get profilePrivate => 'Privé';

  @override
  String get profileBadgeLocked => 'Verrouillé';

  @override
  String timeAgoMonths(int count) {
    return 'il y a $count mois';
  }

  @override
  String timeAgoDays(int count) {
    return 'il y a $count jour(s)';
  }

  @override
  String get timeAgoToday => 'aujourd\'hui';

  @override
  String timeAgoHours(int count) {
    return 'il y a ${count}h';
  }

  @override
  String get timeAgoJustNow => 'à l\'instant';

  @override
  String get journeyCompleted => 'Terminé';

  @override
  String journeyQuiz(int pct) {
    return 'Quiz $pct%';
  }

  @override
  String get journeyStarted => 'Commencé';

  @override
  String get journeySetup => 'Compte créé';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsA11y => 'Accessibilité';

  @override
  String get settingsDisplay => 'Affichage';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsPrivacy => 'Confidentialité & sécurité';

  @override
  String get settingsAppLock => 'Verrouillage de l\'appli';

  @override
  String get settingsAppLockSub => 'Demander le PIN au démarrage';

  @override
  String get settingsPrivateMode => 'Mode privé';

  @override
  String get settingsPrivateModeSub =>
      'Masquer l\'appli dans les écrans récents';

  @override
  String get settingsIncognito => 'Leçons incognito';

  @override
  String get settingsIncognitoSub => 'Ne pas suivre la progression';

  @override
  String get settingsHotline => 'Besoin d\'aide ?';

  @override
  String get settingsHotlineSub => 'Ligne de santé Rwanda : 114';

  @override
  String get settingsCall => 'Appeler 114';

  @override
  String get splashTagline => 'La santé reproductive, expliquée';

  @override
  String get errorNotFound => 'Introuvable';

  @override
  String get errorGeneric => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get categoryMenstrual => 'Santé menstruelle';

  @override
  String get categoryHiv => 'VIH & IST';

  @override
  String get categoryAnatomy => 'Anatomie reproductive';

  @override
  String get categoryMental => 'Santé mentale';

  @override
  String get categoryRelations => 'Relations';

  @override
  String minLeft(int min) {
    return '$min min restantes';
  }

  @override
  String minTotal(int min) {
    return '$min min';
  }

  @override
  String get dayStreak => 'Jours consécutifs';

  @override
  String get lessonsCompleted => 'Leçons terminées';

  @override
  String get quizAccuracy => 'Précision du quiz';

  @override
  String homeStreakDays(int count) {
    return 'Série de $count jours';
  }

  @override
  String get homeStreakEncouragement => 'Continuez comme ça !';

  @override
  String get homeReadyForToday => 'Prêt pour aujourd\'hui ?';

  @override
  String homeNextChapter(String title) {
    return 'Suivant : $title';
  }

  @override
  String get homeGestureTryTitle => 'Essayez les gestes';

  @override
  String get homeGestureTrySub => 'Contrôlez avec les mouvements de la main';

  @override
  String get homePrivacyTitle => 'Confidentialité d\'abord';

  @override
  String get homePrivacyHeadline => 'Rien ne quitte cet appareil.';

  @override
  String get homePrivacyBody =>
      'Pas de suivi, pas de compte, juste l\'apprentissage. Votre parcours vous appartient.';

  @override
  String get navLearn => 'APPRENDRE';

  @override
  String get navHome => 'Accueil';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navActiveLesson => 'Leçon active';

  @override
  String get navChapterBadge => 'Ch 2';

  @override
  String get navChallenges => 'Défis';

  @override
  String get navCommunity => 'Communauté';

  @override
  String get navGesture => 'Gestes';

  @override
  String get navProfile => 'Profil';

  @override
  String get navSettings => 'Paramètres';

  @override
  String navUserStreak(int count) {
    return 'Anonyme - série ${count}j';
  }

  @override
  String get communityTyping => 'Quelqu\'un est en train d\'écrire...';

  @override
  String get communityRecent => 'RÉCENT';

  @override
  String get communitySubmitSuccess => 'Question envoyée anonymement !';

  @override
  String get communityAskDialogTitle => 'Poser une question';

  @override
  String get communityAskDialogBody =>
      'Votre question est totalement anonyme et sera transmise à nos éducateurs de santé.';

  @override
  String get communityAskInputHint => 'Écrivez ici...';

  @override
  String get communityWideSubtitle =>
      'Cercles de pairs, débats ouverts, questions anonymes.';

  @override
  String get communityWeeklyCircle => 'Nouveau cercle chaque semaine.';

  @override
  String get communityWeeklyCircleNext =>
      'Prochain : \"Puberté, expliquée\" - ouverture vendredi.';

  @override
  String get communityRuleAnonymous => 'Anonyme par défaut';

  @override
  String get communityRuleNoJudgment => 'Sans jugement, sans honte';

  @override
  String get communityRuleModerated =>
      'Modéré par de vrais éducateurs de santé';

  @override
  String get communityRuleReport => 'Signalez tout ce qui semble inapproprié';

  @override
  String get communityNeedPrivateChat => 'Besoin de parler en privé ?';

  @override
  String get communityPrivateChatBody =>
      'Discussion gratuite et confidentielle avec un éducateur de santé en kinyarwanda, anglais ou français.';

  @override
  String get communityStartPrivateChat => 'Démarrer un chat privé';

  @override
  String get communityNoNamesNoPhotos =>
      'Pas de noms. Pas de photos. Juste l\'essentiel.';

  @override
  String get gestureSwipeRight => 'Glisser à droite';

  @override
  String get gestureSwipeLeft => 'Glisser à gauche';

  @override
  String get gestureSwipeUp => 'Glisser vers le haut';

  @override
  String get gestureOpenPalm => 'Main ouverte';

  @override
  String get gestureThumbsUp => 'Pouce levé';

  @override
  String get gesturePinchLabel => 'Pincer';

  @override
  String get gestureActionNextChapter => 'Chapitre suivant';

  @override
  String get gestureActionPrevChapter => 'Chapitre précédent';

  @override
  String get gestureActionScroll => 'Faire défiler le contenu';

  @override
  String get gestureActionPauseNarration => 'Mettre la narration en pause';

  @override
  String get gestureActionMarkUnderstood => 'Marquer comme compris';

  @override
  String get gestureActionZoomModel => 'Zoomer le modèle 3D';

  @override
  String get gestureOverlayModel => 'Modèle';

  @override
  String get gestureOverlayLandmarks => 'Repères';

  @override
  String get gestureOverlayHand => 'Main';

  @override
  String get gestureOverlayHandRight => 'Droite';

  @override
  String get gestureOverlayLatency => 'Latence';

  @override
  String get lessonAutoRotateStart => 'Démarrer la rotation auto';

  @override
  String get lessonAutoRotateStop => 'Arrêter la rotation auto';

  @override
  String get lessonZoomIn => 'Zoom avant';

  @override
  String get lessonZoomOut => 'Zoom arrière';

  @override
  String get lessonResetView => 'Réinitialiser la vue';

  @override
  String get pinWeakError =>
      'Le PIN ne doit pas être séquentiel (ex. 1234) ni répété (ex. 1111).';

  @override
  String get pinSyncFailed =>
      'Échec de synchronisation du PIN avec le serveur. Veuillez essayer un autre PIN.';

  @override
  String get pinUsernameHint => 'Entrez votre nom d\'utilisateur (facultatif)';

  @override
  String get sttListening => 'Écoute en cours…';

  @override
  String get sttTapToSpeak => 'Appuyez pour parler';

  @override
  String get sttSpeakNow => 'Parlez maintenant';

  @override
  String get sttNotAvailable =>
      'La saisie vocale n\'est pas disponible sur cet appareil';

  @override
  String get sttNoPermission => 'Permission du microphone refusée';

  @override
  String get sttKinyarwandaNote =>
      'La reconnaissance du kinyarwanda est limitée — l\'application fera de son mieux';

  @override
  String get sttVoiceInput => 'Saisie vocale';

  @override
  String get sttVoiceSearch => 'Recherche vocale';

  @override
  String get sttTryAgain => 'Réessayer';

  @override
  String get homeStreakTitle => 'Votre série';

  @override
  String homeStreakDaysLabel(int days) {
    return 'Série de $days jour(s)';
  }

  @override
  String get communityOfflineQueued =>
      'Message en attente — sera envoyé dès la reconnexion';

  @override
  String get communityVoteOffline => 'Hors ligne — votez dès la reconnexion';

  @override
  String get communityQuestionQueued =>
      'Question en attente — sera envoyée dès la reconnexion';
}
