import 'package:flutter/material.dart';

/// A responsive master-detail scaffold for the content sections.
///
/// Wide windows show the [list] pane beside a [detail] pane. Narrow windows
/// show only the list; opening a record is the caller's job (typically a push
/// to the record's editor route).
class MasterDetailShell extends StatelessWidget {
  const MasterDetailShell({
    super.key,
    required this.title,
    required this.list,
    required this.detail,
    this.actions = const [],
  });

  final String title;

  /// The left pane: its own search field, filters, "+" button and record list.
  final Widget list;

  /// The right pane, shown only on wide windows.
  final Widget detail;

  final List<Widget> actions;

  static const _twoPaneBreakpoint = 840.0;
  static const _listPaneWidth = 340.0;

  /// Whether the current window is wide enough for the two-pane layout.
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= _twoPaneBreakpoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: isWide(context)
          ? Row(
              children: [
                SizedBox(width: _listPaneWidth, child: list),
                const VerticalDivider(width: 1),
                Expanded(child: detail),
              ],
            )
          : list,
    );
  }
}

/// The left pane content shared by every section: a search field and "+" button
/// on top, optional filter chips, then the scrollable record list.
class RecordListPane extends StatelessWidget {
  const RecordListPane({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.searchHint,
    required this.onAdd,
    required this.addTooltip,
    required this.child,
    this.filters = const [],
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String searchHint;
  final VoidCallback onAdd;
  final String addTooltip;

  /// Filter chips shown in a horizontal strip below the search field.
  final List<Widget> filters;

  /// The scrollable list of records.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: searchHint,
                    isDense: true,
                    prefixIcon: const Icon(Icons.search, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton.filledTonal(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                tooltip: addTooltip,
              ),
            ],
          ),
        ),
        if (filters.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  for (final chip in filters)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: chip,
                    ),
                ],
              ),
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}
