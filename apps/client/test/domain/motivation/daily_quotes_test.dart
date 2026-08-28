import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/domain/motivation/daily_quotes.dart';

void main() {
  test('the list is non-empty and every field is filled', () {
    expect(dailyQuotes, isNotEmpty);
    for (final q in dailyQuotes) {
      expect(q.textEs.trim(), isNotEmpty);
      expect(q.textEn.trim(), isNotEmpty);
      expect(q.author.trim(), isNotEmpty);
      if (q.source != null) {
        expect(q.source!.trim(), isNotEmpty);
      }
    }
  });

  test('quoteForDay is stable across a calendar day', () {
    final morning = DateTime(2026, 3, 14, 7);
    final night = DateTime(2026, 3, 14, 23, 59);
    expect(identical(quoteForDay(morning), quoteForDay(night)), isTrue);
  });

  test('consecutive days pick consecutive entries, wrapping with a modulo', () {
    final jan1 = DateTime(2026);
    expect(quoteForDay(jan1), same(dailyQuotes[0]));
    expect(
      quoteForDay(jan1.add(const Duration(days: 1))),
      same(dailyQuotes[1]),
    );
    final wrapDay = jan1.add(Duration(days: dailyQuotes.length));
    expect(quoteForDay(wrapDay), same(dailyQuotes[0]));
  });

  test('text() switches language and falls back to Spanish', () {
    final q = dailyQuotes.first;
    expect(q.text('en'), q.textEn);
    expect(q.text('es'), q.textEs);
    expect(q.text('fr'), q.textEs);
  });

  test('attribution appends the source when there is one', () {
    final withSource = dailyQuotes.firstWhere((q) => q.source != null);
    expect(withSource.attribution, '${withSource.author} · ${withSource.source}');
    final noSource = dailyQuotes.firstWhere((q) => q.source == null);
    expect(noSource.attribution, noSource.author);
  });
}
