# set-local-blocklist input Schema

```txt
http://schema.nethserver.org/crowdsec/set-local-blocklist-input.json
```

Replace the local blocklist: its addresses are banned permanently, the removed ones are unbanned

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [set-local-blocklist-input.json](crowdsec/set-local-blocklist-input.json "open original schema") |

## set-local-blocklist input Type

`object` ([set-local-blocklist input](set-local-blocklist-input.md))

## set-local-blocklist input Examples

```json
{
  "local_blocklist": [
    "203.0.113.25",
    "2001:db8::7"
  ]
}
```

```json
{
  "local_blocklist": []
}
```

# set-local-blocklist input Properties

| Property                            | Type    | Required | Nullable       | Defined by                                                                                                                                                                              |
| :---------------------------------- | :------ | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [local_blocklist](#local_blocklist) | `array` | Required | cannot be null | [set-local-blocklist input](set-local-blocklist-input-properties-local_blocklist.md "http://schema.nethserver.org/crowdsec/set-local-blocklist-input.json#/properties/local_blocklist") |

## local_blocklist

Single IPv4 or IPv6 addresses, one per item; empty items are ignored, networks and allowlisted addresses are rejected

`local_blocklist`

* is required

* Type: `string[]`

* cannot be null

* defined in: [set-local-blocklist input](set-local-blocklist-input-properties-local_blocklist.md "http://schema.nethserver.org/crowdsec/set-local-blocklist-input.json#/properties/local_blocklist")

### local_blocklist Type

`string[]`

### local_blocklist Constraints

**maximum number of items**: the maximum number of items for this array is: `1000`
