# ChronoWorkingTimeCheckResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoWorkingTimeCheckResult`.

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

## Declaration

```apex
global with sharing class ChronoWorkingTimeCheckResult
```

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

Types: [ChronoWorkingTimeCheckResult](ChronoWorkingTimeCheckResult.md).

## ChronoWorkingTimeCheckResult

| Field / property             | Flow label | Contract                                                 |
| ---------------------------- | ---------- | -------------------------------------------------------- |
| `global Boolean success`     | —          | success component; absent optional values are null.      |
| `global String errorMessage` | —          | errorMessage component; absent optional values are null. |
| `global Boolean isOpen`      | —          | isOpen component; absent optional values are null.       |

### ChronoWorkingTimeCheckResult

```apex
global ChronoWorkingTimeCheckResult()
```

Creates uninitialised data.

Types: [ChronoWorkingTimeCheckResult](ChronoWorkingTimeCheckResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
