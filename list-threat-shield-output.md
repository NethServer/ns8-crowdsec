# list-threat-shield output Schema

```txt
http://schema.nethserver.org/crowdsec/list-threat-shield-output.json
```

Nethesis Threat Shield feed catalog, enablement state, decision counts and last import status

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-threat-shield-output.json](crowdsec/list-threat-shield-output.json "open original schema") |

## list-threat-shield output Type

`object` ([list-threat-shield output](list-threat-shield-output.md))

## list-threat-shield output Examples

```json
{
  "subscription": true,
  "entitled": true,
  "type": "enterprise",
  "feeds": [
    {
      "key": "yoroimallvl1",
      "description": "Yoroi malware - Level 1",
      "enabled": true,
      "count": 4213,
      "blocked_24h": 1602,
      "confidence": 10,
      "custom": false,
      "url": ""
    },
    {
      "key": "nethesis-insights",
      "description": "Nethesis community - Level 2",
      "enabled": true,
      "count": 33,
      "blocked_24h": 12,
      "confidence": 8,
      "custom": false,
      "url": ""
    },
    {
      "key": "custom-mylist",
      "description": "My list",
      "enabled": true,
      "count": 120,
      "blocked_24h": 3,
      "confidence": -1,
      "custom": true,
      "url": "https://example.org/block.txt"
    }
  ],
  "allowlists": [
    {
      "name": "nethesis",
      "url": "",
      "description": "Nethesis global allowlist",
      "enabled": true,
      "builtin": true
    },
    {
      "name": "office",
      "url": "https://example.org/allow.txt",
      "description": "Office IPs",
      "enabled": true,
      "builtin": false
    }
  ],
  "last_import": {
    "timestamp": "2026-09-09T06:58:44Z",
    "error": null,
    "feeds": {
      "yoroimallvl1": {
        "success": true,
        "entries": 4213,
        "error": null,
        "timestamp": "2026-09-09T06:09:40Z"
      },
      "nethesis-insights": {
        "success": true,
        "entries": 33,
        "error": null,
        "timestamp": "2026-09-09T06:58:44Z"
      }
    },
    "allowlists": {
      "nethesis": {
        "success": true,
        "entries": 52,
        "error": null,
        "timestamp": "2026-09-09T06:58:44Z"
      },
      "office": {
        "success": true,
        "entries": 4,
        "error": null,
        "timestamp": "2026-09-09T06:58:44Z"
      }
    }
  }
}
```

```json
{
  "subscription": false,
  "entitled": false,
  "type": "",
  "feeds": [],
  "allowlists": []
}
```

# list-threat-shield output Properties

| Property                      | Type      | Required | Nullable       | Defined by                                                                                                                                                                        |
| :---------------------------- | :-------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [subscription](#subscription) | `boolean` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-subscription.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/subscription") |
| [entitled](#entitled)         | `boolean` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-entitled.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/entitled")         |
| [type](#type)                 | `string`  | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-type.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/type")                 |
| [feeds](#feeds)               | `array`   | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-feeds.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds")               |
| [allowlists](#allowlists)     | `array`   | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-allowlists.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists")     |
| [last_import](#last_import)   | `object`  | Optional | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-last_import.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import")   |

## subscription

True if the cluster has a subscription identity

`subscription`

* is required

* Type: `boolean` ([subscription](list-threat-shield-output-properties-subscription.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-subscription.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/subscription")

### subscription Type

`boolean` ([subscription](list-threat-shield-output-properties-subscription.md))

## entitled

True if the subscription carries the blocklist entitlement

`entitled`

* is required

* Type: `boolean` ([entitled](list-threat-shield-output-properties-entitled.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-entitled.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/entitled")

### entitled Type

`boolean` ([entitled](list-threat-shield-output-properties-entitled.md))

## type

Resolved subscription type used in the feed URLs (enterprise or community), empty if unknown

`type`

* is required

* Type: `string` ([type](list-threat-shield-output-properties-type.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-type.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/type")

### type Type

`string` ([type](list-threat-shield-output-properties-type.md))

## feeds

The feed catalog

`feeds`

* is required

* Type: `object[]` ([Details](list-threat-shield-output-properties-feeds-items.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-feeds.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds")

### feeds Type

`object[]` ([Details](list-threat-shield-output-properties-feeds-items.md))

## allowlists

The built-in Nethesis allowlist (only with a subscription), then the custom allowlists

`allowlists`

* is required

* Type: `object[]` ([Details](list-threat-shield-output-properties-allowlists-items.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-allowlists.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists")

### allowlists Type

`object[]` ([Details](list-threat-shield-output-properties-allowlists-items.md))

## last_import

Outcome of the last import run, absent until the timer has run once

`last_import`

* is optional

* Type: `object` ([last_import](list-threat-shield-output-properties-last_import.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-last_import.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import")

### last_import Type

`object` ([last_import](list-threat-shield-output-properties-last_import.md))
