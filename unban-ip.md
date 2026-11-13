# unban-ip input Schema

```txt
http://schema.nethserver.org/crowdsec/unban-ip.json
```

Unban an IP address, or every ban except permanent and Threat Shield ones

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                     |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [unban-ip.json](crowdsec/unban-ip.json "open original schema") |

## unban-ip input Type

`object` ([unban-ip input](unban-ip.md))

## unban-ip input Examples

```json
{
  "ip": "1.2.3.4",
  "action": "unban"
}
```

```json
{
  "ip": "0.0.0.0",
  "action": "unban_all"
}
```

# unban-ip input Properties

| Property          | Type     | Required | Nullable       | Defined by                                                                                                                     |
| :---------------- | :------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------- |
| [ip](#ip)         | `string` | Required | cannot be null | [unban-ip input](unban-ip-properties-ip.md "http://schema.nethserver.org/crowdsec/unban-ip.json#/properties/ip")               |
| [action](#action) | `string` | Required | cannot be null | [unban-ip input](unban-ip-properties-unban-action.md "http://schema.nethserver.org/crowdsec/unban-ip.json#/properties/action") |

## ip

IP to unban, ignored by unban_all

`ip`

* is required

* Type: `string` ([IP](unban-ip-properties-ip.md))

* cannot be null

* defined in: [unban-ip input](unban-ip-properties-ip.md "http://schema.nethserver.org/crowdsec/unban-ip.json#/properties/ip")

### ip Type

`string` ([IP](unban-ip-properties-ip.md))

### ip Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## action

unban: the temporary bans of one IP; unban_all: every ban except permanent and Threat Shield ones

`action`

* is required

* Type: `string` ([Unban action](unban-ip-properties-unban-action.md))

* cannot be null

* defined in: [unban-ip input](unban-ip-properties-unban-action.md "http://schema.nethserver.org/crowdsec/unban-ip.json#/properties/action")

### action Type

`string` ([Unban action](unban-ip-properties-unban-action.md))

### action Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^(unban|unban_all)$
```

[try pattern](https://regexr.com/?expression=%5E\(unban%7Cunban_all\)%24 "try regular expression with regexr.com")

**RegEx**: the string must be a regular expression, according to [ECMA-262](http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf "check the specification")
