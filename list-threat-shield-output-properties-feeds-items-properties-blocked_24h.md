# blocked_24h Schema

```txt
http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/blocked_24h
```

Packets from this feed's addresses blocked by the firewall in the last 24 hours; an address on several feeds is credited to the highest-confidence one

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [list-threat-shield-output.json\*](crowdsec/list-threat-shield-output.json "open original schema") |

## blocked_24h Type

`integer` ([blocked_24h](list-threat-shield-output-properties-feeds-items-properties-blocked_24h.md))

## blocked_24h Constraints

**minimum**: the value of this number must greater than or equal to: `0`
