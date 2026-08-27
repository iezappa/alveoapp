import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../data/providers.dart';
import '../../domain/search/search_hit.dart';
import '../../l10n/app_localizations.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _types = <SearchType>{};
  Timer? _debounce;
  List<SearchHit> _results = const [];
  bool _searched = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String _) {
    setState(() {}); // keep the clear button in sync
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _run);
  }

  Future<void> _run() async {
    final results = await ref
        .read(searchServiceProvider)
        .search(_controller.text, _types);
    if (!mounted) return;
    setState(() {
      _results = results;
      _searched = _controller.text.trim().length >= 2;
    });
  }

  void _toggleType(SearchType type) {
    setState(() {
      _types.contains(type) ? _types.remove(type) : _types.add(type);
    });
    _run();
  }

  String _typeLabel(AppLocalizations l10n, SearchType type) => switch (type) {
    SearchType.mood => l10n.searchTypeMood,
    SearchType.journal => l10n.searchTypeJournal,
    SearchType.task => l10n.searchTypeTask,
    SearchType.session => l10n.searchTypeSession,
  };

  IconData _typeIcon(SearchType type) => switch (type) {
    SearchType.mood => Icons.favorite_outline,
    SearchType.journal => Icons.notes_outlined,
    SearchType.task => Icons.checklist_outlined,
    SearchType.session => Icons.psychology_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            filled: false,
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _run();
              },
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: kGutter),
                child: Row(
                  children: [
                    for (final type in SearchType.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_typeLabel(l10n, type)),
                          selected: _types.contains(type),
                          onSelected: (_) => _toggleType(type),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: !_searched
                    ? EmptyState(
                        icon: Icons.search,
                        message: l10n.searchStartTyping,
                      )
                    : _results.isEmpty
                    ? EmptyState(
                        icon: Icons.search_off,
                        message: l10n.searchNoResults,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kGutter,
                          vertical: 8,
                        ),
                        itemCount: _results.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 2),
                        itemBuilder: (context, i) {
                          final hit = _results[i];
                          return ListTile(
                            leading: Icon(_typeIcon(hit.type)),
                            title: Text(
                              hit.title.isEmpty
                                  ? _typeLabel(l10n, hit.type)
                                  : hit.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '${DateFormat.yMMMd(locale).format(hit.when)}'
                              '${hit.snippet.isEmpty ? '' : '  ·  ${hit.snippet}'}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => context.push(hit.route),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
