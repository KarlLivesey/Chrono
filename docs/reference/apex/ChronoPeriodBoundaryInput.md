# ChronoPeriodBoundaryInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPeriodBoundaryInput`.

Find a calendar period boundary in an explicit timezone where applicable.

## Declaration

```apex
global with sharing class ChronoPeriodBoundaryInput
```

Find a calendar period boundary in an explicit timezone where applicable.

Types: [ChronoPeriodBoundaryInput](ChronoPeriodBoundaryInput.md).

## ChronoPeriodBoundaryInput

| Field / property               | Flow label           | Contract                                                                                |
| ------------------------------ | -------------------- | --------------------------------------------------------------------------------------- |
| `global String valueType`      | Value type           | Chrono type of the source.                                                              |
| `global String value`          | ISO value            | ISO source; alternatively supply native fields.                                         |
| `global Datetime instantValue` | Native datetime      | Exact source instant; mutually exclusive with ISO value.                                |
| `global Date dateValue`        | Native date          | Local source date; mutually exclusive with ISO value.                                   |
| `global String timeValue`      | Local time           | ISO local time for native date/time input.                                              |
| `global String timeZoneId`     | Calculation timezone | Explicit zone for local resolution or calendar calculations.                            |
| `global String disambiguation` | Repeated-time policy | reject, earlier or later; skipped local times are rejected unless explicitly corrected. |
| `global String unit`           | Period               | day, week, month or year.                                                               |
| `global String boundary`       | Boundary             | start or end. End is the final millisecond, or final date, in the period.               |
| `global Integer weekStartsOn`  | Week starts on       | ISO weekday: 1 Monday through 7 Sunday. Defaults to Monday.                             |

### ChronoPeriodBoundaryInput

```apex
global ChronoPeriodBoundaryInput()
```

Required Flow constructor.

Types: [ChronoPeriodBoundaryInput](ChronoPeriodBoundaryInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
