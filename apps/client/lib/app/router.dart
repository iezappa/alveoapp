import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/check_in/check_in_screen.dart';
import '../features/journal/journal_editor_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/timeline/timeline_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const TimelineScreen(),
      ),
      GoRoute(
        path: '/check-in',
        builder: (context, state) => const CheckInScreen(),
      ),
      // '/journal/new' must precede '/journal/:id' so "new" is not read as an id.
      GoRoute(
        path: '/journal/new',
        builder: (context, state) => const JournalEditorScreen(),
      ),
      GoRoute(
        path: '/journal/:id',
        builder: (context, state) =>
            JournalEditorScreen(entryId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
