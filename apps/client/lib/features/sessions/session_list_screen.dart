import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
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
      appBar: AppBar(
        title: Text(l10n.navSessions),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: l10n.navSettings,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: sessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
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
          final past = items.where((s) => s.scheduledFor.isBefore(now)).toList()
            ..sort((a, b) => b.scheduledFor.compareTo(a.scheduledFor));

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(sessionListProvider),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    kGutter,
                    kGutter,
                    kGutter,
                    8,
                  ),
                  children: [
                    if (upcoming.isNotEmpty) ...[
                      SectionLabel(l10n.sessionsUpcoming),
                      ...upcoming.map((s) => _SessionTile(session: s)),
                    ],
                    if (past.isNotEmpty) ...[
                      if (upcoming.isNotEmpty) const SizedBox(height: 20),
                      SectionLabel(l10n.sessionsPast),
                      ...past.map((s) => _SessionTile(session: s)),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => context.push('/sessions/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.newSession),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final day = DateFormat.yMMMMEEEEd(locale).format(session.scheduledFor);
    final time = DateFormat.jm(locale).format(session.scheduledFor);
    final agenda = session.agendaMarkdown?.trim();

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        child: const Icon(Icons.psychology_outlined, size: 20),
      ),
      title: Text(day, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        agenda == null || agenda.isEmpty ? time : '$time  ·  $agenda',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => context.push('/sessions/${session.id}'),
    );
  }
}
