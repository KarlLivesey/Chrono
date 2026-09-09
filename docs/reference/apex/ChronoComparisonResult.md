# ChronoComparisonResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoComparisonResult`.

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

## Declaration

```apex
global with sharing class ChronoComparisonResult
```

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

Types: [ChronoComparisonResult](ChronoComparisonResult.md).

## ChronoComparisonResult

| Field / property                 | Flow label | Contract                                                    |
| -------------------------------- | ---------- | ----------------------------------------------------------- |
| `global Boolean success`         | —          | success component; absent optional values are null.         |
| `global String errorMessage`     | —          | errorMessage component; absent optional values are null.    |
| `global Integer comparison`      | —          | comparison component; absent optional values are null.      |
| `global Boolean withinTolerance` | —          | withinTolerance component; absent optional values are null. |
| `global Boolean samePeriod`      | —          | samePeriod component; absent optional values are null.      |

### ChronoComparisonResult

```apex
global ChronoComparisonResult()
```

Creates uninitialised data.

Types: [ChronoComparisonResult](ChronoComparisonResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
