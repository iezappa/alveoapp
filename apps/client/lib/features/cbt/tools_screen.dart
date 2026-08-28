import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../shared/confirm_delete.dart';
import '../shared/master_detail_shell.dart';
import 'thought_record_editor_screen.dart';
import 'thought_record_preview.dart';
import 'thought_record_providers.dart';

/// The CBT tools section. For now it holds the thought-record log as a
/// master-detail screen; more tools slot in beside it later.
class ToolsScreen extends ConsumerStatefulWidget {
  const ToolsScreen({super.key});

  @override
  ConsumerState<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends ConsumerState<ToolsScreen> {
  final _search = TextEditingController();
  String? _selectedId;
  bool _creating = false;
  bool _editingSelected = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(String id) {
    if (MasterDetailShell.isWide(context)) {
      setState(() {
        _selectedId = id;
        _creating = false;
        _editingSelected = false;
      });
    } else {
      context.push('/thought-records/$id');
    }
  }

  void _add() {
    if (MasterDetailShell.isWide(context)) {
      setState(() {
        _creating = true;
        _editingSelected = false;
      });
    } else {
      context.push('/thought-records/new');
    }
  }

  void _exitEditor() {
    if (mounted) {
      setState(() {
        _creating = false;
        _editingSelected = false;
      });
    }
  }

  Future<void> _delete(String id) async {
    if (!await confirmDelete(context)) return;
    await ref.read(thoughtRecordRepositoryProvider).delete(id);
    ref.invalidate(thoughtRecordListProvider);
    if (mounted) setState(() => _selectedId = null);
  }

  List<ThoughtRecord> _filter(List<ThoughtRecord> all) {
    final query = _search.text.trim().toLowerCase();
    if (query.isEmpty) return all;
    return all
        .where(
          (r) =>
              r.situation.toLowerCase().contains(query) ||
              r.automaticThought.toLowerCase().contains(query) ||
              (r.alternativeThought ?? '').toLowerCase().contains(query),
        )
        .toList();
  }

  Widget _buildDetail(AppLocalizations l10n) {
    if (_creating) {
      return ThoughtRecordEditorScreen(
        key: const ValueKey('tr-editor-new'),
        onDone: _exitEditor,
      );
    }
    if (_editingSelected && _selectedId != null) {
      return ThoughtRecordEditorScreen(
        key: ValueKey('tr-editor-$_selectedId'),
        recordId: _selectedId,
        onDone: _exitEditor,
      );
    }
    if (_selectedId != null) {
      return ThoughtRecordPreview(
        key: ValueKey(_selectedId),
        recordId: _selectedId!,
        onEdit: () => setState(() => _editingSelected = true),
        onDelete: () => _delete(_selectedId!),
      );
    }
    return EmptyState(
      icon: Icons.chevron_left,
      message: l10n.detailNothingSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MasterDetailShell.isWide(context);
    final records = ref.watch(thoughtRecordListProvider);

    final list = RecordListPane(
      searchController: _search,
      onSearchChanged: (_) => setState(() {}),
      searchHint: l10n.thoughtRecordsSearchHint,
      addTooltip: l10n.newThoughtRecord,
      onAdd: _add,
      child: records.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) {
          final items = _filter(all);
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.lightbulb_outline,
              message: l10n.thoughtRecordsEmpty,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 2),
            itemBuilder: (context, i) => _tile(items[i], wide),
          );
        },
      ),
    );

    return MasterDetailShell(
      title: l10n.navTools,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push('/settings'),
          tooltip: l10n.navSettings,
        ),
        const SizedBox(width: 4),
      ],
      list: list,
      detail: _buildDetail(l10n),
    );
  }

  Widget _tile(ThoughtRecord record, bool wide) {
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();

    return ListTile(
      selected: wide && record.id == _selectedId,
      selectedTileColor: scheme.secondaryContainer.withValues(alpha: 0.5),
      leading: CircleAvatar(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        child: const Icon(Icons.lightbulb_outline, size: 20),
      ),
      title: Text(
        record.situation,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${DateFormat.yMMMd(locale).format(record.occurredAt)}  ·  '
        '${record.automaticThought}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _open(record.id),
    );
  }
}
