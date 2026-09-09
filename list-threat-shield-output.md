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
      "confidence": 10
    },
    {
      "key": "nethesis-insights",
      "description": "Nethesis Insights - fleet consensus",
      "enabled": true,
      "count": 33,
      "confidence": 8
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
    }
  }
}
```

```json
{
  "subscription": false,
  "entitled": false,
  "type": "",
  "feeds": []
}
```

# list-threat-shield output Properties

| Property                      | Type      | Required | Nullable       | Defined by                                                                                                                                                                        |
| :---------------------------- | :-------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [subscription](#subscription) | `boolean` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-subscription.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/subscription") |
| [entitled](#entitled)         | `boolean` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-entitled.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/entitled")         |
| [type](#type)                 | `string`  | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-type.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/type")                 |
| [feeds](#feeds)               | `array`   | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-feeds.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds")               |
| [last\_import](#last_import)  | `object`  | Optional | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-last_import.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import")   |

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

## last\_import

Outcome of the last import run, absent until the timer has run once

`last_import`

* is optional

* Type: `object` ([last\_import](list-threat-shield-output-properties-last_import.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-last_import.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import")

### last\_import Type

`object` ([last\_import](list-threat-shield-output-properties-last_import.md))
