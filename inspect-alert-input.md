# inspect-alert input Schema

```txt
http://schema.nethserver.org/crowdsec/inspect-alert-input.json
```

Inspect a specific CrowdSec alert by ID

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [inspect-alert-input.json](crowdsec/inspect-alert-input.json "open original schema") |

## inspect-alert input Type

`object` ([inspect-alert input](inspect-alert-input.md))

## inspect-alert input Examples

```json
{
  "id": 42
}
```

# inspect-alert input Properties

| Property  | Type      | Required | Nullable       | Defined by                                                                                                                                  |
| :-------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------ |
| [id](#id) | `integer` | Required | cannot be null | [inspect-alert input](inspect-alert-input-properties-id.md "http://schema.nethserver.org/crowdsec/inspect-alert-input.json#/properties/id") |

## id

Alert ID to inspect

`id`

* is required

* Type: `integer` ([id](inspect-alert-input-properties-id.md))

* cannot be null

* defined in: [inspect-alert input](inspect-alert-input-properties-id.md "http://schema.nethserver.org/crowdsec/inspect-alert-input.json#/properties/id")

### id Type

`integer` ([id](inspect-alert-input-properties-id.md))
