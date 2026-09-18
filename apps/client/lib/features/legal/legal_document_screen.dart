import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/ui.dart';
import '../../l10n/app_localizations.dart';

/// Who publishes Alveo, as it appears in About and in the legal documents.
const developerName = 'Zeke Zappa Developments (iezappa)';

/// The only contact channel: the repository's issue tracker. No email.
const contactUrl = 'https://github.com/iezappa/alveoapp/issues';

/// A legal document bundled with the app, so it opens with no connection.
enum LegalDocument {
  privacy('privacy'),
  terms('terms');

  const LegalDocument(this._stem);
  final String _stem;

  /// Languages the documents are written in. English is the fallback.
  static const languages = ['en', 'es'];

  /// The asset for [locale], falling back to English.
  String assetFor(Locale locale) {
    final lang = languages.contains(locale.languageCode)
        ? locale.languageCode
        : 'en';
    return 'assets/legal/${_stem}_$lang.md';
  }
}

/// Shows [document] from the bundle, rendering the small Markdown subset the
/// documents use: headings, bullets, paragraphs, **bold** and `code`.
class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key, required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (document) {
      LegalDocument.privacy => l10n.privacyPolicy,
      LegalDocument.terms => l10n.termsOfUse,
    };
    final asset = document.assetFor(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(asset),
        builder: (context, snapshot) {
          final text = snapshot.data;
          if (text == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: PageBody(
              child: SelectionArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final b in parseBlocks(text)) _block(context, b),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _block(BuildContext context, LegalBlock block) {
    final theme = Theme.of(context).textTheme;
    final style = switch (block.kind) {
      LegalBlockKind.title => theme.headlineSmall,
      LegalBlockKind.heading => theme.titleMedium,
      _ => theme.bodyMedium?.copyWith(height: 1.45),
    };
    final text = Text.rich(
      TextSpan(children: inlineSpans(block.text)),
      style: style,
    );
    return Padding(
      padding: EdgeInsets.only(
        top: block.kind == LegalBlockKind.heading ? 16 : 0,
        bottom: 8,
      ),
      child: block.kind == LegalBlockKind.bullet
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('•  ', style: style),
                Expanded(child: text),
              ],
            )
          : text,
    );
  }
}

enum LegalBlockKind { title, heading, bullet, paragraph }

class LegalBlock {
  const LegalBlock(this.kind, this.text);
  final LegalBlockKind kind;
  final String text;
}

/// The `**English** · [Español](X.es.md)` line under each title. It links
/// the repository copies to each other and means nothing inside the app.
final _languageSwitcher = RegExp(
  r'^(\*\*English\*\*|\[English\]\([^)]*\)) · '
  r'(\*\*Español\*\*|\[Español\]\([^)]*\))$',
);

/// Splits the document into blocks, joining hard-wrapped lines. The language
/// switcher line is dropped.
List<LegalBlock> parseBlocks(String source) {
  final blocks = <LegalBlock>[];
  LegalBlockKind? kind;
  final buffer = <String>[];
  void flush() {
    if (kind != null && buffer.isNotEmpty) {
      blocks.add(LegalBlock(kind!, buffer.join(' ')));
    }
    kind = null;
    buffer.clear();
  }

  for (final raw in source.split('\n')) {
    final line = raw.trim();
    if (line.isEmpty || _languageSwitcher.hasMatch(line)) {
      flush();
    } else if (line.startsWith('## ')) {
      flush();
      blocks.add(LegalBlock(LegalBlockKind.heading, line.substring(3)));
    } else if (line.startsWith('# ')) {
      flush();
      blocks.add(LegalBlock(LegalBlockKind.title, line.substring(2)));
    } else if (line.startsWith('- ')) {
      flush();
      kind = LegalBlockKind.bullet;
      buffer.add(line.substring(2));
    } else {
      kind ??= LegalBlockKind.paragraph;
      buffer.add(line);
    }
  }
  flush();
  return blocks;
}

/// `**bold**` becomes bold; backticks are dropped.
List<InlineSpan> inlineSpans(String text) {
  final parts = text.replaceAll('`', '').split('**');
  return [
    for (var i = 0; i < parts.length; i++)
      TextSpan(
        text: parts[i],
        style: i.isOdd ? const TextStyle(fontWeight: FontWeight.w700) : null,
      ),
  ];
}
