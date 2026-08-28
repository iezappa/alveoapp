import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/domain/greeting.dart';

void main() {
  DateTime at(int hour) => DateTime(2026, 8, 28, hour, 30);

  test('maps each hour band to the right part of the day', () {
    expect(dayPartFor(at(0)), DayPart.night);
    expect(dayPartFor(at(4)), DayPart.night);
    expect(dayPartFor(at(5)), DayPart.morning);
    expect(dayPartFor(at(11)), DayPart.morning);
    expect(dayPartFor(at(12)), DayPart.afternoon);
    expect(dayPartFor(at(18)), DayPart.afternoon);
    expect(dayPartFor(at(19)), DayPart.evening);
    expect(dayPartFor(at(22)), DayPart.evening);
    expect(dayPartFor(at(23)), DayPart.night);
  });
}
