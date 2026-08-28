import 'dart:io';

import 'package:file_selector/file_selector.dart';

Future<XTypeGroup> _group(String label, List<String> extensions) async =>
    XTypeGroup(label: label, extensions: extensions);

Future<String?> saveTextFile({
  required String suggestedName,
  required String contents,
  required String typeLabel,
  required List<String> extensions,
}) async {
  final location = await getSaveLocation(
    suggestedName: suggestedName,
    acceptedTypeGroups: [await _group(typeLabel, extensions)],
  );
  if (location == null) return null;
  await File(location.path).writeAsString(contents);
  return location.path;
}

Future<String?> saveBytesFile({
  required String suggestedName,
  required List<int> bytes,
  required String typeLabel,
  required List<String> extensions,
}) async {
  final location = await getSaveLocation(
    suggestedName: suggestedName,
    acceptedTypeGroups: [await _group(typeLabel, extensions)],
  );
  if (location == null) return null;
  await File(location.path).writeAsBytes(bytes);
  return location.path;
}
