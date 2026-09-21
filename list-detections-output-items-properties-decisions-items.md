# Untitled object in list-detections output Schema

```txt
http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/decisions/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-detections-output.json\*](crowdsec/list-detections-output.json "open original schema") |

## items Type

`object` ([Details](list-detections-output-items-properties-decisions-items.md))

# items Properties

| Property              | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                         |
| :-------------------- | :------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [type](#type)         | `string` | Optional | cannot be null | [list-detections output](list-detections-output-items-properties-decisions-items-properties-type.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/decisions/items/properties/type")         |
| [duration](#duration) | `string` | Optional | cannot be null | [list-detections output](list-detections-output-items-properties-decisions-items-properties-duration.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/decisions/items/properties/duration") |

## type

Decision type (e.g. ban)

`type`

* is optional

* Type: `string` ([type](list-detections-output-items-properties-decisions-items-properties-type.md))

* cannot be null

* defined in: [list-detections output](list-detections-output-items-properties-decisions-items-properties-type.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/decisions/items/properties/type")

### type Type

`string` ([type](list-detections-output-items-properties-decisions-items-properties-type.md))

## duration

Remaining ban duration (e.g. 24h0m0s)

`duration`

* is optional

* Type: `string` ([duration](list-detections-output-items-properties-decisions-items-properties-duration.md))

* cannot be null

* defined in: [list-detections output](list-detections-output-items-properties-decisions-items-properties-duration.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/decisions/items/properties/duration")

### duration Type

`string` ([duration](list-detections-output-items-properties-decisions-items-properties-duration.md))
