/// The repository interfaces the app talks to.
///
/// `presentation` and the providers depend on these, never on the Drift
/// implementations in `data/repositories/`: swapping local-first storage for
/// a synced one is then a new implementation and one provider, not a rewrite
/// of the screens (§1.1).
///
/// One compromise is deliberate and worth naming: the row classes Drift
/// generates (`JournalEntry`, `MoodEntry`, `Task`, …) are used as the domain
/// entities, so these interfaces import `data/local/database.dart`. They are
/// plain immutable data classes and nothing in a screen touches Drift itself
/// — a test fails if it ever does. Giving the domain its own entities plus a
/// mapping layer is the next step, and is only worth paying for when a
/// second data source exists.
library;

export 'journal_repository.dart';
export 'link_repository.dart';
export 'medication_repository.dart';
export 'mood_repository.dart';
export 'safety_plan_repository.dart';
export 'session_repository.dart';
export 'settings_repository.dart';
export 'tag_repository.dart';
export 'task_repository.dart';
export 'thought_record_repository.dart';
