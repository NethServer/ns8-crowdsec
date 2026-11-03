# get-facts output Schema

```txt
http://schema.nethserver.org/crowdsec/get-facts-output.json
```

Module facts reported to phonehome

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                     |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [get-facts-output.json](crowdsec/get-facts-output.json "open original schema") |

## get-facts output Type

`object` ([get-facts output](get-facts-output.md))

## get-facts output Examples

```json
{
  "dynamic_bantime": true,
  "ban_local_network": false,
  "capi_enabled": true,
  "pull_community_blocklist": true,
  "console_enrolled": false,
  "nethvoice_collection": true,
  "email_notifications": false,
  "whitelist_count": 2,
  "threat_shield_enterprise": 3,
  "threat_shield_feeds": [
    "yoroimallvl1",
    "nethesis-insights",
    "nethesislvl3"
  ]
}
```
