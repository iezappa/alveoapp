import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/features/journal/markdown_editor.dart';

Widget _host(TextEditingController controller, {required double width}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          height: 500,
          child: MarkdownEditor(
            controller: controller,
            writeLabel: 'Write',
            previewLabel: 'Preview',
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('wide layout renders a live preview beside the editor', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller, width: 900));

    // No toggle on wide layouts.
    expect(find.text('Write'), findsNothing);
    expect(find.text('Preview'), findsNothing);

    await tester.enterText(find.byType(TextField), '# Heading\n\nsome body');
    await tester.pump();

    expect(find.text('Heading'), findsOneWidget);
    expect(find.text('some body'), findsOneWidget);
  });

  testWidgets('narrow layout hides the preview behind a toggle', (
    tester,
  ) async {
    final controller = TextEditingController(text: '# Heading');
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller, width: 360));

    // Editor is shown first; the rendered heading is not.
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Heading'), findsNothing);

    await tester.tap(find.text('Preview'));
    await tester.pumpAndSettle();

    expect(find.text('Heading'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });
}
