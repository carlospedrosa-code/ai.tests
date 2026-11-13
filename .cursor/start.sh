#!/usr/bin/env bash
set -euo pipefail

cd "${CURSOR_WORKSPACE:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
PORT=8080
TMUX_CONF=/exec-daemon/tmux.portal.conf

if curl -sf "http://127.0.0.1:${PORT}/README.md" >/dev/null 2>&1; then
  exit 0
fi

if ! tmux -f "$TMUX_CONF" has-session -t dev_http 2>/dev/null; then
  tmux -f "$TMUX_CONF" new-session -d -s dev_http -c "$PWD" -- \
    python3 -m http.server "$PORT" --bind 127.0.0.1
fi

for _ in $(seq 1 30); do
  if curl -sf "http://127.0.0.1:${PORT}/README.md" >/dev/null 2>&1; then
    exit 0
  fi
  sleep 0.5
done

echo "Dev HTTP server did not become ready on port ${PORT}" >&2
exit 1
