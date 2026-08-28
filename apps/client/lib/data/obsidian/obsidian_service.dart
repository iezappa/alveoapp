// Obsidian vault sync is a filesystem feature: the real implementation on
// native, a stub that refuses on web.
export 'obsidian_service_io.dart'
    if (dart.library.js_interop) 'obsidian_service_web.dart';
