import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../domain/greeting.dart';
import '../../domain/insights/mood_trend.dart';
import '../../domain/motivation/daily_quotes.dart';
import '../../app/user_profile_controller.dart';
import '../../l10n/app_localizations.dart';
import '../insights/sparkline.dart';
import '../shared/name_dialog.dart';
import 'dashboard_providers.dart';

/// The welcome screen and app entry point: a greeting, the next session, a
/// shortcut to the daily check-in, and a way into the breathing exercise.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  /// Guards the one-time first-launch name prompt so a rebuild cannot queue
  /// a second dialog while the first is still open.
  bool _namePromptScheduled = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final nextSession = ref.watch(nextSessionProvider);
    final name = ref.watch(userProfileControllerProvider).asData?.value;
    final nameLoaded = ref.watch(userProfileControllerProvider) is AsyncData;
    final promptForNameEnabled = ref.watch(promptForNameOnFirstLaunchProvider);

    if (promptForNameEnabled &&
        nameLoaded &&
        name == null &&
        !_namePromptScheduled) {
      _namePromptScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) promptForName(context, ref, dismissible: false);
      });
    }

    final greetingBase = switch (dayPartFor(DateTime.now())) {
      DayPart.morning => l10n.dashboardGreetingMorning,
      DayPart.afternoon => l10n.dashboardGreetingAfternoon,
      DayPart.evening => l10n.dashboardGreetingEvening,
      DayPart.night => l10n.dashboardGreetingNight,
    };
    final greeting = name == null || name.isEmpty
        ? '$greetingBase.'
        : l10n.dashboardGreetingNamed(greetingBase, name);

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
              const _QuoteCard(),
              const SizedBox(height: 12),
              const _MoodTrendCard(),
              const SizedBox(height: 16),
              const _QuickLinks(),
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
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.history, size: 20),
                    onPressed: () => context.push('/mood-history'),
                    tooltip: l10n.moodHistoryTitle,
                  ),
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

/// A 14-day sparkline of the daily average mood.
class _MoodTrendCard extends ConsumerWidget {
  const _MoodTrendCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final entries = ref.watch(moodEntriesProvider).asData?.value;
    final points = entries == null
        ? null
        : dailyMoodAverages(
            entries.map((e) => (occurredAt: e.occurredAt, mood: e.mood)),
            now: DateTime.now(),
          );
    final hasData = points != null && points.any((p) => p != null);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/insights'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.dashboardMoodTrend,
                    style: theme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
              const SizedBox(height: 12),
              if (hasData)
                Sparkline(values: points)
              else
                Text(
                  l10n.dashboardMoodTrendEmpty,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact links to the safety plan and the medication log.
class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/safety-plan'),
            icon: const Icon(Icons.health_and_safety_outlined, size: 18),
            label: Text(l10n.dashboardSafetyPlan),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/medications'),
            icon: const Icon(Icons.medication_outlined, size: 18),
            label: Text(l10n.dashboardMedications),
          ),
        ),
      ],
    );
  }
}

/// The quote of the day, with a shortcut into the breathing exercise. Tapping
/// the card opens the full library.
class _QuoteCard extends StatelessWidget {
  const _QuoteCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final quote = quoteForDay(DateTime.now());
    final lang = Localizations.localeOf(context).languageCode;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/library'),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.format_quote,
                color: scheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                quote.text(lang),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                quote.attribution,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FilledButton.icon(
                  onPressed: () => context.push('/breathe'),
                  icon: const Icon(Icons.air, size: 18),
                  label: Text(l10n.breatheAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
