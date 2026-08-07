# Untitled boolean in Configure the insights blocklist-evidence webhook Schema

```txt
http://schema.nethserver.org/crowdsec/set-insights.json#/properties/verify_tls
```

Verify the server TLS certificate. Disable only when pointing at a self-signed test server.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                               |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [set-insights.json\*](crowdsec/set-insights.json "open original schema") |

## verify\_tls Type

`boolean`

## verify\_tls Default Value

The default value is:

```json
true
```
