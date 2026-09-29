# set-threat-shield input Schema

```txt
http://schema.nethserver.org/crowdsec/set-threat-shield-input.json
```

Select which Nethesis Threat Shield premium blocklists are imported as CrowdSec decisions

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [set-threat-shield-input.json](crowdsec/set-threat-shield-input.json "open original schema") |

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

# set-threat-shield input Properties

| Property        | Type    | Required | Nullable       | Defined by                                                                                                                                                    |
| :-------------- | :------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [feeds](#feeds) | `array` | Required | cannot be null | [set-threat-shield input](set-threat-shield-input-properties-feeds.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/feeds") |

## feeds

Catalog keys of the enabled feeds. An empty array disables the feature and removes every Threat Shield decision.

`feeds`

* is required

* Type: `string[]`

* cannot be null

* defined in: [set-threat-shield input](set-threat-shield-input-properties-feeds.md "http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/feeds")

### feeds Type

`string[]`
