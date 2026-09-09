# ChronoCreateValueInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCreateValueInput`.

Construct a validated value from individual calendar and clock components.

## Declaration

```apex
global with sharing class ChronoCreateValueInput
```

Construct a validated value from individual calendar and clock components.

Types: [ChronoCreateValueInput](ChronoCreateValueInput.md).

## ChronoCreateValueInput

| Field / property               | Flow label           | Contract                                                     |
| ------------------------------ | -------------------- | ------------------------------------------------------------ |
| `global String valueType`      | Value type           | Value type.                                                  |
| `global Integer year`          | Year                 | Year.                                                        |
| `global Integer month`         | Month                | Month.                                                       |
| `global Integer day`           | Day                  | Day.                                                         |
| `global Integer hour`          | Hour                 | Hour.                                                        |
| `global Integer minute`        | Minute               | Minute.                                                      |
| `global Integer second`        | Second               | Second.                                                      |
| `global Integer millisecond`   | Millisecond          | Millisecond.                                                 |
| `global String timeZoneId`     | Timezone             | Required when resolving local time or inspecting an instant. |
| `global String disambiguation` | Repeated-time policy | Repeated-time policy.                                        |

### ChronoCreateValueInput

```apex
global ChronoCreateValueInput()
```

Required Flow constructor.

Types: [ChronoCreateValueInput](ChronoCreateValueInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
