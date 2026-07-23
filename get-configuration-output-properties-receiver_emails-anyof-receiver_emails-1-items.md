# Untitled string in get-configuration output Schema

```txt
http://schema.nethserver.org/crowdsec/get-configuration-output.json#/properties/receiver_emails/anyOf/1/items
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [get-configuration-output.json\*](crowdsec/get-configuration-output.json "open original schema") |

## items Type

`string`

## items Constraints

**(international) email**: the string must be an (international) email address, according to [RFC 6531](https://tools.ietf.org/html/rfc6531 "check the specification")
