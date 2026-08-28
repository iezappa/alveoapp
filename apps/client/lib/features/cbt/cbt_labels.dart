import '../../domain/cbt/cognitive_distortion.dart';
import '../../l10n/app_localizations.dart';

extension CognitiveDistortionUi on CognitiveDistortion {
  String label(AppLocalizations l10n) => switch (this) {
    CognitiveDistortion.allOrNothing => l10n.distortionAllOrNothing,
    CognitiveDistortion.overgeneralization => l10n.distortionOvergeneralization,
    CognitiveDistortion.mentalFilter => l10n.distortionMentalFilter,
    CognitiveDistortion.disqualifyingThePositive =>
      l10n.distortionDisqualifyingPositive,
    CognitiveDistortion.jumpingToConclusions =>
      l10n.distortionJumpingToConclusions,
    CognitiveDistortion.catastrophizing => l10n.distortionCatastrophizing,
    CognitiveDistortion.emotionalReasoning => l10n.distortionEmotionalReasoning,
    CognitiveDistortion.shouldStatements => l10n.distortionShouldStatements,
    CognitiveDistortion.labeling => l10n.distortionLabeling,
    CognitiveDistortion.personalization => l10n.distortionPersonalization,
  };
}
