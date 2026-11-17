# Untitled string in set-threat-shield input Schema

```txt
http://schema.nethserver.org/crowdsec/set-threat-shield-input.json#/definitions/url
```

http or https URL of a plain list, one IP address or CIDR per line; an optional user:pass@ is sent as HTTP Basic authentication

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [set-threat-shield-input.json\*](crowdsec/set-threat-shield-input.json "open original schema") |

## url Type

`string`

## url Constraints

**maximum length**: the maximum number of characters for this string is: `512`

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^https?://([^/?#@\s]+@)?[^/?#@\s]+([/?#]\S*)?$
```

[try pattern](https://regexr.com/?expression=%5Ehttps%3F%3A%2F%2F\(%5B%5E%2F%3F%23%40%5Cs%5D%2B%40\)%3F%5B%5E%2F%3F%23%40%5Cs%5D%2B\(%5B%2F%3F%23%5D%5CS*\)%3F%24 "try regular expression with regexr.com")
