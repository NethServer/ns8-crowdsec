# get-configuration output Schema

```txt
http://schema.nethserver.org/crowdsec/get-configuration-output.json
```

Get crowdsec configuration

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [get-configuration-output.json](crowdsec/get-configuration-output.json "open original schema") |

## get-configuration output Type

`object` ([get-configuration output](get-configuration-output.md))

## get-configuration output Examples

```json
{
  "helo_host": "foo.domain.com",
  "receiver_emails": [
    "user@domain.com",
    "user@domain.org"
  ],
  "bantime": "1",
  "dyn_bantime": true,
  "ban_local_network": true,
  "whitelists": [
    "10.10.10.0/8",
    "1.2.3.4",
    "foo.com",
    "foo.foo.org",
    "12123564.org"
  ],
  "enable_online_api": true,
  "enroll_instance": "cl7ze8xdn00030vl70tyutuxjj",
  "group_threshold": 100,
  "dynamic_bantime_duration": "4",
  "pull_community_blocklist": true
}
```

# get-configuration output Properties

| Property                                              | Type      | Required | Nullable       | Defined by                                                                                                                                                                                             |
| :---------------------------------------------------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [group_threshold](#group_threshold)                   | `integer` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-group_threshold.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/group_threshold")                   |
| [helo_host](#helo_host)                               | Merged    | Required | cannot be null | [get-configuration output](get-configuration-output-properties-helo_host.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/helo_host")                               |
| [receiver_emails](#receiver_emails)                   | Merged    | Required | cannot be null | [get-configuration output](get-configuration-output-properties-receiver_emails.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/receiver_emails")                   |
| [bantime](#bantime)                                   | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-bantime.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/bantime")                                   |
| [dyn_bantime](#dyn_bantime)                           | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-dyn_bantime.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/dyn_bantime")                           |
| [ban_local_network](#ban_local_network)               | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-ban_local_network.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/ban_local_network")               |
| [enable_online_api](#enable_online_api)               | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-enable_online_api.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/enable_online_api")               |
| [whitelists](#whitelists)                             | `array`   | Required | cannot be null | [get-configuration output](get-configuration-output-properties-whitelists.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/whitelists")                             |
| [enroll_instance](#enroll_instance)                   | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-enroll_instance.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/enroll_instance")                   |
| [dynamic_bantime_duration](#dynamic_bantime_duration) | `string`  | Optional | cannot be null | [get-configuration output](get-configuration-output-properties-dynamic_bantime_duration.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/dynamic_bantime_duration") |
| [pull_community_blocklist](#pull_community_blocklist) | `boolean` | Optional | cannot be null | [get-configuration output](get-configuration-output-properties-pull_community_blocklist.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/pull_community_blocklist") |

## group_threshold

Number of alerts to group before sending an email

`group_threshold`

* is required

* Type: `integer` ([group_threshold](get-configuration-output-properties-group_threshold.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-group_threshold.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/group_threshold")

### group_threshold Type

`integer` ([group_threshold](get-configuration-output-properties-group_threshold.md))

### group_threshold Constraints

**maximum**: the value of this number must smaller than or equal to: `10000`

**minimum**: the value of this number must greater than or equal to: `1`

## helo_host



`helo_host`

* is required

* Type: merged type ([Details](get-configuration-output-properties-helo_host.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-helo_host.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/helo_host")

### helo_host Type

merged type ([Details](get-configuration-output-properties-helo_host.md))

any of

* [Untitled string in get-configuration output](get-configuration-output-properties-helo_host-anyof-0.md "check type definition")

* [Untitled string in get-configuration output](get-configuration-output-properties-helo_host-anyof-1.md "check type definition")

## receiver_emails



`receiver_emails`

* is required

* Type: merged type ([Details](get-configuration-output-properties-receiver_emails.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-receiver_emails.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/receiver_emails")

### receiver_emails Type

merged type ([Details](get-configuration-output-properties-receiver_emails.md))

any of

* [receiver_emails](get-configuration-output-properties-receiver_emails-anyof-receiver_emails.md "check type definition")

* [receiver_emails](get-configuration-output-properties-receiver_emails-anyof-receiver_emails-1.md "check type definition")

## bantime

Ban time duration of bots (m:minute, h:hour)

`bantime`

* is required

* Type: `string` ([bantime](get-configuration-output-properties-bantime.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-bantime.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/bantime")

### bantime Type

`string` ([bantime](get-configuration-output-properties-bantime.md))

## dyn_bantime

Allow to ban with a dynamic bantime value (each ban increase the time)

`dyn_bantime`

* is required

* Type: `boolean` ([dyn_bantime](get-configuration-output-properties-dyn_bantime.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-dyn_bantime.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/dyn_bantime")

### dyn_bantime Type

`boolean` ([dyn_bantime](get-configuration-output-properties-dyn_bantime.md))

## ban_local_network

Allow to ban on the local network

`ban_local_network`

* is required

* Type: `boolean` ([ban_local_network](get-configuration-output-properties-ban_local_network.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-ban_local_network.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/ban_local_network")

### ban_local_network Type

`boolean` ([ban_local_network](get-configuration-output-properties-ban_local_network.md))

## enable_online_api

Enable the central API

`enable_online_api`

* is required

* Type: `boolean` ([enable_online_api](get-configuration-output-properties-enable_online_api.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-enable_online_api.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/enable_online_api")

### enable_online_api Type

`boolean` ([enable_online_api](get-configuration-output-properties-enable_online_api.md))

## whitelists

Whitelists array of IP, network or hostname

`whitelists`

* is required

* Type: `array` ([whitelists](get-configuration-output-properties-whitelists.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-whitelists.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/whitelists")

### whitelists Type

`array` ([whitelists](get-configuration-output-properties-whitelists.md))

## enroll_instance

Enroll a crowdsec instance to app.crowdsec.net

`enroll_instance`

* is required

* Type: `string` ([enroll_instance](get-configuration-output-properties-enroll_instance.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-enroll_instance.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/enroll_instance")

### enroll_instance Type

`string` ([enroll_instance](get-configuration-output-properties-enroll_instance.md))

## dynamic_bantime_duration

Base duration for dynamic bantime, in minutes

`dynamic_bantime_duration`

* is optional

* Type: `string` ([dynamic_bantime_duration](get-configuration-output-properties-dynamic_bantime_duration.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-dynamic_bantime_duration.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/dynamic_bantime_duration")

### dynamic_bantime_duration Type

`string` ([dynamic_bantime_duration](get-configuration-output-properties-dynamic_bantime_duration.md))

### dynamic_bantime_duration Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[1-9][0-9]*$
```

[try pattern](https://regexr.com/?expression=%5E%5B1-9%5D%5B0-9%5D*%24 "try regular expression with regexr.com")

## pull_community_blocklist

Pull the CrowdSec community blocklist from the Central API

`pull_community_blocklist`

* is optional

* Type: `boolean` ([pull_community_blocklist](get-configuration-output-properties-pull_community_blocklist.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-pull_community_blocklist.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/pull_community_blocklist")

### pull_community_blocklist Type

`boolean` ([pull_community_blocklist](get-configuration-output-properties-pull_community_blocklist.md))
