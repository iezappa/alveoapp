/// There is no service worker outside the browser.
Future<bool> hasWaitingServiceWorker() async => false;

Future<void> applyServiceWorkerUpdate() async {}
