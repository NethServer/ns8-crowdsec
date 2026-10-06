# toggle-collection input Schema

```txt
http://schema.nethserver.org/crowdsec/toggle-collection-input.json
```

Enable or disable a CrowdSec collection

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [toggle-collection-input.json](crowdsec/toggle-collection-input.json "open original schema") |

## toggle-collection input Type

`object` ([toggle-collection input](toggle-collection-input.md))

## toggle-collection input Examples

```json
{
  "name": "crowdsecurity/linux",
  "action": "install"
}
```

# toggle-collection input Properties

| Property          | Type     | Required | Nullable       | Defined by                                                                                                                                                      |
| :---------------- | :------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [name](#name)     | `string` | Required | cannot be null | [toggle-collection input](toggle-collection-input-properties-name.md "http://schema.nethserver.org/crowdsec/toggle-collection-input.json#/properties/name")     |
| [action](#action) | `string` | Required | cannot be null | [toggle-collection input](toggle-collection-input-properties-action.md "http://schema.nethserver.org/crowdsec/toggle-collection-input.json#/properties/action") |

## name

Collection name

`name`

* is required

* Type: `string` ([name](toggle-collection-input-properties-name.md))

* cannot be null

* defined in: [toggle-collection input](toggle-collection-input-properties-name.md "http://schema.nethserver.org/crowdsec/toggle-collection-input.json#/properties/name")

### name Type

`string` ([name](toggle-collection-input-properties-name.md))

## action

Action to perform on the collection

`action`

* is required

* Type: `string` ([action](toggle-collection-input-properties-action.md))

* cannot be null

* defined in: [toggle-collection input](toggle-collection-input-properties-action.md "http://schema.nethserver.org/crowdsec/toggle-collection-input.json#/properties/action")

### action Type

`string` ([action](toggle-collection-input-properties-action.md))

### action Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value       | Explanation |
| :---------- | :---------- |
| `"install"` |             |
| `"remove"`  |             |
