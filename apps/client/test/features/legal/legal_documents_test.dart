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
    test('the English copies are the repository PRIVACY.md and TERMS.md', () {
      expect(
        File('assets/legal/privacy_en.md').readAsStringSync(),
        File('../../PRIVACY.md').readAsStringSync(),
      );
      expect(
        File('assets/legal/terms_en.md').readAsStringSync(),
        File('../../TERMS.md').readAsStringSync(),
      );
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
