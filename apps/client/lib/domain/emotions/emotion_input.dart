/// One emotion attached to a check-in or a journal entry, with how strongly
/// it was felt (1..10).
class EmotionInput {
  const EmotionInput({required this.emotionKey, required this.intensity});

  final String emotionKey;
  final int intensity;
}
