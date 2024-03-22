# unban-ip input Schema

```txt
http://schema.nethserver.org/mail/unban-ip.json
```

flush the postfix queue email

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [unban-ip.json](mail/unban-ip.json "open original schema") |

## unban-ip input Type

`object` ([unban-ip input](unban-ip.md))

## unban-ip input Examples

```json
{
  "queue": "1.2.3.4",
  "action": "unban"
}
```

# unban-ip input Properties

| Property          | Type     | Required | Nullable       | Defined by                                                                                                                 |
| :---------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------- |
| [ip](#ip)         | `string` | Required | cannot be null | [unban-ip input](unban-ip-properties-ip.md "http://schema.nethserver.org/mail/unban-ip.json#/properties/ip")               |
| [action](#action) | `string` | Required | cannot be null | [unban-ip input](unban-ip-properties-unban-action.md "http://schema.nethserver.org/mail/unban-ip.json#/properties/action") |

## ip

IP to unban

`ip`

*   is required

*   Type: `string` ([IP](unban-ip-properties-ip.md))

*   cannot be null

*   defined in: [unban-ip input](unban-ip-properties-ip.md "http://schema.nethserver.org/mail/unban-ip.json#/properties/ip")

### ip Type

`string` ([IP](unban-ip-properties-ip.md))

### ip Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## action

Manage to unban IP

`action`

*   is required

*   Type: `string` ([Unban action](unban-ip-properties-unban-action.md))

*   cannot be null

*   defined in: [unban-ip input](unban-ip-properties-unban-action.md "http://schema.nethserver.org/mail/unban-ip.json#/properties/action")

### action Type

`string` ([Unban action](unban-ip-properties-unban-action.md))

### action Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^(unban|unban_all)$
```

[try pattern](https://regexr.com/?expression=%5E\(unban%7Cunban_all\)%24 "try regular expression with regexr.com")

**RegEx**: the string must be a regular expression, according to [ECMA-262](http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf "check the specification")
