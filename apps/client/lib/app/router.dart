import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/check_in/check_in_screen.dart';
import '../features/journal/journal_editor_screen.dart';
import '../features/journal/journal_labels.dart';
import '../features/journal/journal_screen.dart';
import '../features/journal/journal_section_screen.dart';
import '../features/search/search_screen.dart';
import '../features/sessions/session_editor_screen.dart';
import '../features/sessions/session_list_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/tasks/task_editor_screen.dart';
import '../features/tasks/task_list_screen.dart';
import '../features/timeline/timeline_screen.dart';
import 'home_shell.dart';

DateTime? _parseMonth(String? value) {
  if (value == null) return null;
  final parts = value.split('-');
  if (parts.length != 2) return null;
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  if (year == null || month == null) return null;
  return DateTime(year, month);
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/timeline',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/timeline',
                builder: (context, state) => const TimelineScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/journal',
                builder: (context, state) => const JournalScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sessions',
                builder: (context, state) => const SessionListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TaskListScreen(),
              ),
            ],
          ),
        ],
      ),

      // Editors and settings are pushed over the shell (no nav frame).
      GoRoute(
        path: '/check-in',
        builder: (context, state) => const CheckInScreen(),
      ),
      GoRoute(
        path: '/journal/section/:section',
        builder: (context, state) => JournalSectionScreen(
          section: journalSectionFromName(state.pathParameters['section']),
        ),
      ),
      GoRoute(
        path: '/journal/new',
        builder: (context, state) {
          final q = state.uri.queryParameters;
          return JournalEditorScreen(
            section: journalSectionFromName(q['section']),
            isMonthlyReview: q['review'] != null,
            reviewMonth: _parseMonth(q['review']),
          );
        },
      ),
      GoRoute(
        path: '/journal/:id',
        builder: (context, state) =>
            JournalEditorScreen(entryId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/sessions/new',
        builder: (context, state) => const SessionEditorScreen(),
      ),
      GoRoute(
        path: '/sessions/:id',
        builder: (context, state) =>
            SessionEditorScreen(sessionId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/tasks/new',
        builder: (context, state) => const TaskEditorScreen(),
      ),
      GoRoute(
        path: '/tasks/:id',
        builder: (context, state) =>
            TaskEditorScreen(taskId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
