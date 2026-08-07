# Configure the insights blocklist-evidence webhook Schema

```txt
http://schema.nethserver.org/crowdsec/set-insights.json
```

Configure the CrowdSec notification plugin that pushes every ban decision to the nethesis-insights service.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                             |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [set-insights.json](crowdsec/set-insights.json "open original schema") |

## Configure the insights blocklist-evidence webhook Type

`object` ([Configure the insights blocklist-evidence webhook](set-insights.md))

one (and only one) of

* [Untitled undefined type in Configure the insights blocklist-evidence webhook](set-insights-oneof-0.md "check type definition")

* [Untitled undefined type in Configure the insights blocklist-evidence webhook](set-insights-oneof-1.md "check type definition")

# Configure the insights blocklist-evidence webhook Properties

| Property                   | Type      | Required | Nullable       | Defined by                                                                                                                                                                  |
| :------------------------- | :-------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [active](#active)          | `boolean` | Optional | cannot be null | [Configure the insights blocklist-evidence webhook](set-insights-properties-active.md "http://schema.nethserver.org/crowdsec/set-insights.json#/properties/active")         |
| [base\_url](#base_url)     | `string`  | Optional | cannot be null | [Configure the insights blocklist-evidence webhook](set-insights-properties-base_url.md "http://schema.nethserver.org/crowdsec/set-insights.json#/properties/base_url")     |
| [verify\_tls](#verify_tls) | `boolean` | Optional | cannot be null | [Configure the insights blocklist-evidence webhook](set-insights-properties-verify_tls.md "http://schema.nethserver.org/crowdsec/set-insights.json#/properties/verify_tls") |

## active

Enable or disable the insights webhook.

`active`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Configure the insights blocklist-evidence webhook](set-insights-properties-active.md "http://schema.nethserver.org/crowdsec/set-insights.json#/properties/active")

### active Type

`boolean`

## base\_url

Base URL of the nethesis-insights server that receives the decisions.

`base_url`

* is optional

* Type: `string`

* cannot be null

* defined in: [Configure the insights blocklist-evidence webhook](set-insights-properties-base_url.md "http://schema.nethserver.org/crowdsec/set-insights.json#/properties/base_url")

### base\_url Type

`string`

### base\_url Constraints

**URI**: the string must be a URI, according to [RFC 3986](https://tools.ietf.org/html/rfc3986 "check the specification")

## verify\_tls

Verify the server TLS certificate. Disable only when pointing at a self-signed test server.

`verify_tls`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Configure the insights blocklist-evidence webhook](set-insights-properties-verify_tls.md "http://schema.nethserver.org/crowdsec/set-insights.json#/properties/verify_tls")

### verify\_tls Type

`boolean`

### verify\_tls Default Value

The default value is:

```json
true
```
