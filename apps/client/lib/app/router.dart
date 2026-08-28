import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/breathe/breathe_screen.dart';
import '../features/cbt/thought_record_editor_screen.dart';
import '../features/cbt/tools_screen.dart';
import '../features/check_in/check_in_screen.dart';
import '../features/check_in/mood_history_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/journal/journal_editor_screen.dart';
import '../features/journal/journal_labels.dart';
import '../features/journal/journal_screen.dart';
import '../features/journal/journal_section_screen.dart';
import '../features/medication/medication_editor_screen.dart';
import '../features/medication/medications_screen.dart';
import '../features/motivation/library_screen.dart';
import '../features/safety/safety_plan_screen.dart';
import '../features/search/search_screen.dart';
import '../features/sessions/session_editor_screen.dart';
import '../features/sessions/sessions_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/tasks/task_editor_screen.dart';
import '../features/tasks/tasks_screen.dart';
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
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
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
                builder: (context, state) => const SessionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TasksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tools',
                builder: (context, state) => const ToolsScreen(),
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
        path: '/check-in/:id',
        builder: (context, state) =>
            CheckInScreen(moodEntryId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/mood-history',
        builder: (context, state) => const MoodHistoryScreen(),
      ),
      GoRoute(
        path: '/breathe',
        builder: (context, state) => const BreatheScreen(),
      ),
      GoRoute(
        path: '/library',
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: '/insights',
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/safety-plan',
        builder: (context, state) => const SafetyPlanScreen(),
      ),
      GoRoute(
        path: '/medications',
        builder: (context, state) => const MedicationsScreen(),
      ),
      GoRoute(
        path: '/medications/new',
        builder: (context, state) => const MedicationEditorScreen(),
      ),
      GoRoute(
        path: '/medications/:id',
        builder: (context, state) =>
            MedicationEditorScreen(medicationId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/thought-records/new',
        builder: (context, state) => const ThoughtRecordEditorScreen(),
      ),
      GoRoute(
        path: '/thought-records/:id',
        builder: (context, state) =>
            ThoughtRecordEditorScreen(recordId: state.pathParameters['id']),
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
