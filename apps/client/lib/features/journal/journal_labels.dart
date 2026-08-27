import 'package:flutter/material.dart';

import '../../domain/journal/journal_section.dart';
import '../../l10n/app_localizations.dart';

extension JournalSectionUi on JournalSection {
  String label(AppLocalizations l10n) => switch (this) {
    JournalSection.oneLiner => l10n.journalSectionOneLiner,
    JournalSection.student => l10n.journalSectionStudent,
    JournalSection.creative => l10n.journalSectionCreative,
    JournalSection.freedom => l10n.journalSectionFreedom,
    JournalSection.therapy => l10n.journalSectionTherapy,
    JournalSection.winLog => l10n.journalSectionWinLog,
  };

  IconData get icon => switch (this) {
    JournalSection.oneLiner => Icons.short_text,
    JournalSection.student => Icons.school_outlined,
    JournalSection.creative => Icons.palette_outlined,
    JournalSection.freedom => Icons.air,
    JournalSection.therapy => Icons.spa_outlined,
    JournalSection.winLog => Icons.emoji_events_outlined,
  };
}

/// Resolves a section from its [JournalSection.name], falling back to
/// [JournalSection.oneLiner] for anything unknown.
JournalSection journalSectionFromName(String? name) => JournalSection.values
    .firstWhere((s) => s.name == name, orElse: () => JournalSection.oneLiner);
