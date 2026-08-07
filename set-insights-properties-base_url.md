# Untitled string in Configure the insights blocklist-evidence webhook Schema

```txt
http://schema.nethserver.org/crowdsec/set-insights.json#/properties/base_url
```

Base URL of the nethesis-insights server that receives the decisions.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                               |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [set-insights.json\*](crowdsec/set-insights.json "open original schema") |

## base\_url Type

`string`

## base\_url Constraints

**URI**: the string must be a URI, according to [RFC 3986](https://tools.ietf.org/html/rfc3986 "check the specification")
