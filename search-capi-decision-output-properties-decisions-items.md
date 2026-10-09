# Untitled object in search-capi-decision output Schema

```txt
http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                             |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [search-capi-decision-output.json\*](crowdsec/search-capi-decision-output.json "open original schema") |

## items Type

`object` ([Details](search-capi-decision-output-properties-decisions-items.md))

# items Properties

| Property                | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                              |
| :---------------------- | :-------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [id](#id)               | `integer` | Required | cannot be null | [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-id.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/id")               |
| [origin](#origin)       | `string`  | Required | cannot be null | [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-origin.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/origin")       |
| [scenario](#scenario)   | `string`  | Required | cannot be null | [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-scenario.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/scenario")   |
| [scope](#scope)         | `string`  | Required | cannot be null | [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-scope.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/scope")         |
| [type](#type)           | `string`  | Required | cannot be null | [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-type.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/type")           |
| [duration](#duration)   | `string`  | Required | cannot be null | [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-duration.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/duration")   |
| [value](#value)         | `string`  | Required | cannot be null | [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-value.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/value")         |
| [simulated](#simulated) | `boolean` | Required | cannot be null | [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-simulated.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/simulated") |

## id

Unique decision identifier

`id`

* is required

* Type: `integer` ([id](search-capi-decision-output-properties-decisions-items-properties-id.md))

* cannot be null

* defined in: [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-id.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/id")

### id Type

`integer` ([id](search-capi-decision-output-properties-decisions-items-properties-id.md))

## origin

Source of the decision

`origin`

* is required

* Type: `string` ([origin](search-capi-decision-output-properties-decisions-items-properties-origin.md))

* cannot be null

* defined in: [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-origin.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/origin")

### origin Type

`string` ([origin](search-capi-decision-output-properties-decisions-items-properties-origin.md))

## scenario

CrowdSec scenario that triggered the decision

`scenario`

* is required

* Type: `string` ([scenario](search-capi-decision-output-properties-decisions-items-properties-scenario.md))

* cannot be null

* defined in: [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-scenario.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/scenario")

### scenario Type

`string` ([scenario](search-capi-decision-output-properties-decisions-items-properties-scenario.md))

## scope

Scope of the decision (e.g. Ip, Range)

`scope`

* is required

* Type: `string` ([scope](search-capi-decision-output-properties-decisions-items-properties-scope.md))

* cannot be null

* defined in: [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-scope.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/scope")

### scope Type

`string` ([scope](search-capi-decision-output-properties-decisions-items-properties-scope.md))

## type

Decision type (e.g. ban)

`type`

* is required

* Type: `string` ([type](search-capi-decision-output-properties-decisions-items-properties-type.md))

* cannot be null

* defined in: [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-type.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/type")

### type Type

`string` ([type](search-capi-decision-output-properties-decisions-items-properties-type.md))

## duration

Remaining ban duration (e.g. 165h34m2s)

`duration`

* is required

* Type: `string` ([duration](search-capi-decision-output-properties-decisions-items-properties-duration.md))

* cannot be null

* defined in: [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-duration.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/duration")

### duration Type

`string` ([duration](search-capi-decision-output-properties-decisions-items-properties-duration.md))

## value

IP address targeted by the decision

`value`

* is required

* Type: `string` ([value](search-capi-decision-output-properties-decisions-items-properties-value.md))

* cannot be null

* defined in: [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-value.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/value")

### value Type

`string` ([value](search-capi-decision-output-properties-decisions-items-properties-value.md))

## simulated

Whether the decision is in simulation mode only

`simulated`

* is required

* Type: `boolean` ([simulated](search-capi-decision-output-properties-decisions-items-properties-simulated.md))

* cannot be null

* defined in: [search-capi-decision output](search-capi-decision-output-properties-decisions-items-properties-simulated.md "http://schema.nethserver.org/crowdsec/search-capi-decision-output.json#/properties/decisions/items/properties/simulated")

### simulated Type

`boolean` ([simulated](search-capi-decision-output-properties-decisions-items-properties-simulated.md))
