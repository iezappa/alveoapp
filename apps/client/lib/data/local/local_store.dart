// Deletes the database storage itself, without opening it.
//
// A store that cannot be opened cannot be emptied with SQL either, so the
// only way back from one is to remove what is underneath: the SQLite file on
// native platforms, the browser database on the web. Close every connection
// to it first.
export 'local_store_native.dart'
    if (dart.library.js_interop) 'local_store_web.dart';
