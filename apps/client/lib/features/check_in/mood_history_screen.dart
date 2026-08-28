import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import 'mood_weather.dart';

/// A reverse-chronological list of every mood check-in; tapping one opens it
/// for editing.
class MoodHistoryScreen extends ConsumerWidget {
  const MoodHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final entries = ref.watch(moodEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moodHistoryTitle)),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_outline,
              message: l10n.moodHistoryEmpty,
            );
          }
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: kGutter,
                  vertical: 8,
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 2),
                itemBuilder: (context, i) {
                  final e = items[i];
                  final note = (e.note ?? '').trim();
                  return ListTile(
                    leading: Text(
                      moodWeather[e.mood - 1],
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(
                      DateFormat.yMMMEd(locale).add_jm().format(e.occurredAt),
                    ),
                    subtitle: note.isEmpty
                        ? null
                        : Text(
                            note,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () => context.push('/check-in/${e.id}'),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
