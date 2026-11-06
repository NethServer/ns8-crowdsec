# set-threat-shield input Schema

```txt
http://schema.nethserver.org/crowdsec/set-threat-shield-input.json
```

Select which Nethesis Threat Shield premium blocklists are imported as CrowdSec decisions

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | Yes        | Unknown status | No           | Forbidden         | Allowed               | none                | [set-threat-shield-input.json](crowdsec/set-threat-shield-input.json "open original schema") |

## set-threat-shield input Type

`object` ([set-threat-shield input](set-threat-shield-input.md))

## set-threat-shield input Examples

```json
{
  "feeds": [
    "yoroimallvl1",
    "nethesislvl3"
  ]
}
```

```json
{
  "feeds": []
}
```

```json
{
  "feeds": [
    "yoroimallvl1",
    "custom-mylist"
  ],
  "nethesis_allowlist": true,
  "custom_allowlists": [
    {
      "name": "office",
      "url": "https://example.org/allow.txt",
      "description": "Office IPs",
      "enabled": true
    }
  ],
  "custom_blocklists": [
    {
      "name": "mylist",
      "url": "https://example.org/block.txt",
      "description": "My list"
    }
  ]
}
```

# set-threat-shield input Properties

| Property                                  | Type      | Required | Nullable       | Defined by                                                                                                                                                                              |
| :---------------------------------------- | :-------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [feeds](#feeds)                           | `array`   | Required | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-feeds.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/feeds")                           |
| [nethesis_allowlist](#nethesis_allowlist) | `boolean` | Optional | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-nethesis_allowlist.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/nethesis_allowlist") |
| [custom_allowlists](#custom_allowlists)   | `array`   | Optional | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-custom_allowlists.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists")   |
| [custom_blocklists](#custom_blocklists)   | `array`   | Optional | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-custom_blocklists.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_blocklists")   |

## feeds

Catalog keys and custom-<name> keys of the enabled feeds. An empty array disables the feature and removes every Threat Shield decision.

`feeds`

* is required

* Type: `string[]`

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-feeds.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/feeds")

### feeds Type

`string[]`

## nethesis_allowlist

Import the Nethesis global allowlist (subscription only). Missing means unchanged.

`nethesis_allowlist`

* is optional

* Type: `boolean` ([nethesis_allowlist](set-threat-shield-input-properties-nethesis_allowlist.md))

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-nethesis_allowlist.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/nethesis_allowlist")

### nethesis_allowlist Type

`boolean` ([nethesis_allowlist](set-threat-shield-input-properties-nethesis_allowlist.md))

## custom_allowlists

Custom allowlists, each imported into the cscli allowlist threat_shield\_<name>. Missing means unchanged.

`custom_allowlists`

* is optional

* Type: `object[]` ([Details](set-threat-shield-input-properties-custom_allowlists-items.md))

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-custom_allowlists.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists")

### custom_allowlists Type

`object[]` ([Details](set-threat-shield-input-properties-custom_allowlists-items.md))

## custom_blocklists

Custom blocklists, selectable in feeds as custom-<name>. Missing means unchanged.

`custom_blocklists`

* is optional

* Type: `object[]` ([Details](set-threat-shield-input-properties-custom_blocklists-items.md))

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-custom_blocklists.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_blocklists")

### custom_blocklists Type

`object[]` ([Details](set-threat-shield-input-properties-custom_blocklists-items.md))

# set-threat-shield input Definitions

## Definitions group name

Reference this group by using

```json
{"$ref":"http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/definitions/name"}
```

| Property | Type | Required | Nullable | Defined by |
| :------- | :--- | :------- | :------- | :--------- |

## Definitions group url

Reference this group by using

```json
{"$ref":"http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/definitions/url"}
```

| Property | Type | Required | Nullable | Defined by |
| :------- | :--- | :------- | :------- | :--------- |

## Definitions group description

Reference this group by using

```json
{"$ref":"http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/definitions/description"}
```

| Property | Type | Required | Nullable | Defined by |
| :------- | :--- | :------- | :------- | :--------- |
