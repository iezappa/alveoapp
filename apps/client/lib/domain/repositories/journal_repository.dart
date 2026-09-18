import '../../data/local/database.dart';
import '../emotions/emotion_input.dart';
import '../journal/journal_section.dart';

abstract interface class JournalRepository {
  /// Creates a journal entry and returns its id. [bodyMarkdown] is stored
  /// verbatim — it is the source of truth for the daily `.md` export.
  Future<String> create({
    required String bodyMarkdown,
    required DateTime entryDate,
    String? title,
    JournalSection section,
    bool isMonthlyReview,
    DateTime? createdAt,
    List<String> tagIds,
    List<EmotionInput> emotions,
    String? id,
  });

  /// Rewrites the body and title, and, when [emotions] is given, replaces
  /// the emotion set in the same transaction.
  Future<void> updateBody({
    required String id,
    required String bodyMarkdown,
    String? title,
    List<EmotionInput>? emotions,
    DateTime? updatedAt,
  });

  Future<List<JournalEntry>> getAll();
  Future<JournalEntry?> getById(String id);
  Future<List<JournalEntry>> getBySection(JournalSection section);
  Future<JournalEntry?> getMonthlyReview(DateTime month);
  Future<List<JournalEntry>> getForDay(DateTime day);
  Future<List<JournalEntryEmotion>> emotionsFor(String journalEntryId);
  Future<void> replaceEmotions(String id, List<EmotionInput> emotions);
  Future<void> delete(String id);
}
