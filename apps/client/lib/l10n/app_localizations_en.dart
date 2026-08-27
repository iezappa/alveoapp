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
  String get navTimeline => 'Timeline';

  @override
  String get navSettings => 'Settings';

  @override
  String get checkInTitle => 'How are you feeling?';

  @override
  String get overallMood => 'Overall mood';

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
