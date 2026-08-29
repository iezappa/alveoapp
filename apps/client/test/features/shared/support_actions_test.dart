import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/features/shared/support_actions.dart';
import 'package:alveo/l10n/app_localizations.dart';

Future<void> _pump(WidgetTester tester, UrlOpener open) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SupportProjectsCard(open: open)),
    ),
  );
}

void main() {
  testWidgets('Cafecito button opens the Cafecito URL', (tester) async {
    final opened = <Uri>[];
    await _pump(tester, (url) async {
      opened.add(url);
      return true;
    });

    await tester.tap(find.byKey(const ValueKey('support-cafecito')));
    await tester.pump();

    expect(opened.single.toString(), cafecitoUrl);
  });

  testWidgets('Patreon button opens the Patreon URL', (tester) async {
    final opened = <Uri>[];
    await _pump(tester, (url) async {
      opened.add(url);
      return true;
    });

    await tester.tap(find.byKey(const ValueKey('support-patreon')));
    await tester.pump();

    expect(opened.single.toString(), patreonUrl);
  });

  testWidgets('shows an error snack bar when the launch fails', (tester) async {
    await _pump(tester, (_) async => false);

    await tester.tap(find.byKey(const ValueKey('support-cafecito')));
    await tester.pump();

    expect(find.text("Couldn't open the link"), findsOneWidget);
  });

  testWidgets('a thrown launcher is treated as a failure', (tester) async {
    await _pump(tester, (_) async => throw Exception('no browser'));

    await tester.tap(find.byKey(const ValueKey('support-patreon')));
    await tester.pump();

    expect(find.text("Couldn't open the link"), findsOneWidget);
  });
}
