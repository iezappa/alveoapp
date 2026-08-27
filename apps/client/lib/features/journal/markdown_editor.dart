import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

/// A Markdown editor with a live preview.
///
/// On wide layouts (>= 720 logical px) the editor and preview sit side by
/// side and the preview updates on every keystroke. On narrow layouts they
/// share the space behind a Write / Preview toggle.
class MarkdownEditor extends StatefulWidget {
  const MarkdownEditor({
    super.key,
    required this.controller,
    required this.writeLabel,
    required this.previewLabel,
    this.hintText,
  });

  final TextEditingController controller;
  final String writeLabel;
  final String previewLabel;
  final String? hintText;

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  bool _showPreview = false;

  Widget _buildEditor() {
    return TextField(
      controller: widget.controller,
      expands: true,
      maxLines: null,
      minLines: null,
      textAlignVertical: TextAlignVertical.top,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontFamilyFallback: ['Courier New', 'Courier'],
        height: 1.4,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildPreview() {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final data = widget.controller.text.trim();
          if (data.isEmpty) return const SizedBox.expand();
          return Markdown(data: data, padding: const EdgeInsets.all(12));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 720) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildEditor()),
              const SizedBox(width: 12),
              Expanded(child: _buildPreview()),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: false, label: Text(widget.writeLabel)),
                ButtonSegment(value: true, label: Text(widget.previewLabel)),
              ],
              selected: {_showPreview},
              showSelectedIcon: false,
              onSelectionChanged: (s) =>
                  setState(() => _showPreview = s.first),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _showPreview ? _buildPreview() : _buildEditor(),
            ),
          ],
        );
      },
    );
  }
}
