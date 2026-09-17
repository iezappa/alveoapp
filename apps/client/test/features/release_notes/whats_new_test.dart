import 'dart:io';

import 'package:alveo/domain/release_notes/release_notes.dart';
import 'package:alveo/app/onboarding_controller.dart';
import 'package:alveo/app/user_profile_controller.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/features/release_notes/release_notes_providers.dart';
import 'package:alveo/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository settings;

  setUp(() async {
    db = AppDatabase.forTesting();
    settings = SettingsRepository(db);
    for (final key in [
      disclaimerAcceptedSettingKey,
      backupNoticeAcceptedSettingKey,
      tutorialSeenSettingKey,
    ]) {
      await settings.set(key, 'true');
    }
    await settings.set(userNameSettingKey, 'Ana');
  });
  tearDown(() => db.close());

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          firstRunFlowEnabledProvider.overrideWithValue(true),
          // The shipped file, read up front: bundle I/O under the fake clock
          // would race the assertions.
          releaseNotesProvider.overrideWith(
            (ref, _) => ReleaseNotes.parse(
              File('assets/release_notes/en.json').readAsStringSync(),
            ),
          ),
        ],
        child: const AlveoApp(),
      ),
    );
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pumpAndSettle();
    }
  }

  testWidgets('after an update, shows what is new and remembers it', (
    tester,
  ) async {
    await settings.set(lastSeenVersionSettingKey, '0.9.0');
    await pumpApp(tester);

    expect(find.text("What's new in 1.0.0"), findsOneWidget);
    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );

    expect(
      await tester.runAsync(() => settings.get(lastSeenVersionSettingKey)),
      '1.0.0',
    );
  });

  testWidgets('a first install is told nothing, but remembers the version', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.textContaining("What's new"), findsNothing);
    // Loading the bundled changelog is real I/O: give it time to land.
    String? stored;
    for (var i = 0; i < 50 && stored == null; i++) {
      stored = await tester.runAsync<String?>(() async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return settings.get(lastSeenVersionSettingKey);
      });
      await tester.pump();
    }
    expect(stored, '1.0.0');
    expect(find.textContaining("What's new"), findsNothing);
  });

  testWidgets('the same version shows nothing', (tester) async {
    await settings.set(lastSeenVersionSettingKey, '1.0.0');
    await pumpApp(tester);
    expect(find.textContaining("What's new"), findsNothing);
  });
}
