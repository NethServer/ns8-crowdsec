# group\_threshold Schema

```txt
http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/group_threshold
```

Number of alerts to group before sending an email

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [get-configuration-output.json\*](crowdsec/get-configuration-output.json "open original schema") |

## group\_threshold Type

`integer` ([group\_threshold](get-configuration-output-properties-group_threshold.md))

## group\_threshold Constraints

**maximum**: the value of this number must smaller than or equal to: `10000`

**minimum**: the value of this number must greater than or equal to: `1`
