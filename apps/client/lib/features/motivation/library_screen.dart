import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../domain/motivation/daily_quote.dart';
import '../../domain/motivation/daily_quotes.dart';
import '../../l10n/app_localizations.dart';

/// A scrollable library of every quote, with today's shown first.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final today = quoteForDay(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(l10n.libraryTitle)),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(kGutter, kGutter, kGutter, 24),
            children: [
              SectionLabel(l10n.libraryToday),
              const SizedBox(height: 8),
              _QuoteCard(quote: today, lang: lang, highlighted: true),
              const SizedBox(height: 24),
              SectionLabel(l10n.libraryAll),
              const SizedBox(height: 8),
              for (final quote in dailyQuotes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _QuoteCard(quote: quote, lang: lang),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({
    required this.quote,
    required this.lang,
    this.highlighted = false,
  });

  final DailyQuote quote;
  final String lang;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      color: highlighted ? scheme.secondaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quote.text(lang),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              quote.attribution,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
