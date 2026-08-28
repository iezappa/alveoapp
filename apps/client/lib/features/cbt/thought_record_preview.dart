import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../l10n/app_localizations.dart';
import 'cbt_labels.dart';
import 'thought_record_providers.dart';

/// Read-only view of one thought record for the detail pane.
class ThoughtRecordPreview extends ConsumerWidget {
  const ThoughtRecordPreview({
    super.key,
    required this.recordId,
    required this.onEdit,
    required this.onDelete,
  });

  final String recordId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final record = ref.watch(thoughtRecordByIdProvider(recordId));
    final distortions =
        ref.watch(thoughtRecordDistortionsProvider(recordId)).asData?.value ??
        const {};

    if (record == null) {
      return EmptyState(
        icon: Icons.chevron_left,
        message: l10n.detailNothingSelected,
      );
    }

    String belief(int? before, int? after) {
      if (before == null && after == null) return '';
      return '${before ?? '–'}% → ${after ?? '–'}%';
    }

    String intensity(int? before, int? after) {
      if (before == null && after == null) return '';
      return '${before ?? '–'} → ${after ?? '–'} / 10';
    }

    Widget block(String label, String value) => value.trim().isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(label),
                const SizedBox(height: 6),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat.yMMMMEEEEd(locale).format(record.occurredAt),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(l10n.editAction),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                tooltip: l10n.deleteAction,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            children: [
              block(l10n.trSituation, record.situation),
              block(l10n.trAutomaticThought, record.automaticThought),
              block(l10n.trBeliefBefore, belief(record.beliefBefore, null)),
              block(
                l10n.trEmotion,
                [
                  record.emotionLabel ?? '',
                  intensity(
                    record.emotionIntensityBefore,
                    record.emotionIntensityAfter,
                  ),
                ].where((s) => s.trim().isNotEmpty).join('  ·  '),
              ),
              if (distortions.isNotEmpty) ...[
                SectionLabel(l10n.trDistortions),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final d in distortions)
                      Chip(
                        label: Text(d.label(l10n)),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
              block(
                l10n.trAlternativeThought,
                record.alternativeThought ?? '',
              ),
              block(
                l10n.trBeliefAfter,
                belief(record.beliefBefore, record.beliefAfter),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
