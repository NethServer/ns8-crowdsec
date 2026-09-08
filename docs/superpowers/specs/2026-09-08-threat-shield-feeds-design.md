# Threat Shield feeds in ns8-crowdsec — design

Date: 2026-09-08
Status: approved, ready for implementation planning

## Goal

Expose the Nethesis "Threat Shield" premium IP blocklists — the same feeds
NethSecurity ships in `packages/ns-threat_shield/files/banip.nethesis.feeds` —
inside ns8-crowdsec, selectable per feed from a new **Threat Shield** UI
section. Enabled feeds are imported as CrowdSec decisions, so the existing
firewall bouncer enforces them with no new enforcement path.

Scope is the five Nethesis premium feeds only. Free/community banip feeds are
out of scope: CrowdSec's own CAPI community blocklist already covers that
ground and is configured elsewhere in this module.

## Upstream facts this design relies on

From `NethServer/nethsecurity`:

- `packages/ns-threat_shield/files/banip.nethesis.feeds` — five entries
  (`yoroimallvl1`, `yoroimallvl2`, `yoroisusplvl1`, `yoroisusplvl2`,
  `nethesislvl3`), each with `url_4`, `rule_4` (an awk program) and `descr`.
  URLs are `https://__USER__:__PASSWORD__@bl.nethesis.it/plain/__TYPE__/nethesis-blacklists/<file>`.
- `packages/ns-threat_shield/files/ts-ip` — substitutes `__USER__` /
  `__PASSWORD__` / `__TYPE__` from `uci ns-plug.config.{system_id,secret,type}`,
  and adds `https://<id>:<secret>@bl.nethesis.it/plain/<type>/nethesis-blacklists/whitelist.global`
  to banip's `ban_allowurl` whenever the premium feeds are active.
- `packages/ns-api/files/ns.threatshield`, `has_bl_entitlement()` — probes the
  first feed URL with `Authorization: Basic base64(system_id:secret)` after
  stripping the `__USER__:__PASSWORD__@` userinfo from the URL; HTTP 200 means
  the subscription carries the blocklist entitlement. Result cached 6 hours.
- `packages/ns-plug/files/register` — `type` is `community` or `enterprise`.

## Architecture

The module already has a proven pull-side blocklist path: `imageroot/bin/import-blocklist`
plus `crowdsec-import.{service,timer}`, doing a flush-and-reimport keyed on a
scenario tag. Threat Shield is a second instance of that same shape, with a
per-feed scenario tag instead of one global tag.

### Feed catalog

`imageroot/threat-shield-feeds.json` — a verbatim copy of upstream
`banip.nethesis.feeds`, so refreshing it is a file copy and a diff against
upstream stays readable. `rule_4` is carried but unused: the importer validates
each line with Python's `ipaddress` rather than running awk.

### Shared library

`imageroot/bin/threat_shield.py`, imported by the importer and by both actions
via an explicit `sys.path.insert(0, os.environ['AGENT_INSTALL_DIR'] + '/bin')`
(the repo has no shared-lib convention yet; one explicit line beats inventing a
package layout). It provides:

- `load_catalog()` — parse the JSON catalog.
- `identity()` — `system_id` / `auth_token` read fresh from the
  `cluster/subscription` Redis hash on every call. Never persisted into the
  module environment, so a terminated or re-registered subscription changes
  behaviour on the next run with no reconfiguration. Same rule as the
  nethesis-insights integration.
- `subscription_type()` — resolves the `__TYPE__` URL segment, which is
  `enterprise` or `community`. NS8 has no `ns-plug.config.type`; the equivalent
  field in the `cluster/subscription` hash has not been confirmed, so the probe
  is the authoritative mechanism: try `enterprise`, then `community`, and cache
  whichever answers HTTP 200 (6 hours, same cache file as the entitlement
  probe). If implementation finds a reliable provider/plan field in
  `cluster/subscription`, use it as a first guess and keep the probe as the
  fallback — a node whose provider naming does not match the plan must still
  resolve correctly.
- `has_bl_entitlement()` — upstream's probe: first catalog feed, Basic header,
  200 == entitled. Cached 6 hours in `threat_shield_entitlement.json`.
- `fetch(url)` — GET with the Basic header, userinfo stripped from the URL so
  credentials cannot reach a log line or an exception string.

### Importer

`imageroot/bin/import-threat-shield` (python3, run through `runagent`):

1. Read `THREAT_SHIELD_FEEDS` (comma-separated catalog keys). If empty: delete
   the `nethesis_threat_shield` allowlist, delete the decisions of every catalog
   scenario, exit 0.
2. Read identity. If absent: same cleanup, exit 0.
3. Resolve `subscription_type()`.
4. **Allowlist first.** Fetch `whitelist.global`; on success
   `cscli allowlists delete nethesis_threat_shield`, `create`, then `add` its
   IP/CIDR entries. Applying it before the import means a newly allowlisted
   address cannot be re-banned by the same cycle. On fetch failure: keep the
   previous allowlist and continue; if no allowlist exists yet (first run),
   skip the import for this cycle — no coverage beats banning a protected
   address.
5. For each enabled feed: fetch, keep only valid IP/CIDR values, then
   `cscli decisions delete --origin cscli-import --scenario threat-shield/<key>`
   followed by `cscli decisions import -i - --format values -R threat-shield/<key> -d <duration>`.
   A per-feed tag makes the delete surgical: a failing or disabled feed never
   touches another feed's decisions, nor anything from CAPI, the hub, manual
   bans, or the nethesis-insights import. Large feeds are imported with
   `--batch`.
6. Write `threat_shield_last_import.json` — sibling of `crowdsec_config/`, with
   a timestamp and per-feed `{success, entries, error}`.

`cscli decisions import` always tags origin `cscli-import` regardless of `-R`;
the scenario tag is what separates this feature's rows from the insights
import's rows, which use the same origin.

### Allowlist

The Nethesis global allowlist lives in its own `cscli allowlists` entry,
`nethesis_threat_shield`. It is deliberately not merged into
`nethserver_whitelist`, which `imageroot/bin/whitelist_ips` deletes and
recreates from `WHITELISTS` on every service start — merging would let each
manager clobber the other's entries. It has no UI representation.

### Timer

`imageroot/crowdsec-threat-shield.service` / `.timer`, installed by
`imageroot/bin/install-systemd-units` with `${MODULE_ID}` substituted, and
registered in `imageroot/actions/create-module` and
`imageroot/update-module.d/10install_systemd_units` alongside the existing
import and upgrade-hub units.

- `OnActiveSec=2min`, `OnUnitInactiveSec=6h` — the feeds update daily upstream.
- Decision duration `7h`: longer than the interval, so one failed cycle
  degrades coverage instead of dropping it, but a value dropped upstream
  expires within a cycle.

### Actions

- `set-threat-shield` — input `{feeds: [<catalog key>, ...]}`, validated against
  the catalog keys. Writes `THREAT_SHIELD_FEEDS` via `agent.set_env`, busts the
  entitlement cache (an admin who just bought the entitlement must not be told
  "no" for six hours), then `systemctl start <module>-threat-shield.service` so
  the effect is visible immediately rather than at the next timer tick.
- `list-threat-shield` — returns the catalog (key, `descr`), the enabled flag
  per feed, the current decision count per feed from `cscli`, the last-import
  status, and `{subscription, entitled, type}` so the view never has to infer
  state.
- `search-threat-shield-decision` — input `{ip}`. Python, not bash: the feeds
  contain CIDRs, so an exact string match would miss an address inside a banned
  `/24`. It dumps `cscli decisions list --origin cscli-import --limit 0 -o json`,
  keeps the `threat-shield/*` scenarios, and tests membership with `ipaddress`.
  It does not pass `--ip`, for the same reason `search-capi-decision` avoids it:
  on IPv4 that triggers a range-containment lookup that hangs on large datasets.

### What does not change

- No `expand-*` script and no template: all state here is cscli/database state,
  not rendered configuration.
- No backup change. `imageroot/etc/state-include.conf` already covers
  `volumes/data`, where the decisions live. `threat_shield_last_import.json` and
  `threat_shield_entitlement.json` are disposable caches and stay out of it.
- No change to `configure-module`, the bouncer, or the enforcement path.

## UI

`ui/src/views/ThreatShield.vue`, route `/threat-shield` in
`ui/src/router/index.js`, nav entry in `ui/src/components/AppSideMenuContent.vue`
directly after Blocklists, and a `threat_shield` namespace in
`ui/public/i18n/en/translation.json`. Backend calls go through the `TaskService`
mixin's `createModuleTaskForApp` with per-call `eventId` one-shot listeners,
like every other view in this module.

Three states, driven by `list-threat-shield`:

1. No subscription — toggles rendered but disabled, `NsInlineNotification`
   explaining that a subscription is required.
2. Subscription without the blocklist entitlement — toggles disabled, a
   notification pointing at the entitlement.
3. Entitled — toggles live.

Contents:

- One row per feed: `descr` as the label, a `cv-toggle`, the current decision
  count as caption.
- A single Save button issuing one `set-threat-shield` call with the full
  enabled-key array. Per-toggle calls are deliberately avoided: a click storm
  would interleave writes.
- Last-import status: timestamp and per-feed error text. Hidden until the timer
  has run at least once.
- An IP search box backed by `search-threat-shield-decision`, following the
  Blocklists.vue search pattern.
- No allowlist UI.

## Testing

`tests/crowdsec.robot` gains cases that run without a subscription, which is
what CI has:

- the catalog is listed with the five expected keys;
- an empty selection is a clean no-op;
- enabling feeds on an unsubscribed node neither errors nor creates decisions.

The premium fetch, the allowlist pull, and the entitlement probe cannot be
exercised in CI and are verified by hand on the dev leader (rl1).

## Documentation

README gains a Threat Shield section: the feeds, the subscription and
entitlement requirement, the 6h refresh, and the hidden `nethesis_threat_shield`
allowlist (so an admin debugging a missing ban knows it exists).
