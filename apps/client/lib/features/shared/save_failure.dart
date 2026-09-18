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
Future<bool> saveOrReport(
  BuildContext context,
  Future<void> Function() save,
) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final message = AppLocalizations.of(context).saveFailed;
  try {
    await save();
    return true;
  } on Object catch (error, stack) {
    developer.log(
      'Saving failed',
      name: 'alveo',
      error: error,
      stackTrace: stack,
    );
    messenger?.showSnackBar(SnackBar(content: Text(message)));
    return false;
  }
}
