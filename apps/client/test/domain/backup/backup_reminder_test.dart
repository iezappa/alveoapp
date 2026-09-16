import 'package:alveo/domain/backup/backup_reminder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 9, 16, 12);

  BackupReminder decide({
    DateTime? lastExportAt,
    DateTime? dismissedAt,
    bool holdsData = true,
  }) => backupReminderFor(
    now: now,
    lastExportAt: lastExportAt,
    dismissedAt: dismissedAt,
    holdsData: holdsData,
  );

  test('stays quiet on a fresh install with nothing written', () {
    expect(decide(holdsData: false), isA<NoBackupReminder>());
  });

  test('reminds when there is data and it was never exported', () {
    expect(decide(), isA<BackupNeverTaken>());
  });

  test('stays quiet within 30 days of the last export', () {
    expect(
      decide(lastExportAt: now.subtract(const Duration(days: 30))),
      isA<NoBackupReminder>(),
    );
  });

  test('reminds, with the age in days, past 30 days', () {
    final reminder = decide(
      lastExportAt: now.subtract(const Duration(days: 45)),
    );
    expect(reminder, isA<BackupOverdue>());
    expect((reminder as BackupOverdue).days, 45);
  });

  test('"not now" keeps it away for 7 days', () {
    expect(
      decide(dismissedAt: now.subtract(const Duration(days: 6))),
      isA<NoBackupReminder>(),
    );
  });

  test('comes back once the 7-day snooze runs out', () {
    expect(
      decide(dismissedAt: now.subtract(const Duration(days: 7))),
      isA<BackupNeverTaken>(),
    );
  });
}
