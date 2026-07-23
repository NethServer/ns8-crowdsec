# get-capi-status output Schema

```txt
http://schema.nethserver.org/crowdsec/get-capi-status-output.json
```

CrowdSec Central API connection status

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [get-capi-status-output.json](crowdsec/get-capi-status-output.json "open original schema") |

## get-capi-status output Type

`object` ([get-capi-status output](get-capi-status-output.md))

## get-capi-status output Examples

```json
{
  "connected": true,
  "enrolled": true,
  "subscription": "COMMUNITY",
  "sharing": true,
  "pull_community": true,
  "pull_console": true
}
```

# get-capi-status output Properties

| Property                           | Type      | Required | Nullable       | Defined by                                                                                                                                                                   |
| :--------------------------------- | :-------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [connected](#connected)            | `boolean` | Required | cannot be null | [get-capi-status output](get-capi-status-output-properties-connected.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/connected")           |
| [enrolled](#enrolled)              | `boolean` | Required | cannot be null | [get-capi-status output](get-capi-status-output-properties-enrolled.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/enrolled")             |
| [subscription](#subscription)      | `string`  | Required | cannot be null | [get-capi-status output](get-capi-status-output-properties-subscription.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/subscription")     |
| [sharing](#sharing)                | `boolean` | Required | cannot be null | [get-capi-status output](get-capi-status-output-properties-sharing.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/sharing")               |
| [pull\_community](#pull_community) | `boolean` | Required | cannot be null | [get-capi-status output](get-capi-status-output-properties-pull_community.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/pull_community") |
| [pull\_console](#pull_console)     | `boolean` | Required | cannot be null | [get-capi-status output](get-capi-status-output-properties-pull_console.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/pull_console")     |

## connected

Whether the instance can successfully reach the Central API

`connected`

* is required

* Type: `boolean` ([connected](get-capi-status-output-properties-connected.md))

* cannot be null

* defined in: [get-capi-status output](get-capi-status-output-properties-connected.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/connected")

### connected Type

`boolean` ([connected](get-capi-status-output-properties-connected.md))

## enrolled

Whether the instance is enrolled in the CrowdSec console

`enrolled`

* is required

* Type: `boolean` ([enrolled](get-capi-status-output-properties-enrolled.md))

* cannot be null

* defined in: [get-capi-status output](get-capi-status-output-properties-enrolled.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/enrolled")

### enrolled Type

`boolean` ([enrolled](get-capi-status-output-properties-enrolled.md))

## subscription

Subscription type (e.g. COMMUNITY, PRO)

`subscription`

* is required

* Type: `string` ([subscription](get-capi-status-output-properties-subscription.md))

* cannot be null

* defined in: [get-capi-status output](get-capi-status-output-properties-subscription.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/subscription")

### subscription Type

`string` ([subscription](get-capi-status-output-properties-subscription.md))

## sharing

Whether signal sharing with the Central API is enabled

`sharing`

* is required

* Type: `boolean` ([sharing](get-capi-status-output-properties-sharing.md))

* cannot be null

* defined in: [get-capi-status output](get-capi-status-output-properties-sharing.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/sharing")

### sharing Type

`boolean` ([sharing](get-capi-status-output-properties-sharing.md))

## pull\_community

Whether pulling the community blocklist is enabled

`pull_community`

* is required

* Type: `boolean` ([pull\_community](get-capi-status-output-properties-pull_community.md))

* cannot be null

* defined in: [get-capi-status output](get-capi-status-output-properties-pull_community.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/pull_community")

### pull\_community Type

`boolean` ([pull\_community](get-capi-status-output-properties-pull_community.md))

## pull\_console

Whether pulling blocklists from the console is enabled

`pull_console`

* is required

* Type: `boolean` ([pull\_console](get-capi-status-output-properties-pull_console.md))

* cannot be null

* defined in: [get-capi-status output](get-capi-status-output-properties-pull_console.md "http://schema.nethserver.org/crowdsec/get-capi-status-output.json#/properties/pull_console")

### pull\_console Type

`boolean` ([pull\_console](get-capi-status-output-properties-pull_console.md))
