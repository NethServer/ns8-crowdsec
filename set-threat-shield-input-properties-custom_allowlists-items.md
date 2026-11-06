# Untitled object in set-threat-shield input Schema

```txt
http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [set-threat-shield-input.json\*](crowdsec/set-threat-shield-input.json "open original schema") |

## items Type

`object` ([Details](set-threat-shield-input-properties-custom_allowlists-items.md))

# items Properties

| Property                    | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                                      |
| :-------------------------- | :-------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [name](#name)               | `string`  | Required | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-custom_allowlists-items-properties-name.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists/items/properties/name")               |
| [url](#url)                 | `string`  | Required | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-custom_allowlists-items-properties-url.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists/items/properties/url")                 |
| [description](#description) | `string`  | Optional | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-custom_allowlists-items-properties-description.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists/items/properties/description") |
| [enabled](#enabled)         | `boolean` | Optional | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-custom_allowlists-items-properties-enabled.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists/items/properties/enabled")         |

## name

Unique list name: lowercase letters, digits and dashes, at most 20 characters

`name`

* is required

* Type: `string`

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-custom_allowlists-items-properties-name.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists/items/properties/name")

### name Type

`string`

### name Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[a-z0-9][a-z0-9-]{0,19}$
```

[try pattern](https://regexr.com/?expression=%5E%5Ba-z0-9%5D%5Ba-z0-9-%5D%7B0%2C19%7D%24 "try regular expression with regexr.com")

## url

http or https URL of a plain list, one IP address or CIDR per line; no credentials in the URL

`url`

* is required

* Type: `string`

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-custom_allowlists-items-properties-url.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists/items/properties/url")

### url Type

`string`

### url Constraints

**maximum length**: the maximum number of characters for this string is: `512`

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^https?://[^/?#@\s]+([/?#]\S*)?$
```

[try pattern](https://regexr.com/?expression=%5Ehttps%3F%3A%2F%2F%5B%5E%2F%3F%23%40%5Cs%5D%2B\(%5B%2F%3F%23%5D%5CS*\)%3F%24 "try regular expression with regexr.com")

## description



`description`

* is optional

* Type: `string`

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-custom_allowlists-items-properties-description.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists/items/properties/description")

### description Type

`string`

### description Constraints

**maximum length**: the maximum number of characters for this string is: `128`

## enabled

Import this allowlist, default true

`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-custom_allowlists-items-properties-enabled.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists/items/properties/enabled")

### enabled Type

`boolean`
