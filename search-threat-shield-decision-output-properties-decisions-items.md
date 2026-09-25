# Untitled object in search-threat-shield-decision output Schema

```txt
http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                                               |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [search-threat-shield-decision-output.json\*](crowdsec/search-threat-shield-decision-output.json "open original schema") |

## items Type

`object` ([Details](search-threat-shield-decision-output-properties-decisions-items.md))

# items Properties

| Property                | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                                                         |
| :---------------------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [id](#id)               | `integer` | Optional | cannot be null | [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-id.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/id")               |
| [origin](#origin)       | `string`  | Optional | cannot be null | [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-origin.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/origin")       |
| [scenario](#scenario)   | `string`  | Optional | cannot be null | [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-scenario.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/scenario")   |
| [scope](#scope)         | `string`  | Optional | cannot be null | [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-scope.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/scope")         |
| [type](#type)           | `string`  | Optional | cannot be null | [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-type.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/type")           |
| [duration](#duration)   | `string`  | Optional | cannot be null | [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-duration.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/duration")   |
| [value](#value)         | `string`  | Optional | cannot be null | [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-value.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/value")         |
| [simulated](#simulated) | `boolean` | Optional | cannot be null | [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-simulated.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/simulated") |

## id

Unique decision identifier

`id`

* is optional

* Type: `integer` ([id](search-threat-shield-decision-output-properties-decisions-items-properties-id.md))

* cannot be null

* defined in: [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-id.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/id")

### id Type

`integer` ([id](search-threat-shield-decision-output-properties-decisions-items-properties-id.md))

## origin

Source of the decision, always cscli-import here

`origin`

* is optional

* Type: `string` ([origin](search-threat-shield-decision-output-properties-decisions-items-properties-origin.md))

* cannot be null

* defined in: [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-origin.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/origin")

### origin Type

`string` ([origin](search-threat-shield-decision-output-properties-decisions-items-properties-origin.md))

## scenario

Scenario tag, threat-shield/<feed key>

`scenario`

* is optional

* Type: `string` ([scenario](search-threat-shield-decision-output-properties-decisions-items-properties-scenario.md))

* cannot be null

* defined in: [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-scenario.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/scenario")

### scenario Type

`string` ([scenario](search-threat-shield-decision-output-properties-decisions-items-properties-scenario.md))

## scope

Scope of the decision (e.g. Ip, Range)

`scope`

* is optional

* Type: `string` ([scope](search-threat-shield-decision-output-properties-decisions-items-properties-scope.md))

* cannot be null

* defined in: [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-scope.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/scope")

### scope Type

`string` ([scope](search-threat-shield-decision-output-properties-decisions-items-properties-scope.md))

## type

Decision type (e.g. ban)

`type`

* is optional

* Type: `string` ([type](search-threat-shield-decision-output-properties-decisions-items-properties-type.md))

* cannot be null

* defined in: [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-type.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/type")

### type Type

`string` ([type](search-threat-shield-decision-output-properties-decisions-items-properties-type.md))

## duration

Remaining ban duration

`duration`

* is optional

* Type: `string` ([duration](search-threat-shield-decision-output-properties-decisions-items-properties-duration.md))

* cannot be null

* defined in: [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-duration.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/duration")

### duration Type

`string` ([duration](search-threat-shield-decision-output-properties-decisions-items-properties-duration.md))

## value

IP or CIDR targeted by the decision

`value`

* is optional

* Type: `string` ([value](search-threat-shield-decision-output-properties-decisions-items-properties-value.md))

* cannot be null

* defined in: [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-value.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/value")

### value Type

`string` ([value](search-threat-shield-decision-output-properties-decisions-items-properties-value.md))

## simulated

Whether the decision is in simulation mode only

`simulated`

* is optional

* Type: `boolean` ([simulated](search-threat-shield-decision-output-properties-decisions-items-properties-simulated.md))

* cannot be null

* defined in: [search-threat-shield-decision output](search-threat-shield-decision-output-properties-decisions-items-properties-simulated.md "http://schema.nethserver.org/crowdsec/search-threat-shield-decision-output.json#/properties/decisions/items/properties/simulated")

### simulated Type

`boolean` ([simulated](search-threat-shield-decision-output-properties-decisions-items-properties-simulated.md))
