import 'package:alveo/data/local/storage_durability.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('durabilityOfImplementation', () {
    test('trusts the origin private file system', () {
      expect(
        durabilityOfImplementation('opfsShared'),
        StorageDurability.durable,
      );
      expect(
        durabilityOfImplementation('opfsLocks'),
        StorageDurability.durable,
      );
    });

    test('calls IndexedDB degraded, since it persists lazily', () {
      expect(
        durabilityOfImplementation('sharedIndexedDb'),
        StorageDurability.degraded,
      );
      expect(
        durabilityOfImplementation('unsafeIndexedDb'),
        StorageDurability.degraded,
      );
    });

    test('calls memory volatile, since nothing survives a reload', () {
      expect(
        durabilityOfImplementation('inMemory'),
        StorageDurability.volatile,
      );
    });

    test('treats an implementation it does not know as degraded', () {
      expect(
        durabilityOfImplementation('somethingNew'),
        StorageDurability.degraded,
      );
    });
  });
}
