import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('en'),
    Locale('es'),
  ];

  /// Application name shown in the app bar and task switcher
  ///
  /// In en, this message translates to:
  /// **'Alveo'**
  String get appTitle;

  /// Label for the language toggle in settings
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent colour'**
  String get accentColor;

  /// No description provided for @accentGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get accentGreen;

  /// No description provided for @accentBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get accentBlue;

  /// No description provided for @accentPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get accentPink;

  /// No description provided for @accentViolet.
  ///
  /// In en, this message translates to:
  /// **'Violet'**
  String get accentViolet;

  /// No description provided for @accentOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get accentOrange;

  /// No description provided for @accentRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get accentRed;

  /// No description provided for @pinSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'PIN lock'**
  String get pinSectionTitle;

  /// No description provided for @pinSet.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN'**
  String get pinSet;

  /// No description provided for @pinChange.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get pinChange;

  /// No description provided for @pinRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get pinRemove;

  /// No description provided for @pinNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get pinNewLabel;

  /// No description provided for @pinConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get pinConfirmLabel;

  /// No description provided for @pinCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get pinCurrentLabel;

  /// No description provided for @pinEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get pinEnterTitle;

  /// No description provided for @pinUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get pinUnlock;

  /// No description provided for @pinWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get pinWrong;

  /// No description provided for @pinTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 4 digits'**
  String get pinTooShort;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'The PINs don\'t match'**
  String get pinMismatch;

  /// No description provided for @pinUpdated.
  ///
  /// In en, this message translates to:
  /// **'PIN updated'**
  String get pinUpdated;

  /// No description provided for @pinRemoved.
  ///
  /// In en, this message translates to:
  /// **'PIN removed'**
  String get pinRemoved;

  /// No description provided for @dataSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get dataSectionTitle;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get importBackup;

  /// No description provided for @backupFileType.
  ///
  /// In en, this message translates to:
  /// **'Alveo backup'**
  String get backupFileType;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get backupSaved;

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Import complete'**
  String get importDone;

  /// No description provided for @importSummary.
  ///
  /// In en, this message translates to:
  /// **'{inserted} added, {skipped} already present'**
  String importSummary(int inserted, int skipped);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {reason}'**
  String importFailed(String reason);

  /// No description provided for @obsidianSection.
  ///
  /// In en, this message translates to:
  /// **'Obsidian'**
  String get obsidianSection;

  /// No description provided for @obsidianVaultFolder.
  ///
  /// In en, this message translates to:
  /// **'Vault folder'**
  String get obsidianVaultFolder;

  /// No description provided for @obsidianNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get obsidianNotSet;

  /// No description provided for @obsidianExport.
  ///
  /// In en, this message translates to:
  /// **'Export journal to Obsidian'**
  String get obsidianExport;

  /// No description provided for @obsidianImport.
  ///
  /// In en, this message translates to:
  /// **'Import journal from Obsidian'**
  String get obsidianImport;

  /// No description provided for @obsidianNoVault.
  ///
  /// In en, this message translates to:
  /// **'Choose a vault folder first'**
  String get obsidianNoVault;

  /// No description provided for @obsidianExported.
  ///
  /// In en, this message translates to:
  /// **'{count} notes written'**
  String obsidianExported(int count);

  /// No description provided for @obsidianImported.
  ///
  /// In en, this message translates to:
  /// **'{created} added, {updated} updated'**
  String obsidianImported(int created, int updated);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get navSessions;

  /// No description provided for @navJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get navJournal;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @dashboardGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning.'**
  String get dashboardGreetingMorning;

  /// No description provided for @dashboardGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon.'**
  String get dashboardGreetingAfternoon;

  /// No description provided for @dashboardGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening.'**
  String get dashboardGreetingEvening;

  /// No description provided for @dashboardGreetingNight.
  ///
  /// In en, this message translates to:
  /// **'Rest well.'**
  String get dashboardGreetingNight;

  /// No description provided for @dashboardSafeHere.
  ///
  /// In en, this message translates to:
  /// **'Take a deep breath. You\'re safe here.'**
  String get dashboardSafeHere;

  /// No description provided for @dashboardNextSession.
  ///
  /// In en, this message translates to:
  /// **'Next session'**
  String get dashboardNextSession;

  /// No description provided for @dashboardNextSessionNone.
  ///
  /// In en, this message translates to:
  /// **'No sessions scheduled'**
  String get dashboardNextSessionNone;

  /// No description provided for @dashboardScheduleSession.
  ///
  /// In en, this message translates to:
  /// **'Schedule one'**
  String get dashboardScheduleSession;

  /// No description provided for @dashboardNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get dashboardNotes;

  /// No description provided for @dashboardToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dashboardToday;

  /// No description provided for @dashboardTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get dashboardTomorrow;

  /// No description provided for @dashboardCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in'**
  String get dashboardCheckInTitle;

  /// No description provided for @dashboardCheckInPrompt.
  ///
  /// In en, this message translates to:
  /// **'How is your heart today?'**
  String get dashboardCheckInPrompt;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @libraryToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get libraryToday;

  /// No description provided for @libraryAll.
  ///
  /// In en, this message translates to:
  /// **'All quotes'**
  String get libraryAll;

  /// No description provided for @breatheAction.
  ///
  /// In en, this message translates to:
  /// **'Breathe'**
  String get breatheAction;

  /// No description provided for @breatheTitle.
  ///
  /// In en, this message translates to:
  /// **'Breathe'**
  String get breatheTitle;

  /// No description provided for @breatheStart.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get breatheStart;

  /// No description provided for @breatheStop.
  ///
  /// In en, this message translates to:
  /// **'End session'**
  String get breatheStop;

  /// No description provided for @breatheRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get breatheRemaining;

  /// No description provided for @breathePhaseInhale.
  ///
  /// In en, this message translates to:
  /// **'Breathe in'**
  String get breathePhaseInhale;

  /// No description provided for @breathePhaseHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get breathePhaseHold;

  /// No description provided for @breathePhaseExhale.
  ///
  /// In en, this message translates to:
  /// **'Breathe out'**
  String get breathePhaseExhale;

  /// No description provided for @breathePatternBox.
  ///
  /// In en, this message translates to:
  /// **'Box · 4·4·4·4'**
  String get breathePatternBox;

  /// No description provided for @breathePatternRelaxing.
  ///
  /// In en, this message translates to:
  /// **'Calm · 4·7·8'**
  String get breathePatternRelaxing;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search entries, sessions, tasks…'**
  String get searchHint;

  /// No description provided for @searchStartTyping.
  ///
  /// In en, this message translates to:
  /// **'Type to search'**
  String get searchStartTyping;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get searchNoResults;

  /// No description provided for @searchTypeMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get searchTypeMood;

  /// No description provided for @searchTypeJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get searchTypeJournal;

  /// No description provided for @searchTypeTask.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get searchTypeTask;

  /// No description provided for @searchTypeSession.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get searchTypeSession;

  /// No description provided for @journalSectionOneLiner.
  ///
  /// In en, this message translates to:
  /// **'One-liners'**
  String get journalSectionOneLiner;

  /// No description provided for @journalSectionStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get journalSectionStudent;

  /// No description provided for @journalSectionCreative.
  ///
  /// In en, this message translates to:
  /// **'Creative'**
  String get journalSectionCreative;

  /// No description provided for @journalSectionFreedom.
  ///
  /// In en, this message translates to:
  /// **'Freedom'**
  String get journalSectionFreedom;

  /// No description provided for @journalSectionTherapy.
  ///
  /// In en, this message translates to:
  /// **'Therapy'**
  String get journalSectionTherapy;

  /// No description provided for @journalSectionWinLog.
  ///
  /// In en, this message translates to:
  /// **'Win log'**
  String get journalSectionWinLog;

  /// No description provided for @journalSectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get journalSectionEmpty;

  /// No description provided for @journalSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search the journal'**
  String get journalSearchHint;

  /// No description provided for @journalEntryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 entry} other{{count} entries}}'**
  String journalEntryCount(int count);

  /// No description provided for @monthlyReview.
  ///
  /// In en, this message translates to:
  /// **'Monthly review'**
  String get monthlyReview;

  /// No description provided for @writeMonthlyReview.
  ///
  /// In en, this message translates to:
  /// **'Write this month\'s review'**
  String get writeMonthlyReview;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get deleteConfirmTitle;

  /// No description provided for @detailNothingSelected.
  ///
  /// In en, this message translates to:
  /// **'Pick a record to see it here'**
  String get detailNothingSelected;

  /// No description provided for @sessionsUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get sessionsUpcoming;

  /// No description provided for @sessionsPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get sessionsPast;

  /// No description provided for @sessionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get sessionsEmpty;

  /// No description provided for @sessionsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search sessions'**
  String get sessionsSearchHint;

  /// No description provided for @sessionPreviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'This session has no notes yet'**
  String get sessionPreviewEmpty;

  /// No description provided for @newSession.
  ///
  /// In en, this message translates to:
  /// **'New session'**
  String get newSession;

  /// No description provided for @editSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get editSession;

  /// No description provided for @sessionScheduledFor.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get sessionScheduledFor;

  /// No description provided for @sessionAgenda.
  ///
  /// In en, this message translates to:
  /// **'Agenda'**
  String get sessionAgenda;

  /// No description provided for @sessionNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get sessionNotes;

  /// No description provided for @sessionTakeaways.
  ///
  /// In en, this message translates to:
  /// **'Takeaways'**
  String get sessionTakeaways;

  /// No description provided for @sessionAgendaHint.
  ///
  /// In en, this message translates to:
  /// **'What do you want to bring up?'**
  String get sessionAgendaHint;

  /// No description provided for @sessionNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Notes during the session…'**
  String get sessionNotesHint;

  /// No description provided for @sessionTakeawaysHint.
  ///
  /// In en, this message translates to:
  /// **'What did you take away?'**
  String get sessionTakeawaysHint;

  /// No description provided for @sessionSaved.
  ///
  /// In en, this message translates to:
  /// **'Session saved'**
  String get sessionSaved;

  /// No description provided for @sessionLinks.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get sessionLinks;

  /// No description provided for @linkAdd.
  ///
  /// In en, this message translates to:
  /// **'Link an item'**
  String get linkAdd;

  /// No description provided for @linkRemove.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get linkRemove;

  /// No description provided for @linkEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing linked yet'**
  String get linkEmpty;

  /// No description provided for @linkNothingToLink.
  ///
  /// In en, this message translates to:
  /// **'Nothing to link'**
  String get linkNothingToLink;

  /// No description provided for @linkMoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Mood check-in'**
  String get linkMoodLabel;

  /// No description provided for @tasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get tasksEmpty;

  /// No description provided for @tasksSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search tasks'**
  String get tasksSearchHint;

  /// No description provided for @taskClosingNote.
  ///
  /// In en, this message translates to:
  /// **'How it went'**
  String get taskClosingNote;

  /// No description provided for @newTask.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get newTask;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get editTask;

  /// No description provided for @taskTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskTitleHint;

  /// No description provided for @taskDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get taskDescriptionHint;

  /// No description provided for @taskDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get taskDueDate;

  /// No description provided for @taskNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get taskNoDueDate;

  /// No description provided for @taskClearDueDate.
  ///
  /// In en, this message translates to:
  /// **'Clear due date'**
  String get taskClearDueDate;

  /// No description provided for @taskStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get taskStatus;

  /// No description provided for @taskClosingNoteHint.
  ///
  /// In en, this message translates to:
  /// **'How it went (optional)'**
  String get taskClosingNoteHint;

  /// No description provided for @taskSaved.
  ///
  /// In en, this message translates to:
  /// **'Task saved'**
  String get taskSaved;

  /// No description provided for @checkInTitle.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get checkInTitle;

  /// No description provided for @overallMood.
  ///
  /// In en, this message translates to:
  /// **'Overall mood'**
  String get overallMood;

  /// No description provided for @moodScale1.
  ///
  /// In en, this message translates to:
  /// **'Very low'**
  String get moodScale1;

  /// No description provided for @moodScale2.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get moodScale2;

  /// No description provided for @moodScale3.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get moodScale3;

  /// No description provided for @moodScale4.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodScale4;

  /// No description provided for @moodScale5.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get moodScale5;

  /// No description provided for @emotionsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Emotions'**
  String get emotionsSectionTitle;

  /// No description provided for @intensityLabel.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get intensityLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteLabel;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @checkInSaved.
  ///
  /// In en, this message translates to:
  /// **'Check-in saved'**
  String get checkInSaved;

  /// No description provided for @addCheckIn.
  ///
  /// In en, this message translates to:
  /// **'New check-in'**
  String get addCheckIn;

  /// No description provided for @journalUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled entry'**
  String get journalUntitled;

  /// No description provided for @journalNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get journalNewTitle;

  /// No description provided for @journalEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get journalEditTitle;

  /// No description provided for @journalTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get journalTitleHint;

  /// No description provided for @journalBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Write in Markdown…'**
  String get journalBodyHint;

  /// No description provided for @journalDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get journalDate;

  /// No description provided for @journalSaved.
  ///
  /// In en, this message translates to:
  /// **'Entry saved'**
  String get journalSaved;

  /// No description provided for @editorWrite.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get editorWrite;

  /// No description provided for @editorPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get editorPreview;

  /// No description provided for @exportDayTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export a day'**
  String get exportDayTooltip;

  /// No description provided for @exportNothing.
  ///
  /// In en, this message translates to:
  /// **'No records for that day'**
  String get exportNothing;

  /// No description provided for @exportMarkdownType.
  ///
  /// In en, this message translates to:
  /// **'Markdown'**
  String get exportMarkdownType;

  /// No description provided for @exportSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to {path}'**
  String exportSaved(String path);

  /// No description provided for @taskStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get taskStatusPending;

  /// No description provided for @taskStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get taskStatusInProgress;

  /// No description provided for @taskStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taskStatusDone;

  /// No description provided for @taskStatusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get taskStatusSkipped;

  /// No description provided for @emotionJoy.
  ///
  /// In en, this message translates to:
  /// **'Joy'**
  String get emotionJoy;

  /// No description provided for @emotionSadness.
  ///
  /// In en, this message translates to:
  /// **'Sadness'**
  String get emotionSadness;

  /// No description provided for @emotionTrust.
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get emotionTrust;

  /// No description provided for @emotionDisgust.
  ///
  /// In en, this message translates to:
  /// **'Disgust'**
  String get emotionDisgust;

  /// No description provided for @emotionFear.
  ///
  /// In en, this message translates to:
  /// **'Fear'**
  String get emotionFear;

  /// No description provided for @emotionAnger.
  ///
  /// In en, this message translates to:
  /// **'Anger'**
  String get emotionAnger;

  /// No description provided for @emotionSurprise.
  ///
  /// In en, this message translates to:
  /// **'Surprise'**
  String get emotionSurprise;

  /// No description provided for @emotionAnticipation.
  ///
  /// In en, this message translates to:
  /// **'Anticipation'**
  String get emotionAnticipation;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
