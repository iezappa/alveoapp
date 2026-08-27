// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Terapia';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get navTimeline => 'Línea de tiempo';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get checkInTitle => '¿Cómo te sentís?';

  @override
  String get overallMood => 'Estado general';

  @override
  String get emotionsSectionTitle => 'Emociones';

  @override
  String get intensityLabel => 'Intensidad';

  @override
  String get noteLabel => 'Nota (opcional)';

  @override
  String get saveButton => 'Guardar';

  @override
  String get checkInSaved => 'Registro guardado';

  @override
  String get addCheckIn => 'Nuevo registro';

  @override
  String get timelineEmpty => 'Todavía no hay registros';

  @override
  String timelineMoodLabel(int score) {
    return 'Ánimo $score/5';
  }

  @override
  String get journalUntitled => 'Entrada sin título';

  @override
  String get taskStatusPending => 'Pendiente';

  @override
  String get taskStatusInProgress => 'En curso';

  @override
  String get taskStatusDone => 'Hecha';

  @override
  String get taskStatusSkipped => 'Omitida';

  @override
  String get emotionJoy => 'Alegría';

  @override
  String get emotionSadness => 'Tristeza';

  @override
  String get emotionTrust => 'Confianza';

  @override
  String get emotionDisgust => 'Asco';

  @override
  String get emotionFear => 'Miedo';

  @override
  String get emotionAnger => 'Enojo';

  @override
  String get emotionSurprise => 'Sorpresa';

  @override
  String get emotionAnticipation => 'Anticipación';
}
