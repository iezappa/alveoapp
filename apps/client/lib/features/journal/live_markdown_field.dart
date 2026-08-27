import 'package:flutter/material.dart';

/// A [TextEditingController] that styles Markdown syntax inline as the user
/// types — headings, bold, italic, code, strikethrough, quotes and list
/// markers. The raw syntax stays visible (dimmed); this is a lightweight
/// "live preview", not a WYSIWYG that hides the markup.
class MarkdownStylingController extends TextEditingController {
  MarkdownStylingController({super.text});

  static final _inline = RegExp(
    r'(\*\*|__)(.+?)\1' // 1 delim, 2 bold
    r'|(\*|_)(?!\s)(.+?)(?<!\s)\3' // 3 delim, 4 italic
    r'|(`)([^`]+?)`' // 5 delim, 6 code
    r'|(~~)(.+?)~~' // 7 delim, 8 strike
    r'|\[([^\]]+)\]\(([^)]+)\)', // 9 link text, 10 url
  );

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final base = style ?? const TextStyle();
    final scheme = Theme.of(context).colorScheme;
    final dim = base.copyWith(
      color: scheme.onSurfaceVariant.withValues(alpha: 0.55),
    );

    final children = <InlineSpan>[];
    final lines = text.split('\n');
    for (var i = 0; i < lines.length; i++) {
      children.addAll(_line(lines[i], base, dim, scheme));
      if (i != lines.length - 1) {
        children.add(TextSpan(text: '\n', style: base));
      }
    }
    return TextSpan(style: base, children: children);
  }

  List<InlineSpan> _line(
    String line,
    TextStyle base,
    TextStyle dim,
    ColorScheme scheme,
  ) {
    // Heading: leading #'s
    final heading = RegExp(r'^(#{1,6})(\s+)(.*)$').firstMatch(line);
    if (heading != null) {
      final level = heading.group(1)!.length;
      final scale = switch (level) {
        1 => 1.6,
        2 => 1.35,
        3 => 1.18,
        _ => 1.08,
      };
      final headStyle = base.copyWith(
        fontSize: (base.fontSize ?? 16) * scale,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );
      return [
        TextSpan(text: heading.group(1)! + heading.group(2)!, style: dim),
        ..._inlineSpans(heading.group(3)!, headStyle, dim, scheme),
      ];
    }

    // Blockquote
    final quote = RegExp(r'^(>\s?)(.*)$').firstMatch(line);
    if (quote != null) {
      final qStyle = base.copyWith(
        fontStyle: FontStyle.italic,
        color: scheme.onSurfaceVariant,
      );
      return [
        TextSpan(text: quote.group(1), style: dim),
        ..._inlineSpans(quote.group(2)!, qStyle, dim, scheme),
      ];
    }

    // List item, optionally a checkbox
    final li = RegExp(r'^(\s*)([-*+]|\d+\.)(\s+)(\[[ xX]\]\s+)?(.*)$')
        .firstMatch(line);
    if (li != null) {
      final markerStyle = base.copyWith(
        color: scheme.primary,
        fontWeight: FontWeight.w600,
      );
      final box = li.group(4);
      final checked = box != null && box.toLowerCase().contains('x');
      return [
        TextSpan(text: li.group(1)),
        TextSpan(text: li.group(2)! + li.group(3)!, style: markerStyle),
        if (box != null)
          TextSpan(
            text: box,
            style: markerStyle.copyWith(
              color: checked ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
        ..._inlineSpans(
          li.group(5)!,
          checked
              ? base.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: scheme.onSurfaceVariant,
                )
              : base,
          dim,
          scheme,
        ),
      ];
    }

    return _inlineSpans(line, base, dim, scheme);
  }

  List<InlineSpan> _inlineSpans(
    String text,
    TextStyle base,
    TextStyle dim,
    ColorScheme scheme,
  ) {
    final spans = <InlineSpan>[];
    var index = 0;
    for (final m in _inline.allMatches(text)) {
      if (m.start > index) {
        spans.add(TextSpan(text: text.substring(index, m.start), style: base));
      }
      if (m.group(2) != null) {
        final d = m.group(1)!;
        spans
          ..add(TextSpan(text: d, style: dim))
          ..add(
            TextSpan(
              text: m.group(2),
              style: base.copyWith(fontWeight: FontWeight.w700),
            ),
          )
          ..add(TextSpan(text: d, style: dim));
      } else if (m.group(4) != null) {
        final d = m.group(3)!;
        spans
          ..add(TextSpan(text: d, style: dim))
          ..add(
            TextSpan(
              text: m.group(4),
              style: base.copyWith(fontStyle: FontStyle.italic),
            ),
          )
          ..add(TextSpan(text: d, style: dim));
      } else if (m.group(6) != null) {
        spans
          ..add(TextSpan(text: '`', style: dim))
          ..add(
            TextSpan(
              text: m.group(6),
              style: base.copyWith(
                fontFamily: 'monospace',
                backgroundColor: scheme.surfaceContainerHighest,
              ),
            ),
          )
          ..add(TextSpan(text: '`', style: dim));
      } else if (m.group(8) != null) {
        spans
          ..add(TextSpan(text: '~~', style: dim))
          ..add(
            TextSpan(
              text: m.group(8),
              style: base.copyWith(decoration: TextDecoration.lineThrough),
            ),
          )
          ..add(TextSpan(text: '~~', style: dim));
      } else if (m.group(9) != null) {
        spans
          ..add(TextSpan(text: '[', style: dim))
          ..add(
            TextSpan(
              text: m.group(9),
              style: base.copyWith(
                color: scheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          )
          ..add(TextSpan(text: '](${m.group(10)})', style: dim));
      }
      index = m.end;
    }
    if (index < text.length) {
      spans.add(TextSpan(text: text.substring(index), style: base));
    }
    return spans;
  }
}

/// Kinds of block/format the "add" menu can insert.
enum _MdInsert { h1, h2, bullet, numbered, checkbox, quote, code, link, rule }

/// A single-field Markdown editor with live inline styling and a small
/// formatting toolbar (bold / italic / code, plus an "add" menu for blocks).
class LiveMarkdownField extends StatefulWidget {
  const LiveMarkdownField({super.key, required this.controller, this.hintText});

  final MarkdownStylingController controller;
  final String? hintText;

  @override
  State<LiveMarkdownField> createState() => _LiveMarkdownFieldState();
}

class _LiveMarkdownFieldState extends State<LiveMarkdownField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  TextEditingController get _c => widget.controller;

  void _wrap(String left, [String? right]) {
    right ??= left;
    final sel = _c.selection;
    final text = _c.text;
    final start = sel.isValid ? sel.start : text.length;
    final end = sel.isValid ? sel.end : text.length;
    final inner = text.substring(start, end);
    _c.value = _c.value.copyWith(
      text: text.replaceRange(start, end, '$left$inner$right'),
      selection: TextSelection.collapsed(
        offset: inner.isEmpty
            ? start + left.length
            : end + left.length + right.length,
      ),
    );
    _focusNode.requestFocus();
  }

  void _prefixLine(String prefix) {
    final sel = _c.selection;
    final text = _c.text;
    final at = sel.isValid ? sel.start : text.length;
    final lineStart = at == 0 ? 0 : text.lastIndexOf('\n', at - 1) + 1;
    _c.value = _c.value.copyWith(
      text: text.replaceRange(lineStart, lineStart, prefix),
      selection: TextSelection.collapsed(offset: at + prefix.length),
    );
    _focusNode.requestFocus();
  }

  void _insert(String snippet) {
    final sel = _c.selection;
    final text = _c.text;
    final at = sel.isValid ? sel.start : text.length;
    _c.value = _c.value.copyWith(
      text: text.replaceRange(at, at, snippet),
      selection: TextSelection.collapsed(offset: at + snippet.length),
    );
    _focusNode.requestFocus();
  }

  void _onInsert(_MdInsert kind) {
    switch (kind) {
      case _MdInsert.h1:
        _prefixLine('# ');
      case _MdInsert.h2:
        _prefixLine('## ');
      case _MdInsert.bullet:
        _prefixLine('- ');
      case _MdInsert.numbered:
        _prefixLine('1. ');
      case _MdInsert.checkbox:
        _prefixLine('- [ ] ');
      case _MdInsert.quote:
        _prefixLine('> ');
      case _MdInsert.code:
        _wrap('`');
      case _MdInsert.link:
        _wrap('[', '](url)');
      case _MdInsert.rule:
        _insert('\n---\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Toolbar(
          onBold: () => _wrap('**'),
          onItalic: () => _wrap('_'),
          onCode: () => _wrap('`'),
          onInsert: _onInsert,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            expands: true,
            maxLines: null,
            minLines: null,
            textAlignVertical: TextAlignVertical.top,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(height: 1.45),
            decoration: InputDecoration(
              hintText: widget.hintText,
              alignLabelWithHint: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.onBold,
    required this.onItalic,
    required this.onCode,
    required this.onInsert,
  });

  final VoidCallback onBold;
  final VoidCallback onItalic;
  final VoidCallback onCode;
  final ValueChanged<_MdInsert> onInsert;

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData icon, VoidCallback onTap, String tip) => IconButton(
      visualDensity: VisualDensity.compact,
      iconSize: 20,
      icon: Icon(icon),
      tooltip: tip,
      onPressed: onTap,
    );

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  leadingIcon: const Icon(Icons.title),
                  onPressed: () => onInsert(_MdInsert.h1),
                  child: const Text('Heading 1'),
                ),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.title, size: 18),
                  onPressed: () => onInsert(_MdInsert.h2),
                  child: const Text('Heading 2'),
                ),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.format_list_bulleted),
                  onPressed: () => onInsert(_MdInsert.bullet),
                  child: const Text('Bullet list'),
                ),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.format_list_numbered),
                  onPressed: () => onInsert(_MdInsert.numbered),
                  child: const Text('Numbered list'),
                ),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.check_box_outlined),
                  onPressed: () => onInsert(_MdInsert.checkbox),
                  child: const Text('Checklist'),
                ),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.format_quote),
                  onPressed: () => onInsert(_MdInsert.quote),
                  child: const Text('Quote'),
                ),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.link),
                  onPressed: () => onInsert(_MdInsert.link),
                  child: const Text('Link'),
                ),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.horizontal_rule),
                  onPressed: () => onInsert(_MdInsert.rule),
                  child: const Text('Divider'),
                ),
              ],
              builder: (context, controller, _) => IconButton(
                visualDensity: VisualDensity.compact,
                iconSize: 20,
                icon: const Icon(Icons.add),
                tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
              ),
            ),
            const SizedBox(width: 4),
            btn(Icons.format_bold, onBold, 'Bold'),
            btn(Icons.format_italic, onItalic, 'Italic'),
            btn(Icons.code, onCode, 'Code'),
          ],
        ),
      ),
    );
  }
}
