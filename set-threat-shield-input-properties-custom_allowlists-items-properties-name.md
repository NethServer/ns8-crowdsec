# Untitled string in set-threat-shield input Schema

```txt
http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/properties/custom_allowlists/items/properties/name
```

Unique list name: lowercase letters, digits and dashes, at most 20 characters

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [set-threat-shield-input.json\*](crowdsec/set-threat-shield-input.json "open original schema") |

## name Type

`string`

## name Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[a-z0-9][a-z0-9-]{0,19}$
```

[try pattern](https://regexr.com/?expression=%5E%5Ba-z0-9%5D%5Ba-z0-9-%5D%7B0%2C19%7D%24 "try regular expression with regexr.com")
