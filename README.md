# Alveo

**A calm, private, local‑first companion for personal therapy work.**

Alveo is a single‑user app for keeping track of how you're doing between and around
therapy sessions: mood check‑ins, a Markdown journal, session preparation and notes,
homework from your therapist, CBT thought records, a breathing exercise, and simple
trends over time. Everything lives on your own device.

> **Disclaimer.** Alveo is a personal tracking tool. It is **not** a medical device,
> it does not provide diagnosis or treatment, and it is **not** a substitute for
> professional care. In an emergency, contact your local emergency services or your
> care provider.

---

## Highlights

- **Local‑first, no backend.** No account, no sync server, no telemetry, no ads, no
  AI. The app makes zero network calls. Your data never leaves the device.
- **Private by design.** Optional PIN lock with backoff on repeated failures. Backups
  are an explicit, user‑initiated file export.
- **Bilingual.** Full Spanish / English UI with a runtime toggle.
- **Warm, minimal design.** Material 3 with a warm cream palette and a serif display
  face; built to feel unhurried.
- **Runs on desktop and the web.** The web build installs as a PWA (add to home
  screen on iOS/Android).

## Features

| Area | What it does |
| --- | --- |
| **Daily check‑in** | 1–5 mood scale with weather‑style icons, Plutchik emotion wheel, context tags, and a short note. |
| **Journal** | Markdown entries organised into notebooks (day lines, study, creativity, …) plus a monthly review. |
| **Sessions** | Prepare an agenda, take notes during, capture takeaways after; link a session to related tasks, journal entries and check‑ins. |
| **Tasks** | Track the homework assigned by your therapist, with a closing note when you finish. |
| **Tools** | CBT thought records: situation → automatic thought → evidence → reframe, with belief ratings and cognitive‑distortion tags. |
| **Breathe** | A guided breathing exercise (box 4·4·4·4 or calm 4·7·8). |
| **Insights** | A 14‑day mood sparkline on the dashboard and a fuller trend chart + calendar view. |
| **See everything** | One read‑only stream of every text you've written, newest first. |
| **Library** | A short motivational quote for each day of the year. |
| **Safety plan** | A private, structured plan (warning signs, coping steps, contacts). |
| **Medications** | Track medications and log intakes. |
| **Backups** | Full database export / import as a single file, to move between devices. |
| **Obsidian export** | Write journal entries out as Markdown into an Obsidian vault (desktop only). |
| **Onboarding** | First‑run name prompt and a short tutorial, re‑openable from Settings. |

## Tech stack

- **Flutter** (Dart SDK `^3.13.1`), Material 3
- **Riverpod** for state, **go_router** for navigation
- **Drift** over SQLite for persistence — a native file on desktop, WebAssembly +
  IndexedDB on the web (schema v8, with forward migrations)
- **fl_chart** for trends, **pdf** for the doctor‑facing export, bundled **Lora** /
  **Lato** fonts

## Architecture

Feature‑first, with a framework‑free domain layer:

```
apps/client/lib/
  app/          # composition root: router, theme, locale, lock, onboarding
  domain/       # pure Dart: emotions, greeting, CBT, export renderers, …
  data/
    local/      # Drift database, tables, platform connections (native / web)
    repositories/  # one per aggregate, the only thing that touches Drift
    export/ transfer/ security/ search/ obsidian/
  features/     # one folder per screen area (UI + its providers)
  l10n/         # app_en.arb / app_es.arb (key parity is enforced by a test)
```

- Domain code has no Flutter or Drift imports and is unit‑tested in isolation.
- Screens read repository‑backed providers; list screens use a master–detail shell
  that becomes two‑pane on wide windows.
- Platform‑specific code (database connection, file saving, Obsidian) is selected
  with conditional imports.

## Running it

Prerequisites: Flutter (matching `apps/client/pubspec.yaml`; developed on 3.47.x).

```bash
cd apps/client
flutter pub get
flutter run -d linux      # or: -d macos / -d windows
flutter run -d chrome     # web
```

Regenerate the database code after changing tables:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Tests and checks:

```bash
flutter test
flutter analyze
```

## Web / PWA deployment

`.github/workflows/deploy-web.yml` builds the web app and publishes it to GitHub
Pages on every push to the default branch:

- `flutter build web --release --base-href "/<repo>/"`
- SPA fallback (`404.html`) and `.nojekyll` are added
- deployed with `actions/deploy-pages`

To install on a phone, open the published URL in Safari (iOS) or Chrome (Android)
and choose **Add to Home Screen**. Updates ship automatically on the next push; the
service worker picks up the new version on the following launch.

> **iOS note.** Safari may clear a PWA's local storage after roughly a week of
> disuse. Open the app regularly and export a backup from Settings from time to time.

## Data & privacy notes

- The SQLite database is **not encrypted at rest**. The PIN gates the UI, it does not
  encrypt data. Rely on full‑disk encryption (BitLocker / FileVault / LUKS) and treat
  exported backups as sensitive files.
- Nothing is uploaded. A publicly hosted web build still only ever sees an empty
  local database in each visitor's browser.

## Status

Personal project, single maintainer. Not published to any app store; the web PWA is
the supported distribution.
