/// The classic cognitive distortions (Burns), used to label an automatic
/// thought in a thought record.
///
/// Stored by index via Drift's `intEnum`. APPEND-ONLY: never reorder or remove
/// values, or existing rows decode to the wrong distortion.
enum CognitiveDistortion {
  allOrNothing,
  overgeneralization,
  mentalFilter,
  disqualifyingThePositive,
  jumpingToConclusions,
  catastrophizing,
  emotionalReasoning,
  shouldStatements,
  labeling,
  personalization,
}
