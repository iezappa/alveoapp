import 'dart:js_interop';

import 'package:web/web.dart' as web;

@JS('appServiceWorker')
external _AppServiceWorker? get _appServiceWorker;

extension type _AppServiceWorker._(JSObject _) implements JSObject {
  external JSPromise<JSBoolean> checkForUpdate();
  external JSPromise<JSAny?> applyUpdate();
}

/// True when sw.js has a new version installed and waiting for the user.
Future<bool> hasWaitingServiceWorker() async {
  final sw = _appServiceWorker;
  if (sw == null) return false;
  try {
    return (await sw.checkForUpdate().toDart).toDart;
  } on Object {
    return false; // Offline is a normal case.
  }
}

/// Activates the waiting worker and reloads; a plain reload without one.
Future<void> applyServiceWorkerUpdate() async {
  final sw = _appServiceWorker;
  if (sw == null) {
    web.window.location.reload();
    return;
  }
  await sw.applyUpdate().toDart;
}
