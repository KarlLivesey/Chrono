# ChronoReplaceValueInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoReplaceValueInput`.

Replace supplied components and preserve other fields. Resolve zoned values explicitly.

## Declaration

```apex
global with sharing class ChronoReplaceValueInput
```

Replace supplied components and preserve other fields. Resolve zoned values explicitly.

Types: [ChronoReplaceValueInput](ChronoReplaceValueInput.md).

## ChronoReplaceValueInput

| Field / property               | Flow label            | Contract                                                     |
| ------------------------------ | --------------------- | ------------------------------------------------------------ |
| `global String valueType`      | Value type            | Value type.                                                  |
| `global String value`          | ISO value             | ISO value.                                                   |
| `global Date dateValue`        | Native date           | Native date.                                                 |
| `global Datetime instantValue` | Native datetime       | Native datetime.                                             |
| `global String timeValue`      | Local time            | ISO time for a native date and time input.                   |
| `global String timeZoneId`     | Timezone              | Required when resolving local time or inspecting an instant. |
| `global String disambiguation` | Repeated-time policy  | Repeated-time policy.                                        |
| `global Integer year`          | Year                  | Year.                                                        |
| `global Integer month`         | Month                 | Month.                                                       |
| `global Integer day`           | Day                   | Day.                                                         |
| `global Integer hour`          | Hour                  | Hour.                                                        |
| `global Integer minute`        | Minute                | Minute.                                                      |
| `global Integer second`        | Second                | Second.                                                      |
| `global Integer millisecond`   | Millisecond           | Millisecond.                                                 |
| `global String overflow`       | Invalid date handling | Invalid date handling.                                       |

### ChronoReplaceValueInput

```apex
global ChronoReplaceValueInput()
```

Required Flow constructor.

Types: [ChronoReplaceValueInput](ChronoReplaceValueInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
