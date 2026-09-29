# action Schema

```txt
http://schema.nethserver.org/crowdsec/toggle-collection-input.json#/properties/action
```

Action to perform on the collection

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [toggle-collection-input.json\*](crowdsec/toggle-collection-input.json "open original schema") |

## action Type

`string` ([action](toggle-collection-input-properties-action.md))

## action Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value       | Explanation |
| :---------- | :---------- |
| `"install"` |             |
| `"remove"`  |             |
