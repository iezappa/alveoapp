import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Runs [save] and tells the user when it throws; returns whether it worked.
///
/// A write kicked off from a button has no one waiting on its future: an
/// error there goes to the zone, and the user is left believing their entry
/// was kept. This turns it into a message they can act on. Callers stay where
/// they are on failure, so whatever was typed is still there to retry or copy.
/// The log gets the error only, never what was being saved.
Future<bool> saveOrReport(BuildContext context, Future<void> Function() save) =>
    _writeOrReport(
      context,
      save,
      message: AppLocalizations.of(context).saveFailed,
      log: 'Saving failed',
    );

/// Runs [delete] and tells the user when it throws; returns whether it worked.
///
/// Without it a refused delete leaves the record in place with nothing on
/// screen to say so. Callers stay where they are on failure.
Future<bool> deleteOrReport(
  BuildContext context,
  Future<void> Function() delete,
) => _writeOrReport(
  context,
  delete,
  message: AppLocalizations.of(context).deleteFailed,
  log: 'Deleting failed',
);

Future<bool> _writeOrReport(
  BuildContext context,
  Future<void> Function() write, {
  required String message,
  required String log,
}) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  try {
    await write();
    return true;
  } on Object catch (error, stack) {
    developer.log(log, name: 'alveo', error: error, stackTrace: stack);
    messenger?.showSnackBar(SnackBar(content: Text(message)));
    return false;
  }
}
