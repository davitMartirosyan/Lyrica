#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MOBILE="$ROOT/apps/mobile"
PORT="${PORT:-8081}"
BIN_DIR="$ROOT/bin"
CLOUDFLARED="$BIN_DIR/cloudflared"

ensure_cloudflared() {
  if [[ -x "$CLOUDFLARED" ]]; then
    return
  fi
  mkdir -p "$BIN_DIR"
  echo "Downloading cloudflared..."
  curl -fsSL -o "$CLOUDFLARED" \
    https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
  chmod +x "$CLOUDFLARED"
}

cleanup() {
  [[ -n "${TUNNEL_PID:-}" ]] && kill "$TUNNEL_PID" 2>/dev/null || true
  [[ -n "${EXPO_PID:-}" ]] && kill "$EXPO_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

ensure_cloudflared

echo "Starting Cloudflare tunnel on port $PORT..."
"$CLOUDFLARED" tunnel --url "http://127.0.0.1:$PORT" --protocol http2 > /tmp/lyrica-tunnel.log 2>&1 &
TUNNEL_PID=$!

PUBLIC_URL=""
for _ in $(seq 1 60); do
  PUBLIC_URL="$(grep -oE 'https://[a-z0-9-]+\.trycloudflare\.com' /tmp/lyrica-tunnel.log | head -1 || true)"
  if [[ -n "$PUBLIC_URL" ]]; then
    break
  fi
  sleep 1
done

if [[ -z "$PUBLIC_URL" ]]; then
  echo "Failed to create Cloudflare tunnel. Log:"
  cat /tmp/lyrica-tunnel.log
  exit 1
fi

HOST="${PUBLIC_URL#https://}"
echo ""
echo "========================================"
echo " Tunnel ready"
echo "========================================"
echo ""
echo " On iPhone:"
echo "  1. Install Expo Go from the App Store"
echo "  2. Open Expo Go"
echo "  3. Tap Enter URL manually"
echo "  4. Paste:"
echo ""
echo "     exp://${HOST}:443"
echo ""
echo " Keep this terminal open while testing."
echo "========================================"
echo ""

cd "$MOBILE"
EXPO_PACKAGER_PROXY_URL="$PUBLIC_URL" \
REACT_NATIVE_PACKAGER_HOSTNAME="$HOST" \
npx expo start --localhost --port "$PORT"
