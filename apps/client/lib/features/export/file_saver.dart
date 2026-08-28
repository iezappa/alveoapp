// A tiny cross-platform "save this to a file" helper: a native save dialog
// on desktop/mobile, a browser download on web. Returns the chosen path/name,
// or `null` if the user cancelled.
export 'file_saver_io.dart'
    if (dart.library.js_interop) 'file_saver_web.dart';
