# Untitled object in list-collections output Schema

```txt
http://schema.nethserver.org/crowdsec/list-collections-output.json#/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-collections-output.json\*](crowdsec/list-collections-output.json "open original schema") |

## items Type

`object` ([Details](list-collections-output-items.md))

# items Properties

| Property                        | Type      | Required | Nullable       | Defined by                                                                                                                                                                                |
| :------------------------------ | :-------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [name](#name)                   | `string`  | Required | cannot be null | [list-collections output](list-collections-output-items-properties-name.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/name")                   |
| [status](#status)               | `string`  | Required | cannot be null | [list-collections output](list-collections-output-items-properties-status.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/status")               |
| [local_version](#local_version) | `string`  | Optional | cannot be null | [list-collections output](list-collections-output-items-properties-local_version.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/local_version") |
| [local_path](#local_path)       | `string`  | Optional | cannot be null | [list-collections output](list-collections-output-items-properties-local_path.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/local_path")       |
| [description](#description)     | `string`  | Optional | can be null    | [list-collections output](list-collections-output-items-properties-description.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/description")     |
| [up_to_date](#up_to_date)       | `boolean` | Optional | cannot be null | [list-collections output](list-collections-output-items-properties-up_to_date.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/up_to_date")       |
| [tainted](#tainted)             | `boolean` | Optional | cannot be null | [list-collections output](list-collections-output-items-properties-tainted.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/tainted")             |

## name

Collection name

`name`

* is required

* Type: `string` ([name](list-collections-output-items-properties-name.md))

* cannot be null

* defined in: [list-collections output](list-collections-output-items-properties-name.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/name")

### name Type

`string` ([name](list-collections-output-items-properties-name.md))

## status

Collection status (e.g. enabled, disabled)

`status`

* is required

* Type: `string` ([status](list-collections-output-items-properties-status.md))

* cannot be null

* defined in: [list-collections output](list-collections-output-items-properties-status.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/status")

### status Type

`string` ([status](list-collections-output-items-properties-status.md))

## local_version

Installed version of the collection

`local_version`

* is optional

* Type: `string` ([local_version](list-collections-output-items-properties-local_version.md))

* cannot be null

* defined in: [list-collections output](list-collections-output-items-properties-local_version.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/local_version")

### local_version Type

`string` ([local_version](list-collections-output-items-properties-local_version.md))

## local_path

Path to the collection file on disk

`local_path`

* is optional

* Type: `string` ([local_path](list-collections-output-items-properties-local_path.md))

* cannot be null

* defined in: [list-collections output](list-collections-output-items-properties-local_path.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/local_path")

### local_path Type

`string` ([local_path](list-collections-output-items-properties-local_path.md))

## description

Human-readable description of the collection

`description`

* is optional

* Type: `string` ([description](list-collections-output-items-properties-description.md))

* can be null

* defined in: [list-collections output](list-collections-output-items-properties-description.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/description")

### description Type

`string` ([description](list-collections-output-items-properties-description.md))

## up_to_date

Whether the installed version matches the latest available

`up_to_date`

* is optional

* Type: `boolean` ([up_to_date](list-collections-output-items-properties-up_to_date.md))

* cannot be null

* defined in: [list-collections output](list-collections-output-items-properties-up_to_date.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/up_to_date")

### up_to_date Type

`boolean` ([up_to_date](list-collections-output-items-properties-up_to_date.md))

## tainted

Whether the collection has been locally modified

`tainted`

* is optional

* Type: `boolean` ([tainted](list-collections-output-items-properties-tainted.md))

* cannot be null

* defined in: [list-collections output](list-collections-output-items-properties-tainted.md "http://schema.nethserver.org/crowdsec/list-collections-output.json#/items/properties/tainted")

### tainted Type

`boolean` ([tainted](list-collections-output-items-properties-tainted.md))
