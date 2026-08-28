import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/features/journal/live_markdown_field.dart';

Widget _host(MarkdownStylingController controller) => MaterialApp(
  home: Scaffold(
    body: SizedBox(
      height: 320,
      child: LiveMarkdownField(controller: controller),
    ),
  ),
);

void main() {
  testWidgets('the bold button wraps the selection in **', (tester) async {
    final controller = MarkdownStylingController(text: 'hello world');
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller));

    controller.selection = const TextSelection(baseOffset: 6, extentOffset: 11);
    await tester.tap(find.byTooltip('Bold'));
    await tester.pump();

    expect(controller.text, 'hello **world**');
  });

  testWidgets('the add menu prefixes the current line with a bullet', (
    tester,
  ) async {
    final controller = MarkdownStylingController(text: 'idea');
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller));

    controller.selection = const TextSelection.collapsed(offset: 4);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bullet list'));
    await tester.pumpAndSettle();

    expect(controller.text, '- idea');
  });

  testWidgets('styling restyles the text without changing it', (tester) async {
    final controller = MarkdownStylingController(
      text: '# Title\n**bold** and _it_',
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller));
    await tester.pump();

    expect(controller.text, '# Title\n**bold** and _it_');

    final span = controller.buildTextSpan(
      context: tester.element(find.byType(LiveMarkdownField)),
      withComposing: false,
    );
    expect(span.children, isNotNull);
    expect(span.children!.length, greaterThan(3));
  });
}
