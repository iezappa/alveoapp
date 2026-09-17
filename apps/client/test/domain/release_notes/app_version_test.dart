import 'package:alveo/domain/release_notes/app_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses plain, v-prefixed and build-suffixed versions', () {
    expect(AppVersion.tryParse('1.2.3'), const AppVersion(1, 2, 3));
    expect(AppVersion.tryParse('v1.2.3'), const AppVersion(1, 2, 3));
    expect(AppVersion.tryParse('1.2.3+4'), const AppVersion(1, 2, 3));
    expect(AppVersion.tryParse('garbage'), isNull);
    expect(AppVersion.tryParse(null), isNull);
  });

  test('orders numerically, major first', () {
    expect(const AppVersion(1, 10, 0) > const AppVersion(1, 9, 9), isTrue);
    expect(const AppVersion(2, 0, 0) > const AppVersion(1, 99, 99), isTrue);
    expect(const AppVersion(1, 0, 0).compareTo(const AppVersion(1, 0, 0)), 0);
    expect('${const AppVersion(1, 2, 3)}', '1.2.3');
  });
}
