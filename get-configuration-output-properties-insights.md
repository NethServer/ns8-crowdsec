# insights Schema

```txt
http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights
```

State of the webhook that pushes ban decisions to the nethesis-insights service.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [get-configuration-output.json\*](crowdsec/get-configuration-output.json "open original schema") |

## insights Type

`object` ([insights](get-configuration-output-properties-insights.md))

# insights Properties

| Property                     | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                           |
| :--------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled)          | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-insights-properties-enabled.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/enabled")         |
| [base\_url](#base_url)       | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-insights-properties-base_url.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/base_url")       |
| [verify\_tls](#verify_tls)   | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-insights-properties-verify_tls.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/verify_tls")   |
| [last\_import](#last_import) | `object`  | Optional | cannot be null | [get-configuration output](get-configuration-output-properties-insights-properties-last_import.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import") |

## enabled

Whether the webhook is configured and the node has a subscription. Without a subscription this is always false.

`enabled`

* is required

* Type: `boolean`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-insights-properties-enabled.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/enabled")

### enabled Type

`boolean`

## base\_url

Base URL of the nethesis-insights server that receives the decisions.

`base_url`

* is required

* Type: `string`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-insights-properties-base_url.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/base_url")

### base\_url Type

`string`

## verify\_tls

Whether the server TLS certificate is verified.

`verify_tls`

* is required

* Type: `boolean`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-insights-properties-verify_tls.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/verify_tls")

### verify\_tls Type

`boolean`

## last\_import

Outcome of the most recent crowdsec1-import.timer run. Absent if it has never run.

`last_import`

* is optional

* Type: `object` ([last\_import](get-configuration-output-properties-insights-properties-last_import.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-insights-properties-last_import.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/last_import")

### last\_import Type

`object` ([last\_import](get-configuration-output-properties-insights-properties-last_import.md))
