# list-alerts output Schema

```txt
http://schema.nethserver.org/crowdsec/list-alerts-output.json
```

List of CrowdSec detection alerts

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                         |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [list-alerts-output.json](crowdsec/list-alerts-output.json "open original schema") |

## list-alerts output Type

`object[]` ([Details](list-alerts-output-items.md))

## list-alerts output Examples

```json
[
  {
    "id": 42,
    "created_at": "2026-01-15T10:23:00Z",
    "scenario": "crowdsecurity/ssh-bf",
    "simulated": false,
    "events_count": 5,
    "source": {
      "ip": "1.2.3.4",
      "cn": "US",
      "as_name": "Example ISP"
    },
    "decisions": [
      {
        "type": "ban",
        "duration": "24h0m0s"
      }
    ]
  }
]
```
