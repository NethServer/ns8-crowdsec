# Untitled object in list-threat-shield output Schema

```txt
http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-threat-shield-output.json\*](crowdsec/list-threat-shield-output.json "open original schema") |

## items Type

`object` ([Details](list-threat-shield-output-properties-allowlists-items.md))

# items Properties

| Property                    | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                              |
| :-------------------------- | :-------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [name](#name)               | `string`  | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-allowlists-items-properties-name.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists/items/properties/name")               |
| [url](#url)                 | `string`  | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-allowlists-items-properties-url.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists/items/properties/url")                 |
| [description](#description) | `string`  | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-allowlists-items-properties-description.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists/items/properties/description") |
| [enabled](#enabled)         | `boolean` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-allowlists-items-properties-enabled.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists/items/properties/enabled")         |
| [builtin](#builtin)         | `boolean` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-allowlists-items-properties-builtin.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists/items/properties/builtin")         |

## name

"nethesis" for the built-in row, else the custom allowlist name

`name`

* is required

* Type: `string`

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-allowlists-items-properties-name.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists/items/properties/name")

### name Type

`string`

## url

URL of a custom allowlist, empty for the built-in row

`url`

* is required

* Type: `string`

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-allowlists-items-properties-url.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists/items/properties/url")

### url Type

`string`

## description

Description as entered, possibly empty

`description`

* is required

* Type: `string`

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-allowlists-items-properties-description.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists/items/properties/description")

### description Type

`string`

## enabled

True if the allowlist is imported

`enabled`

* is required

* Type: `boolean`

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-allowlists-items-properties-enabled.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists/items/properties/enabled")

### enabled Type

`boolean`

## builtin

True for the Nethesis global allowlist, which cannot be edited or deleted

`builtin`

* is required

* Type: `boolean`

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-allowlists-items-properties-builtin.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/allowlists/items/properties/builtin")

### builtin Type

`boolean`
