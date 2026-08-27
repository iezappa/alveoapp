import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/check_in/check_in_screen.dart';
import '../features/journal/journal_editor_screen.dart';
import '../features/sessions/session_editor_screen.dart';
import '../features/sessions/session_list_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/tasks/task_editor_screen.dart';
import '../features/tasks/task_list_screen.dart';
import '../features/timeline/timeline_screen.dart';
import 'home_shell.dart';

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
        path: '/journal/new',
        builder: (context, state) => const JournalEditorScreen(),
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
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
