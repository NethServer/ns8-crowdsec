# ns8-crowdsec

CrowdSec is an open-source and lightweight software that allows you to detect peers with malevolent behaviors and block them from accessing your systems at various levels (infrastructural, system, applicative).
To achieve this, CrowdSec reads logs from different sources (files, streams ...) to parse, normalize and enrich them before matching them to threats patterns called scenarios.

ns8-crowdsec installs the LAPI (local api) on the node, composed of agent (to read logs) and a list of collections to parse them (scenarios, parsers...), the notifications can be sent by email.
When crowdsec detects an IP which is abusing it triggers an alert and then a decision (ban) to block the IP with a bouncer (iptable with IPSET). The bouncer is installed on the node however it could be installed to another Linux machine.

## Documentation

https://docs.crowdsec.net/docs/intro

## Install

**You can install only one crowdsec instance on the node**, other crowdsec instance will conflict with crowdsec1 and fail to start

Instantiate the module with:

    add-module ghcr.io/nethserver/crowdsec:latest 1

The output of the command will return the instance name.
Output example:

    {"module_id": "crowdsec1", "image_name": "crowdsec", "image_url": "ghcr.io/nethserver/crowdsec:latest"}

## Configure email notification

ns8-crowdsec detects changes in the event smarthost-changed and adapt to the new settings to send email when the alerts or decisions come.

First of all, you need to set the smarthost credentials in the `Settings > Smarthost` panel of the cluster-admin UI

then trigger the action configure-module (see below)

## Configure

Let's assume that the crowdsec instance is named `crowdsec1`. Once installed the container is up, nothing is needed, customisation can be done :

- by editing a file inside /var/lib/nethserver/crowdsec1/state/crowdsec_config where all config files are stored
- by editing a file inside the container use the wrapper with the name of the container : `podman exec -ti crowdsec1 bash`

then restart the container : `systemctl restart crowdsec1`

You can also modify settings with the configure-module action

    api-cli run configure-module --agent module/crowdsec1 --data - <<EOF
    {
        "helo_host": "foo.domain.com",
        "receiver_emails": ["user@domain.com","user@domain.org"],
        "bantime": "1",
        "dyn_bantime": true,
        "whitelists":["10.10.10.0/8","1.2.3.4","foo.com","foo.foo.org","12123564.org"],
        "enable_online_api": true,
        "ban_local_network": false
    }
    EOF

- `bantime`: set the ban time in minutes
- `dyn_bantime`: enable a dynamic ban_time ((number of ban +1) *4) (same unit as ban_time)
- `receiver_emails`: all emails account you want to notice when decisions or alert come
- `helo_host`: set a fully qualified domain name to use the relevant helo with postfix.(could be empty `""`)
- `whitelists`: whitelist domain, ip or network to crowdsec, no ban will occurs for that list
- `enable_online_api`: enable/disable to  push signals and receive bad IPs from crowdsec hub (true/false default is true)
- `ban_local_network`: enable/disable to ban on private IP address range

## Threat Shield premium blocklists

The Nethesis **Threat Shield** IP blocklists — the same feeds NethSecurity
ships in `ns-threat_shield` — can be imported as CrowdSec decisions and are
then enforced by the existing firewall bouncer. Six feeds are available: five
premium `bl.nethesis.it` feeds, plus `nethesis-insights`, the fleet-wide
consensus blocklist aggregated by
[`nethesis-insights`](https://github.com/nethesis/nethesis-insights) from
every subscribed node's own ban decisions. All six are selected the same way,
through `set-threat-shield` and the `THREAT_SHIELD_FEEDS` environment
variable — `nethesis-insights` is a *virtual* feed with no entry in
`imageroot/threat-shield-feeds.json`, pulled on its own, faster timer (see
below) rather than the shared 6-hour one:

| Key | Description | Confidence |
|---|---|---|
| `yoroimallvl1` | Yoroi malware - Level 1 | 10 |
| `yoroimallvl2` | Yoroi malware - Level 2 | 8 |
| `yoroisusplvl1` | Yoroi suspicious - Level 1 | 10 |
| `yoroisusplvl2` | Yoroi suspicious - Level 2 | 8 |
| `nethesislvl3` | Nethesis suspicious - Level 3 | 6 |
| `nethesis-insights` | Nethesis Insights - fleet consensus | 8 |

Confidence is a 1-10 rating shown next to each feed in the UI, derived from
the feed's level suffix (`lvl1` → 10, `lvl2` → 8, `lvl3` → 6, `lvl4` → 5) and
`-1` ("not rated") for any non-enterprise subscription; `nethesis-insights`
carries no level suffix so it is rated explicitly at 8.

Select the enabled feeds from the **Threat Shield** page of the UI, or with:

    api-cli run module/crowdsec1/set-threat-shield --data '{
      "feeds": ["yoroimallvl1", "nethesislvl3", "nethesis-insights"]
    }'

An empty array removes every Threat Shield decision, the `nethesis-insights`
ones included:

    api-cli run module/crowdsec1/set-threat-shield --data '{"feeds": []}'

The outbound push described below is not affected — it follows the
entitlement, not the selection.

List the catalog, the decision count per feed, the confidence rating and the
last import outcome:

    api-cli run module/crowdsec1/list-threat-shield

It returns `subscription`, `entitled`, `type`, a `feeds[]` array (each with
`key`, `description`, `enabled`, `count`, `confidence`) and a merged
`last_import` whose `feeds` map covers both the premium feeds and
`nethesis-insights`, each entry carrying its own `timestamp` since the two
run on different cadences.

Look an address up, matching enclosing networks too:

    api-cli run module/crowdsec1/search-threat-shield-decision --data '{"ip": "185.220.101.5"}'

The feeds require an **active subscription** that carries the **blocklist
entitlement**. Identity (`system_id` / `auth_token`) is read fresh from the
`cluster/subscription` Redis hash on every run and sent as
`Authorization: Basic base64(system_id:auth_token)`; it is never stored in the
module environment, so a subscription registered or terminated later takes
effect on the next run. Whether the subscription carries the entitlement, and
whether its feed URLs live under `enterprise` or `community`, is resolved by
probing the first feed and cached for 6 hours in `threat_shield_entitlement.json`;
`set-threat-shield` busts that cache, so a freshly bought entitlement is
picked up at once.

`${MODULE_ID}-threat-shield.timer` refreshes the five premium feeds every 6
hours. Each run is a flush-and-reimport per feed: decisions carry
`origin: cscli-import` and `scenario: threat-shield/<feed key>`, so a failing
or disabled feed never touches another feed's decisions, nor anything from
CAPI, the hub, manual bans, or the `nethesis-insights` import. Decisions last
7 hours — longer than the interval, so one failed cycle degrades coverage
instead of dropping it.

`nethesis-insights` is pulled separately by `imageroot/bin/import-blocklist`
on its own `${MODULE_ID}-import.timer`, every 15 minutes, from
`{insights_url}/blocklist/v1/feed`. It's the same flush-and-reimport pattern —
`cscli decisions delete --origin cscli-import --scenario nethesis-insights`
then a fresh import — but with a bare `nethesis-insights` scenario tag rather
than the `threat-shield/<key>` one the premium feeds use, and decisions last
35 minutes to match the shorter interval. The server URL is the constant
`INSIGHTS_DEFAULT_URL = "https://insights.nethesis.it"` in
`imageroot/bin/threat_shield.py`; `INSIGHTS_SERVER_URL` and
`INSIGHTS_VERIFY_TLS` still work as environment overrides for dev/test
deployments pointed at a staging server, but no action sets them — there is
no user-facing configuration for the server address. `verify_tls: false`
(via `INSIGHTS_VERIFY_TLS`) exists for self-signed test servers only.

Every ban decision this node makes is also pushed back in near-real-time to
`nethesis-insights`, so the central service can fold it into that same
fleet-wide consensus list. Delivery uses CrowdSec's own `notification-http`
plugin, driven by `profiles.yaml`: no polling, no cursor, no extra timer.
Decisions fired within the same 30s window are batched into a single
`POST /blocklist/v1/events`. Simulated alerts (`cscli simulation`) are never
sent. Delivery is best effort: a decision made while `crowdsec1` is
mid-restart, or lost to a plugin subprocess crash, is not retried. There is
no separate on/off switch for this direction: it is wired automatically
whenever the node carries the Threat Shield entitlement and has a
subscription identity, independent of which feeds are selected. The gate is
read from the cached entitlement verdict in `threat_shield_entitlement.json`,
never a live probe — `expand-configuration` runs as the service's
`ExecStartPre`, and a live probe there could stall the start.

Identity for both the push and the `nethesis-insights` pull is read fresh
from the `cluster/subscription` Redis hash (`system_id`/`auth_token`) at
render/run time and sent as `Authorization: Basic base64(system_id:auth_token)`
— it is never persisted into the module environment, so a
terminated/re-registered subscription starts working (or stops) on the very
next reload with no reconfiguration.

The outcome of each run — premium feeds every 6 hours, `nethesis-insights`
every 15 minutes — is merged into the single `last_import` map surfaced by
`list-threat-shield` described above.

Every run also refreshes the Nethesis **global allowlist** into a dedicated
`cscli allowlists` entry named `nethesis_threat_shield`, applied before the
import so a newly allowlisted address cannot be re-banned by the same cycle.
It has no UI representation, and is deliberately kept separate from
`nethserver_whitelist` (which `whitelist_ips` recreates from `WHITELISTS` on
every service start) so the two managers cannot clobber each other:

    runagent -m crowdsec1 cscli allowlists inspect nethesis_threat_shield

If the allowlist cannot be fetched on the very first run the import is skipped
for that cycle — no coverage beats banning a protected address.

If the `nethesis-insights` blocklist contains a false positive, request its
removal from the fleet-wide feed, from the **Threat Shield** page of the UI
or with:

    api-cli run module/crowdsec1/request-allowlist --data '{
      "cidr": "203.0.113.7",
      "reason": "This is our office egress IP"
    }'

Returns `{"accepted": true, "requests": N}`, `N` being how many systems in
the fleet have asked for that CIDR so far — repeating the same request is a
no-op. Requires the Threat Shield entitlement; the server does the actual
CIDR/reason validation.

## get-configuration

Display the configuration

    api-cli run get-configuration --agent module/crowdsec1 | jq

## Disable whitelist

By default whitelist is enabled to never ban IP on the local network, for test purpose you could disable it

    runagent -m crowdsec1 cscli parsers remove crowdsecurity/whitelists
    systemctl restart crowdsec1

### cscli

Crowdsec come with a cli tool, available within the application environment. Get a shell with:

    runagent -m crowdsec1 bash -l

Then run the tool as

    cscli --help

- help on a specific command:  `cscli <command> --help`
- get a glance : `cscli metrics`
- see the state of installed bouncers : `cscli bouncers list`
- see the active decisions(ban): `cscli decisions list`
- see the alerts (discovered IP): `cscli alerts list`
- see the details of an alert: `cscli alerts inspect <alert_ID> -d`
- see installed collections : `cscli collections list` or `cscli collections list --all`
- upgrade collections (a systemd timer does upgrade the collection every 15 days): `cscli hub update && cscli hub upgrade`

- ban manually an IP: `cscli decision add -i 1.2.3.4`
- unban an IP `cscli decision delete -i 1.2.3.4`
- ban a network `cscli decision add -r 1.2.3.0/24`
- unban a network `cscli decision delete -r 1.2.3.0/24`
- unban from a scenario `cscli decisions delete -s crowdsecurity/ssh-bfcscli`
- unban all decisions `cscli decisions delete --all`

- inspect a collection: `cscli collections inspect crowdsecurity/sshd`
- inspect a scenario: `cscli scenarios inspect crowdsecurity/ssh-bf`
- inspect a parser: `cscli parsers inspect crowdsecurity/sshd-logs`

## NethVoice / Kamailio scenarios

Besides the CrowdSec hub collections, ns8-crowdsec ships custom parsers/scenarios to detect:

- HTTP brute-force and exploit-scan attacks against the NethVoice CTI middleware
- Brute-force attacks against the NethVoice admin API login endpoint (`/freepbx/rest/login`)
- Brute-force attacks against the NethVoice reports application login (`reports-api`)
- SIP brute-force attacks against Kamailio authentication

These protections are enabled by default for new installations.
For existing installations, the protections are disabled by default and can be managed from the Web interface.

From CLI, the protection can be enabled/disabled by setting the `NETHVOICE_COLLECTION_ENABLED=True` variable in the module's `.env` file:

    runagent -m crowdsec1 python3 -c 'import agent ; agent.set_env("NETHVOICE_COLLECTION_ENABLED", "True")'

Then restart the module for changes to take effect:

    systemctl restart crowdsec1

To disable, remove the variable from `.env`, then restart:

    runagent -m crowdsec1 python3 -c 'import agent ; agent.set_env("NETHVOICE_COLLECTION_ENABLED", "False")'
    systemctl restart crowdsec1

## Instance enroll request

You can see the metrics of crowdsec at https://app.crowdsec.net/, for this purpose you need to create a login for a single user or an organization in the website, then in the top right menu click in `enroll an instance` and retrieve the keys, then enroll your container and restart it.

    runagent -m crowdsec1 cscli console enroll <key>
    systemctl restart crowdsec1

you can force the enrollment with another key

    runagent -m crowdsec1 cscli console enroll --overwrite <key>
    systemctl restart crowdsec1

Once done you need to accept inside the website the `Instance enroll request`

## Uninstall

To uninstall the instance:

    remove-module --no-preserve crowdsec1

## Inspect active bans (nftables)

Since version 1.0.6 the firewall bouncer runs in a privileged container with
`--network=host` and writes host **nftables** sets — one set per decision
origin, split by IP family (table `crowdsec` for IPv4, `crowdsec6` for IPv6).
Run these on the host as root:

    # list every crowdsec set (names + element counts)
    nft list sets table ip crowdsec
    nft list sets table ip6 crowdsec6

    # dump the community (CAPI) blocklist contents
    nft list set ip crowdsec crowdsec-blacklists-CAPI
    nft list set ip6 crowdsec6 crowdsec6-blacklists-CAPI

Sets follow the pattern `crowdsec-blacklists-<ORIGIN>` / `crowdsec6-blacklists-<ORIGIN>`
(e.g. `CAPI` for the community blocklist, `cscli` for manual bans, `crowdsec`
for local scenario decisions). Each element carries a `timeout`/`expires` value
matching the decision duration.

Disabling the Central API or the community blocklist purges the CAPI decisions
(`cscli decisions delete --all --origin CAPI`) and flushes the matching
`*-blacklists-CAPI` sets immediately, so bans clear without waiting for the
bouncer to resync.

## Uninstall the old crowdsec binary bouncer

Previous to the version 1.0.6 the bouncer was installed on the host following a repository method, after this version the bouncer is shipped in a full container.
With the upgrade the service `crowdsec-firewall-bouncer` has been stopped but not removed from the host. For a full cleaning you can

- remove firewalld permanent sets:

      firewall-cmd --permanent --delete-ipset=crowdsec-blacklists
      firewall-cmd --permanent --delete-ipset=crowdsec6-blacklists

- remove the bouncer on rocky linux

      dnf remove -y crowdsec-firewall-bouncer-iptables
      rm -rvf /etc/yum.repos.d/crowdsec_crowdsec.repo /etc/crowdsec /usr/local/sbin/cscli

- remove the bouncer on debian

      apt-get -y remove crowdsec-firewall-bouncer-iptables
      rm -rvf /etc/apt/sources.list.d/crowdsec_crowdsec.list /etc/crowdsec /usr/local/sbin/cscli


## Running tests locally

This module uses the NS8 standard testing infrastructure. For instructions on how to run the test suite locally, refer to the [Running tests locally](https://github.com/NethServer/ns8-github-actions/blob/v1/README.md#running-tests-locally) section of the ns8-github-actions repository.

## UI translation

Translated with [Weblate](https://hosted.weblate.org/projects/ns8/).

To setup the translation process:

- add [GitHub Weblate app](https://docs.weblate.org/en/latest/admin/continuous.html#github-setup) to your repository
- add your repository to [hosted.weblate.org](https://hosted.weblate.org) or ask a NethServer developer to add it to ns8 Weblate project
