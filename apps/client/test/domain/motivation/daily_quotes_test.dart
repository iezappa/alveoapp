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
    // Feb 29 in a leap year is day-of-year 59 and still maps into the list.
    expect(quoteForDay(DateTime(2028, 2, 29)), same(dailyQuotes[59]));
    // The modulo keeps the lookup safe if the list is ever shorter than 366.
    final idx = (dailyQuotes.length + 3) % dailyQuotes.length;
    expect(
      quoteForDay(DateTime(2026).add(Duration(days: idx))),
      same(dailyQuotes[idx]),
    );
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
