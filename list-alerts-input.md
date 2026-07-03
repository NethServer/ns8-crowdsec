# list-alerts input Schema

```txt
http://schema.nethserver.org/crowdsec/list-alerts-input.json
```

List CrowdSec alerts with an optional result limit

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [list-alerts-input.json](crowdsec/list-alerts-input.json "open original schema") |

## list-alerts input Type

`object` ([list-alerts input](list-alerts-input.md))

## list-alerts input Examples

```json
{
  "limit": "500"
}
```

```json
{
  "limit": "all"
}
```

# list-alerts input Properties

| Property        | Type     | Required | Nullable       | Defined by                                                                                                                                  |
| :-------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------ |
| [limit](#limit) | `string` | Optional | cannot be null | [list-alerts input](list-alerts-input-properties-limit.md "http://schema.nethserver.org/crowdsec/list-alerts-input.json#/properties/limit") |

## limit

Maximum number of alerts to return, or 'all' for no limit

`limit`

* is optional

* Type: `string` ([Limit](list-alerts-input-properties-limit.md))

* cannot be null

* defined in: [list-alerts input](list-alerts-input-properties-limit.md "http://schema.nethserver.org/crowdsec/list-alerts-input.json#/properties/limit")

### limit Type

`string` ([Limit](list-alerts-input-properties-limit.md))

### limit Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value    | Explanation |
| :------- | :---------- |
| `"500"`  |             |
| `"1000"` |             |
| `"2000"` |             |
| `"3000"` |             |
| `"4000"` |             |
| `"all"`  |             |
