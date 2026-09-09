# ChronoEpochValueAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoEpochValueAction`.

Convert an exact value to or from Unix seconds or milliseconds.

## Declaration

```apex
global with sharing class ChronoEpochValueAction
```

Convert an exact value to or from Unix seconds or milliseconds.

Types: [ChronoEpochValueAction](ChronoEpochValueAction.md).

## ChronoEpochValueAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoEpochResult> run(List<Request> requests)
```

Convert an exact value to or from Unix seconds or milliseconds.

Types: [ChronoEpochResult](ChronoEpochResult.md).

## ChronoEpochValueAction.Request

| Field / property               | Flow label           | Contract                                                     |
| ------------------------------ | -------------------- | ------------------------------------------------------------ |
| `global String operation`      | Operation            | Operation.                                                   |
| `global String valueType`      | Value type           | Value type.                                                  |
| `global String value`          | ISO value            | ISO value.                                                   |
| `global Date dateValue`        | Native date          | Native date.                                                 |
| `global Datetime instantValue` | Native datetime      | Native datetime.                                             |
| `global String timeValue`      | Local time           | ISO time for a native date and time input.                   |
| `global String timeZoneId`     | Timezone             | Required when resolving local time or inspecting an instant. |
| `global String disambiguation` | Repeated-time policy | Repeated-time policy.                                        |
| `global Decimal epochValue`    | Unix timestamp       | Unix timestamp.                                              |
| `global String epochUnit`      | Timestamp unit       | Timestamp unit.                                              |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
