import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/providers.dart';
import '../../domain/links/link_target_type.dart';
import '../../domain/links/linked_item.dart';
import '../../l10n/app_localizations.dart';
import 'link_providers.dart';

IconData _iconFor(LinkTargetType type) => switch (type) {
      LinkTargetType.task => Icons.checklist_outlined,
      LinkTargetType.journal => Icons.notes_outlined,
      LinkTargetType.mood => Icons.favorite_outline,
    };

String _labelFor(AppLocalizations l10n, LinkedItem item) {
  final title = item.title?.trim();
  if (title != null && title.isNotEmpty) return title;
  return switch (item.type) {
    LinkTargetType.journal => l10n.journalUntitled,
    LinkTargetType.mood => l10n.linkMoodLabel,
    LinkTargetType.task => l10n.newTask,
  };
}

/// The "Links" tab of the session editor: shows records tied to this session
/// and lets the user attach or detach more.
class SessionLinksTab extends ConsumerWidget {
  const SessionLinksTab({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final linked = ref.watch(sessionLinkedItemsProvider(sessionId));

    void refresh() {
      ref.invalidate(sessionLinkedItemsProvider(sessionId));
      ref.invalidate(sessionLinkableItemsProvider(sessionId));
    }

    return Scaffold(
      body: linked.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.linkEmpty));
          }
          return ListView(
            children: [
              for (final item in items)
                ListTile(
                  leading: Icon(_iconFor(item.type)),
                  title: Text(_labelFor(l10n, item)),
                  subtitle: Text(DateFormat.yMMMd(locale).format(item.when)),
                  trailing: IconButton(
                    icon: const Icon(Icons.link_off),
                    tooltip: l10n.linkRemove,
                    onPressed: () async {
                      await ref
                          .read(linkRepositoryProvider)
                          .unlink(sessionId, item.type, item.id);
                      refresh();
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickAndLink(context, ref, l10n, locale, refresh),
        icon: const Icon(Icons.add_link),
        label: Text(l10n.linkAdd),
      ),
    );
  }

  Future<void> _pickAndLink(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String locale,
    VoidCallback refresh,
  ) async {
    final candidates =
        await ref.read(linkRepositoryProvider).linkableItems(sessionId);
    if (!context.mounted) return;

    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.linkNothingToLink)));
      return;
    }

    final selected = await showModalBottomSheet<LinkedItem>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final item in candidates)
              ListTile(
                leading: Icon(_iconFor(item.type)),
                title: Text(_labelFor(l10n, item)),
                subtitle: Text(DateFormat.yMMMd(locale).format(item.when)),
                onTap: () => Navigator.pop(context, item),
              ),
          ],
        ),
      ),
    );

    if (selected == null) return;
    await ref
        .read(linkRepositoryProvider)
        .link(sessionId, selected.type, selected.id);
    refresh();
  }
}
