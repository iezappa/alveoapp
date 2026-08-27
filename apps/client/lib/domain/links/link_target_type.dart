/// The kinds of record a session can be linked to.
///
/// Stored by index via Drift's `intEnum`. APPEND-ONLY: never reorder or
/// remove values.
enum LinkTargetType { task, journal, mood }
