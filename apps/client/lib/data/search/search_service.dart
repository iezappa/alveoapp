import 'package:drift/drift.dart';

import '../../domain/search/search_hit.dart';
import '../local/database.dart';

/// Free-text search across journal entries, sessions, tasks and mood notes.
class SearchService {
  SearchService(this._db);

  final AppDatabase _db;

  static const minQueryLength = 2;

  /// Returns matches for [rawQuery], newest first. An empty [types] means
  /// "search everything".
  Future<List<SearchHit>> search(String rawQuery, Set<SearchType> types) async {
    final q = rawQuery.trim().toLowerCase();
    if (q.length < minQueryLength) return const [];
    final like = '%$q%';
    bool wants(SearchType t) => types.isEmpty || types.contains(t);

    final hits = <SearchHit>[];

    if (wants(SearchType.journal)) {
      final rows =
          await (_db.select(_db.journalEntries)..where(
                (t) =>
                    t.title.lower().like(like) |
                    t.bodyMarkdown.lower().like(like),
              ))
              .get();
      hits.addAll(
        rows.map(
          (e) => SearchHit(
            type: SearchType.journal,
            id: e.id,
            title: e.title?.trim().isNotEmpty ?? false
                ? e.title!.trim()
                : _firstLine(e.bodyMarkdown),
            snippet: _excerpt(e.bodyMarkdown, q),
            when: e.entryDate,
            route: '/journal/${e.id}',
          ),
        ),
      );
    }

    if (wants(SearchType.session)) {
      final rows =
          await (_db.select(_db.sessions)..where(
                (t) =>
                    t.agendaMarkdown.lower().like(like) |
                    t.notesMarkdown.lower().like(like) |
                    t.takeawaysMarkdown.lower().like(like),
              ))
              .get();
      hits.addAll(
        rows.map(
          (s) => SearchHit(
            type: SearchType.session,
            id: s.id,
            title: _firstLine(
              s.agendaMarkdown ?? s.notesMarkdown ?? s.takeawaysMarkdown ?? '',
            ),
            snippet: _excerpt(
              [
                s.agendaMarkdown,
                s.notesMarkdown,
                s.takeawaysMarkdown,
              ].whereType<String>().join('\n'),
              q,
            ),
            when: s.scheduledFor,
            route: '/sessions/${s.id}',
          ),
        ),
      );
    }

    if (wants(SearchType.task)) {
      final rows =
          await (_db.select(_db.tasks)..where(
                (t) =>
                    t.title.lower().like(like) |
                    t.descriptionMarkdown.lower().like(like) |
                    t.closingNote.lower().like(like),
              ))
              .get();
      hits.addAll(
        rows.map(
          (t) => SearchHit(
            type: SearchType.task,
            id: t.id,
            title: t.title,
            snippet: _excerpt(
              [
                t.descriptionMarkdown,
                t.closingNote,
              ].whereType<String>().join('\n'),
              q,
            ),
            when: t.createdAt,
            route: '/tasks/${t.id}',
          ),
        ),
      );
    }

    if (wants(SearchType.mood)) {
      final rows = await (_db.select(
        _db.moodEntries,
      )..where((t) => t.note.lower().like(like))).get();
      hits.addAll(
        rows.map(
          (m) => SearchHit(
            type: SearchType.mood,
            id: m.id,
            title: m.note?.trim() ?? '',
            snippet: _excerpt(m.note ?? '', q),
            when: m.occurredAt,
            route: '/dashboard',
          ),
        ),
      );
    }

    hits.sort((a, b) => b.when.compareTo(a.when));
    return hits;
  }

  String _firstLine(String text) {
    final line = text.trim().split('\n').first.trim();
    return line.replaceFirst(RegExp(r'^#+\s*'), '');
  }

  String _excerpt(String text, String needle) {
    final flat = text.replaceAll('\n', ' ').trim();
    final at = flat.toLowerCase().indexOf(needle);
    if (at < 0) return flat.length <= 100 ? flat : '${flat.substring(0, 100)}…';
    final start = (at - 40).clamp(0, flat.length);
    final end = (at + needle.length + 60).clamp(0, flat.length);
    final prefix = start > 0 ? '…' : '';
    final suffix = end < flat.length ? '…' : '';
    return '$prefix${flat.substring(start, end)}$suffix';
  }
}
