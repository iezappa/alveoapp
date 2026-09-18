# TODO

What is open in Alveo, and what to re-check against the standard.

The standard is
[standardizer_multiplatform](https://github.com/iezappa/standardizer_multiplatform).
It is the canonical copy: the `Estandarizador/` folder here is a working copy,
ignored by git, and loses to that repository on any disagreement.

This app is the canonical reference for §2.2, the settings layout — the other
apps were migrated to match it. Changing settings here changes the standard,
so the edit belongs in that repository first.

Last checked against it: **2026-09-18**.

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
- [x] Warning before every unencrypted export (JSON, CSV, Obsidian, session
      PDF, daily Markdown). It was mutable for the session until Phase 4, when
      the mute was removed.
- [x] Web PIN caveat in the PIN section and the new-PIN dialog.

## Open

### P1

- [ ] Re-verify the crisis numbers at asistenciaalsuicida.org.ar before each
      release (TODO in `lib/features/safety/crisis_resources.dart`). 0800 345
      1435 is listed in CUMPLIMIENTO.md but was left out as unverified.
- [ ] Check the CSP in `deploy/nginx.conf` in a browser against the Docker
      image: the directives were read off the built output, not exercised.
      Watch the console for CSP violations, especially around the CanvasKit
      workers and the fonts.
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

- [ ] Drift's generated row classes are still the domain entities: the
      repository interfaces in `lib/domain/repositories/` import
      `data/local/database.dart`. Giving the domain its own entities and a
      mapping layer is the next step, and only pays for itself when a second
      data source exists.
- [ ] The Android build has never run: this machine has no Android SDK, so
      the Gradle signing config, the manifest queries, the file_picker save
      path and `tool/release_apk.sh` past its pure checks are unverified.
      Same for the Windows and macOS jobs and the Docker image.
- [ ] Record the release keystore fingerprint in `docs/SIGNING.md` (it says
      `PENDING`) before the first APK is published.
- [ ] Run the §8.2 service-worker checklist in a real browser before the
      first release that touches `web/`: scope, cache contents, offline
      launch, the update flow and the kill switch.
- [ ] The working copy under `Estandarizador/` is stale — it predates §2.2.
      Refresh it from the canonical repository, or read the standard there.
- [ ] Schema dumps v1–v7 were reconstructed from history, so the migration
      tests validate against a derived ground truth. From the next release
      that moves the schema, capture the dump at release time from the tagged
      commit (docs/RELEASING.md, "Database schema dumps").
- [ ] The CI step that expects `assembleRelease --dry-run` to be refused by
      the signing gate has not run yet (no Android SDK here). Watch the first
      CI run: if Gradle does not fire `taskGraph.whenReady` under
      `--dry-run`, the step fails with "a release build was planned".
- [ ] The migration stays inside one transaction, and v9's `alterTable`
      turns `PRAGMA foreign_keys = OFF` into a no-op there. That is safe only
      because nothing enables foreign keys before `beforeOpen`; keep it so.
- [ ] The integration test walks the bottom bar and asserts no section throws.
      The flows worth adding next are the ones with something at stake: a
      check-in written and read back, and the PIN lock.

---

## Resolved (Phases 2 and 3, 2026-09-17)

- [x] `PRIVACY.md` and `TERMS.md` (Profile A, sensitive health data under Ley
      25.326), bundled in both languages and readable offline from About,
      alongside contact and licences.
- [x] Settings in the §2.2 order, with a layout test and `meetsGuideline`
      (tap targets, labels, contrast) on Settings and the five tabs in light
      and dark.
- [x] Drift schema dumps v1–v9 and a migration test from every version ever
      shipped, data included.
- [x] CSV export for reading, next to the JSON backup.
- [x] Android platform, release signing that refuses to build without the
      keystore, `tool/release_apk.sh` and `docs/SIGNING.md` / `RELEASING.md`.
- [x] Release notes dialog after an update, from a changelog asset.
- [x] Repository interfaces in `domain`, Drift implementations behind them,
      and a test that keeps `drift` out of the screens.
- [x] `updatedAt` on every table (schema v9) and in the backup (format 2).
- [x] Own service worker (`web/sw.js`, `web/flutter_bootstrap.js`,
      `tool/generate_sw.sh`), wired into the Pages deploy.
- [x] `UpdateService` (§8.2) with the banner, the six-hour throttle and the
      backup prompt on a schema change.
- [x] `release.yml` for Linux, Windows, macOS, web and GHCR, with the
      compliance gate; Windows and macOS platforms added.
- [x] `deploy/` (Dockerfile, nginx with COOP/COEP, compose for ZimaOS on port
      8083, ZIMAOS.md) and a README with the backup warning, crisis lines and
      per-device install.

---

## Resolved (Phase 4, security review, 2026-09-18)

- [x] Android backup opt-out: `allowBackup="false"` plus
      `data_extraction_rules.xml` (cloud backup and device transfer) and
      `full_backup_content.xml`, so the Drift database — therapy notes and the
      PIN salt/hash — is never copied to a Google account or a new phone.
      Guarded by `test/tooling/android_backup_test.dart`; PRIVACY.md, the
      bundled legal documents and the README say so.
- [x] The unencrypted-export warning can no longer be silenced. Muting it once
      used to let every later export of any kind write in the clear without a
      word.
- [x] Every GitHub action pinned to a full commit SHA with its version in a
      comment (`ci.yml`, `deploy-web.yml`, `release.yml`), and the release
      scripts take `github.ref_name` and the repository name from the
      environment instead of `${{ }}` inside the script body.
- [x] `deploy/Dockerfile` defaults to the pinned Flutter image and the docker
      job passes `FLUTTER_IMAGE` from `FLUTTER_VERSION`, so the published
      image is built with the same SDK as everything else.
- [x] `deploy/nginx.conf` sends a Content-Security-Policy, `frame-ancestors
      'none'` / `X-Frame-Options: DENY` and `Referrer-Policy: no-referrer` on
      the documents it serves.

## Resolved (Phase 5, reliability review, 2026-09-18)

- [x] Migrations are crash-atomic: one transaction around `onUpgrade`, and
      every step idempotent (`_addColumnIfMissing`, v9 skips tables already
      rebuilt), so a store half-upgraded by an earlier build still opens.
      `migration_interrupted_test.dart` builds those states by hand.
- [x] `release.yml` runs format, analyze and test in a `check` job that every
      build job needs; `test/ci/release_workflow_test.dart` walks `needs`.
- [x] `updatedAt` coverage for every table. Replacing a journal entry's
      emotions and linking/unlinking session items now stamp the parent,
      since a deleted child row leaves nothing behind to carry the change.
- [x] The layering test says it is an import check, and resolves every
      repository provider against one database at runtime.
- [x] CI asks Gradle to plan a release build and expects the signing gate to
      refuse it.
- [x] Update checks report an unreadable answer (debug console only), never
      being offline.
- [x] The CSV export also defuses formulas behind a leading tab or CR.

---

## To re-check against the standard

Not a list of known faults — a list of what drifts silently. Walk it when the
standard changes, or before a release.

- [ ] **§2.2 Settings layout.** One flat column, sections in the fixed order,
      no card per section, every `ListTile` at `contentPadding: EdgeInsets.zero`,
      the disclaimer printed in full. This app defines that layout; a widget
      test asserting the structure keeps the reference honest, since a drift
      here silently redefines the standard for everyone.

**§2.2 Settings** — Conforming: yes · Last reviewed: 2026-09-17 ·
Asserted by: `apps/client/test/features/settings/settings_layout_test.dart`

- [x] Body inside the shared page widget, with a maximum width
- [x] One flat column — no section wrapped in a `Card`
- [x] Every section opened by `SectionLabel`, in capitals
- [x] Sections in the fixed order, with Obsidian (this app's own) before SUPPORT
- [x] Separated by `Gap.vSection` — no loose `SizedBox(height: 28)`
- [x] Every `ListTile` at `contentPadding: EdgeInsets.zero`
- [x] Fixed short option sets in `SegmentedButton`, not `DropdownButton`
- [x] The support block is the only `Card`, and prints no title of its own
- [x] Disclaimer printed in full, outside any `ListTile`
- [x] Profile A: backup notice first in YOUR DATA
- [x] "Delete all my data" last in YOUR DATA, with confirmation
- [x] ABOUT with privacy, terms, contact and licences
- [x] `meetsGuideline` for tap targets and contrast, light and dark
- [x] Layout test present and green

Deliberate deviation, to carry back to the canonical repository: Obsidian sync
is hidden on Android as well as on the web — it needs a vault folder on the
filesystem, which the Storage Access Framework does not give.
- [ ] **§2.1 Product patterns.** i18n through ARB files, onboarding shown once,
      local PIN, disclaimer accepted at onboarding and visible in settings,
      JSON import/export.
- [ ] **§5 CI.** Analyse, format and test before deploying, not only building.
- [ ] **§8.1/§8.2.** APK signed with the fixed keystore, update banner,
      release notes, own service worker.
- [ ] **§7 Testing.** Widget tests for the screens, `integration_test` for the
      critical flows.

A change decided here and not carried back to the canonical repository is not
a standard — it is an exception the next project will never hear about.
