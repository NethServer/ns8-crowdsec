# cidr Schema

```txt
http://schema.nethserver.org/crowdsec/request-allowlist-input.json#/properties/cidr
```

A bare address or CIDR. The server normalises a bare address to /32 or /128 and rejects a prefix wider than /24 (IPv4) or /48 (IPv6).

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [request-allowlist-input.json\*](crowdsec/request-allowlist-input.json "open original schema") |

## cidr Type

`string` ([cidr](request-allowlist-input-properties-cidr.md))

## cidr Constraints

**minimum length**: the minimum number of characters for this string is: `1`
