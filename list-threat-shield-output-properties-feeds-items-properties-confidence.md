# confidence Schema

```txt
http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/confidence
```

How much to trust this feed, 1-10; -1 means not rated (e.g. a community subscription)

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [list-threat-shield-output.json\*](crowdsec/list-threat-shield-output.json "open original schema") |

## confidence Type

`integer` ([confidence](list-threat-shield-output-properties-feeds-items-properties-confidence.md))

## confidence Constraints

**maximum**: the value of this number must smaller than or equal to: `10`

**minimum**: the value of this number must greater than or equal to: `-1`
