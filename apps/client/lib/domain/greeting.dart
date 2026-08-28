/// Which part of the day a moment falls in, used to pick a greeting.
///
/// Never persisted, so the ordering here carries no storage contract.
enum DayPart { morning, afternoon, evening, night }

/// Maps the local hour of [when] to a [DayPart]:
/// morning 05:00–11:59, afternoon 12:00–18:59, evening 19:00–22:59,
/// night 23:00–04:59.
DayPart dayPartFor(DateTime when) {
  final hour = when.hour;
  if (hour >= 5 && hour < 12) return DayPart.morning;
  if (hour >= 12 && hour < 19) return DayPart.afternoon;
  if (hour >= 19 && hour < 23) return DayPart.evening;
  return DayPart.night;
}
