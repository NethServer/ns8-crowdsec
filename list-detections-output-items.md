# Untitled object in list-detections output Schema

```txt
http://schema.nethserver.org/crowdsec/list-detections-output.json#/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-detections-output.json\*](crowdsec/list-detections-output.json "open original schema") |

## items Type

`object` ([Details](list-detections-output-items.md))

# items Properties

| Property                       | Type      | Required | Nullable       | Defined by                                                                                                                                                                           |
| :----------------------------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [id](#id)                      | `integer` | Required | cannot be null | [list-detections output](list-detections-output-items-properties-id.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/id")                     |
| [created\_at](#created_at)     | `string`  | Required | cannot be null | [list-detections output](list-detections-output-items-properties-created_at.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/created_at")     |
| [scenario](#scenario)          | `string`  | Required | cannot be null | [list-detections output](list-detections-output-items-properties-scenario.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/scenario")         |
| [simulated](#simulated)        | `boolean` | Required | cannot be null | [list-detections output](list-detections-output-items-properties-simulated.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/simulated")       |
| [events\_count](#events_count) | `integer` | Required | cannot be null | [list-detections output](list-detections-output-items-properties-events_count.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/events_count") |
| [source](#source)              | `object`  | Required | cannot be null | [list-detections output](list-detections-output-items-properties-source.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/source")             |
| [decisions](#decisions)        | `array`   | Optional | can be null    | [list-detections output](list-detections-output-items-properties-decisions.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/decisions")       |

## id

Unique alert identifier

`id`

* is required

* Type: `integer` ([id](list-detections-output-items-properties-id.md))

* cannot be null

* defined in: [list-detections output](list-detections-output-items-properties-id.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/id")

### id Type

`integer` ([id](list-detections-output-items-properties-id.md))

## created\_at

Timestamp when the alert was created

`created_at`

* is required

* Type: `string` ([created\_at](list-detections-output-items-properties-created_at.md))

* cannot be null

* defined in: [list-detections output](list-detections-output-items-properties-created_at.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/created_at")

### created\_at Type

`string` ([created\_at](list-detections-output-items-properties-created_at.md))

## scenario

CrowdSec scenario that triggered the alert

`scenario`

* is required

* Type: `string` ([scenario](list-detections-output-items-properties-scenario.md))

* cannot be null

* defined in: [list-detections output](list-detections-output-items-properties-scenario.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/scenario")

### scenario Type

`string` ([scenario](list-detections-output-items-properties-scenario.md))

## simulated

Whether the alert is in simulation mode only

`simulated`

* is required

* Type: `boolean` ([simulated](list-detections-output-items-properties-simulated.md))

* cannot be null

* defined in: [list-detections output](list-detections-output-items-properties-simulated.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/simulated")

### simulated Type

`boolean` ([simulated](list-detections-output-items-properties-simulated.md))

## events\_count

Number of events that triggered the alert

`events_count`

* is required

* Type: `integer` ([events\_count](list-detections-output-items-properties-events_count.md))

* cannot be null

* defined in: [list-detections output](list-detections-output-items-properties-events_count.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/events_count")

### events\_count Type

`integer` ([events\_count](list-detections-output-items-properties-events_count.md))

## source

Origin of the alert

`source`

* is required

* Type: `object` ([source](list-detections-output-items-properties-source.md))

* cannot be null

* defined in: [list-detections output](list-detections-output-items-properties-source.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/source")

### source Type

`object` ([source](list-detections-output-items-properties-source.md))

## decisions

Decisions taken in response to this alert

`decisions`

* is optional

* Type: `object[]` ([Details](list-detections-output-items-properties-decisions-items.md))

* can be null

* defined in: [list-detections output](list-detections-output-items-properties-decisions.md "http://schema.nethserver.org/crowdsec/list-detections-output.json#/items/properties/decisions")

### decisions Type

`object[]` ([Details](list-detections-output-items-properties-decisions-items.md))
