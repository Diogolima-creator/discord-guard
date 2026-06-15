#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GUARD="$ROOT/bin/discord-guard"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "$TMP_HOME"' EXIT

check() {
  local timestamp="$1"
  local expected="$2"
  local actual
  actual="$(HOME="$TMP_HOME" DISCORD_GUARD_NOW="$timestamp" DISCORD_GUARD_NO_NOTIFY=1 "$GUARD" status --json | python3 -c 'import json,sys; print(json.load(sys.stdin)["effective_blocked"])')"
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

HOME="$TMP_HOME" "$GUARD" config set --start 21:30 --end 07:15 --days mon >/dev/null
check "2026-06-15T21:29:00-04:00" "False"
check "2026-06-15T21:30:00-04:00" "True"
check "2026-06-16T07:14:00-04:00" "True"
check "2026-06-16T07:15:00-04:00" "False"
check "2026-06-17T21:30:00-04:00" "False"

HOME="$TMP_HOME" "$GUARD" config set --blocks '[{"start":"08:00","end":"09:00","days":["mon"]},{"start":"22:00","end":"23:00","days":["mon"]}]' >/dev/null
check "2026-06-15T08:30:00-04:00" "True"
check "2026-06-15T09:30:00-04:00" "False"
check "2026-06-15T22:30:00-04:00" "True"
check "2026-06-16T08:30:00-04:00" "False"

echo "schedule tests passed"
