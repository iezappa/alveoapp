import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/domain/safety/safety_plan.dart';

void main() {
  test('round-trips through JSON', () {
    const plan = SafetyPlan(
      warningSigns: 'racing thoughts',
      copingStrategies: 'walk, cold water',
      distractions: 'call a friend',
      environmentSafety: 'give the pills to my flatmate',
      contacts: [
        SafetyContact(name: 'A', phone: '111'),
        SafetyContact(
          name: 'Dr B',
          phone: '222',
          kind: SafetyContactKind.professional,
        ),
      ],
    );

    final back = SafetyPlan.decode(plan.encode());
    expect(back.warningSigns, 'racing thoughts');
    expect(back.environmentSafety, 'give the pills to my flatmate');
    expect(back.contacts, hasLength(2));
    expect(back.contacts[0].kind, SafetyContactKind.support);
    expect(back.contacts[1].kind, SafetyContactKind.professional);
  });

  test('decode tolerates null, garbage and empty objects', () {
    expect(SafetyPlan.decode(null).isEmpty, isTrue);
    expect(SafetyPlan.decode('not json').isEmpty, isTrue);
    expect(SafetyPlan.decode('{}').isEmpty, isTrue);
  });

  test('an unknown contact kind falls back to support', () {
    final plan = SafetyPlan.decode(
      '{"contacts":[{"name":"X","phone":"1","kind":"mystery"}]}',
    );
    expect(plan.contacts.single.kind, SafetyContactKind.support);
  });
}
