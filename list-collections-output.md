# list-collections output Schema

```txt
http://schema.nethserver.org/crowdsec/list-collections-output.json
```

List of installed CrowdSec collections

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [list-collections-output.json](crowdsec/list-collections-output.json "open original schema") |

## list-collections output Type

`object[]` ([Details](list-collections-output-items.md))

## list-collections output Examples

```json
[
  {
    "name": "crowdsecurity/linux",
    "status": "enabled",
    "local_version": "0.2",
    "local_path": "/etc/crowdsec/collections/linux.yaml",
    "description": "Detect attacks against Linux systems",
    "up_to_date": true,
    "tainted": false
  }
]
```
