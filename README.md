# README

## Top-level Schemas

* [delete-alerts output](./delete-alerts-output.md "Result of flushing all CrowdSec alerts") – `http://schema.nethserver.org/crowdsec/delete-alerts-output.json`

* [get-capi-count output](./get-capi-count-output.md "Number of active decisions received from the CrowdSec community blocklist") – `http://schema.nethserver.org/crowdsec/get-capi-count-output.json`

* [get-capi-status output](./get-capi-status-output.md "CrowdSec Central API connection status") – `http://schema.nethserver.org/crowdsec/get-capi-status-output.json`

* [get-configuration output](./get-configuration-output.md "Get crowdsec configuration") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json`

* [inspect-alert input](./inspect-alert-input.md "Inspect a specific CrowdSec alert by ID") – `http://schema.nethserver.org/crowdsec/inspect-alert-input.json`

* [list-alerts input](./list-alerts-input.md "List CrowdSec alerts with an optional result limit") – `http://schema.nethserver.org/crowdsec/list-alerts-input.json`

* [list-alerts output](./list-alerts-output.md "List of CrowdSec detection alerts") – `http://schema.nethserver.org/crowdsec/list-alerts-output.json`

* [list-collections output](./list-collections-output.md "List of installed CrowdSec collections") – `http://schema.nethserver.org/crowdsec/list-collections-output.json`

* [search-capi-decision input](./search-capi-decision-input.md "Search for a specific IP address in the CrowdSec community blocklist") – `http://schema.nethserver.org/crowdsec/search-capi-decision-input.json`

* [search-capi-decision output](./search-capi-decision-output.md "Whether the searched IP is present in the CAPI community blocklist, with matching decisions") – `http://schema.nethserver.org/crowdsec/search-capi-decision-output.json`

* [toggle-collection input](./toggle-collection-input.md "Enable or disable a CrowdSec collection") – `http://schema.nethserver.org/crowdsec/toggle-collection-input.json`

* [unban-ip input](./unban-ip.md "flush the postfix queue email") – `http://schema.nethserver.org/mail/unban-ip.json`

## Other Schemas

### Objects

* [Untitled object in list-alerts output](./list-alerts-output-items.md) – `http://schema.nethserver.org/crowdsec/list-alerts-output.json#/items`

* [Untitled object in list-alerts output](./list-alerts-output-items-properties-decisions-items.md) – `http://schema.nethserver.org/crowdsec/list-alerts-output.json#/items/properties/decisions/items`

* [Untitled object in list-collections output](./list-collections-output-items.md) – `http://schema.nethserver.org/crowdsec/list-collections-output.json#/items`

* [Untitled object in search-capi-decision output](./search-capi-decision-output-properties-decisions-items.md) – `http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items`

* [source](./list-alerts-output-items-properties-source.md "Origin of the alert") – `http://schema.nethserver.org/crowdsec/list-alerts-output.json#/items/properties/source`

### Arrays

* [decisions](./search-capi-decision-output-properties-decisions.md "CAPI decisions matching the searched IP") – `http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions`

* [receiver\_emails](./get-configuration-output-properties-receiver_emails-anyof-receiver_emails.md "List of administrators to send crowdsec alerts") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/receiver_emails/anyOf/0`

* [receiver\_emails](./get-configuration-output-properties-receiver_emails-anyof-receiver_emails-1.md "List of administrators to send crowdsec alerts") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/receiver_emails/anyOf/1`

* [whitelists](./get-configuration-output-properties-whitelists.md "Whitelists array of IP, network or hostname") – `http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/whitelists`

## Version Note

The schemas linked above follow the JSON Schema Spec version: `http://json-schema.org/draft-07/schema#`
