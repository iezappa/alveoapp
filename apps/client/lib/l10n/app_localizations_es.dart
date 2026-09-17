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
  String get supportSection => 'Soporte';

  @override
  String get supportTitle => 'Apoyá mis proyectos';

  @override
  String get supportBody =>
      'Alveo es gratis y funciona sin conexión. Si te sirve, podés colaborar para que pueda seguir manteniendo mis proyectos.';

  @override
  String get supportCafecito => 'Cafecito (Argentina)';

  @override
  String get supportPatreon => 'Patreon (resto del mundo)';

  @override
  String get supportLinkError => 'No se pudo abrir el enlace';

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
  String pinLockedOut(int seconds) {
    return 'Demasiados intentos. Esperá ${seconds}s.';
  }

  @override
  String get pinTooShort => 'Usá al menos 4 dígitos';

  @override
  String get pinMismatch => 'Los PIN no coinciden';

  @override
  String get pinUpdated => 'PIN actualizado';

  @override
  String get pinRemoved => 'PIN quitado';

  @override
  String get dataSectionTitle => 'Tus datos';

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
  String get dashboardGreetingMorning => 'Buenos días';

  @override
  String get dashboardGreetingAfternoon => 'Buenas tardes';

  @override
  String get dashboardGreetingEvening => 'Buenas noches';

  @override
  String get dashboardGreetingNight => 'Que descanses';

  @override
  String dashboardGreetingNamed(String greeting, String name) {
    return '$greeting, $name.';
  }

  @override
  String get namePromptTitle => '¿Cómo te llamás?';

  @override
  String get namePromptLabel => 'Tu nombre';

  @override
  String get settingsTutorial => 'Tutorial';

  @override
  String get settingsTutorialSubtitle => 'Repasá cómo funciona la app';

  @override
  String get settingsDisclaimerTitle => 'Sobre esta app';

  @override
  String get settingsDisclaimerBody =>
      'Alveo es una herramienta personal para hacer seguimiento de cómo estás. No es un dispositivo médico, no da diagnóstico ni tratamiento, y no reemplaza la atención profesional. Ante una emergencia, comunicate con los servicios de emergencia de tu zona o con tu profesional de salud.';

  @override
  String get tutorialSkip => 'Omitir';

  @override
  String get tutorialBack => 'Atrás';

  @override
  String get tutorialNext => 'Siguiente';

  @override
  String get tutorialDone => 'Listo';

  @override
  String get tutorialWelcomeTitle => 'Bienvenido a Alveo';

  @override
  String get tutorialWelcomeBody =>
      'Un espacio tranquilo y privado para tu terapia. Todo queda en este dispositivo; nunca se sube a ningún lado.';

  @override
  String get tutorialCheckInTitle => 'Check-in diario';

  @override
  String get tutorialCheckInBody =>
      'Desde el inicio, registrá cómo te sentís en una escala del 1 al 5, elegí las emociones que encajan y sumá una nota breve.';

  @override
  String get tutorialWriteTitle => 'Diario, sesiones y tareas';

  @override
  String get tutorialWriteBody =>
      'Escribí libremente en los cuadernos del diario, prepará y repasá tus sesiones de terapia, y seguí las tareas que te da tu terapeuta.';

  @override
  String get tutorialToolsTitle => 'Herramientas para calmarte';

  @override
  String get tutorialToolsBody =>
      'Trabajá un pensamiento difícil con un registro de pensamiento (TCC), o abrí Respirar para un ejercicio guiado corto.';

  @override
  String get tutorialReviewTitle => 'Todo en un solo lugar';

  @override
  String get tutorialReviewBody =>
      '«Ver todo» en el inicio reúne todas tus notas. Configurá un PIN y exportá copias de seguridad desde Ajustes, y volvé a abrir esta guía desde ahí cuando quieras.';

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
  String get dashboardViewAll => 'Ver todo';

  @override
  String get allRecordsTitle => 'Todo';

  @override
  String get allRecordsEmpty => 'Todavía no escribiste nada';

  @override
  String get allRecordsKindThought => 'Registro de pensamiento';

  @override
  String get allRecordsKindMood => 'Nota del check-in';

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
  String get medicationsTitle => 'Medicación';

  @override
  String get dashboardMedications => 'Medicación';

  @override
  String get medicationsEmpty => 'No hay medicación registrada';

  @override
  String get newMedication => 'Nueva medicación';

  @override
  String get editMedication => 'Medicación';

  @override
  String get medicationName => 'Nombre';

  @override
  String get medicationDose => 'Dosis';

  @override
  String get medicationSchedule => 'Horario';

  @override
  String get medicationActive => 'Activa';

  @override
  String get medicationTake => 'Registrar toma';

  @override
  String get medicationSaved => 'Medicación guardada';

  @override
  String medicationTakenToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomas hoy',
      one: '1 toma hoy',
    );
    return '$_temp0';
  }

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
  String get checkInEditTitle => 'Editar check-in';

  @override
  String get tagsLabel => 'Etiquetas';

  @override
  String get tagsHint => 'Agregá una etiqueta';

  @override
  String get moodHistoryTitle => 'Historial de ánimo';

  @override
  String get moodHistoryEmpty => 'Todavía no hay check-ins';

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

  @override
  String get storageDegradedWarning =>
      'Este navegador guarda tus datos en un almacenamiento que puede perderse al recargar o al borrar los datos del navegador. Exportá una copia ahora.';

  @override
  String get storageVolatileWarning =>
      'Este navegador no puede guardar tus datos: todo lo que escribas se pierde al cerrar esta pestaña. Exportá una copia antes de irte.';

  @override
  String get storageExportNow => 'Exportar ahora';

  @override
  String get storageWarningDismiss => 'Ocultar';

  @override
  String get recoveryTitle => 'No se pudo abrir la base de datos local';

  @override
  String get recoveryBody =>
      'Los datos guardados en este dispositivo no se pudieron leer, así que la app no puede arrancar normalmente. Podés restaurar una copia de seguridad o empezar de cero con una base vacía.';

  @override
  String get recoveryImport => 'Importar una copia';

  @override
  String get recoveryReset => 'Restablecer la base de datos local';

  @override
  String get recoveryImportConfirmTitle => '¿Importar una copia?';

  @override
  String get recoveryImportConfirmBody =>
      'La base ilegible de este dispositivo se borra para siempre y queda lo que traiga el archivo de copia. No se puede deshacer.';

  @override
  String get recoveryImportFailed =>
      'No se pudo restaurar la copia. La base local quedó vacía; probá con otro archivo de copia.';

  @override
  String get recoveryResetConfirmTitle =>
      '¿Restablecer la base de datos local?';

  @override
  String get recoveryResetConfirmBody =>
      'Todo lo guardado en este dispositivo se borra para siempre y la app arranca vacía. No se puede deshacer.';

  @override
  String get recoveryResetConfirmAction => 'Restablecer';

  @override
  String get backupNoticeTitle => 'Tus datos viven solo en este dispositivo';

  @override
  String get backupNoticeOnboarding =>
      'No guardamos tus datos en nuestros servidores. Si desinstalás la app, perdés o reseteás el dispositivo o borrás los datos del navegador, se pierden. Exportá seguido desde Ajustes → Datos → Exportar copia y guardá el archivo en un lugar seguro.';

  @override
  String get backupNoticeAccept => 'Entendido, voy a hacer copias';

  @override
  String get backupNoticeSettings =>
      'Tus datos no se guardan en nuestros servidores. Exportá seguido y guardá el archivo fuera de este dispositivo.';

  @override
  String get backupReminderNever =>
      'Todavía no hiciste una copia de tus datos.';

  @override
  String backupReminderOverdue(int days) {
    return 'Tu última copia fue hace $days días.';
  }

  @override
  String get backupReminderAction => 'Exportar';

  @override
  String get backupReminderDismiss => 'Ahora no';

  @override
  String get eraseAllData => 'Borrar todos mis datos';

  @override
  String get eraseAllTitle => '¿Borrar todos tus datos?';

  @override
  String get eraseAllBody =>
      'Se borra todo lo registrado en este dispositivo, junto con tu PIN, tu perfil, tu plan de seguridad y tus ajustes; solo se conservan el idioma y la apariencia. Después la app vuelve a empezar desde la bienvenida. No se puede deshacer y no existe ninguna copia en otro lado: exportá antes si podrías querer algo de vuelta.';

  @override
  String get eraseAllConfirmWord => 'BORRAR';

  @override
  String eraseAllTypeToConfirm(String word) {
    return 'Escribí $word para confirmar';
  }

  @override
  String get eraseAllExportFirst => 'Exportar antes';

  @override
  String get eraseAllAction => 'Borrar todo';

  @override
  String get disclaimerAcceptTitle => 'Antes de empezar';

  @override
  String get disclaimerAcceptBody =>
      'Alveo es una herramienta personal, no un dispositivo médico. No diagnostica ni trata, y no reemplaza la atención profesional. En una emergencia, llamá al 911.';

  @override
  String get disclaimerAcceptAction => 'Entiendo';

  @override
  String get crisisTitle => 'Si estás en crisis';

  @override
  String get crisisIntro =>
      'No tenés que atravesarlo sin ayuda. En Argentina, el Centro de Asistencia al Suicida atiende estas líneas:';

  @override
  String get crisisLine135 => 'Línea 135 (gratuita desde CABA y GBA)';

  @override
  String get crisisLineNational => '(011) 5275-1135 (desde todo el país)';

  @override
  String get crisisEmergency => '911 — emergencias';

  @override
  String get crisisCallError =>
      'No se pudo iniciar la llamada. Marcá el número vos.';

  @override
  String get sensitiveExportTitle => 'Guardá este archivo en privado';

  @override
  String get sensitiveExportBody =>
      'Este archivo contiene tus notas de terapia sin cifrar. Guardalo en un lugar privado.';

  @override
  String get sensitiveExportMute => 'No volver a mostrar en esta sesión';

  @override
  String get sensitiveExportContinue => 'Continuar';

  @override
  String get pinWebCaveat =>
      'En la versión web, el PIN disuade el acceso casual pero no protege frente a alguien con acceso a este navegador o dispositivo.';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfUse => 'Términos de uso';

  @override
  String get developerContact => 'Desarrollador y contacto';

  @override
  String get openSourceLicenses => 'Licencias';

  @override
  String get profileSection => 'Perfil';

  @override
  String get securitySection => 'Seguridad';

  @override
  String get aboutSection => 'Acerca de';
}
