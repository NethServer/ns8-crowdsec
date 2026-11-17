# Untitled string in set-threat-shield input Schema

```txt
http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/definitions/name
```

Unique list name: 3 to 16 lowercase letters and digits, starting with a letter; names starting with nethesis, yoroi or crowdsec are reserved

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [set-threat-shield-input.json\*](crowdsec/set-threat-shield-input.json "open original schema") |

## name Type

`string`

## name Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[a-z][a-z0-9]{2,15}$
```

[try pattern](https://regexr.com/?expression=%5E%5Ba-z%5D%5Ba-z0-9%5D%7B2%2C15%7D%24 "try regular expression with regexr.com")
