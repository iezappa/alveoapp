// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Alveo';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get cancel => 'Cancelar';

  @override
  String get appearanceSection => 'Apariencia';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get accentColor => 'Color de acento';

  @override
  String get accentGreen => 'Verde';

  @override
  String get accentBlue => 'Azul';

  @override
  String get accentPink => 'Rosa';

  @override
  String get accentViolet => 'Violeta';

  @override
  String get accentOrange => 'Naranja';

  @override
  String get accentRed => 'Rojo';

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
  String get dataSectionTitle => 'Datos';

  @override
  String get exportBackup => 'Exportar copia';

  @override
  String get importBackup => 'Importar copia';

  @override
  String get backupFileType => 'Copia de Alveo';

  @override
  String get backupSaved => 'Copia guardada';

  @override
  String get importDone => 'Importación completa';

  @override
  String importSummary(int inserted, int skipped) {
    return '$inserted agregados, $skipped ya presentes';
  }

  @override
  String importFailed(String reason) {
    return 'Falló la importación: $reason';
  }

  @override
  String get obsidianSection => 'Obsidian';

  @override
  String get obsidianVaultFolder => 'Carpeta de la bóveda';

  @override
  String get obsidianNotSet => 'Sin configurar';

  @override
  String get obsidianExport => 'Exportar diario a Obsidian';

  @override
  String get obsidianImport => 'Importar diario de Obsidian';

  @override
  String get obsidianNoVault => 'Elegí primero una carpeta';

  @override
  String obsidianExported(int count) {
    return '$count notas escritas';
  }

  @override
  String obsidianImported(int created, int updated) {
    return '$created agregadas, $updated actualizadas';
  }

  @override
  String get navHome => 'Inicio';

  @override
  String get navTasks => 'Tareas';

  @override
  String get navSessions => 'Sesiones';

  @override
  String get navJournal => 'Diario';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get dashboardGreetingMorning => 'Buenos días.';

  @override
  String get dashboardGreetingAfternoon => 'Buenas tardes.';

  @override
  String get dashboardGreetingEvening => 'Buenas noches.';

  @override
  String get dashboardGreetingNight => 'Que descanses.';

  @override
  String get dashboardSafeHere => 'Respirá hondo. Estás en un lugar seguro.';

  @override
  String get dashboardNextSession => 'Próxima sesión';

  @override
  String get dashboardNextSessionNone => 'No tenés sesiones programadas';

  @override
  String get dashboardScheduleSession => 'Programar una';

  @override
  String get dashboardNotes => 'Notas';

  @override
  String get dashboardToday => 'Hoy';

  @override
  String get dashboardTomorrow => 'Mañana';

  @override
  String get dashboardCheckInTitle => 'Check-in diario';

  @override
  String get dashboardCheckInPrompt => '¿Cómo está tu corazón hoy?';

  @override
  String get dashboardMoodTrend => 'Ánimo · últimos 14 días';

  @override
  String get dashboardMoodTrendEmpty =>
      'Registrá tu ánimo unos días para ver la tendencia';

  @override
  String get insightsTitle => 'Progreso';

  @override
  String get insightsRange30 => '30 días';

  @override
  String get insightsRange90 => '90 días';

  @override
  String get insightsEmpty => 'Todavía no hay suficientes check-ins';

  @override
  String get insightsCalendar => 'Calendario';

  @override
  String get safetyPlanTitle => 'Plan de seguridad';

  @override
  String get safetyPlanSaved => 'Plan guardado';

  @override
  String get dashboardSafetyPlan => 'Plan de seguridad';

  @override
  String get safetyWarningSigns => 'Señales de alerta';

  @override
  String get safetyCoping => 'Cosas que puedo hacer solo/a';

  @override
  String get safetyDistractions => 'Personas y lugares que me distraen';

  @override
  String get safetyEnvironment => 'Hacer mi entorno más seguro';

  @override
  String get safetyContacts => 'Personas a las que puedo recurrir';

  @override
  String get safetyAddContact => 'Agregar contacto';

  @override
  String get safetyContactName => 'Nombre';

  @override
  String get safetyContactPhone => 'Teléfono';

  @override
  String get safetyContactSupport => 'Apoyo';

  @override
  String get safetyContactProfessional => 'Profesional';

  @override
  String insightsAverage(String value) {
    return 'Promedio $value/5';
  }

  @override
  String insightsDaysLogged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días registrados',
      one: '1 día registrado',
    );
    return '$_temp0';
  }

  @override
  String get libraryTitle => 'Biblioteca';

  @override
  String get libraryToday => 'Hoy';

  @override
  String get libraryAll => 'Todas las frases';

  @override
  String get breatheAction => 'Respirar';

  @override
  String get breatheTitle => 'Respirar';

  @override
  String get breatheStart => 'Empezar sesión';

  @override
  String get breatheStop => 'Terminar sesión';

  @override
  String get breatheRemaining => 'Restante';

  @override
  String get breathePhaseInhale => 'Inhalá';

  @override
  String get breathePhaseHold => 'Sostené';

  @override
  String get breathePhaseExhale => 'Exhalá';

  @override
  String get breathePatternBox => 'Cuadrada · 4·4·4·4';

  @override
  String get breathePatternRelaxing => 'Calma · 4·7·8';

  @override
  String get search => 'Buscar';

  @override
  String get searchHint => 'Buscá entradas, sesiones, tareas…';

  @override
  String get searchStartTyping => 'Escribí para buscar';

  @override
  String get searchNoResults => 'Sin coincidencias';

  @override
  String get searchTypeMood => 'Ánimo';

  @override
  String get searchTypeJournal => 'Diario';

  @override
  String get searchTypeTask => 'Tareas';

  @override
  String get searchTypeSession => 'Sesiones';

  @override
  String get journalSectionOneLiner => 'Líneas del día';

  @override
  String get journalSectionStudent => 'Estudio';

  @override
  String get journalSectionCreative => 'Creatividad';

  @override
  String get journalSectionFreedom => 'Libertad';

  @override
  String get journalSectionTherapy => 'Terapia';

  @override
  String get journalSectionWinLog => 'Logros y gratitud';

  @override
  String get journalSectionEmpty => 'Todavía no hay nada acá';

  @override
  String get journalSearchHint => 'Buscar en el diario';

  @override
  String journalEntryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entradas',
      one: '1 entrada',
    );
    return '$_temp0';
  }

  @override
  String get monthlyReview => 'Repaso del mes';

  @override
  String get writeMonthlyReview => 'Escribir el repaso del mes';

  @override
  String get editAction => 'Editar';

  @override
  String get deleteAction => 'Eliminar';

  @override
  String get deleteConfirmTitle => '¿Eliminar este registro?';

  @override
  String get detailNothingSelected => 'Elegí un registro para verlo acá';

  @override
  String get sessionsUpcoming => 'Próximas';

  @override
  String get sessionsPast => 'Pasadas';

  @override
  String get sessionsEmpty => 'Todavía no hay sesiones';

  @override
  String get sessionsSearchHint => 'Buscar sesiones';

  @override
  String get sessionPreviewEmpty => 'Esta sesión todavía no tiene notas';

  @override
  String get newSession => 'Nueva sesión';

  @override
  String get editSession => 'Sesión';

  @override
  String get sessionScheduledFor => 'Cuándo';

  @override
  String get sessionPreSummary => 'Resumen previo';

  @override
  String get sessionPreSummaryDone => 'Agregado a los temas';

  @override
  String get sessionExportTitle => 'Sesión de terapia';

  @override
  String get sessionExportPdf => 'Exportar como PDF';

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
  String get tasksSearchHint => 'Buscar tareas';

  @override
  String get taskClosingNote => 'Cómo fue';

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
  String get moodScale1 => 'Muy mal';

  @override
  String get moodScale2 => 'Mal';

  @override
  String get moodScale3 => 'Más o menos';

  @override
  String get moodScale4 => 'Bien';

  @override
  String get moodScale5 => 'Muy bien';

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
  String get navTools => 'Herramientas';

  @override
  String get toolsAdd => 'Usar una herramienta';

  @override
  String get thoughtRecordsEmpty => 'Todavía no hay registros';

  @override
  String get thoughtRecordsSearchHint => 'Buscar registros';

  @override
  String get newThoughtRecord => 'Nuevo registro';

  @override
  String get editThoughtRecord => 'Registro de pensamiento';

  @override
  String get thoughtRecordSaved => 'Registro guardado';

  @override
  String get trSituation => 'Situación';

  @override
  String get trSituationHint => '¿Qué estaba pasando?';

  @override
  String get trAutomaticThought => 'Pensamiento automático';

  @override
  String get trAutomaticThoughtHint => '¿Qué te cruzó por la cabeza?';

  @override
  String get trBeliefBefore => 'Credibilidad inicial';

  @override
  String get trBeliefAfter => 'Credibilidad final';

  @override
  String get trEmotion => 'Emoción';

  @override
  String get trEmotionHint => 'Nombrá lo que sentiste';

  @override
  String get trEmotionIntensityBefore => 'Intensidad inicial';

  @override
  String get trEmotionIntensityAfter => 'Intensidad final';

  @override
  String get trDistortions => 'Distorsiones';

  @override
  String get trAlternativeThought => 'Pensamiento alternativo';

  @override
  String get trAlternativeThoughtHint =>
      'Una forma más justa y amable de verlo';

  @override
  String get distortionAllOrNothing => 'Pensamiento todo o nada';

  @override
  String get distortionOvergeneralization => 'Sobregeneralización';

  @override
  String get distortionMentalFilter => 'Filtro mental';

  @override
  String get distortionDisqualifyingPositive => 'Descalificar lo positivo';

  @override
  String get distortionJumpingToConclusions => 'Sacar conclusiones apresuradas';

  @override
  String get distortionCatastrophizing => 'Catastrofizar';

  @override
  String get distortionEmotionalReasoning => 'Razonamiento emocional';

  @override
  String get distortionShouldStatements => 'Los \"debería\"';

  @override
  String get distortionLabeling => 'Etiquetado';

  @override
  String get distortionPersonalization => 'Personalización';

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
