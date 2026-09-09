# ChronoLocalResolutionResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoLocalResolutionResult`.

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

## Declaration

```apex
global with sharing class ChronoLocalResolutionResult
```

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

Types: [ChronoLocalResolutionResult](ChronoLocalResolutionResult.md).

## ChronoLocalResolutionResult

| Field / property                           | Flow label | Contract                                                     |
| ------------------------------------------ | ---------- | ------------------------------------------------------------ |
| `global Boolean success`                   | —          | success component; absent optional values are null.          |
| `global String errorMessage`               | —          | errorMessage component; absent optional values are null.     |
| `global String resolutionStatus`           | —          | resolutionStatus component; absent optional values are null. |
| `global ChronoZonedDateTime value`         | —          | value component; absent optional values are null.            |
| `global ChronoZonedDateTime earlierValue`  | —          | earlierValue component; absent optional values are null.     |
| `global ChronoZonedDateTime laterValue`    | —          | laterValue component; absent optional values are null.       |
| `global ChronoZonedDateTime previousValue` | —          | previousValue component; absent optional values are null.    |
| `global ChronoZonedDateTime nextValue`     | —          | nextValue component; absent optional values are null.        |

### ChronoLocalResolutionResult

```apex
global ChronoLocalResolutionResult()
```

Creates uninitialised data.

Types: [ChronoLocalResolutionResult](ChronoLocalResolutionResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
