# ChronoWorkingTimeResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoWorkingTimeResult`.

Data-only outcome for one bulk working-time request.

## Declaration

```apex
global with sharing class ChronoWorkingTimeResult
```

Data-only outcome for one bulk working-time request.

Types: [ChronoWorkingTimeResult](ChronoWorkingTimeResult.md).

## ChronoWorkingTimeResult

| Field / property                   | Flow label | Contract                                       |
| ---------------------------------- | ---------- | ---------------------------------------------- |
| `global Boolean success`           | —          | True when the corresponding request succeeded. |
| `global String errorMessage`       | —          | Failure diagnostic; null on success.           |
| `global ChronoZonedDateTime value` | —          | Independent zoned result; null on failure.     |

### ChronoWorkingTimeResult

```apex
global ChronoWorkingTimeResult()
```

Creates an uninitialised result.

Types: [ChronoWorkingTimeResult](ChronoWorkingTimeResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
