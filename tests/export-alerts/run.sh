#!/bin/bash

#
# Copyright (C) 2026 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Fixture test of imageroot/bin/export-alerts, no cscli needed.

set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
script="${here}/../../imageroot/bin/export-alerts"
work=$(mktemp -d)
trap 'rm -rf "${work}"' EXIT
cd "${work}"
export MODULE_ID=crowdsec-test

fail() { echo "FAIL: $*" >&2; exit 1; }

# Allowlisted fields only, sorted by id, non-ban and already exported alerts skipped.
"${script}" --input "${here}/alerts.json" --cursor 40 --dry-run 2>/dev/null >out.jsonl
diff -u "${here}/expected.jsonl" out.jsonl || fail "output differs from expected.jsonl"

# No attacker-controlled text may leave the LAPI.
if grep -E 'root|events over|<script>' out.jsonl; then
    fail "alert text leaked"
fi

# The IP comes only from source.ip, never from the decision or the message.
[[ $(jq -s 'map(.ip) | join(",")' out.jsonl) == '"198.51.100.7,192.0.2.1,203.0.113.9,2001:db8::10"' ]] || fail "unexpected ip values"

# An alert with an invalid source ip aborts the run.
if "${script}" --input <(jq '[.[2]]' "${here}/invalid.json") --cursor 0 2>/dev/null >out.jsonl; then
    fail "invalid ip must fail"
fi

# A custom-scope alert has no IP to export: it is skipped, not fatal.
jq '[.[0] | .source = {"scope": "username", "value": "root"}]' "${here}/alerts.json" >custom.json
"${script}" --input custom.json --cursor 40 --dry-run 2>/dev/null >out.jsonl || fail "custom scope must not fail"
[[ ! -s out.jsonl ]] || fail "custom scope must be skipped"

# One invalid alert aborts the whole run: no partial output, non-zero exit.
if "${script}" --input "${here}/invalid.json" --cursor 0 2>/dev/null >out.jsonl; then
    fail "invalid input must fail"
fi
[[ ! -s out.jsonl ]] || fail "partial output on invalid input"
[[ ! -e export_alerts_cursor ]] || fail "cursor written on invalid input"

# First run: no backfill, the cursor starts at the newest alert.
"${script}" --input "${here}/alerts.json" 2>/dev/null >out.jsonl
[[ ! -s out.jsonl ]] || fail "first run must not backfill"
[[ $(jq .alert_id export_alerts_cursor) == 45 ]] || fail "cursor must start at 45"

# Next run from the cursor: nothing new, cursor unchanged.
"${script}" --input "${here}/alerts.json" 2>/dev/null >out.jsonl
[[ ! -s out.jsonl ]] || fail "nothing new expected"

# An older cursor exports the newer bans and moves to the last alert read.
echo '{"alert_id": 42, "time": '"$(date +%s)"'}' >export_alerts_cursor
"${script}" --input "${here}/alerts.json" 2>/dev/null >out.jsonl
[[ $(jq -s 'map(.alert_id) | join(",")' out.jsonl) == '"43,44"' ]] || fail "expected bans 43,44"
[[ $(jq .alert_id export_alerts_cursor) == 45 ]] || fail "cursor must move to 45"

# A run with nothing new refreshes the cursor time, so a quiet node does not warn.
echo '{"alert_id": 45, "time": 0}' >export_alerts_cursor
"${script}" --input "${here}/alerts.json" 2>/dev/null >/dev/null
(( $(jq .time export_alerts_cursor) > 0 )) || fail "cursor time must be refreshed"

# A stale cursor warns about possible loss.
echo '{"alert_id": 45, "time": 0}' >export_alerts_cursor
"${script}" --input "${here}/alerts.json" 2>err.log >/dev/null
grep -q "may have been lost" err.log || fail "stale cursor must warn"

echo "export-alerts: all tests passed"
