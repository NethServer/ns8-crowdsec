# Limit Schema

```txt
http://schema.nethserver.org/crowdsec/list-alerts-input.json#/properties/limit
```

Maximum number of alerts to return, or 'all' for no limit

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                         |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [list-alerts-input.json\*](crowdsec/list-alerts-input.json "open original schema") |

## limit Type

`string` ([Limit](list-alerts-input-properties-limit.md))

## limit Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value    | Explanation |
| :------- | :---------- |
| `"500"`  |             |
| `"1000"` |             |
| `"2000"` |             |
| `"3000"` |             |
| `"4000"` |             |
| `"all"`  |             |
