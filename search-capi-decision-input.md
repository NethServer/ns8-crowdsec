# search-capi-decision input Schema

```txt
http://schema.nethserver.org/crowdsec/search-capi-decision-input.json
```

Search for a specific IP address in the CrowdSec community blocklist

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [search-capi-decision-input.json](crowdsec/search-capi-decision-input.json "open original schema") |

## search-capi-decision input Type

`object` ([search-capi-decision input](search-capi-decision-input.md))

## search-capi-decision input Examples

```json
{
  "ip": "185.220.101.0"
}
```

# search-capi-decision input Properties

| Property  | Type     | Required | Nullable       | Defined by                                                                                                                                                       |
| :-------- | :------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [ip](#ip) | `string` | Required | cannot be null | [search-capi-decision input](search-capi-decision-input-properties-ip.md "http://schema.nethserver.org/crowdsec/search-capi-decision-input.json#/properties/ip") |

## ip

IP address to look up in the CAPI community decisions

`ip`

* is required

* Type: `string` ([ip](search-capi-decision-input-properties-ip.md))

* cannot be null

* defined in: [search-capi-decision input](search-capi-decision-input-properties-ip.md "http://schema.nethserver.org/crowdsec/search-capi-decision-input.json#/properties/ip")

### ip Type

`string` ([ip](search-capi-decision-input-properties-ip.md))
