import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/local/database.dart';
import '../../l10n/app_localizations.dart';
import 'session_providers.dart';

class SessionListScreen extends ConsumerWidget {
  const SessionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sessions = ref.watch(sessionListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSessions)),
      body: sessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.sessionsEmpty));
          }

          final now = DateTime.now();
          final upcoming = items
              .where((s) => !s.scheduledFor.isBefore(now))
              .toList();
          final past = items.where((s) => s.scheduledFor.isBefore(now)).toList()
            ..sort((a, b) => b.scheduledFor.compareTo(a.scheduledFor));

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(sessionListProvider),
            child: ListView(
              children: [
                if (upcoming.isNotEmpty)
                  _SectionHeader(label: l10n.sessionsUpcoming),
                ...upcoming.map((s) => _SessionTile(session: s)),
                if (past.isNotEmpty) _SectionHeader(label: l10n.sessionsPast),
                ...past.map((s) => _SessionTile(session: s)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/sessions/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.newSession),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final when = DateFormat.yMMMMEEEEd(locale)
        .add_jm()
        .format(session.scheduledFor);
    final agenda = session.agendaMarkdown?.trim();

    return ListTile(
      leading: const Icon(Icons.psychology_outlined),
      title: Text(when),
      subtitle: agenda == null || agenda.isEmpty
          ? null
          : Text(agenda, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: () => context.push('/sessions/${session.id}'),
    );
  }
}
