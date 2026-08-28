import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../data/local/database.dart';
import '../../l10n/app_localizations.dart';
import '../shared/master_detail_shell.dart';
import 'session_preview.dart';
import 'session_providers.dart';

/// Sessions as a master-detail screen: the list of sessions on the left, a
/// read-only preview of the selected one on the right (wide windows only).
class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen> {
  final _search = TextEditingController();
  String? _selectedId;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(String id) {
    if (MasterDetailShell.isWide(context)) {
      setState(() => _selectedId = id);
    } else {
      context.push('/sessions/$id');
    }
  }

  List<Session> _filter(List<Session> all) {
    final query = _search.text.trim().toLowerCase();
    if (query.isEmpty) return all;
    bool has(String? s) => (s ?? '').toLowerCase().contains(query);
    return all
        .where(
          (s) =>
              has(s.agendaMarkdown) ||
              has(s.notesMarkdown) ||
              has(s.takeawaysMarkdown),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MasterDetailShell.isWide(context);
    final sessions = ref.watch(sessionListProvider);

    final list = RecordListPane(
      searchController: _search,
      onSearchChanged: (_) => setState(() {}),
      searchHint: l10n.sessionsSearchHint,
      addTooltip: l10n.newSession,
      onAdd: () => context.push('/sessions/new'),
      child: sessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) {
          final items = _filter(all);
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.psychology_outlined,
              message: l10n.sessionsEmpty,
            );
          }
          final now = DateTime.now();
          final upcoming = items
              .where((s) => !s.scheduledFor.isBefore(now))
              .toList();
          final past =
              items.where((s) => s.scheduledFor.isBefore(now)).toList()
                ..sort((a, b) => b.scheduledFor.compareTo(a.scheduledFor));

          return ListView(
            padding: const EdgeInsets.only(bottom: 12),
            children: [
              ..._group(l10n.sessionsUpcoming, upcoming, wide),
              ..._group(l10n.sessionsPast, past, wide),
            ],
          );
        },
      ),
    );

    final detail = _selectedId == null
        ? EmptyState(
            icon: Icons.chevron_left,
            message: l10n.detailNothingSelected,
          )
        : SessionPreview(
            key: ValueKey(_selectedId),
            sessionId: _selectedId!,
            onEdit: () => context.push('/sessions/$_selectedId'),
          );

    return MasterDetailShell(
      title: l10n.navSessions,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push('/settings'),
          tooltip: l10n.navSettings,
        ),
        const SizedBox(width: 4),
      ],
      list: list,
      detail: detail,
    );
  }

  List<Widget> _group(String label, List<Session> rows, bool wide) {
    if (rows.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: SectionLabel(label),
      ),
      for (final session in rows) _tile(session, wide),
    ];
  }

  Widget _tile(Session session, bool wide) {
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final day = DateFormat.yMMMEd(locale).format(session.scheduledFor);
    final time = DateFormat.jm(locale).format(session.scheduledFor);
    final agenda = session.agendaMarkdown?.trim() ?? '';

    return ListTile(
      selected: wide && session.id == _selectedId,
      selectedTileColor: scheme.secondaryContainer.withValues(alpha: 0.5),
      leading: CircleAvatar(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        child: const Icon(Icons.psychology_outlined, size: 20),
      ),
      title: Text(day, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        agenda.isEmpty ? time : '$time  ·  $agenda',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _open(session.id),
    );
  }
}
