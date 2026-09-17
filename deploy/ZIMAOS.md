# Serving Alveo from a ZimaOS server

This serves the web/PWA build of Alveo from a home ZimaOS server, so the
people in a household can install it without going through GitHub Pages.

**Read this first: the server only serves the app.** Check-ins, journal
entries, session notes — everything Alveo holds — stay in each person's own
browser storage on their own device. None of it reaches this server, and the
container has no volume and no database. Two people using the same server
share nothing, and see nothing of each other's. Recreating or updating the
container loses nothing, because there is nothing on it to lose.

The flip side: the only backup is each person's own export
(Settings → Your data → Export backup). Nobody can recover their data from
the server, because it was never there.

## Requirements

- ZimaOS with access to its web interface and to the internet.
- A release published by `.github/workflows/release.yml`, which pushes
  `ghcr.io/iezappa/alveoapp:<version>` and `:latest` for amd64 and arm64.

## 1. Publish the image

```bash
git tag v1.0.0 && git push origin v1.0.0
```

The first time, make the package public: GitHub → Packages → the package →
Package settings → Change visibility → Public. A private package cannot be
pulled by ZimaOS without credentials.

## 2. Install it

1. In ZimaOS open **App Store** → **"+"** → **Install a customized app**.
2. Use **Import** and paste `deploy/docker-compose.yml` as it is. It already
   names the image, the port (8083) and the icon; change the port only if
   something else on the server uses it.
3. **Install**, then check `http://<zimaos-ip>:8083` loads. That URL is for
   checking only — see the next section.

Menu names differ between ZimaOS versions; look for the custom install or
"import docker-compose" option in the App Store.

## 3. HTTPS for everyone else, with Tailscale

Installing a PWA, the service worker and OPFS storage all need a secure
context. `http://IP:port` loads in a browser but cannot be installed and
loses offline support, so it is not a way to hand the app to someone.

1. Install **Tailscale** from the ZimaOS App Store and sign in.
2. In the Tailscale admin console enable **MagicDNS** and **HTTPS
   Certificates**.
3. On the server:

   ```bash
   tailscale serve --bg http://127.0.0.1:8083
   tailscale serve status
   ```

   If Tailscale runs as a container, run it inside that container against the
   server's LAN address instead of `127.0.0.1`.
4. The app is then at `https://<server>.<your-tailnet>.ts.net/`.
5. Everyone installs Tailscale on their device and joins the tailnet.

**Always use the `ts.net` URL, at home too.** Browser storage is per origin:
data written while visiting the LAN IP does not exist when visiting the
`ts.net` name, and the app will look empty. One URL, everywhere.

## 4. Installing on each device

| Device | How |
|---|---|
| iPhone / iPad | Open the `ts.net` URL in **Safari** → Share → **Add to Home Screen**. Always open it from that icon: an installed, used web app keeps its storage, a Safari tab can lose it after a week of not visiting. |
| Android | Chrome → menu → **Install app**. Or the signed APK from GitHub Releases, which needs no server at all. |
| Windows / macOS / Linux | Chrome or Edge → the install icon in the address bar. Or the desktop build from GitHub Releases. |

After installing, open it once with a connection and check that an export
works.

## 5. Updating

1. Push a new tag; the workflow refreshes `:latest`.
2. On ZimaOS, update the app (or `docker pull ghcr.io/iezappa/alveoapp:latest`)
   and restart it so the container is recreated.
3. The next time someone opens the app with a connection, the service worker
   fetches the new version in the background and the app shows "A new version
   is available". Nothing swaps under a page that is in use until they tap
   Update.

When a release changes the local schema, the migration runs on each device,
on the only copy of that person's data. The banner asks for a backup first
for exactly that reason — say so in the release notes too.
