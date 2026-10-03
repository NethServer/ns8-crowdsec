# 1. Ban analytics through journald and Loki

Status: proposed

## Context

Administrators want to know where bans come from: how many per day, which countries and network providers, which services are attacked, with a history longer than a week. The CrowdSec LAPI keeps alerts for 7 days or 5000 items. The Prometheus metrics carry no geography. NethServer 8 already ships Grafana, Prometheus and Loki through ns8-metrics and ns8-loki, and every journald line of the node reaches Loki with the `module_id` and `node_id` labels.

## Options rejected

Third-party web UIs (crowdsec-web-ui, crowdsec_manager, crowdsec-local-dashboard) add a container, an exposed route, its own authentication and an update cycle we do not control. Most of them talk to the LAPI with machine credentials and show raw IPs.

A Prometheus textfile exporter with country and ASN labels creates one series per country, ASN and scenario. Cardinality grows without bound and Prometheus has no event history, only counters.

Parsing the CrowdSec logs depends on the log format of each release and the lines carry the attacker IP.

## Decision

A systemd timer runs `bin/export-alerts` every 5 minutes. It reads new local alerts with `cscli alerts list --kind crowdsec`, keeps those with a ban decision, and writes one JSON line per ban to stdout with a fixed schema: `v`, `ts`, `alert_id`, `country`, `asn`, `as_name`, `scenario`, `service`, `lat`, `lon`. Each field is validated against a strict format, `as_name` is reduced to a safe character set. A malformed alert aborts the run, nothing is written and the cursor stays. Loki parses the JSON at query time, the fields never become labels.

The `crowdsec_bans` dashboard reads Loki and is published with the other CrowdSec dashboards. The timer is always on, there is no setting to turn it off.

## Security

What we protect against: the alert source IP, which is personal data, and the attacker-controlled text of the alert (message, events, meta, target user) never reach Loki. A crafted log line cannot inject markup or LogQL into the dashboard because no free text is passed through. The trust boundary is the CrowdSec database: only the allowlisted, validated fields cross it.

What we do not protect: country, ASN, AS name and approximate coordinates of each ban are readable by anyone with Grafana access, for the whole Loki retention period (365 days by default). The export is always on, so this applies to every installation from install or update.

## Consequences

History starts at install or update. There is no backfill because Loki stamps a line when it is ingested.

The cursor is not backed up. After a restore, history restarts from the restore time and nothing is duplicated.

If the LAPI flushes alerts before the next run (more than 5000 alerts, or the timer stopped for more than 7 days), those bans are lost and the script logs a warning.

## What we will only know in use

The real volume per node and whether the 500 series limit of Loki queries is reached on the map, which groups by coordinates (capped to the top 300). Whether the volatile journal on some nodes drops lines at reboot before Loki reads them. Whether the 365 days retention is acceptable, which is for the maintainers to decide.
