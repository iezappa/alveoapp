import 'dart:io';

import 'package:alveo/features/legal/legal_document_screen.dart';
import 'package:alveo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Locale locale, LegalDocument doc) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: LegalDocumentScreen(document: doc),
);

void main() {
  group('bundled legal documents', () {
    test('each bundled copy is byte-identical to its repository file', () {
      const pairs = {
        'assets/legal/privacy_en.md': '../../PRIVACY.md',
        'assets/legal/privacy_es.md': '../../PRIVACY.es.md',
        'assets/legal/terms_en.md': '../../TERMS.md',
        'assets/legal/terms_es.md': '../../TERMS.es.md',
      };
      pairs.forEach((asset, root) {
        expect(
          File(asset).readAsBytesSync(),
          File(root).readAsBytesSync(),
          reason: '$asset != $root',
        );
      });
    });

    test('the asset follows the locale, with English as the fallback', () {
      expect(
        LegalDocument.privacy.assetFor(const Locale('es')),
        'assets/legal/privacy_es.md',
      );
      expect(
        LegalDocument.privacy.assetFor(const Locale('es', 'AR')),
        'assets/legal/privacy_es.md',
      );
      expect(
        LegalDocument.terms.assetFor(const Locale('en')),
        'assets/legal/terms_en.md',
      );
      expect(
        LegalDocument.terms.assetFor(const Locale('fr')),
        'assets/legal/terms_en.md',
      );
    });

    test('both languages ship for every document', () {
      for (final doc in LegalDocument.values) {
        for (final lang in LegalDocument.languages) {
          final file = File(doc.assetFor(Locale(lang)));
          expect(file.existsSync(), isTrue, reason: file.path);
        }
      }
    });

    test('the language switcher line is not rendered in the app', () {
      final blocks = parseBlocks(
        File('assets/legal/privacy_es.md').readAsStringSync(),
      );
      expect(blocks.any((b) => b.text.contains('English')), isFalse);
      expect(blocks.first.kind, LegalBlockKind.title);
    });

    test('every locale has both documents, with no template markers', () {
      for (final locale in AppLocalizations.supportedLocales) {
        for (final doc in LegalDocument.values) {
          final file = File(doc.assetFor(locale));
          expect(file.existsSync(), isTrue, reason: file.path);
          final text = file.readAsStringSync();
          expect(text, isNot(contains('{{')));
          expect(text, contains('Zeke Zappa Developments (iezappa)'));
          expect(text, contains(contactUrl));
        }
      }
    });

    test('pubspec ships the legal folder', () {
      expect(
        File('pubspec.yaml').readAsStringSync(),
        contains('assets/legal/'),
      );
    });
  });

  testWidgets('renders the privacy policy offline, in the app language', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const Locale('es'), LegalDocument.privacy));
    await tester.pumpAndSettle();
    expect(find.text('Política de privacidad de Alveo'), findsOneWidget);
    expect(find.textContaining('Ley'), findsWidgets);
  });

  testWidgets('renders the terms in English', (tester) async {
    await tester.pumpWidget(_host(const Locale('en'), LegalDocument.terms));
    await tester.pumpAndSettle();
    expect(find.text('Alveo terms of use'), findsOneWidget);
    expect(find.textContaining('not a medical device'), findsOneWidget);
  });
}
