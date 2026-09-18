import 'package:alveo/data/local/database.dart';

/// Makes every insert and update on [table] fail, the way a store held at an
/// older schema refuses this release's writes.
Future<void> refuseWrites(AppDatabase db, String table) async {
  for (final op in ['INSERT', 'UPDATE']) {
    await db.customStatement(
      'CREATE TRIGGER refuse_${op.toLowerCase()}_$table BEFORE $op ON $table '
      "BEGIN SELECT RAISE(ABORT, 'refused'); END",
    );
  }
}

const saveFailedMessage = "Couldn't save. Please try again.";

/// Makes every delete from [table] fail, the way a store held at an older
/// schema refuses this release's writes.
Future<void> refuseDeletes(AppDatabase db, String table) => db.customStatement(
  'CREATE TRIGGER refuse_delete_$table BEFORE DELETE ON $table '
  "BEGIN SELECT RAISE(ABORT, 'refused'); END",
);

const deleteFailedMessage = "Couldn't delete. Please try again.";
