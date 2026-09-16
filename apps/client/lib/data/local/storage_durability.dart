/// How much the storage the database landed on can be trusted with.
///
/// Native platforms write a SQLite file and are always [durable]. The web
/// build takes whatever the browser allows, and drift says which it chose.
enum StorageDurability {
  /// Written to a real file: the origin private file system, or disk.
  durable,

  /// IndexedDB. It persists, but lazily: a reload or a browser clean-up at
  /// the wrong moment can lose recent writes.
  degraded,

  /// Memory only. Nothing survives closing the tab.
  volatile,
}

/// Maps drift's `WasmStorageImplementation` to a [StorageDurability].
///
/// Takes the enum's name rather than the enum itself: the type lives in
/// `package:drift/wasm.dart`, which only compiles for the web, and this
/// decision is worth testing on the VM.
StorageDurability durabilityOfImplementation(String name) => switch (name) {
  'opfsShared' || 'opfsLocks' => StorageDurability.durable,
  'inMemory' => StorageDurability.volatile,
  // IndexedDB, and anything a future drift adds: not known to be durable, so
  // not claimed to be.
  _ => StorageDurability.degraded,
};
