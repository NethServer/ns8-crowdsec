# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`ns8-crowdsec` is a NethServer 8 module that wraps [CrowdSec](https://docs.crowdsec.net/docs/intro) (intrusion detection/prevention). It runs the CrowdSec LAPI + agent in one container and a separate firewall-bouncer container that enforces bans via iptables/IPSET. Backend is Python 3 + bash under `imageroot/`, frontend is Vue 2 under `ui/`. Follow the `nethserver-ns8-module` skill for generic NS8 conventions (action/event structure, agent SDK, systemd pod ordering, backup patterns, ns8-ui-lib usage) — this file only covers what's specific to this repo.

## Build / test commands

- UI dev build: `cd ui && corepack enable && yarn install && yarn build` (also invoked by `build-images.sh` inside a buildah node container — do not assume a local Node toolchain is pre-provisioned).
  - No corepack/Berry yarn locally: `npm exec --yes corepack@latest -- yarn@4.18.0 <install|build|lint>`.
  - Node 17+: prefix local build/lint with `NODE_OPTIONS=--openssl-legacy-provider` (`build-images.sh` already does).
- UI lint/format: `cd ui && yarn lint`, `yarn format`.
- Full image build (requires `buildah`, network access, root/rootless podman storage): `./build-images.sh`. It also downloads and checksum-verifies the `crowdsec-firewall-bouncer` release tarball against `CHECKSUM` — regenerate that file (`sha256sum crowdsec-firewall-bouncer-linux-amd64.tgz > CHECKSUM`) whenever the bouncer version in `build-images.sh` changes.
- Integration tests: Robot Framework, `tests/crowdsec.robot`, run via the shared `NethServer/ns8-github-actions` test workflow (`.github/workflows/test-module.yml`) — see that repo's README for running locally. Don't try to invent a local Robot runner setup.
- No unit-test harness for the Python/bash backend; don't add one.

## Architecture

### Two images, two systemd-managed containers
- `crowdsec` image: `imageroot/` + built `ui/dist` (`/ui`). Runs `<module>.service` — **rootful**, `--privileged`, `--network=host` (see `org.nethserver.rootfull=1` in `build-images.sh`). Runs the CrowdSec agent/LAPI.
- `crowdsec-firewall-bouncer` image: built separately in `build-images.sh` from a pinned GitHub release tarball of `cs-firewall-bouncer` (tracked by the custom `regexManagers` entry in `renovate.json`, not the `org.nethserver.images` label). Runs `<module>-firewall-bouncer.service`, also privileged/host-network, and actually installs the IPSET/iptables rules.
- A third unit pair, `<module>-upgrade-hub.service`/`.timer`, periodically runs `cscli hub update && cscli hub upgrade` (every ~15 days).

All three unit files are installed by `imageroot/actions/create-module` and `imageroot/update-module.d/10install_systemd_units` via `imageroot/bin/install-systemd-units`, which `envsubst`s `${MODULE_ID}` into the bouncer/timer unit templates before writing them to `/etc/systemd/system/`.

### Config is generated at container start, not only at configure-module time
Unlike the typical NS8 pattern of doing all config work inside action steps, most CrowdSec YAML config is (re)rendered from Jinja2 templates in `imageroot/templates/` by three scripts in `imageroot/bin/` — `expand-configuration`, `expand-smarthost`, `expand-bouncer-configuration` — invoked as `ExecStartPre=`/`ExecReload=` in `imageroot/crowdsec.service` / `crowdsec-firewall-bouncer.service`. `configure-module` itself just persists settings via `agent.set_env()`; the actual `crowdsec_config/*.yaml` files are only materialized on service (re)start/reload. When changing what `configure-module` accepts, check whether the corresponding `expand-*` script also needs the new env var, and whether a `systemctl reload`/`restart` is needed to see the effect.

`whitelist_ips` (an `ExecStartPost` in `crowdsec.service`) manages a `cscli allowlists` entry (`nethserver_whitelist`) for IP/CIDR whitelist entries and always adds `sos.nethesis.it`'s IP when a subscription is active; FQDN whitelist entries go through a different path — a postoverflow YAML template (`nethserver-postoverflows-whitelists.yaml`) rendered by `expand-configuration`. Keep this IP-vs-FQDN split in mind when touching whitelist logic — it's split across two files for a reason (CrowdSec's centralized allowlists only accept IP/CIDR, not domains).

### Custom "tainted" parsers/scenarios and the fake `nethesis/nethvoice` collection
`imageroot/tainted/` holds custom CrowdSec parsers/scenarios not from the CrowdSec hub: NethVoice CTI/admin-API/reports brute-force detection, Kamailio SIP brute-force detection, and a permanent Nextcloud parser. These are copied into `crowdsec_config/` by `expand-configuration`, not managed via `cscli`. The NethVoice+Kamailio set is bundled and exposed to the UI/API as a single fake collection named `nethesis/nethvoice`, toggled through the `toggle-collection` action (`imageroot/actions/toggle-collection/10toggle-collection`) which special-cases that name to flip the `NETHVOICE_COLLECTION_ENABLED` env var instead of calling `cscli collections install/remove`. Any other collection name in that action goes through real `cscli collections <install|remove>`. New "fake collection" style additions should follow this same env-var + `expand-configuration` copy pattern, not try to register with the real hub.

### Notifications
Email notifications go through `imageroot/bin/expand-smarthost`, which reads cluster smarthost settings via `agent.get_smarthost_settings()` and only renders `crowdsec_config/notifications/email.yaml` when both an SMTP smarthost is configured and `receiver_emails` is non-empty. The `smarthost-changed` event handler (`imageroot/events/smarthost-changed/10handler`) just restarts the service so `ExecStartPre` re-expands this file with the latest smarthost config.

### Backup scope
`imageroot/etc/state-include.conf` only backs up `volumes/data` (the CrowdSec data volume, alerts/decisions DB) and `state/secrets/bouncer_keys_firewall.secret`. All other config under `state/crowdsec_config/` is regenerated from templates/env vars on every start — do not add it to the backup list.

### No database service
This module has no MariaDB/PostgreSQL component — don't apply the DB dump/restore patterns from the general NS8 skill here; CrowdSec persists its own SQLite/data volume.

### Threat Shield (Nethesis blocklists + Insights)
- `THREAT_SHIELD_FEEDS` (written only by `set-threat-shield`) picks feeds from `imageroot/etc/threat-shield-feeds.json`: five `bl.nethesis.it` feeds (copy of NethSecurity's catalog) plus `nethesis-insights`. Insights' `url_4` has no `__TYPE__` and is the only place its host is set (`threat_shield.insights_url()`); `premium_feeds()` skips it where a `bl.nethesis.it` feed is needed.
- Identity (`system_id`/`auth_token`) is read fresh from Redis `cluster/subscription` via `threat_shield.identity()`, never stored in the module env.
- Subscription alone enables the Insights push and the Nethesis allowlist; the entitlement only gates blocklist downloads. Keep that split.
- Entitlement is cached 6h in `threat_shield_entitlement.json` by `probe_status()`. Only clear answers (200, 4xx but 408/429) are cached: a network blip must never read as "not entitled". On service-start paths (`expand-configuration`) and in `request-allowlist` use `cached_probe_status()`, which never probes. Kept warm by `import-threat-shield`, `set-threat-shield`, `subscription-changed/10refresh-entitlement` and `list-threat-shield` (while the verdict is "no").
- Confidence (`get_confidence()`) mirrors NethSecurity's `ns.threatshield`: -1 if not enterprise, lvl1→10, lvl2→8, lvl3→6, lvl4→5; Insights → `INSIGHTS_CONFIDENCE`.
- Import: `bin/import-threat-shield` on `<module>-threat-shield.timer` (30 min, decisions last 65m), enabled only with an identity (`bin/sync-threat-shield-timer`). Allowlist first; if it was never fetched, import nothing. Per feed: import the new list, then hard-delete the old alerts (`cscli alerts delete --id`), as `decisions delete` leaves rows that inflate `GetDecisionsCount()`. The bouncer isn't told, so dropped addresses stay blocked until their old timeout. Rows are told apart only by `scenario: threat-shield/<key>` (origin is always `cscli-import`).
- Allowlist: its own `cscli allowlists` entry `nethesis_threat_shield`, separate from `nethserver_whitelist`; updated add-before-remove, an empty download is a failure.
- Status in `threat_shield_last_import.json` (not backed up); `list-threat-shield` is the only UI source, `get-configuration` has no Threat Shield data.
- Push: `templates/nethesis-insights.yaml` via `notification-http`, rendered by `expand-configuration` whenever there is an identity. Deliberately not gated on the feed selection or the entitlement.
- `request-allowlist`: thin relay to Insights `POST /blocklist/v1/allowlist-requests`, gated on the cached entitlement. CLI only, no UI.

## UI structure

Views under `ui/src/views/`: `Status`, `Settings`, `Detections`, `Collections`, `Blocklists`, `ThreatShield`, `About`. A new view needs a route (`ui/src/router/index.js`), a nav entry (`ui/src/components/AppSideMenuContent.vue`) and an i18n namespace. `Blocklists.vue` covers the local allowlist and the CrowdSec Central API community blocklist/console-enrollment status (backed by `get-capi-status`, `get-capi-count`, `search-capi-decision`). `ThreatShield.vue` is the feeds table plus IP search (`list-/set-threat-shield`, `search-threat-shield-decision`), all gated on `canEdit` (subscription + entitlement). Shared helpers live in `ui/src/lib/`. Standard NS8/Carbon/ns8-ui-lib conventions apply — see the `nethserver-ns8-module` skill; backend calls go only through `TaskService`'s `createModuleTaskForApp` + one-shot `core.$root` events keyed by `eventId`.

Live test without rebuilding the image: the UI is served from `/var/lib/nethserver/cluster/ui/apps/<module id>/`, so `rsync -a --delete --chown=rocky:rocky --exclude metadata.json --exclude shortcuts.json ui/dist/` there; `imageroot/` changes go straight into `AGENT_INSTALL_DIR`.
