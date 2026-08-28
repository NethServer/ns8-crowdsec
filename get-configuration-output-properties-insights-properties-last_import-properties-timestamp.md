# Untitled string in get-configuration output Schema

```txt
http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import/properties/timestamp
```

UTC time of the last blocklist pull attempt

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [get-configuration-output.json\*](crowdsec/get-configuration-output.json "open original schema") |

## timestamp Type

`string`

## timestamp Constraints

**date time**: the string must be a date time string, according to [RFC 3339, section 5.6](https://tools.ietf.org/html/rfc3339 "check the specification")
