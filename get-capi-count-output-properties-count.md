# count Schema

```txt
http://schema.nethserver.org/crowdsec/get-capi-count-output.json#/properties/count
```

Total number of IPs currently blocked via CAPI community decisions

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                 |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [get-capi-count-output.json\*](crowdsec/get-capi-count-output.json "open original schema") |

## count Type

`integer` ([count](get-capi-count-output-properties-count.md))

## count Constraints

**minimum**: the value of this number must greater than or equal to: `0`
