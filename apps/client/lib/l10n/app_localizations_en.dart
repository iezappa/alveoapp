// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Terapia';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

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
  String get pinTooShort => 'Use at least 4 digits';

  @override
  String get pinMismatch => 'The PINs don\'t match';

  @override
  String get pinUpdated => 'PIN updated';

  @override
  String get pinRemoved => 'PIN removed';

  @override
  String get dataSectionTitle => 'Data';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get importBackup => 'Import backup';

  @override
  String get backupFileType => 'Terapia backup';

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
  String get navTimeline => 'Timeline';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navSessions => 'Sessions';

  @override
  String get navJournal => 'Journal';

  @override
  String get navSettings => 'Settings';

  @override
  String get dashboardGreetingMorning => 'Good morning.';

  @override
  String get dashboardGreetingAfternoon => 'Good afternoon.';

  @override
  String get dashboardGreetingEvening => 'Good evening.';

  @override
  String get dashboardGreetingNight => 'Rest well.';

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
  String get dashboardBreatheTitle => 'Take a moment';

  @override
  String get dashboardBreathePrompt => 'A minute of paced breathing.';

  @override
  String get breatheAction => 'Breathe';

  @override
  String get breatheTitle => 'Breathe';

  @override
  String get breatheStart => 'Start';

  @override
  String get breatheStop => 'Stop';

  @override
  String get breatheReady => 'Ready when you are';

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
  String get sessionsUpcoming => 'Upcoming';

  @override
  String get sessionsPast => 'Past';

  @override
  String get sessionsEmpty => 'No sessions yet';

  @override
  String get newSession => 'New session';

  @override
  String get editSession => 'Session';

  @override
  String get sessionScheduledFor => 'When';

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
  String get sessionTimelineLabel => 'Therapy session';

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
  String get timelineEmpty => 'Nothing logged yet';

  @override
  String timelineMoodLabel(int score) {
    return 'Mood $score/5';
  }

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
}
