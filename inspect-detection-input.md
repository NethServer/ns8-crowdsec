# inspect-detection input Schema

```txt
http://schema.nethserver.org/crowdsec/inspect-detection-input.json
```

Inspect a specific CrowdSec alert by ID

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [inspect-detection-input.json](crowdsec/inspect-detection-input.json "open original schema") |

## inspect-detection input Type

`object` ([inspect-detection input](inspect-detection-input.md))

## inspect-detection input Examples

```json
{
  "id": 42
}
```

# inspect-detection input Properties

| Property  | Type      | Required | Nullable       | Defined by                                                                                                                                              |
| :-------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [id](#id) | `integer` | Required | cannot be null | [inspect-detection input](inspect-detection-input-properties-id.md "http://schema.nethserver.org/crowdsec/inspect-detection-input.json#/properties/id") |

## id

Alert ID to inspect

`id`

* is required

* Type: `integer` ([id](inspect-detection-input-properties-id.md))

* cannot be null

* defined in: [inspect-detection input](inspect-detection-input-properties-id.md "http://schema.nethserver.org/crowdsec/inspect-detection-input.json#/properties/id")

### id Type

`integer` ([id](inspect-detection-input-properties-id.md))
