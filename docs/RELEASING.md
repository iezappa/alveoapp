# Releasing

APKs are built and signed on the maintainer's machine and attached to the
GitHub release with `apps/client/tool/release_apk.sh`; the keystore never
reaches CI. Keystore location, backup, `key.properties` and the recorded
certificate fingerprint are in [`SIGNING.md`](SIGNING.md). The general
procedure is the shared standard,
[`FIRMA-ANDROID.md`](https://github.com/iezappa/standardizer_multiplatform/blob/main/FIRMA-ANDROID.md).

## Android APK

Requirements: the Android SDK with build-tools (`apksigner` on `PATH` or under
`$ANDROID_HOME`), Flutter, an authenticated `gh`, and the signing setup in
[`SIGNING.md`](SIGNING.md).

1. Bump `version:` in `apps/client/pubspec.yaml`, commit.
2. Tag and push the tag: `git tag vX.Y.Z && git push origin vX.Y.Z`.
3. Create the GitHub release. A release workflow that builds the other
   artifacts is still pending (P1, see `TODO.md`); until then create it by hand
   with `gh release create vX.Y.Z`.
4. With a clean tree checked out at the tag:

   ```bash
   git fetch --tags && git checkout vX.Y.Z
   cd apps/client
   tool/release_apk.sh --dry-run vX.Y.Z   # builds and verifies, no upload
   tool/release_apk.sh vX.Y.Z
   ```

   It checks the tree, the tag, the pubspec version, `key.properties` and the
   keystore it points to, `apksigner`, `gh` and the release; builds; compares
   the certificate with `docs/SIGNING.md` (or `APK_CERT_SHA256`) and stops on a
   mismatch; and uploads `alveoapp-vX.Y.Z-android.apk` plus its `.sha256`
   (the name the README and Obtainium expect).

The script's pure checks are covered by `tool/release_apk_test.sh`.

## Database schema dumps

`apps/client/drift_schemas/` is the ground truth the migration tests validate
against. v1–v7 were not captured when they shipped: they were reconstructed
from history by dumping the code at the last commit of each version, so those
tests check the migrations against a derived shape, not the one users' stores
actually have. From the next release on, capture the dump **at release time**,
from the tagged commit, whenever `currentSchemaVersion` moved:

    cd apps/client
    dart run drift_dev schema dump lib/data/local/database.dart drift_schemas/
    dart run drift_dev schema generate --data-classes --companions \
      drift_schemas/ test/generated_migrations/

Commit it with the release. A dump taken later from a different commit is a
reconstruction again.
