# Unban action Schema

```txt
http://schema.nethserver.org/mail/unban-ip.json#/properties/action
```

Manage to unban IP

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                   |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [unban-ip.json\*](mail/unban-ip.json "open original schema") |

## action Type

`string` ([Unban action](unban-ip-properties-unban-action.md))

## action Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^(unban|unban_all)$
```

[try pattern](https://regexr.com/?expression=%5E\(unban%7Cunban_all\)%24 "try regular expression with regexr.com")

**RegEx**: the string must be a regular expression, according to [ECMA-262](http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf "check the specification")
