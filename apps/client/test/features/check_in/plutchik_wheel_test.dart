import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/features/check_in/plutchik_wheel.dart';

void main() {
  testWidgets('tapping the north wedge toggles "joy" on and off',
      (tester) async {
    final selected = <String>{};

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: StatefulBuilder(
                builder: (context, setState) => PlutchikWheel(
                  selected: selected,
                  labelFor: (k) => k,
                  onToggle: (k) => setState(() {
                    selected.contains(k)
                        ? selected.remove(k)
                        : selected.add(k);
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final rect = tester.getRect(find.byType(PlutchikWheel));
    final northOfCentre =
        Offset(rect.center.dx, rect.center.dy - rect.height * 0.3);

    await tester.tapAt(northOfCentre);
    await tester.pump();
    expect(selected, contains('joy'));

    await tester.tapAt(northOfCentre);
    await tester.pump();
    expect(selected, isEmpty);
  });

  testWidgets('a tap outside the disc selects nothing', (tester) async {
    final selected = <String>{};

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: PlutchikWheel(
                selected: selected,
                labelFor: (k) => k,
                onToggle: selected.add,
              ),
            ),
          ),
        ),
      ),
    );

    final rect = tester.getRect(find.byType(PlutchikWheel));
    await tester.tapAt(rect.topLeft + const Offset(2, 2)); // corner, outside disc
    await tester.pump();
    expect(selected, isEmpty);
  });
}
