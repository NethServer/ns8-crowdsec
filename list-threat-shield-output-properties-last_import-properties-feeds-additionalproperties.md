# Untitled object in list-threat-shield output Schema

```txt
http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds/additionalProperties
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-threat-shield-output.json\*](crowdsec/list-threat-shield-output.json "open original schema") |

## additionalProperties Type

`object` ([Details](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties.md))

# additionalProperties Properties

| Property                | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                                                                                            |
| :---------------------- | :-------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [success](#success)     | `boolean` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-success.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds/additionalProperties/properties/success")     |
| [entries](#entries)     | `integer` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-entries.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds/additionalProperties/properties/entries")     |
| [error](#error)         | `string`  | Optional | can be null    | [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-error.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds/additionalProperties/properties/error")         |
| [timestamp](#timestamp) | `string`  | Optional | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-timestamp.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds/additionalProperties/properties/timestamp") |

## success

True if the feed was fetched and imported

`success`

* is required

* Type: `boolean` ([success](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-success.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-success.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds/additionalProperties/properties/success")

### success Type

`boolean` ([success](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-success.md))

## entries

Number of imported values

`entries`

* is required

* Type: `integer` ([entries](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-entries.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-entries.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds/additionalProperties/properties/entries")

### entries Type

`integer` ([entries](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-entries.md))

### entries Constraints

**minimum**: the value of this number must greater than or equal to: `0`

## error

Failure reason, null on success

`error`

* is optional

* Type: `string` ([error](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-error.md))

* can be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-error.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds/additionalProperties/properties/error")

### error Type

`string` ([error](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-error.md))

## timestamp

UTC timestamp of the run that produced this feed's outcome (its own timer, not necessarily last\_import.timestamp)

`timestamp`

* is optional

* Type: `string` ([timestamp](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-timestamp.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-timestamp.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/last_import/properties/feeds/additionalProperties/properties/timestamp")

### timestamp Type

`string` ([timestamp](list-threat-shield-output-properties-last_import-properties-feeds-additionalproperties-properties-timestamp.md))
