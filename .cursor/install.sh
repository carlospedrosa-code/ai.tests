#!/usr/bin/env bash
set -euo pipefail

cd "${CURSOR_WORKSPACE:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"

if [[ ! -f README.md ]]; then
  echo "Expected README.md in repository root" >&2
  exit 1
fi

echo "ai.tests workspace ready"
