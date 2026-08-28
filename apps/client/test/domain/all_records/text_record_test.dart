import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/domain/all_records/text_record.dart';

void main() {
  TextRecord rec(String body, DateTime when, {String? title}) => TextRecord(
    kind: TextRecordKind.journal,
    when: when,
    body: body,
    title: title,
  );

  test('orders records newest first', () {
    final result = sortedTextRecords([
      rec('older', DateTime(2026, 1, 1)),
      rec('newest', DateTime(2026, 3, 1)),
      rec('middle', DateTime(2026, 2, 1)),
    ]);

    expect(result.map((r) => r.body), ['newest', 'middle', 'older']);
  });

  test('drops records with neither body nor title', () {
    final result = sortedTextRecords([
      rec('   ', DateTime(2026, 1, 2)),
      rec('kept', DateTime(2026, 1, 1)),
      rec('', DateTime(2026, 1, 3), title: '  a title  '),
    ]);

    expect(result.map((r) => r.body), ['', 'kept']);
    expect(result.first.title, '  a title  ');
  });

  test('hasText is false only when both parts are blank', () {
    expect(rec('', DateTime(2026, 1, 1)).hasText, isFalse);
    expect(rec('body', DateTime(2026, 1, 1)).hasText, isTrue);
    expect(rec('', DateTime(2026, 1, 1), title: 'x').hasText, isTrue);
  });
}
