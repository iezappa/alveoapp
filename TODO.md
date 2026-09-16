# TODO

What is open in Alveo, and what to re-check against the standard.

The standard is
[standardizer_multiplatform](https://github.com/iezappa/standardizer_multiplatform).
It is the canonical copy: the `Estandarizador/` folder here is a working copy,
ignored by git, and loses to that repository on any disagreement.

This app is the canonical reference for §2.2, the settings layout — the other
apps were migrated to match it. Changing settings here changes the standard,
so the edit belongs in that repository first.

Last checked against it: **2026-09-16**.

---

## Resolved (Phase 1, 2026-09-16)

- [x] Web storage durability: the storage drift chose is reported, a banner
      warns when it is IndexedDB or memory, and `navigator.storage.persist()`
      is requested at startup.
- [x] A database that will not open shows a recovery screen (import a backup
      or reset, both confirmed, never automatic) instead of failing every
      screen; the app restarts from a fresh provider container.
- [x] Backup notice (§5.A): accepted in onboarding (existing users once),
      always visible above the export in Settings → Data, and a reminder
      banner after 30 days without an export (7-day snooze).
- [x] "Delete all my data" (CUMPLIMIENTO 20): typed confirmation, export
      first, wipes every table and setting except language/theme/accent,
      clears the PIN and returns to onboarding.
- [x] Disclaimer accepted at onboarding (existing users once); crisis lines
      (Línea 135, (011) 5275-1135, 911) in Settings → About, at the top of the
      safety plan and in the disclaimer.
- [x] Warning before every unencrypted export (JSON, Obsidian, session PDF,
      daily Markdown), mutable for the session only.
- [x] Web PIN caveat in the PIN section and the new-PIN dialog.

## Open

### P1

- [ ] Re-verify the crisis numbers at asistenciaalsuicida.org.ar before each
      release (TODO in `lib/features/safety/crisis_resources.dart`). 0800 345
      1435 is listed in CUMPLIMIENTO.md but was left out as unverified.
- [ ] Check the web behaviour in real browsers: which storage drift picks on
      GitHub Pages (no COOP/COEP headers, so likely IndexedDB), whether
      `persist()` is granted, and that recovery really deletes the browser
      database. Only covered by VM tests so far.
- [ ] Integration test for "Delete all my data": after erasing, the database
      is empty and onboarding appears (CUMPLIMIENTO 20 asks for it).
- [ ] The PIN hash lives in the same database it guards, and nothing is
      encrypted at rest. Real protection needs SQLCipher (native) and stays a
      deterrent on the web.

### P2

- [ ] Repositories are concrete classes wired in `lib/data/providers.dart`;
      move to interfaces when a second data source appears.
- [ ] Settings still says "Data", where §2.2 names the section `TUS DATOS` /
      "Your data".
- [ ] About lacks privacy policy, terms, contact and licences links (the ACERCA DE
      order in CUMPLIMIENTO.md) and the README lacks the backup section (§5.A.4).
- [ ] Android platform is not added yet.
- [ ] The working copy under `Estandarizador/` is stale — it predates §2.2.
      Refresh it from the canonical repository, or read the standard there.
- [ ] The integration test walks the bottom bar and asserts no section throws.
      The flows worth adding next are the ones with something at stake: a
      check-in written and read back, and the PIN lock.

---

## To re-check against the standard

Not a list of known faults — a list of what drifts silently. Walk it when the
standard changes, or before a release.

- [ ] **§2.2 Settings layout.** One flat column, sections in the fixed order,
      no card per section, every `ListTile` at `contentPadding: EdgeInsets.zero`,
      the disclaimer printed in full. This app defines that layout; a widget
      test asserting the structure keeps the reference honest, since a drift
      here silently redefines the standard for everyone.
- [ ] **§2.1 Product patterns.** i18n through ARB files, onboarding shown once,
      local PIN, disclaimer accepted at onboarding and visible in settings,
      JSON import/export.
- [ ] **§5 CI.** Analyse and test before deploying, not only building.
- [ ] **§7 Testing.** Widget tests for the screens, `integration_test` for the
      critical flows.

A change decided here and not carried back to the canonical repository is not
a standard — it is an exception the next project will never hear about.
