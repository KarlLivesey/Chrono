# ChronoDurationCalculationResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoDurationCalculationResult`.

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

## Declaration

```apex
global with sharing class ChronoDurationCalculationResult
```

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

Types: [ChronoDurationCalculationResult](ChronoDurationCalculationResult.md).

## ChronoDurationCalculationResult

| Field / property              | Flow label | Contract                                                 |
| ----------------------------- | ---------- | -------------------------------------------------------- |
| `global Boolean success`      | —          | success component; absent optional values are null.      |
| `global String errorMessage`  | —          | errorMessage component; absent optional values are null. |
| `global ChronoDuration value` | —          | value component; absent optional values are null.        |

### ChronoDurationCalculationResult

```apex
global ChronoDurationCalculationResult()
```

Creates uninitialised data.

Types: [ChronoDurationCalculationResult](ChronoDurationCalculationResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
