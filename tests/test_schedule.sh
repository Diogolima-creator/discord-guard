#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GUARD="$ROOT/bin/discord-guard"

check() {
  local timestamp="$1"
  local expected="$2"
  local actual
  actual="$(DISCORD_GUARD_NOW="$timestamp" DISCORD_GUARD_NO_NOTIFY=1 "$GUARD" status --json | python3 -c 'import json,sys; print(json.load(sys.stdin)["effective_blocked"])')"
  if [[ "$actual" != "$expected" ]]; then
    echo "FAIL $timestamp expected=$expected actual=$actual" >&2
    exit 1
  fi
}

check "2026-06-15T19:59:00-04:00" "False"
check "2026-06-15T20:00:00-04:00" "True"
check "2026-06-16T05:59:00-04:00" "True"
check "2026-06-16T06:00:00-04:00" "False"
check "2026-06-19T20:00:00-04:00" "False"

echo "schedule tests passed"
