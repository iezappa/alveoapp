import '../../domain/obsidian/obsidian_report.dart';
import '../repositories/journal_repository.dart';

/// Web stub: Obsidian sync needs local filesystem access it does not have.
class ObsidianService {
  ObsidianService(this._journal);

  // ignore: unused_field
  final JournalRepository _journal;

  Future<ObsidianReport> exportJournal(String vaultDir) =>
      throw const ObsidianException(
        'Obsidian sync is only available on the '
        'desktop app.',
      );

  Future<ObsidianReport> importJournal(String dir) =>
      throw const ObsidianException(
        'Obsidian sync is only available on the '
        'desktop app.',
      );
}
