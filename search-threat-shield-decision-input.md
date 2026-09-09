# search-threat-shield-decision input Schema

```txt
http://schema.nethserver.org/crowdsec/search-threat-shield-decision-input.json
```

Search for an IP address in the Nethesis Threat Shield decisions

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [search-threat-shield-decision-input.json](crowdsec/search-threat-shield-decision-input.json "open original schema") |

## search-threat-shield-decision input Type

`object` ([search-threat-shield-decision input](search-threat-shield-decision-input.md))

## search-threat-shield-decision input Examples

```json
{
  "ip": "185.220.101.5"
}
```

# search-threat-shield-decision input Properties

| Property  | Type     | Required | Nullable       | Defined by                                                                                                                                                                                  |
| :-------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [ip](#ip) | `string` | Required | cannot be null | [search-threat-shield-decision input](search-threat-shield-decision-input-properties-ip.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-input.json#/properties/ip") |

## ip

IP address to look up. Matches both exact values and enclosing CIDR bans.

`ip`

* is required

* Type: `string` ([ip](search-threat-shield-decision-input-properties-ip.md))

* cannot be null

* defined in: [search-threat-shield-decision input](search-threat-shield-decision-input-properties-ip.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-input.json#/properties/ip")

### ip Type

`string` ([ip](search-threat-shield-decision-input-properties-ip.md))
