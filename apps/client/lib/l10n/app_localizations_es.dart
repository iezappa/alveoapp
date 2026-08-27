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
  String get cancel => 'Cancelar';

  @override
  String get pinSectionTitle => 'Bloqueo con PIN';

  @override
  String get pinSet => 'Configurar un PIN';

  @override
  String get pinChange => 'Cambiar PIN';

  @override
  String get pinRemove => 'Quitar PIN';

  @override
  String get pinNewLabel => 'Nuevo PIN';

  @override
  String get pinConfirmLabel => 'Confirmá el PIN';

  @override
  String get pinCurrentLabel => 'PIN actual';

  @override
  String get pinEnterTitle => 'Ingresá tu PIN';

  @override
  String get pinUnlock => 'Desbloquear';

  @override
  String get pinWrong => 'PIN incorrecto';

  @override
  String get pinTooShort => 'Usá al menos 4 dígitos';

  @override
  String get pinMismatch => 'Los PIN no coinciden';

  @override
  String get pinUpdated => 'PIN actualizado';

  @override
  String get pinRemoved => 'PIN quitado';

  @override
  String get navTimeline => 'Línea de tiempo';

  @override
  String get navTasks => 'Tareas';

  @override
  String get navSessions => 'Sesiones';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get sessionsUpcoming => 'Próximas';

  @override
  String get sessionsPast => 'Pasadas';

  @override
  String get sessionsEmpty => 'Todavía no hay sesiones';

  @override
  String get newSession => 'Nueva sesión';

  @override
  String get editSession => 'Sesión';

  @override
  String get sessionScheduledFor => 'Cuándo';

  @override
  String get sessionAgenda => 'Temas';

  @override
  String get sessionNotes => 'Notas';

  @override
  String get sessionTakeaways => 'Conclusiones';

  @override
  String get sessionAgendaHint => '¿Qué querés plantear?';

  @override
  String get sessionNotesHint => 'Notas durante la sesión…';

  @override
  String get sessionTakeawaysHint => '¿Con qué te quedaste?';

  @override
  String get sessionSaved => 'Sesión guardada';

  @override
  String get sessionTimelineLabel => 'Sesión de terapia';

  @override
  String get sessionLinks => 'Vínculos';

  @override
  String get linkAdd => 'Vincular un elemento';

  @override
  String get linkRemove => 'Desvincular';

  @override
  String get linkEmpty => 'Todavía no hay nada vinculado';

  @override
  String get linkNothingToLink => 'No hay nada para vincular';

  @override
  String get linkMoodLabel => 'Registro de ánimo';

  @override
  String get tasksEmpty => 'Todavía no hay tareas';

  @override
  String get newTask => 'Nueva tarea';

  @override
  String get editTask => 'Editar tarea';

  @override
  String get taskTitleHint => 'Tarea';

  @override
  String get taskDescriptionHint => 'Descripción (opcional)';

  @override
  String get taskDueDate => 'Para';

  @override
  String get taskNoDueDate => 'Sin fecha límite';

  @override
  String get taskClearDueDate => 'Quitar fecha límite';

  @override
  String get taskStatus => 'Estado';

  @override
  String get taskClosingNoteHint => 'Cómo fue (opcional)';

  @override
  String get taskSaved => 'Tarea guardada';

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
  String get journalNewTitle => 'Nueva entrada';

  @override
  String get journalEditTitle => 'Editar entrada';

  @override
  String get journalTitleHint => 'Título (opcional)';

  @override
  String get journalBodyHint => 'Escribí en Markdown…';

  @override
  String get journalDate => 'Fecha';

  @override
  String get journalSaved => 'Entrada guardada';

  @override
  String get editorWrite => 'Escribir';

  @override
  String get editorPreview => 'Vista previa';

  @override
  String get exportDayTooltip => 'Exportar un día';

  @override
  String get exportNothing => 'No hay registros para ese día';

  @override
  String get exportMarkdownType => 'Markdown';

  @override
  String exportSaved(String path) {
    return 'Guardado en $path';
  }

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
