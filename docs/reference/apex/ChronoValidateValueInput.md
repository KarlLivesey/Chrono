# ChronoValidateValueInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoValidateValueInput`.

Validate a native or ISO value without failing other interviews.

## Declaration

```apex
global with sharing class ChronoValidateValueInput
```

Validate a native or ISO value without failing other interviews.

Types: [ChronoValidateValueInput](ChronoValidateValueInput.md).

## ChronoValidateValueInput

| Field / property               | Flow label           | Contract                                                     |
| ------------------------------ | -------------------- | ------------------------------------------------------------ |
| `global String valueType`      | Value type           | Value type.                                                  |
| `global String value`          | ISO value            | ISO value.                                                   |
| `global Date dateValue`        | Native date          | Native date.                                                 |
| `global Datetime instantValue` | Native datetime      | Native datetime.                                             |
| `global String timeValue`      | Local time           | ISO time for a native date and time input.                   |
| `global String timeZoneId`     | Timezone             | Required when resolving local time or inspecting an instant. |
| `global String disambiguation` | Repeated-time policy | Repeated-time policy.                                        |

### ChronoValidateValueInput

```apex
global ChronoValidateValueInput()
```

Required Flow constructor.

Types: [ChronoValidateValueInput](ChronoValidateValueInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
