# request-allowlist input Schema

```txt
http://schema.nethserver.org/crowdsec/request-allowlist-input.json
```

Request an IP address or CIDR be added to the nethesis-insights allowlist

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [request-allowlist-input.json](crowdsec/request-allowlist-input.json "open original schema") |

## request-allowlist input Type

`object` ([request-allowlist input](request-allowlist-input.md))

## request-allowlist input Examples

```json
{
  "cidr": "203.0.113.7",
  "reason": "False positive: this is our office egress IP"
}
```

# request-allowlist input Properties

| Property          | Type     | Required | Nullable       | Defined by                                                                                                                                                      |
| :---------------- | :------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [cidr](#cidr)     | `string` | Required | cannot be null | [request-allowlist input](request-allowlist-input-properties-cidr.md "http://schema.nethserver.org/crowdsec/request-allowlist-input.json#/properties/cidr")     |
| [reason](#reason) | `string` | Required | cannot be null | [request-allowlist input](request-allowlist-input-properties-reason.md "http://schema.nethserver.org/crowdsec/request-allowlist-input.json#/properties/reason") |

## cidr

A bare address or CIDR. The server normalises a bare address to /32 or /128 and rejects a prefix wider than /24 (IPv4) or /48 (IPv6).

`cidr`

* is required

* Type: `string` ([cidr](request-allowlist-input-properties-cidr.md))

* cannot be null

* defined in: [request-allowlist input](request-allowlist-input-properties-cidr.md "http://schema.nethserver.org/crowdsec/request-allowlist-input.json#/properties/cidr")

### cidr Type

`string` ([cidr](request-allowlist-input-properties-cidr.md))

### cidr Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## reason

Free text explaining why this address should be allowlisted

`reason`

* is required

* Type: `string` ([reason](request-allowlist-input-properties-reason.md))

* cannot be null

* defined in: [request-allowlist input](request-allowlist-input-properties-reason.md "http://schema.nethserver.org/crowdsec/request-allowlist-input.json#/properties/reason")

### reason Type

`string` ([reason](request-allowlist-input-properties-reason.md))

### reason Constraints

**minimum length**: the minimum number of characters for this string is: `1`
