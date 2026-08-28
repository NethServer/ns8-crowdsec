# last\_import Schema

```txt
http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import
```

Outcome of the most recent crowdsec1-import.timer run. Absent if it has never run.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [get-configuration-output.json\*](crowdsec/get-configuration-output.json "open original schema") |

## last\_import Type

`object` ([last\_import](get-configuration-output-properties-insights-properties-last_import.md))

# last\_import Properties

| Property                | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                                                     |
| :---------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [timestamp](#timestamp) | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-insights-properties-last_import-properties-timestamp.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import/properties/timestamp") |
| [success](#success)     | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-insights-properties-last_import-properties-success.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import/properties/success")     |
| [entries](#entries)     | `integer` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-insights-properties-last_import-properties-entries.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import/properties/entries")     |
| [error](#error)         | `string`  | Optional | can be null    | [get-configuration output](get-configuration-output-properties-insights-properties-last_import-properties-error.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import/properties/error")         |

## timestamp

UTC time of the last blocklist pull attempt

`timestamp`

* is required

* Type: `string`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-insights-properties-last_import-properties-timestamp.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import/properties/timestamp")

### timestamp Type

`string`

### timestamp Constraints

**date time**: the string must be a date time string, according to [RFC 3339, section 5.6](https://tools.ietf.org/html/rfc3339 "check the specification")

## success

Whether the fetch and import both succeeded

`success`

* is required

* Type: `boolean`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-insights-properties-last_import-properties-success.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import/properties/success")

### success Type

`boolean`

## entries

Number of IP/CIDR entries imported (0 on failure or an empty feed)

`entries`

* is required

* Type: `integer`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-insights-properties-last_import-properties-entries.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import/properties/entries")

### entries Type

`integer`

## error

Short error message when success is false

`error`

* is optional

* Type: `string`

* can be null

* defined in: [get-configuration output](get-configuration-output-properties-insights-properties-last_import-properties-error.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import/properties/error")

### error Type

`string`
