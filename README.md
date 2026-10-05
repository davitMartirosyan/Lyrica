# Lyrica

Monorepo for the Lyrica startup: **Expo React Native** mobile app + **Node/Express** API.

```
apps/
  mobile/   # iOS + Android (Expo + TypeScript)
  api/      # Backend API (Express + TypeScript)
```

## Prerequisites

- Node.js 20+
- [Expo Go](https://expo.dev/go) on a phone for the fastest mobile loop
- Optional later: Android Studio, macOS/Xcode, or [EAS](https://docs.expo.dev/eas/) cloud builds

## Setup

```bash
npm install
```

## Run

Terminal 1 — API:

```bash
npm run api
```

Terminal 2 — Mobile:

```bash
npm run mobile
```

Scan the Expo QR code with Expo Go.

## Test on iPhone (different network)

You do **not** need the same Wi‑Fi. Use a public tunnel:

```bash
npm run mobile:tunnel
```

Then on your iPhone:

1. Install **Expo Go** from the App Store  
2. Open Expo Go → **Enter URL manually**  
3. Paste the `exp://…trycloudflare.com:443` URL printed in the terminal  

Keep that terminal open while you test.

| Command | What it does |
| --- | --- |
| `npm run api` | Start API on http://localhost:3000 |
| `npm run mobile` | Start Expo (same Wi‑Fi / LAN) |
| `npm run mobile:tunnel` | Start Expo + public tunnel (different networks) |
| `npm run mobile:android` | Open on Android |
| `npm run mobile:ios` | Open on iOS simulator (macOS) |
| `npm run typecheck` | Typecheck mobile + API |
| `npm run doctor` | Expo health check |

## API

- `GET /` — service info
- `GET /health` — health check

Copy `apps/api/.env.example` → `apps/api/.env` to configure port / CORS.

## Mobile → API

Default API URL: `http://localhost:3000`

Override with:

```bash
EXPO_PUBLIC_API_URL=http://YOUR_LAN_IP:3000 npm run mobile
```

On an Android emulator use `http://10.0.2.2:3000`. On a physical device use your machine’s LAN IP.
