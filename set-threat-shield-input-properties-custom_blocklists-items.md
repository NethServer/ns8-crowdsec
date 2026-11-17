# Untitled object in set-threat-shield input Schema

```txt
http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_blocklists/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [set-threat-shield-input.json\*](crowdsec/set-threat-shield-input.json "open original schema") |

## items Type

`object` ([Details](set-threat-shield-input-properties-custom_blocklists-items.md))

# items Properties

| Property                    | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                                      |
| :-------------------------- | :------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [name](#name)               | `string` | Required | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-custom_blocklists-items-properties-name.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_blocklists/items/properties/name")               |
| [url](#url)                 | `string` | Required | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-custom_blocklists-items-properties-url.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_blocklists/items/properties/url")                 |
| [description](#description) | `string` | Optional | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-custom_blocklists-items-properties-description.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_blocklists/items/properties/description") |

## name

Unique list name: 3 to 16 lowercase letters and digits, starting with a letter; names starting with nethesis, yoroi or crowdsec are reserved

`name`

* is required

* Type: `string`

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-custom_blocklists-items-properties-name.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_blocklists/items/properties/name")

### name Type

`string`

### name Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[a-z][a-z0-9]{2,15}$
```

[try pattern](https://regexr.com/?expression=%5E%5Ba-z%5D%5Ba-z0-9%5D%7B2%2C15%7D%24 "try regular expression with regexr.com")

## url

http or https URL of a plain list, one IP address or CIDR per line; an optional user:pass@ is sent as HTTP Basic authentication

`url`

* is required

* Type: `string`

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-custom_blocklists-items-properties-url.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_blocklists/items/properties/url")

### url Type

`string`

### url Constraints

**maximum length**: the maximum number of characters for this string is: `512`

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^https?://([^/?#@\s]+@)?[^/?#@\s]+([/?#]\S*)?$
```

[try pattern](https://regexr.com/?expression=%5Ehttps%3F%3A%2F%2F\(%5B%5E%2F%3F%23%40%5Cs%5D%2B%40\)%3F%5B%5E%2F%3F%23%40%5Cs%5D%2B\(%5B%2F%3F%23%5D%5CS*\)%3F%24 "try regular expression with regexr.com")

## description



`description`

* is optional

* Type: `string`

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-custom_blocklists-items-properties-description.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_blocklists/items/properties/description")

### description Type

`string`

### description Constraints

**maximum length**: the maximum number of characters for this string is: `128`
