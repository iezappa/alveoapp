import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';

Future<XTypeGroup> _group(String label, List<String> extensions) async =>
    XTypeGroup(label: label, extensions: extensions);

/// file_selector has no save dialog on Android; there the system "create
/// document" picker (Storage Access Framework) writes the bytes instead.
Future<String?> _saveOnAndroid(String name, List<int> bytes) async {
  final uri = await FilePicker.saveFile(
    fileName: name,
    bytes: Uint8List.fromList(bytes),
  );
  return uri?.toString();
}

Future<String?> saveTextFile({
  required String suggestedName,
  required String contents,
  required String typeLabel,
  required List<String> extensions,
}) async {
  if (Platform.isAndroid) {
    return _saveOnAndroid(suggestedName, utf8.encode(contents));
  }
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
  if (Platform.isAndroid) return _saveOnAndroid(suggestedName, bytes);
  final location = await getSaveLocation(
    suggestedName: suggestedName,
    acceptedTypeGroups: [await _group(typeLabel, extensions)],
  );
  if (location == null) return null;
  await File(location.path).writeAsBytes(bytes);
  return location.path;
}
