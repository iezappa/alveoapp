import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../local/database.dart';

/// Labels for the session PDF, passed in so the caller controls the language.
class SessionPdfLabels {
  const SessionPdfLabels({
    required this.title,
    required this.dateText,
    required this.agenda,
    required this.notes,
    required this.takeaways,
  });

  final String title;
  final String dateText;
  final String agenda;
  final String notes;
  final String takeaways;
}

/// The built-in PDF fonts only cover Latin-1, so fold the few typographic
/// characters that appear in notes down to ASCII equivalents.
String _sanitize(String s) => s
    .replaceAll('—', '-') // em dash
    .replaceAll('–', '-') // en dash
    .replaceAll('…', '...') // ellipsis
    .replaceAll(RegExp('[‘’]'), "'")
    .replaceAll(RegExp('[“”]'), '"');

/// Renders one session to a shareable A4 PDF. Body text is written verbatim
/// (Markdown markers included) — a real Markdown layout comes later.
Future<Uint8List> buildSessionPdf(
  Session session,
  SessionPdfLabels labels,
) async {
  final doc = pw.Document();

  pw.Widget block(String label, String? body) {
    final text = _sanitize(body?.trim() ?? '');
    if (text.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 18),
        pw.Text(
          label.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 9,
            letterSpacing: 1.2,
            color: PdfColors.grey700,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(text, style: const pw.TextStyle(fontSize: 11, lineSpacing: 3)),
      ],
    );
  }

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(48),
      build: (context) => [
        pw.Text(
          _sanitize(labels.title),
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          _sanitize(labels.dateText),
          style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
        ),
        block(labels.agenda, session.agendaMarkdown),
        block(labels.notes, session.notesMarkdown),
        block(labels.takeaways, session.takeawaysMarkdown),
      ],
    ),
  );

  return doc.save();
}
