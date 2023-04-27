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
  "enroll_instance": "cl7ze8xdn00030vl70tyutuxjj"
}
```

# get-configuration output Properties

| Property                                  | Type      | Required | Nullable       | Defined by                                                                                                                                                                               |
| :---------------------------------------- | :-------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [helo\_host](#helo_host)                  | Merged    | Required | cannot be null | [get-configuration output](get-configuration-output-properties-helo_host.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/helo_host")                 |
| [receiver\_emails](#receiver_emails)      | Merged    | Required | cannot be null | [get-configuration output](get-configuration-output-properties-receiver_emails.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/receiver_emails")     |
| [bantime](#bantime)                       | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-bantime.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/bantime")                     |
| [dyn\_bantime](#dyn_bantime)              | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-dyn_bantime.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/dyn_bantime")             |
| [ban\_local\_network](#ban_local_network) | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-ban_local_network.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/ban_local_network") |
| [enable\_online\_api](#enable_online_api) | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-enable_online_api.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/enable_online_api") |
| [whitelists](#whitelists)                 | `array`   | Required | cannot be null | [get-configuration output](get-configuration-output-properties-whitelists.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/whitelists")               |
| [enroll\_instance](#enroll_instance)      | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-enroll_instance.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/enroll_instance")     |

## helo\_host



`helo_host`

*   is required

*   Type: merged type ([Details](get-configuration-output-properties-helo_host.md))

*   cannot be null

*   defined in: [get-configuration output](get-configuration-output-properties-helo_host.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/helo_host")

### helo\_host Type

merged type ([Details](get-configuration-output-properties-helo_host.md))

any of

*   [Untitled string in get-configuration output](get-configuration-output-properties-helo_host-anyof-0.md "check type definition")

*   [Untitled string in get-configuration output](get-configuration-output-properties-helo_host-anyof-1.md "check type definition")

## receiver\_emails



`receiver_emails`

*   is required

*   Type: merged type ([Details](get-configuration-output-properties-receiver_emails.md))

*   cannot be null

*   defined in: [get-configuration output](get-configuration-output-properties-receiver_emails.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/receiver_emails")

### receiver\_emails Type

merged type ([Details](get-configuration-output-properties-receiver_emails.md))

any of

*   [receiver_emails](get-configuration-output-properties-receiver_emails-anyof-receiver_emails.md "check type definition")

*   [receiver_emails](get-configuration-output-properties-receiver_emails-anyof-receiver_emails-1.md "check type definition")

## bantime

Ban time duration of bots (m:minute, h:hour)

`bantime`

*   is required

*   Type: `string` ([bantime](get-configuration-output-properties-bantime.md))

*   cannot be null

*   defined in: [get-configuration output](get-configuration-output-properties-bantime.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/bantime")

### bantime Type

`string` ([bantime](get-configuration-output-properties-bantime.md))

## dyn\_bantime

Allow to ban with a dynamic bantime value (each ban increase the time)

`dyn_bantime`

*   is required

*   Type: `boolean` ([dyn\_bantime](get-configuration-output-properties-dyn_bantime.md))

*   cannot be null

*   defined in: [get-configuration output](get-configuration-output-properties-dyn_bantime.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/dyn_bantime")

### dyn\_bantime Type

`boolean` ([dyn\_bantime](get-configuration-output-properties-dyn_bantime.md))

## ban\_local\_network

Allow to ban on the local network

`ban_local_network`

*   is required

*   Type: `boolean` ([ban\_local\_network](get-configuration-output-properties-ban_local_network.md))

*   cannot be null

*   defined in: [get-configuration output](get-configuration-output-properties-ban_local_network.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/ban_local_network")

### ban\_local\_network Type

`boolean` ([ban\_local\_network](get-configuration-output-properties-ban_local_network.md))

## enable\_online\_api

Enable the central API

`enable_online_api`

*   is required

*   Type: `boolean` ([enable\_online\_api](get-configuration-output-properties-enable_online_api.md))

*   cannot be null

*   defined in: [get-configuration output](get-configuration-output-properties-enable_online_api.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/enable_online_api")

### enable\_online\_api Type

`boolean` ([enable\_online\_api](get-configuration-output-properties-enable_online_api.md))

## whitelists

Whitelists array of IP, network or hostname

`whitelists`

*   is required

*   Type: `array` ([whitelists](get-configuration-output-properties-whitelists.md))

*   cannot be null

*   defined in: [get-configuration output](get-configuration-output-properties-whitelists.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/whitelists")

### whitelists Type

`array` ([whitelists](get-configuration-output-properties-whitelists.md))

## enroll\_instance

Enroll a crowdsec instance to app.crowdsec.net

`enroll_instance`

*   is required

*   Type: `string` ([enroll\_instance](get-configuration-output-properties-enroll_instance.md))

*   cannot be null

*   defined in: [get-configuration output](get-configuration-output-properties-enroll_instance.md "http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/enroll_instance")

### enroll\_instance Type

`string` ([enroll\_instance](get-configuration-output-properties-enroll_instance.md))
