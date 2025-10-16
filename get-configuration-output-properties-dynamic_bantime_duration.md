# dynamic\_bantime\_duration Schema

```txt
http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/dynamic_bantime_duration
```

Base duration for dynamic bantime, in minutes

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [get-configuration-output.json\*](crowdsec/get-configuration-output.json "open original schema") |

## dynamic\_bantime\_duration Type

`string` ([dynamic\_bantime\_duration](get-configuration-output-properties-dynamic_bantime_duration.md))

## dynamic\_bantime\_duration Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[1-9][0-9]*$
```

[try pattern](https://regexr.com/?expression=%5E%5B1-9%5D%5B0-9%5D*%24 "try regular expression with regexr.com")
