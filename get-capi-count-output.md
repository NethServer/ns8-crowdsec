# get-capi-count output Schema

```txt
http://schema.nethserver.org/crowdsec/get-capi-count-output.json
```

Number of active decisions received from the CrowdSec community blocklist

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                               |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [get-capi-count-output.json](crowdsec/get-capi-count-output.json "open original schema") |

## get-capi-count output Type

`object` ([get-capi-count output](get-capi-count-output.md))

## get-capi-count output Examples

```json
{
  "count": 15423
}
```

# get-capi-count output Properties

| Property        | Type      | Required | Nullable       | Defined by                                                                                                                                              |
| :-------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [count](#count) | `integer` | Required | cannot be null | [get-capi-count output](get-capi-count-output-properties-count.md "http://schema.nethserver.org/crowdsec/get-capi-count-output.json#/properties/count") |

## count

Total number of IPs currently blocked via CAPI community decisions

`count`

* is required

* Type: `integer` ([count](get-capi-count-output-properties-count.md))

* cannot be null

* defined in: [get-capi-count output](get-capi-count-output-properties-count.md "http://schema.nethserver.org/crowdsec/get-capi-count-output.json#/properties/count")

### count Type

`integer` ([count](get-capi-count-output-properties-count.md))

### count Constraints

**minimum**: the value of this number must greater than or equal to: `0`
