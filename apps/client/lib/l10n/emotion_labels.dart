import 'app_localizations.dart';

/// Resolves a Plutchik emotion [key] to its label in the active locale.
extension EmotionLabels on AppLocalizations {
  String emotionLabel(String key) {
    switch (key) {
      case 'joy':
        return emotionJoy;
      case 'sadness':
        return emotionSadness;
      case 'trust':
        return emotionTrust;
      case 'disgust':
        return emotionDisgust;
      case 'fear':
        return emotionFear;
      case 'anger':
        return emotionAnger;
      case 'surprise':
        return emotionSurprise;
      case 'anticipation':
        return emotionAnticipation;
      default:
        return key;
    }
  }
}
