# local_blocklist Schema

```txt
http://schema.nethserver.org/crowdsec/set-local-blocklist-input.json#/properties/local_blocklist
```

Single IPv4 or IPv6 addresses, one per item; empty items are ignored, networks and allowlisted addresses are rejected

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [set-local-blocklist-input.json\*](crowdsec/set-local-blocklist-input.json "open original schema") |

## local_blocklist Type

`string[]`

## local_blocklist Constraints

**maximum number of items**: the maximum number of items for this array is: `1000`
