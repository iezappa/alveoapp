import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/export/pdf_export.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/repositories/session_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // for rootBundle (fonts)

  test('builds a valid, non-trivial PDF for a session', () async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final id = await SessionRepository(db).create(
      scheduledFor: DateTime(2026, 9, 1, 10),
      agendaMarkdown: 'boundaries — sleep',
      takeawaysMarkdown: 'try the breathing exercise',
    );
    final session = (await SessionRepository(db).getById(id))!;

    final bytes = await buildSessionPdf(
      session,
      const SessionPdfLabels(
        title: 'Therapy session',
        dateText: 'September 1, 2026',
        agenda: 'Agenda',
        notes: 'Notes',
        takeaways: 'Takeaways',
      ),
    );

    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(800));
  });
}
