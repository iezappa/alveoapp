import 'dart:io';

import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/data/repositories/link_repository.dart';
import 'package:alveo/data/repositories/medication_repository.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/data/repositories/safety_plan_repository.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/data/repositories/tag_repository.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/data/repositories/thought_record_repository.dart';
import 'package:drift/drift.dart' show TableInfo;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Import hygiene for the hinge of §1.1: screens and their providers know the
/// repository interfaces, never the database.
///
/// Most of these checks read source text: they catch a screen importing drift
/// or a Drift repository, and a provider typed as an implementation. They do
/// not prove a screen *uses* the interface — a screen could still reach the
/// database through some other import — so they are a tripwire, not a proof.
/// The last group is the runtime half: the repository providers, resolved
/// against one AppDatabase, hand out the Drift implementations and write into
/// that same database.
void main() {
  final presentation = Directory('lib/features')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  test('there is presentation code to check', () {
    expect(presentation, isNotEmpty);
  });

  test('no screen imports drift', () {
    final offenders = [
      for (final file in presentation)
        if (file.readAsStringSync().contains("import 'package:drift/"))
          file.path,
    ];
    expect(offenders, isEmpty);
  });

  test('no screen imports a Drift repository implementation', () {
    final offenders = [
      for (final file in presentation)
        if (RegExp(r"import .*data/repositories/")
            .hasMatch(file.readAsStringSync()))
          file.path,
    ];
    expect(offenders, isEmpty);
  });

  test('every repository provider is typed as the domain interface', () {
    final providers = File('lib/data/providers.dart').readAsStringSync();
    final declared = RegExp(r'Provider<(\w+Repository)>')
        .allMatches(providers)
        .map((m) => m[1]!)
        .toSet();
    expect(declared, isNotEmpty);
    for (final name in declared) {
      expect(name, isNot(startsWith('Drift')), reason: providers);
    }
    // And each one is built by a Drift implementation of that interface.
    for (final name in declared) {
      expect(providers, contains('Drift$name('));
    }
  });

  group('at runtime, against one database', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() {
      db = AppDatabase.forTesting();
      container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
    });
    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('every repository provider resolves to its Drift implementation', () {
      expect(
        container.read(settingsRepositoryProvider),
        isA<DriftSettingsRepository>(),
      );
      expect(
        container.read(safetyPlanRepositoryProvider),
        isA<DriftSafetyPlanRepository>(),
      );
      expect(
        container.read(moodRepositoryProvider),
        isA<DriftMoodRepository>(),
      );
      expect(container.read(tagRepositoryProvider), isA<DriftTagRepository>());
      expect(
        container.read(journalRepositoryProvider),
        isA<DriftJournalRepository>(),
      );
      expect(
        container.read(taskRepositoryProvider),
        isA<DriftTaskRepository>(),
      );
      expect(
        container.read(sessionRepositoryProvider),
        isA<DriftSessionRepository>(),
      );
      expect(
        container.read(linkRepositoryProvider),
        isA<DriftLinkRepository>(),
      );
      expect(
        container.read(thoughtRecordRepositoryProvider),
        isA<DriftThoughtRecordRepository>(),
      );
      expect(
        container.read(medicationRepositoryProvider),
        isA<DriftMedicationRepository>(),
      );
    });

    test('they all write into the overridden database', () async {
      await container.read(settingsRepositoryProvider).set('k', 'v');
      await container
          .read(moodRepositoryProvider)
          .add(mood: 3, occurredAt: DateTime(2026));
      await container
          .read(journalRepositoryProvider)
          .create(bodyMarkdown: 'x', entryDate: DateTime(2026));
      await container.read(taskRepositoryProvider).create(title: 't');
      await container
          .read(sessionRepositoryProvider)
          .create(scheduledFor: DateTime(2026));
      await container.read(tagRepositoryProvider).findOrCreate('work');
      await container.read(medicationRepositoryProvider).create(name: 'm');
      await container
          .read(thoughtRecordRepositoryProvider)
          .create(
            occurredAt: DateTime(2026),
            situation: 's',
            automaticThought: 'a',
          );

      for (final table in <TableInfo>[
        db.appSettings,
        db.moodEntries,
        db.journalEntries,
        db.tasks,
        db.sessions,
        db.tags,
        db.medications,
        db.thoughtRecords,
      ]) {
        expect(
          await db.select(table).get(),
          hasLength(1),
          reason: table.actualTableName,
        );
      }
    });
  });
}
