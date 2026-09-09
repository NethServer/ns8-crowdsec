# last\_import Schema

```txt
http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import
```

Outcome of the last import run, absent until the timer has run once

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-threat-shield-output.json\*](crowdsec/list-threat-shield-output.json "open original schema") |

## last\_import Type

`object` ([last\_import](list-threat-shield-output-properties-last_import.md))

# last\_import Properties

| Property                | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                |
| :---------------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [timestamp](#timestamp) | `string` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-timestamp.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/timestamp") |
| [error](#error)         | `string` | Optional | can be null    | [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-error.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/error")         |
| [feeds](#feeds)         | `object` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-feeds.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds")         |

## timestamp

UTC timestamp of the last import run

`timestamp`

* is required

* Type: `string` ([timestamp](list-threat-shield-output-properties-last_import-properties-timestamp.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-timestamp.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/timestamp")

### timestamp Type

`string` ([timestamp](list-threat-shield-output-properties-last_import-properties-timestamp.md))

## error

Error that aborted the whole run, null when the run completed

`error`

* is optional

* Type: `string` ([error](list-threat-shield-output-properties-last_import-properties-error.md))

* can be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-error.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/error")

### error Type

`string` ([error](list-threat-shield-output-properties-last_import-properties-error.md))

## feeds

Per-feed outcome, keyed by catalog key

`feeds`

* is required

* Type: `object` ([feeds](list-threat-shield-output-properties-last_import-properties-feeds.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-feeds.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds")

### feeds Type

`object` ([feeds](list-threat-shield-output-properties-last_import-properties-feeds.md))
