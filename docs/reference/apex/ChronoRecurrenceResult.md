# ChronoRecurrenceResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoRecurrenceResult`.

Independent Flow output with native and ISO fields.

## Declaration

```apex
global with sharing class ChronoRecurrenceResult
```

Independent Flow output with native and ISO fields.

Types: [ChronoRecurrenceResult](ChronoRecurrenceResult.md).

## ChronoRecurrenceResult

| Field / property             | Flow label                 | Contract                    |
| ---------------------------- | -------------------------- | --------------------------- |
| `global Boolean success`     | Success                    | Success.                    |
| `global String errorMessage` | Error                      | Error.                      |
| `global List<String> values` | Occurrence ISO values      | Occurrence ISO values.      |
| `global List<Date> dates`    | Occurrence local dates     | Occurrence local dates.     |
| `global String value`        | First occurrence ISO value | First occurrence ISO value. |
| `global Integer count`       | Result count               | Result count.               |
| `global Boolean found`       | Found occurrences          | Found occurrences.          |

### ChronoRecurrenceResult

```apex
global ChronoRecurrenceResult()
```

Required Flow constructor.

Types: [ChronoRecurrenceResult](ChronoRecurrenceResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
