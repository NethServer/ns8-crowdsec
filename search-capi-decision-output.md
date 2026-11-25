# search-capi-decision output Schema

```txt
http://schema.nethserver.org/crowdsec/search-capi-decision-output.json
```

Whether the searched IP is present in the CAPI community blocklist, with matching decisions

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [search-capi-decision-output.json](crowdsec/search-capi-decision-output.json "open original schema") |

## search-capi-decision output Type

`object` ([search-capi-decision output](search-capi-decision-output.md))

## search-capi-decision output Examples

```json
{
  "found": true,
  "decisions": [
    {
      "id": 45002,
      "origin": "CAPI",
      "scenario": "ssh:bruteforce",
      "scope": "Ip",
      "type": "ban",
      "duration": "165h34m2s",
      "value": "107.189.1.82",
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

# search-capi-decision output Properties

| Property                | Type      | Required | Nullable       | Defined by                                                                                                                                                                        |
| :---------------------- | :-------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [found](#found)         | `boolean` | Required | cannot be null | [search-capi-decision output](search-capi-decision-output-properties-found.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/found")         |
| [decisions](#decisions) | `array`   | Required | cannot be null | [search-capi-decision output](search-capi-decision-output-properties-decisions.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions") |

## found

True if the IP is covered by at least one CAPI decision

`found`

* is required

* Type: `boolean` ([found](search-capi-decision-output-properties-found.md))

* cannot be null

* defined in: [search-capi-decision output](search-capi-decision-output-properties-found.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/found")

### found Type

`boolean` ([found](search-capi-decision-output-properties-found.md))

## decisions

CAPI decisions matching the searched IP

`decisions`

* is required

* Type: `object[]` ([Details](search-capi-decision-output-properties-decisions-items.md))

* cannot be null

* defined in: [search-capi-decision output](search-capi-decision-output-properties-decisions.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions")

### decisions Type

`object[]` ([Details](search-capi-decision-output-properties-decisions-items.md))
