# Untitled object in list-threat-shield output Schema

```txt
http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-threat-shield-output.json\*](crowdsec/list-threat-shield-output.json "open original schema") |

## items Type

`object` ([Details](list-threat-shield-output-properties-feeds-items.md))

# items Properties

| Property                    | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                    |
| :-------------------------- | :-------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [key](#key)                 | `string`  | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-feeds-items-properties-key.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/key")                 |
| [description](#description) | `string`  | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-feeds-items-properties-description.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/description") |
| [enabled](#enabled)         | `boolean` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-feeds-items-properties-enabled.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/enabled")         |
| [count](#count)             | `integer` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-feeds-items-properties-count.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/count")             |
| [confidence](#confidence)   | `integer` | Required | cannot be null | [list-threat-shield output](list-threat-shield-output-properties-feeds-items-properties-confidence.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/confidence")   |

## key

Catalog key of the feed, or "nethesis-insights" for the virtual fleet-consensus feed

`key`

* is required

* Type: `string` ([key](list-threat-shield-output-properties-feeds-items-properties-key.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-feeds-items-properties-key.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/key")

### key Type

`string` ([key](list-threat-shield-output-properties-feeds-items-properties-key.md))

## description

Human readable feed name

`description`

* is required

* Type: `string` ([description](list-threat-shield-output-properties-feeds-items-properties-description.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-feeds-items-properties-description.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/description")

### description Type

`string` ([description](list-threat-shield-output-properties-feeds-items-properties-description.md))

## enabled

True if the feed is currently imported

`enabled`

* is required

* Type: `boolean` ([enabled](list-threat-shield-output-properties-feeds-items-properties-enabled.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-feeds-items-properties-enabled.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/enabled")

### enabled Type

`boolean` ([enabled](list-threat-shield-output-properties-feeds-items-properties-enabled.md))

## count

Active decisions currently held by this feed

`count`

* is required

* Type: `integer` ([count](list-threat-shield-output-properties-feeds-items-properties-count.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-feeds-items-properties-count.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/count")

### count Type

`integer` ([count](list-threat-shield-output-properties-feeds-items-properties-count.md))

### count Constraints

**minimum**: the value of this number must greater than or equal to: `0`

## confidence

How much to trust this feed, 1-10; -1 means not rated (e.g. a community subscription)

`confidence`

* is required

* Type: `integer` ([confidence](list-threat-shield-output-properties-feeds-items-properties-confidence.md))

* cannot be null

* defined in: [list-threat-shield output](list-threat-shield-output-properties-feeds-items-properties-confidence.md "http://schema.nethserver.org/crowdsec/list-threat-shield-output.json#/properties/feeds/items/properties/confidence")

### confidence Type

`integer` ([confidence](list-threat-shield-output-properties-feeds-items-properties-confidence.md))

### confidence Constraints

**maximum**: the value of this number must smaller than or equal to: `10`

**minimum**: the value of this number must greater than or equal to: `-1`
