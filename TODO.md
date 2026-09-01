# TODO

What is open in Alveo, and what to re-check against the standard.

The standard is
[standardizer_multiplatform](https://github.com/iezappa/standardizer_multiplatform).
It is the canonical copy: the `Estandarizador/` folder here is a working copy,
ignored by git, and loses to that repository on any disagreement.

This app is the canonical reference for §2.2, the settings layout — the other
apps were migrated to match it. Changing settings here changes the standard,
so the edit belongs in that repository first.

Last checked against it: **2026-09-01**.

---

## Open

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
