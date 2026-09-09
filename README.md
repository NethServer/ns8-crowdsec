# README

## Top-level Schemas

* [delete-detections output](./delete-detections-output.md "Result of flushing all CrowdSec alerts") – `http://schema.nethserver.org/crowdsec/delete-detections-output.json`

* [get-capi-count output](./get-capi-count-output.md "Number of active decisions received from the CrowdSec community blocklist") – `http://schema.nethserver.org/crowdsec/get-capi-count-output.json`

* [get-capi-status output](./get-capi-status-output.md "CrowdSec Central API connection status") – `http://schema.nethserver.org/crowdsec/get-capi-status-output.json`

* [get-configuration output](./get-configuration-output.md "Get crowdsec configuration") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json`

* [inspect-detection input](./inspect-detection-input.md "Inspect a specific CrowdSec alert by ID") – `http://schema.nethserver.org/crowdsec/inspect-detection-input.json`

* [list-collections output](./list-collections-output.md "List of installed CrowdSec collections") – `http://schema.nethserver.org/crowdsec/list-collections-output.json`

* [list-detections input](./list-detections-input.md "List CrowdSec alerts with an optional result limit") – `http://schema.nethserver.org/crowdsec/list-detections-input.json`

* [list-detections output](./list-detections-output.md "List of CrowdSec detection alerts") – `http://schema.nethserver.org/crowdsec/list-detections-output.json`

* [list-threat-shield output](./list-threat-shield-output.md "Nethesis Threat Shield feed catalog, enablement state, decision counts and last import status") – `http://schema.nethserver.org/crowdsec/list-threat-shield-output.json`

* [request-allowlist input](./request-allowlist-input.md "Request an IP address or CIDR be added to the nethesis-insights allowlist") – `http://schema.nethserver.org/crowdsec/request-allowlist-input.json`

* [request-allowlist output](./request-allowlist-output.md "Result of an allowlist request to nethesis-insights") – `http://schema.nethserver.org/crowdsec/request-allowlist-output.json`

* [search-capi-decision input](./search-capi-decision-input.md "Search for a specific IP address in the CrowdSec community blocklist") – `http://schema.nethserver.org/crowdsec/search-capi-decision-input.json`

* [search-capi-decision output](./search-capi-decision-output.md "Whether the searched IP is present in the CAPI community blocklist, with matching decisions") – `http://schema.nethserver.org/crowdsec/search-capi-decision-output.json`

* [search-threat-shield-decision input](./search-threat-shield-decision-input.md "Search for an IP address in the Nethesis Threat Shield decisions") – `http://schema.nethserver.org/crowdsec/search-threat-shield-decision-input.json`

* [search-threat-shield-decision output](./search-threat-shield-decision-output.md "Whether the searched IP is covered by a Nethesis Threat Shield decision, with the matching decisions") – `http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json`

* [set-threat-shield input](./set-threat-shield-input.md "Select which Nethesis Threat Shield premium blocklists are imported as CrowdSec decisions") – `http://schema.nethserver.org/crowdsec/set-threat-shield-input.json`

* [toggle-collection input](./toggle-collection-input.md "Enable or disable a CrowdSec collection") – `http://schema.nethserver.org/crowdsec/toggle-collection-input.json`

* [unban-ip input](./unban-ip.md "flush the postfix queue email") – `http://schema.nethserver.org/mail/unban-ip.json`

## Other Schemas

### Objects

* [Untitled object in list-collections output](./list-collections-output-items.md) – `http://schema.nethserver.org/crowdsec/list-collections-output.json#/items`

* [Untitled object in list-detections output](./list-detections-output-items.md) – `http://schema.nethserver.org/crowdsec/list-detections-output.json#/items`

* [Untitled object in list-detections output](./list-detections-output-items-properties-decisions-items.md) – `http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/decisions/items`

* [Untitled object in list-threat-shield output](./list-threat-shield-output-properties-feeds-items.md) – `http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items`

* [Untitled object in list-threat-shield output](./list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties.md) – `http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds/additionalProperties`

* [Untitled object in search-capi-decision output](./search-capi-decision-output-properties-decisions-items.md) – `http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items`

* [Untitled object in search-threat-shield-decision output](./search-threat-shield-decision-output-properties-decisions-items.md) – `http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items`

* [feeds](./list-threat-shield-output-properties-last_import-properties-feeds.md "Per-feed outcome, keyed by catalog key") – `http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds`

* [last\_import](./list-threat-shield-output-properties-last_import.md "Outcome of the last import run, absent until the timer has run once") – `http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import`

* [source](./list-detections-output-items-properties-source.md "Origin of the alert") – `http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/source`

### Arrays

* [decisions](./search-capi-decision-output-properties-decisions.md "CAPI decisions matching the searched IP") – `http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions`

* [decisions](./search-threat-shield-decision-output-properties-decisions.md "Threat Shield decisions matching the searched IP") – `http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions`

* [feeds](./list-threat-shield-output-properties-feeds.md "The feed catalog") – `http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds`

* [feeds](./set-threat-shield-input-properties-feeds.md "Catalog keys of the enabled feeds") – `http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/feeds`

* [receiver\_emails](./get-configuration-output-properties-receiver_emails-anyof-receiver_emails.md "List of administrators to send crowdsec alerts") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/receiver_emails/anyOf/0`

* [receiver\_emails](./get-configuration-output-properties-receiver_emails-anyof-receiver_emails-1.md "List of administrators to send crowdsec alerts") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/receiver_emails/anyOf/1`

* [whitelists](./get-configuration-output-properties-whitelists.md "Whitelists array of IP, network or hostname") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/whitelists`

## Version Note

The schemas linked above follow the JSON Schema Spec version: `http://json-schema.org/draft-07/schema#`
