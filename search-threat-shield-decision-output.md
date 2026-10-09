# search-threat-shield-decision output Schema

```txt
http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json
```

Whether the searched IP is covered by a Nethesis Threat Shield decision, with the matching decisions

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                                             |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [search-threat-shield-decision-output.json](crowdsec/search-threat-shield-decision-output.json "open original schema") |

## search-threat-shield-decision output Type

`object` ([search-threat-shield-decision output](search-threat-shield-decision-output.md))

## search-threat-shield-decision output Examples

```json
{
  "found": true,
  "decisions": [
    {
      "id": 91002,
      "origin": "cscli-import",
      "scenario": "threat-shield/nethesislvl3",
      "scope": "Ip",
      "type": "ban",
      "duration": "6h59m2s",
      "value": "185.220.101.0/24",
      "simulated": false
    }
  ]
}
```

```json
{
  "found": false,
  "decisions": []
}
```

# search-threat-shield-decision output Properties

| Property                | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                   |
| :---------------------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [found](#found)         | `boolean` | Required | cannot be null | [search-threat-shield-decision output](search-threat-shield-decision-output-properties-found.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/found")         |
| [decisions](#decisions) | `array`   | Required | cannot be null | [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions") |

## found

True if at least one Threat Shield decision covers the IP

`found`

* is required

* Type: `boolean` ([found](search-threat-shield-decision-output-properties-found.md))

* cannot be null

* defined in: [search-threat-shield-decision output](search-threat-shield-decision-output-properties-found.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/found")

### found Type

`boolean` ([found](search-threat-shield-decision-output-properties-found.md))

## decisions

Threat Shield decisions matching the searched IP

`decisions`

* is required

* Type: `object[]` ([Details](search-threat-shield-decision-output-properties-decisions-items.md))

* cannot be null

* defined in: [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions")

### decisions Type

`object[]` ([Details](search-threat-shield-decision-output-properties-decisions-items.md))
