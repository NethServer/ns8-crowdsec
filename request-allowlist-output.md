# request-allowlist output Schema

```txt
http://schema.nethserver.org/crowdsec/request-allowlist-output.json
```

Result of an allowlist request to nethesis-insights

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [request-allowlist-output.json](crowdsec/request-allowlist-output.json "open original schema") |

## request-allowlist output Type

`object` ([request-allowlist output](request-allowlist-output.md))

## request-allowlist output Examples

```json
{
  "accepted": true,
  "requests": 1
}
```

# request-allowlist output Properties

| Property              | Type      | Required | Nullable       | Defined by                                                                                                                                                             |
| :-------------------- | :-------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [accepted](#accepted) | `boolean` | Required | cannot be null | [request-allowlist output](request-allowlist-output-properties-accepted.md "http://schema.nethserver.org/crowdsec/request-allowlist-output.json#/properties/accepted") |
| [requests](#requests) | `integer` | Required | cannot be null | [request-allowlist output](request-allowlist-output-properties-requests.md "http://schema.nethserver.org/crowdsec/request-allowlist-output.json#/properties/requests") |

## accepted

Whether the request was recorded (also true when the CIDR was already allowlisted)

`accepted`

* is required

* Type: `boolean` ([accepted](request-allowlist-output-properties-accepted.md))

* cannot be null

* defined in: [request-allowlist output](request-allowlist-output-properties-accepted.md "http://schema.nethserver.org/crowdsec/request-allowlist-output.json#/properties/accepted")

### accepted Type

`boolean` ([accepted](request-allowlist-output-properties-accepted.md))

## requests

Current distinct-system count requesting this CIDR

`requests`

* is required

* Type: `integer` ([requests](request-allowlist-output-properties-requests.md))

* cannot be null

* defined in: [request-allowlist output](request-allowlist-output-properties-requests.md "http://schema.nethserver.org/crowdsec/request-allowlist-output.json#/properties/requests")

### requests Type

`integer` ([requests](request-allowlist-output-properties-requests.md))
