# ChronoEpochResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoEpochResult`.

Flat Flow result for epoch operations.

## Declaration

```apex
global with sharing class ChronoEpochResult
```

Flat Flow result for epoch operations.

Types: [ChronoEpochResult](ChronoEpochResult.md).

## ChronoEpochResult

| Field / property               | Flow label      | Contract         |
| ------------------------------ | --------------- | ---------------- |
| `global Boolean success`       | Success         | Success.         |
| `global String errorMessage`   | Error           | Error.           |
| `global String value`          | ISO value       | ISO value.       |
| `global Datetime instantValue` | Native datetime | Native datetime. |
| `global Decimal epochValue`    | Unix timestamp  | Unix timestamp.  |
| `global String epochUnit`      | Timestamp unit  | Timestamp unit.  |

### ChronoEpochResult

```apex
global ChronoEpochResult()
```

Required Flow constructor.

Types: [ChronoEpochResult](ChronoEpochResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
