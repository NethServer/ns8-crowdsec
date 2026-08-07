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

| Property                                             | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                                   |
| :--------------------------------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [status](#status)                                    | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-insights-properties-status.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/status")                                   |
| [base\_url](#base_url)                               | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-insights-properties-base_url.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/base_url")                               |
| [verify\_tls](#verify_tls)                           | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-insights-properties-verify_tls.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/verify_tls")                           |
| [subscription\_configured](#subscription_configured) | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-insights-properties-subscription_configured.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/subscription_configured") |

## status

Whether the blocklist-evidence webhook is configured.

`status`

* is required

* Type: `string`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-insights-properties-status.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/status")

### status Type

`string`

### status Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value        | Explanation |
| :----------- | :---------- |
| `"active"`   |             |
| `"inactive"` |             |

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

## subscription\_configured

True when cluster/subscription holds identity data. An active webhook with no subscription ships nothing.

`subscription_configured`

* is required

* Type: `boolean`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-insights-properties-subscription_configured.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/insights/properties/subscription_configured")

### subscription\_configured Type

`boolean`
