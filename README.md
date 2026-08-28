# README

## Top-level Schemas

* [Configure the insights blocklist-evidence webhook](./set-insights.md "Configure the CrowdSec notification plugin that pushes every ban decision to the nethesis-insights service") – `http://schema.nethserver.org/crowdsec/set-insights.json`

* [delete-detections output](./delete-detections-output.md "Result of flushing all CrowdSec alerts") – `http://schema.nethserver.org/crowdsec/delete-detections-output.json`

* [get-capi-count output](./get-capi-count-output.md "Number of active decisions received from the CrowdSec community blocklist") – `http://schema.nethserver.org/crowdsec/get-capi-count-output.json`

* [get-capi-status output](./get-capi-status-output.md "CrowdSec Central API connection status") – `http://schema.nethserver.org/crowdsec/get-capi-status-output.json`

* [get-configuration output](./get-configuration-output.md "Get crowdsec configuration") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json`

* [inspect-detection input](./inspect-detection-input.md "Inspect a specific CrowdSec alert by ID") – `http://schema.nethserver.org/crowdsec/inspect-detection-input.json`

* [list-collections output](./list-collections-output.md "List of installed CrowdSec collections") – `http://schema.nethserver.org/crowdsec/list-collections-output.json`

* [list-detections input](./list-detections-input.md "List CrowdSec alerts with an optional result limit") – `http://schema.nethserver.org/crowdsec/list-detections-input.json`

* [list-detections output](./list-detections-output.md "List of CrowdSec detection alerts") – `http://schema.nethserver.org/crowdsec/list-detections-output.json`

* [request-allowlist input](./request-allowlist-input.md "Request an IP address or CIDR be added to the nethesis-insights allowlist") – `http://schema.nethserver.org/crowdsec/request-allowlist-input.json`

* [request-allowlist output](./request-allowlist-output.md "Result of an allowlist request to nethesis-insights") – `http://schema.nethserver.org/crowdsec/request-allowlist-output.json`

* [search-capi-decision input](./search-capi-decision-input.md "Search for a specific IP address in the CrowdSec community blocklist") – `http://schema.nethserver.org/crowdsec/search-capi-decision-input.json`

* [search-capi-decision output](./search-capi-decision-output.md "Whether the searched IP is present in the CAPI community blocklist, with matching decisions") – `http://schema.nethserver.org/crowdsec/search-capi-decision-output.json`

* [toggle-collection input](./toggle-collection-input.md "Enable or disable a CrowdSec collection") – `http://schema.nethserver.org/crowdsec/toggle-collection-input.json`

* [unban-ip input](./unban-ip.md "flush the postfix queue email") – `http://schema.nethserver.org/mail/unban-ip.json`

## Other Schemas

### Objects

* [Untitled object in list-collections output](./list-collections-output-items.md) – `http://schema.nethserver.org/crowdsec/list-collections-output.json#/items`

* [Untitled object in list-detections output](./list-detections-output-items.md) – `http://schema.nethserver.org/crowdsec/list-detections-output.json#/items`

* [Untitled object in list-detections output](./list-detections-output-items-properties-decisions-items.md) – `http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/decisions/items`

* [Untitled object in search-capi-decision output](./search-capi-decision-output-properties-decisions-items.md) – `http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items`

* [insights](./get-configuration-output-properties-insights.md "State of the webhook that pushes ban decisions to the nethesis-insights service") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights`

* [last\_import](./get-configuration-output-properties-insights-properties-last_import.md "Outcome of the most recent crowdsec1-import") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import`

* [source](./list-detections-output-items-properties-source.md "Origin of the alert") – `http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/source`

### Arrays

* [decisions](./search-capi-decision-output-properties-decisions.md "CAPI decisions matching the searched IP") – `http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions`

* [receiver\_emails](./get-configuration-output-properties-receiver_emails-anyof-receiver_emails.md "List of administrators to send crowdsec alerts") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/receiver_emails/anyOf/0`

* [receiver\_emails](./get-configuration-output-properties-receiver_emails-anyof-receiver_emails-1.md "List of administrators to send crowdsec alerts") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/receiver_emails/anyOf/1`

* [whitelists](./get-configuration-output-properties-whitelists.md "Whitelists array of IP, network or hostname") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/whitelists`
