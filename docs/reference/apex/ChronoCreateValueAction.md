# ChronoCreateValueAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCreateValueAction`.

Construct a validated value from individual calendar and clock components.

## Declaration

```apex
global with sharing class ChronoCreateValueAction
```

Construct a validated value from individual calendar and clock components.

Types: [ChronoCreateValueAction](ChronoCreateValueAction.md).

## ChronoCreateValueAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoFlowResult> run(List<Request> requests)
```

Construct a validated value from individual calendar and clock components.

Types: [ChronoFlowResult](ChronoFlowResult.md).

## ChronoCreateValueAction.Request

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

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
