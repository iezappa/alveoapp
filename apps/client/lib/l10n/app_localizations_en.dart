// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Alveo';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get supportSection => 'Support';

  @override
  String get supportTitle => 'Support my projects';

  @override
  String get supportBody =>
      'Alveo is free and works fully offline. If it helps you, you can chip in to help me keep my projects going.';

  @override
  String get supportCafecito => 'Cafecito (Argentina)';

  @override
  String get supportPatreon => 'Patreon (rest of the world)';

  @override
  String get supportLinkError => 'Couldn\'t open the link';

  @override
  String get cancel => 'Cancel';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get accentColor => 'Accent colour';

  @override
  String get accentGreen => 'Green';

  @override
  String get accentBlue => 'Blue';

  @override
  String get accentPink => 'Pink';

  @override
  String get accentViolet => 'Violet';

  @override
  String get accentOrange => 'Orange';

  @override
  String get accentRed => 'Red';

  @override
  String get pinSectionTitle => 'PIN lock';

  @override
  String get pinSet => 'Set a PIN';

  @override
  String get pinChange => 'Change PIN';

  @override
  String get pinRemove => 'Remove PIN';

  @override
  String get pinNewLabel => 'New PIN';

  @override
  String get pinConfirmLabel => 'Confirm PIN';

  @override
  String get pinCurrentLabel => 'Current PIN';

  @override
  String get pinEnterTitle => 'Enter your PIN';

  @override
  String get pinUnlock => 'Unlock';

  @override
  String get pinWrong => 'Wrong PIN';

  @override
  String pinLockedOut(int seconds) {
    return 'Too many tries. Wait ${seconds}s.';
  }

  @override
  String get pinTooShort => 'Use at least 4 digits';

  @override
  String get pinMismatch => 'The PINs don\'t match';

  @override
  String get pinUpdated => 'PIN updated';

  @override
  String get pinRemoved => 'PIN removed';

  @override
  String get dataSectionTitle => 'Your data';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get importBackup => 'Import backup';

  @override
  String get backupFileType => 'Alveo backup';

  @override
  String get backupSaved => 'Backup saved';

  @override
  String get importDone => 'Import complete';

  @override
  String importSummary(int inserted, int skipped) {
    return '$inserted added, $skipped already present';
  }

  @override
  String importFailed(String reason) {
    return 'Import failed: $reason';
  }

  @override
  String get obsidianSection => 'Obsidian';

  @override
  String get obsidianVaultFolder => 'Vault folder';

  @override
  String get obsidianNotSet => 'Not set';

  @override
  String get obsidianExport => 'Export journal to Obsidian';

  @override
  String get obsidianImport => 'Import journal from Obsidian';

  @override
  String get obsidianNoVault => 'Choose a vault folder first';

  @override
  String obsidianExported(int count) {
    return '$count notes written';
  }

  @override
  String obsidianImported(int created, int updated) {
    return '$created added, $updated updated';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navSessions => 'Sessions';

  @override
  String get navJournal => 'Journal';

  @override
  String get navSettings => 'Settings';

  @override
  String get dashboardGreetingMorning => 'Good morning';

  @override
  String get dashboardGreetingAfternoon => 'Good afternoon';

  @override
  String get dashboardGreetingEvening => 'Good evening';

  @override
  String get dashboardGreetingNight => 'Rest well';

  @override
  String dashboardGreetingNamed(String greeting, String name) {
    return '$greeting, $name.';
  }

  @override
  String get namePromptTitle => 'What\'s your name?';

  @override
  String get namePromptLabel => 'Your name';

  @override
  String get settingsTutorial => 'Tutorial';

  @override
  String get settingsTutorialSubtitle => 'Review how the app works';

  @override
  String get settingsDisclaimerTitle => 'About this app';

  @override
  String get settingsDisclaimerBody =>
      'Alveo is a personal tool for keeping track of how you\'re doing. It is not a medical device, it does not provide diagnosis or treatment, and it is not a substitute for professional care. In an emergency, contact your local emergency services or your care provider.';

  @override
  String get tutorialSkip => 'Skip';

  @override
  String get tutorialBack => 'Back';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialDone => 'Done';

  @override
  String get tutorialWelcomeTitle => 'Welcome to Alveo';

  @override
  String get tutorialWelcomeBody =>
      'A calm, private space for your therapy work. Everything stays on this device — nothing is ever uploaded.';

  @override
  String get tutorialCheckInTitle => 'Daily check-in';

  @override
  String get tutorialCheckInBody =>
      'From Home, log how you feel on a 1–5 scale, choose the emotions that fit, and add a short note.';

  @override
  String get tutorialWriteTitle => 'Journal, sessions & tasks';

  @override
  String get tutorialWriteBody =>
      'Write freely in journal notebooks, prepare and review your therapy sessions, and track the tasks your therapist gives you.';

  @override
  String get tutorialToolsTitle => 'Tools to steady yourself';

  @override
  String get tutorialToolsBody =>
      'Work through a hard thought with a CBT thought record, or open Breathe for a short guided exercise.';

  @override
  String get tutorialReviewTitle => 'Everything in one place';

  @override
  String get tutorialReviewBody =>
      '\"See everything\" on Home gathers all your notes. Set a PIN and export backups from Settings — and reopen this guide there anytime.';

  @override
  String get dashboardSafeHere => 'Take a deep breath. You\'re safe here.';

  @override
  String get dashboardNextSession => 'Next session';

  @override
  String get dashboardNextSessionNone => 'No sessions scheduled';

  @override
  String get dashboardScheduleSession => 'Schedule one';

  @override
  String get dashboardNotes => 'Notes';

  @override
  String get dashboardToday => 'Today';

  @override
  String get dashboardTomorrow => 'Tomorrow';

  @override
  String get dashboardCheckInTitle => 'Daily check-in';

  @override
  String get dashboardCheckInPrompt => 'How is your heart today?';

  @override
  String get dashboardMoodTrend => 'Mood · last 14 days';

  @override
  String get dashboardMoodTrendEmpty => 'Check in a few days to see your trend';

  @override
  String get dashboardViewAll => 'See everything';

  @override
  String get allRecordsTitle => 'Everything';

  @override
  String get allRecordsEmpty => 'Nothing written yet';

  @override
  String get allRecordsKindThought => 'Thought record';

  @override
  String get allRecordsKindMood => 'Check-in note';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get insightsRange30 => '30 days';

  @override
  String get insightsRange90 => '90 days';

  @override
  String get insightsEmpty => 'Not enough check-ins yet';

  @override
  String get insightsCalendar => 'Calendar';

  @override
  String get safetyPlanTitle => 'Safety plan';

  @override
  String get safetyPlanSaved => 'Safety plan saved';

  @override
  String get dashboardSafetyPlan => 'Safety plan';

  @override
  String get safetyWarningSigns => 'Warning signs';

  @override
  String get safetyCoping => 'Things I can do on my own';

  @override
  String get safetyDistractions => 'People and places that distract me';

  @override
  String get safetyEnvironment => 'Making my space safer';

  @override
  String get safetyContacts => 'People I can reach';

  @override
  String get safetyAddContact => 'Add contact';

  @override
  String get safetyContactName => 'Name';

  @override
  String get safetyContactPhone => 'Phone';

  @override
  String get safetyContactSupport => 'Support';

  @override
  String get safetyContactProfessional => 'Professional';

  @override
  String get medicationsTitle => 'Medications';

  @override
  String get dashboardMedications => 'Medications';

  @override
  String get medicationsEmpty => 'No medications tracked';

  @override
  String get newMedication => 'New medication';

  @override
  String get editMedication => 'Medication';

  @override
  String get medicationName => 'Name';

  @override
  String get medicationDose => 'Dose';

  @override
  String get medicationSchedule => 'Schedule';

  @override
  String get medicationActive => 'Active';

  @override
  String get medicationTake => 'Log a dose';

  @override
  String get medicationSaved => 'Medication saved';

  @override
  String medicationTakenToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doses today',
      one: '1 dose today',
    );
    return '$_temp0';
  }

  @override
  String insightsAverage(String value) {
    return 'Average $value/5';
  }

  @override
  String insightsDaysLogged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days logged',
      one: '1 day logged',
    );
    return '$_temp0';
  }

  @override
  String get libraryTitle => 'Library';

  @override
  String get libraryToday => 'Today';

  @override
  String get libraryAll => 'All quotes';

  @override
  String get breatheAction => 'Breathe';

  @override
  String get breatheTitle => 'Breathe';

  @override
  String get breatheStart => 'Start session';

  @override
  String get breatheStop => 'End session';

  @override
  String get breatheRemaining => 'Remaining';

  @override
  String get breathePhaseInhale => 'Breathe in';

  @override
  String get breathePhaseHold => 'Hold';

  @override
  String get breathePhaseExhale => 'Breathe out';

  @override
  String get breathePatternBox => 'Box · 4·4·4·4';

  @override
  String get breathePatternRelaxing => 'Calm · 4·7·8';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search entries, sessions, tasks…';

  @override
  String get searchStartTyping => 'Type to search';

  @override
  String get searchNoResults => 'No matches';

  @override
  String get searchTypeMood => 'Mood';

  @override
  String get searchTypeJournal => 'Journal';

  @override
  String get searchTypeTask => 'Tasks';

  @override
  String get searchTypeSession => 'Sessions';

  @override
  String get journalSectionOneLiner => 'One-liners';

  @override
  String get journalSectionStudent => 'Student';

  @override
  String get journalSectionCreative => 'Creative';

  @override
  String get journalSectionFreedom => 'Freedom';

  @override
  String get journalSectionTherapy => 'Therapy';

  @override
  String get journalSectionWinLog => 'Win log';

  @override
  String get journalSectionEmpty => 'Nothing here yet';

  @override
  String get journalSearchHint => 'Search the journal';

  @override
  String journalEntryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
    );
    return '$_temp0';
  }

  @override
  String get monthlyReview => 'Monthly review';

  @override
  String get writeMonthlyReview => 'Write this month\'s review';

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deleteConfirmTitle => 'Delete this record?';

  @override
  String get detailNothingSelected => 'Pick a record to see it here';

  @override
  String get sessionsUpcoming => 'Upcoming';

  @override
  String get sessionsPast => 'Past';

  @override
  String get sessionsEmpty => 'No sessions yet';

  @override
  String get sessionsSearchHint => 'Search sessions';

  @override
  String get sessionPreviewEmpty => 'This session has no notes yet';

  @override
  String get newSession => 'New session';

  @override
  String get editSession => 'Session';

  @override
  String get sessionScheduledFor => 'When';

  @override
  String get sessionPreSummary => 'Pre-session summary';

  @override
  String get sessionPreSummaryDone => 'Added to the agenda';

  @override
  String get sessionExportTitle => 'Therapy session';

  @override
  String get sessionExportPdf => 'Export as PDF';

  @override
  String get sessionAgenda => 'Agenda';

  @override
  String get sessionNotes => 'Notes';

  @override
  String get sessionTakeaways => 'Takeaways';

  @override
  String get sessionAgendaHint => 'What do you want to bring up?';

  @override
  String get sessionNotesHint => 'Notes during the session…';

  @override
  String get sessionTakeawaysHint => 'What did you take away?';

  @override
  String get sessionSaved => 'Session saved';

  @override
  String get sessionLinks => 'Links';

  @override
  String get linkAdd => 'Link an item';

  @override
  String get linkRemove => 'Unlink';

  @override
  String get linkEmpty => 'Nothing linked yet';

  @override
  String get linkNothingToLink => 'Nothing to link';

  @override
  String get linkMoodLabel => 'Mood check-in';

  @override
  String get tasksEmpty => 'No tasks yet';

  @override
  String get tasksSearchHint => 'Search tasks';

  @override
  String get taskClosingNote => 'How it went';

  @override
  String get newTask => 'New task';

  @override
  String get editTask => 'Edit task';

  @override
  String get taskTitleHint => 'Task';

  @override
  String get taskDescriptionHint => 'Description (optional)';

  @override
  String get taskDueDate => 'Due';

  @override
  String get taskNoDueDate => 'No due date';

  @override
  String get taskClearDueDate => 'Clear due date';

  @override
  String get taskStatus => 'Status';

  @override
  String get taskClosingNoteHint => 'How it went (optional)';

  @override
  String get taskSaved => 'Task saved';

  @override
  String get checkInTitle => 'How are you feeling?';

  @override
  String get checkInEditTitle => 'Edit check-in';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get tagsHint => 'Add a tag';

  @override
  String get moodHistoryTitle => 'Mood history';

  @override
  String get moodHistoryEmpty => 'No check-ins yet';

  @override
  String get overallMood => 'Overall mood';

  @override
  String get moodScale1 => 'Very low';

  @override
  String get moodScale2 => 'Low';

  @override
  String get moodScale3 => 'Okay';

  @override
  String get moodScale4 => 'Good';

  @override
  String get moodScale5 => 'Great';

  @override
  String get emotionsSectionTitle => 'Emotions';

  @override
  String get intensityLabel => 'Intensity';

  @override
  String get noteLabel => 'Note (optional)';

  @override
  String get saveButton => 'Save';

  @override
  String get checkInSaved => 'Check-in saved';

  @override
  String get addCheckIn => 'New check-in';

  @override
  String get journalUntitled => 'Untitled entry';

  @override
  String get journalNewTitle => 'New entry';

  @override
  String get journalEditTitle => 'Edit entry';

  @override
  String get journalTitleHint => 'Title (optional)';

  @override
  String get journalBodyHint => 'Write in Markdown…';

  @override
  String get journalDate => 'Date';

  @override
  String get journalSaved => 'Entry saved';

  @override
  String get editorWrite => 'Write';

  @override
  String get editorPreview => 'Preview';

  @override
  String get exportDayTooltip => 'Export a day';

  @override
  String get exportNothing => 'No records for that day';

  @override
  String get exportMarkdownType => 'Markdown';

  @override
  String exportSaved(String path) {
    return 'Saved to $path';
  }

  @override
  String get taskStatusPending => 'Pending';

  @override
  String get taskStatusInProgress => 'In progress';

  @override
  String get taskStatusDone => 'Done';

  @override
  String get taskStatusSkipped => 'Skipped';

  @override
  String get navTools => 'Tools';

  @override
  String get toolsAdd => 'Use a tool';

  @override
  String get thoughtRecordsEmpty => 'No thought records yet';

  @override
  String get thoughtRecordsSearchHint => 'Search thought records';

  @override
  String get newThoughtRecord => 'New thought record';

  @override
  String get editThoughtRecord => 'Thought record';

  @override
  String get thoughtRecordSaved => 'Thought record saved';

  @override
  String get trSituation => 'Situation';

  @override
  String get trSituationHint => 'What was happening?';

  @override
  String get trAutomaticThought => 'Automatic thought';

  @override
  String get trAutomaticThoughtHint => 'What went through your mind?';

  @override
  String get trBeliefBefore => 'Belief before';

  @override
  String get trBeliefAfter => 'Belief after';

  @override
  String get trEmotion => 'Emotion';

  @override
  String get trEmotionHint => 'Name the feeling';

  @override
  String get trEmotionIntensityBefore => 'Intensity before';

  @override
  String get trEmotionIntensityAfter => 'Intensity after';

  @override
  String get trDistortions => 'Distortions';

  @override
  String get trAlternativeThought => 'Alternative thought';

  @override
  String get trAlternativeThoughtHint => 'A fairer, kinder way to see it';

  @override
  String get distortionAllOrNothing => 'All-or-nothing thinking';

  @override
  String get distortionOvergeneralization => 'Overgeneralization';

  @override
  String get distortionMentalFilter => 'Mental filter';

  @override
  String get distortionDisqualifyingPositive => 'Disqualifying the positive';

  @override
  String get distortionJumpingToConclusions => 'Jumping to conclusions';

  @override
  String get distortionCatastrophizing => 'Catastrophizing';

  @override
  String get distortionEmotionalReasoning => 'Emotional reasoning';

  @override
  String get distortionShouldStatements => '\"Should\" statements';

  @override
  String get distortionLabeling => 'Labeling';

  @override
  String get distortionPersonalization => 'Personalization';

  @override
  String get emotionJoy => 'Joy';

  @override
  String get emotionSadness => 'Sadness';

  @override
  String get emotionTrust => 'Trust';

  @override
  String get emotionDisgust => 'Disgust';

  @override
  String get emotionFear => 'Fear';

  @override
  String get emotionAnger => 'Anger';

  @override
  String get emotionSurprise => 'Surprise';

  @override
  String get emotionAnticipation => 'Anticipation';

  @override
  String get storageDegradedWarning =>
      'This browser keeps your data in storage that may be lost on a reload or when browser data is cleared. Export a backup now.';

  @override
  String get storageVolatileWarning =>
      'This browser cannot store your data: everything you write will be lost when you close this tab. Export a backup before you leave.';

  @override
  String get storageExportNow => 'Export now';

  @override
  String get storageWarningDismiss => 'Dismiss';

  @override
  String get recoveryTitle => 'The local database could not be opened';

  @override
  String get recoveryBody =>
      'The data stored on this device could not be read, so the app cannot start normally. You can restore a backup file, or start over with an empty database.';

  @override
  String get recoveryImport => 'Import a backup';

  @override
  String get recoveryReset => 'Reset local database';

  @override
  String get recoveryImportConfirmTitle => 'Import a backup?';

  @override
  String get recoveryImportConfirmBody =>
      'The unreadable database on this device will be permanently deleted and replaced by what the backup file holds. It cannot be undone.';

  @override
  String get recoveryImportFailed =>
      'The backup could not be restored. The local database is now empty; try another backup file.';

  @override
  String get recoveryResetConfirmTitle => 'Reset the local database?';

  @override
  String get recoveryResetConfirmBody =>
      'Everything stored on this device will be permanently deleted and the app will start empty. It cannot be undone.';

  @override
  String get recoveryResetConfirmAction => 'Reset';

  @override
  String get backupNoticeTitle => 'Your data lives only on this device';

  @override
  String get backupNoticeOnboarding =>
      'We don\'t store your data on our servers. If you uninstall the app, lose or reset your device, or clear your browser data, it will be lost. Export regularly from Settings → Data → Export backup and keep the file somewhere safe.';

  @override
  String get backupNoticeAccept => 'Got it, I\'ll back up';

  @override
  String get backupNoticeSettings =>
      'Your data isn\'t stored on our servers. Export regularly and keep the file off this device.';

  @override
  String get backupReminderNever => 'You haven\'t backed up your data yet.';

  @override
  String backupReminderOverdue(int days) {
    return 'Your last backup was $days days ago.';
  }

  @override
  String get backupReminderAction => 'Export';

  @override
  String get backupReminderDismiss => 'Not now';

  @override
  String get eraseAllData => 'Delete all my data';

  @override
  String get eraseAllTitle => 'Delete all your data?';

  @override
  String get eraseAllBody =>
      'Every record on this device is deleted, along with your PIN, profile, safety plan and settings; only the language and the appearance are kept. The app then starts over from the welcome screens. It cannot be undone, and no copy exists anywhere else: export first if you might want any of it back.';

  @override
  String get eraseAllConfirmWord => 'DELETE';

  @override
  String eraseAllTypeToConfirm(String word) {
    return 'Type $word to confirm';
  }

  @override
  String get eraseAllExportFirst => 'Export first';

  @override
  String get eraseAllAction => 'Delete everything';

  @override
  String get disclaimerAcceptTitle => 'Before you start';

  @override
  String get disclaimerAcceptBody =>
      'Alveo is a personal tool, not a medical device. It does not diagnose or treat, and it is not a substitute for professional care. In an emergency, call 911.';

  @override
  String get disclaimerAcceptAction => 'I understand';

  @override
  String get crisisTitle => 'If you are in crisis';

  @override
  String get crisisIntro =>
      'You don\'t have to go through it without help. In Argentina, the Centro de Asistencia al Suicida answers these lines:';

  @override
  String get crisisLine135 =>
      'Línea 135 (free from Buenos Aires City and Greater Buenos Aires)';

  @override
  String get crisisLineNational =>
      '(011) 5275-1135 (from anywhere in Argentina)';

  @override
  String get crisisEmergency => '911 — emergencies';

  @override
  String get crisisCallError =>
      'Couldn\'t start a call. Dial the number yourself.';

  @override
  String get sensitiveExportTitle => 'Keep this file private';

  @override
  String get sensitiveExportBody =>
      'This file contains your therapy notes unencrypted. Store it somewhere private.';

  @override
  String get sensitiveExportMute => 'Don\'t show again this session';

  @override
  String get sensitiveExportContinue => 'Continue';

  @override
  String get pinWebCaveat =>
      'On the web version, the PIN deters casual access but does not protect against someone with access to this browser or device.';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get developerContact => 'Developer and contact';

  @override
  String get openSourceLicenses => 'Licenses';

  @override
  String get profileSection => 'Profile';

  @override
  String get securitySection => 'Security';

  @override
  String get aboutSection => 'About';

  @override
  String get exportCsv => 'Export as spreadsheet (CSV)';

  @override
  String get exportCsvSubtitle =>
      'For reading. It cannot be imported back — use the backup for that.';

  @override
  String get csvFileType => 'CSV spreadsheet';

  @override
  String get csvSaved => 'Spreadsheet saved';

  @override
  String whatsNewTitle(String version) {
    return 'What\'s new in $version';
  }

  @override
  String get whatsNewClose => 'Got it';
}
