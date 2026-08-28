import 'package:drift/drift.dart';

import '../../domain/cbt/cognitive_distortion.dart';
import '../../domain/journal/journal_section.dart';
import '../../domain/links/link_target_type.dart';

export '../../domain/cbt/cognitive_distortion.dart';
export '../../domain/journal/journal_section.dart';
export '../../domain/links/link_target_type.dart';

/// Lifecycle of a task assigned by the therapist.
///
/// Stored by index via [intEnum]. APPEND-ONLY: never reorder or remove
/// existing values, or previously stored rows will decode to the wrong status.
enum TaskStatus { pending, inProgress, done, skipped }

/// Emotional check-in. One row per moment the user logs a feeling.
///
/// [mood] is a 1..5 overall scale. The range is validated in the domain
/// layer, not as a DB CHECK constraint: validation belongs with business
/// rules, and SQLite would only enforce it weakly anyway.
class MoodEntries extends Table {
  TextColumn get id => text()();

  /// When the feeling happened. May be backdated by the user.
  DateTimeColumn get occurredAt => dateTime()();

  IntColumn get mood => integer()();

  /// Short plain-text note. NOT markdown — the markdown surface is
  /// [JournalEntries]. Keeping them separate avoids mixing a quick tag-along
  /// note with a full journal document.
  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Emotions attached to a [MoodEntries] row, each with its own intensity.
///
/// [emotionKey] references a Plutchik catalog defined in Dart code, not a DB
/// table: the catalog is static, so a table would only add migrations for no
/// gain.
class MoodEntryEmotions extends Table {
  TextColumn get moodEntryId =>
      text().references(MoodEntries, #id, onDelete: KeyAction.cascade)();

  TextColumn get emotionKey => text()();

  /// 1..5. Validated in the domain layer (see [MoodEntries.mood]).
  IntColumn get intensity => integer()();

  @override
  Set<Column> get primaryKey => {moodEntryId, emotionKey};
}

/// A journal entry written in Markdown. [bodyMarkdown] is the source of truth
/// and is what the per-day `.md` export writes out verbatim.
class JournalEntries extends Table {
  TextColumn get id => text()();

  /// The day this entry belongs to (stored at local midnight). Separate from
  /// [createdAt] so an entry written after midnight can still be filed under
  /// the previous day for the daily export.
  DateTimeColumn get entryDate => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  TextColumn get title => text().nullable()();
  TextColumn get bodyMarkdown => text()();

  /// Which notebook this entry belongs to.
  IntColumn get section => intEnum<JournalSection>().withDefault(
    Constant(JournalSection.oneLiner.index),
  )();

  /// True for the monthly-review entry of the "Diario" section (its
  /// [entryDate] is the first day of the month it reviews).
  BoolColumn get isMonthlyReview =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Emotions attached to a [JournalEntries] row, each with its own intensity.
///
/// Mirrors [MoodEntryEmotions]: [emotionKey] references the Plutchik catalog
/// defined in Dart, not a DB table.
class JournalEntryEmotions extends Table {
  TextColumn get journalEntryId =>
      text().references(JournalEntries, #id, onDelete: KeyAction.cascade)();

  TextColumn get emotionKey => text()();

  /// 1..5. Validated in the domain layer.
  IntColumn get intensity => integer()();

  @override
  Set<Column> get primaryKey => {journalEntryId, emotionKey};
}

/// A task assigned by the therapist.
class Tasks extends Table {
  TextColumn get id => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  TextColumn get title => text()();
  TextColumn get descriptionMarkdown => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();

  IntColumn get status => intEnum<TaskStatus>()();

  DateTimeColumn get completedAt => dateTime().nullable()();

  /// How the task went — filled in when the user closes it.
  TextColumn get closingNote => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A CBT thought record: the chain from a situation to a reframed thought.
///
/// The emotion is captured locally as free text plus a 0..10 intensity (not
/// linked to the Plutchik model). Belief ratings are 0..100 percent.
class ThoughtRecords extends Table {
  TextColumn get id => text()();

  /// When the situation happened. May be backdated.
  DateTimeColumn get occurredAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  TextColumn get situation => text()();
  TextColumn get automaticThought => text()();

  /// 0..100 — how much the automatic thought was believed at the time.
  IntColumn get beliefBefore => integer().nullable()();

  TextColumn get emotionLabel => text().nullable()();

  /// 0..10.
  IntColumn get emotionIntensityBefore => integer().nullable()();

  TextColumn get alternativeThought => text().nullable()();

  /// 0..100 — belief in the automatic thought after the reframe.
  IntColumn get beliefAfter => integer().nullable()();

  /// 0..10.
  IntColumn get emotionIntensityAfter => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Distortions tagged on a [ThoughtRecords] row.
class ThoughtRecordDistortions extends Table {
  TextColumn get recordId =>
      text().references(ThoughtRecords, #id, onDelete: KeyAction.cascade)();

  IntColumn get distortion => intEnum<CognitiveDistortion>()();

  @override
  Set<Column> get primaryKey => {recordId, distortion};
}

/// A medication the user is tracking.
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get dose => text().nullable()();

  /// Free-text schedule reminder, e.g. "morning + night".
  TextColumn get scheduleNote => text().nullable()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// One recorded intake of a [Medications] row.
class MedicationLogs extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get takenAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Context labels (people, places, situations) shared across entities.
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();

  @override
  Set<Column> get primaryKey => {id};
}

class MoodEntryTags extends Table {
  TextColumn get moodEntryId =>
      text().references(MoodEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {moodEntryId, tagId};
}

class JournalEntryTags extends Table {
  TextColumn get journalEntryId =>
      text().references(JournalEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {journalEntryId, tagId};
}

/// Small key/value store for app-level preferences (UI language, and later
/// things like the export folder or lock settings). Deliberately generic so
/// each new preference is a row, not a migration.
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// A therapy session: the agenda prepared beforehand, notes taken during, and
/// the takeaways drawn afterward. All three bodies are Markdown.
class Sessions extends Table {
  TextColumn get id => text()();

  /// When the session takes (or took) place.
  DateTimeColumn get scheduledFor => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  TextColumn get agendaMarkdown => text().nullable()();
  TextColumn get notesMarkdown => text().nullable()();
  TextColumn get takeawaysMarkdown => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Associates a session with another record (a task, journal entry, or mood
/// entry). [targetId] is polymorphic so it carries no foreign key; dangling
/// rows are dropped on read and cleaned up when the target is deleted.
class SessionLinks extends Table {
  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();

  IntColumn get targetType => intEnum<LinkTargetType>()();

  TextColumn get targetId => text()();

  @override
  Set<Column> get primaryKey => {sessionId, targetType, targetId};
}
