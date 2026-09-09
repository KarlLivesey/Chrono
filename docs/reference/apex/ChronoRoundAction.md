# ChronoRoundAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoRoundAction`.

Round to a clock increment or a calendar-day boundary.

## Declaration

```apex
global with sharing class ChronoRoundAction
```

Round to a clock increment or a calendar-day boundary.

Types: [ChronoRoundAction](ChronoRoundAction.md).

## ChronoRoundAction

```apex
global class Request
```

Scalar Flow inputs.

### run

```apex
global static List<ChronoFlowResult> run(List<Request> requests)
```

Round to a clock increment or a calendar-day boundary.

Types: [ChronoFlowResult](ChronoFlowResult.md).

## ChronoRoundAction.Request

| Field / property               | Flow label           | Contract                                                                                |
| ------------------------------ | -------------------- | --------------------------------------------------------------------------------------- |
| `global String valueType`      | Value type           | Chrono type of the source.                                                              |
| `global String value`          | ISO value            | ISO source; alternatively supply native fields.                                         |
| `global Datetime instantValue` | Native datetime      | Exact source instant; mutually exclusive with ISO value.                                |
| `global Date dateValue`        | Native date          | Local source date; mutually exclusive with ISO value.                                   |
| `global String timeValue`      | Local time           | ISO local time for native date/time input.                                              |
| `global String timeZoneId`     | Calculation timezone | Explicit zone for local resolution or calendar calculations.                            |
| `global String disambiguation` | Repeated-time policy | reject, earlier or later; skipped local times are rejected unless explicitly corrected. |
| `global String unit`           | Unit                 | day, hour, minute, second or millisecond.                                               |
| `global Integer increment`     | Increment            | Positive increment dividing its parent unit; defaults to 1.                             |
| `global String roundingMode`   | Rounding mode        | floor, ceil or halfExpand (nearest, ties away from zero). Defaults to halfExpand.       |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
