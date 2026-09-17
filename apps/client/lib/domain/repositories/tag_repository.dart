import '../../data/local/database.dart';

abstract interface class TagRepository {
  Future<List<Tag>> all();
  Future<String> findOrCreate(String name);
  Future<List<MoodEntryTag>> moodTagLinks();
}
