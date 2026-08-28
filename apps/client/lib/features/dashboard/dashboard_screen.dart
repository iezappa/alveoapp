import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../data/local/database.dart';
import '../../domain/greeting.dart';
import '../../l10n/app_localizations.dart';
import 'dashboard_providers.dart';

/// The welcome screen and app entry point: a greeting, the next session, a
/// shortcut to the daily check-in, and a way into the breathing exercise.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final nextSession = ref.watch(nextSessionProvider);

    final greeting = switch (dayPartFor(DateTime.now())) {
      DayPart.morning => l10n.dashboardGreetingMorning,
      DayPart.afternoon => l10n.dashboardGreetingAfternoon,
      DayPart.evening => l10n.dashboardGreetingEvening,
      DayPart.night => l10n.dashboardGreetingNight,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: l10n.navSettings,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(kGutter, kGutter, kGutter, 32),
            children: [
              Text(
                greeting,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.dashboardSafeHere,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              _NextSessionCard(session: nextSession),
              const SizedBox(height: 12),
              const _CheckInCard(),
              const SizedBox(height: 12),
              const _BreatheCard(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Relative-day suffix (" · Today" / " · Tomorrow") for a session date, empty
/// when it is further out.
String _relativeSuffix(BuildContext context, DateTime when) {
  final l10n = AppLocalizations.of(context);
  final now = DateTime.now();
  final days = DateTime(when.year, when.month, when.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
  return switch (days) {
    0 => '  ·  ${l10n.dashboardToday}',
    1 => '  ·  ${l10n.dashboardTomorrow}',
    _ => '',
  };
}

class _NextSessionCard extends StatelessWidget {
  const _NextSessionCard({required this.session});

  final AsyncValue<Session?> session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();

    final body = switch (session) {
      AsyncData(:final value?) => [
        Text(DateFormat.yMMMMEEEEd(locale).format(value.scheduledFor)),
        const SizedBox(height: 2),
        Text(
          DateFormat.jm(locale).format(value.scheduledFor) +
              _relativeSuffix(context, value.scheduledFor),
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton.icon(
            onPressed: () => context.push('/sessions/${value.id}'),
            icon: const Icon(Icons.description_outlined, size: 18),
            label: Text(l10n.dashboardNotes),
          ),
        ),
      ],
      AsyncData() => [
        Text(
          l10n.dashboardNextSessionNone,
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton.icon(
            onPressed: () => context.push('/sessions/new'),
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.dashboardScheduleSession),
          ),
        ),
      ],
      AsyncError() => [
        Text(
          l10n.dashboardNextSessionNone,
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
      ],
      _ => [
        const SizedBox(
          height: 20,
          child: Center(child: LinearProgressIndicator()),
        ),
      ],
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event_outlined, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.dashboardNextSession,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...body,
          ],
        ),
      ),
    );
  }
}

class _CheckInCard extends StatelessWidget {
  const _CheckInCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/check-in'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 20,
                    color: scheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.dashboardCheckInTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.dashboardCheckInPrompt,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreatheCard extends StatelessWidget {
  const _BreatheCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dashboardBreatheTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.dashboardBreathePrompt,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () => context.push('/breathe'),
              icon: const Icon(Icons.air, size: 18),
              label: Text(l10n.breatheAction),
            ),
          ],
        ),
      ),
    );
  }
}
