import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<String?> saveTextFile({
  required String suggestedName,
  required String contents,
  required String typeLabel,
  required List<String> extensions,
}) async {
  _download(suggestedName, utf8.encode(contents), 'text/plain;charset=utf-8');
  return suggestedName;
}

Future<String?> saveBytesFile({
  required String suggestedName,
  required List<int> bytes,
  required String typeLabel,
  required List<String> extensions,
}) async {
  _download(suggestedName, bytes, 'application/octet-stream');
  return suggestedName;
}

void _download(String name, List<int> bytes, String mimeType) {
  final data = Uint8List.fromList(bytes);
  final blob = web.Blob([data.toJS].toJS, web.BlobPropertyBag(type: mimeType));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = name
    ..style.display = 'none';
  web.document.body!.appendChild(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
}
