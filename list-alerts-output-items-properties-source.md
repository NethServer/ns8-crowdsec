# source Schema

```txt
http://schema.nethserver.org/crowdsec/list-alerts-output.json#/items/properties/source
```

Origin of the alert

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-alerts-output.json\*](crowdsec/list-alerts-output.json "open original schema") |

## source Type

`object` ([source](list-alerts-output-items-properties-source.md))

# source Properties

| Property             | Type     | Required | Nullable       | Defined by                                                                                                                                                                                         |
| :------------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [ip](#ip)            | `string` | Optional | cannot be null | [list-alerts output](list-alerts-output-items-properties-source-properties-ip.md "http://schema.nethserver.org/crowdsec/list-alerts-output.json#/items/properties/source/properties/ip")           |
| [cn](#cn)            | `string` | Optional | can be null    | [list-alerts output](list-alerts-output-items-properties-source-properties-cn.md "http://schema.nethserver.org/crowdsec/list-alerts-output.json#/items/properties/source/properties/cn")           |
| [as\_name](#as_name) | `string` | Optional | can be null    | [list-alerts output](list-alerts-output-items-properties-source-properties-as_name.md "http://schema.nethserver.org/crowdsec/list-alerts-output.json#/items/properties/source/properties/as_name") |

## ip

Source IP address

`ip`

* is optional

* Type: `string` ([ip](list-alerts-output-items-properties-source-properties-ip.md))

* cannot be null

* defined in: [list-alerts output](list-alerts-output-items-properties-source-properties-ip.md "http://schema.nethserver.org/crowdsec/list-alerts-output.json#/items/properties/source/properties/ip")

### ip Type

`string` ([ip](list-alerts-output-items-properties-source-properties-ip.md))

## cn

Country code of the source IP

`cn`

* is optional

* Type: `string` ([cn](list-alerts-output-items-properties-source-properties-cn.md))

* can be null

* defined in: [list-alerts output](list-alerts-output-items-properties-source-properties-cn.md "http://schema.nethserver.org/crowdsec/list-alerts-output.json#/items/properties/source/properties/cn")

### cn Type

`string` ([cn](list-alerts-output-items-properties-source-properties-cn.md))

## as\_name

Autonomous system name of the source IP

`as_name`

* is optional

* Type: `string` ([as\_name](list-alerts-output-items-properties-source-properties-as_name.md))

* can be null

* defined in: [list-alerts output](list-alerts-output-items-properties-source-properties-as_name.md "http://schema.nethserver.org/crowdsec/list-alerts-output.json#/items/properties/source/properties/as_name")

### as\_name Type

`string` ([as\_name](list-alerts-output-items-properties-source-properties-as_name.md))
