import 'link_target_type.dart';

/// A record that is (or could be) linked to a session, resolved against the
/// live row so callers never see a dangling reference.
class LinkedItem {
  const LinkedItem({
    required this.type,
    required this.id,
    required this.when,
    this.title,
  });

  final LinkTargetType type;
  final String id;
  final DateTime when;

  /// Best-effort human title (a task's or journal entry's title). Null for
  /// mood entries and untitled journal entries — the UI supplies a fallback.
  final String? title;
}
