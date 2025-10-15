# Untitled string in get-configuration output Schema

```txt
http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/helo_host/anyOf/0
```

Helo host value for SMTP

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [get-configuration-output.json\*](crowdsec/get-configuration-output.json "open original schema") |

## 0 Type

`string`

## 0 Constraints

**(international) hostname**: the string must be an (IDN) hostname, according to [RFC 5890, section 2.3.2.3](https://tools.ietf.org/html/rfc5890 "check the specification")
