import 'package:drift/drift.dart';

QueryExecutor openConnection() =>
    throw UnsupportedError('No database backend for this platform.');

QueryExecutor openInMemory() =>
    throw UnsupportedError('In-memory database is only available natively.');
