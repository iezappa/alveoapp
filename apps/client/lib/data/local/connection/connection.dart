// Platform-specific database connections.
//
// Native (desktop/mobile) opens a file-backed SQLite database; web opens a
// WASM SQLite database persisted in the browser. Tests use an in-memory one.
export 'unsupported.dart'
    if (dart.library.io) 'native.dart'
    if (dart.library.js_interop) 'web.dart';
