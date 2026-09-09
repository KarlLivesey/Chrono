# ChronoRangeResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoRangeResult`.

Independent Flow output with native and ISO fields.

## Declaration

```apex
global with sharing class ChronoRangeResult
```

Independent Flow output with native and ISO fields.

Types: [ChronoRangeResult](ChronoRangeResult.md).

## ChronoRangeResult

| Field / property                  | Flow label              | Contract                 |
| --------------------------------- | ----------------------- | ------------------------ |
| `global Boolean success`          | Success                 | Success.                 |
| `global String errorMessage`      | Error                   | Error.                   |
| `global Boolean isValid`          | Valid range             | Valid range.             |
| `global String validationMessage` | Validation message      | Validation message.      |
| `global Boolean containsValue`    | Contains point          | Contains point.          |
| `global String relationship`      | Range relationship      | Range relationship.      |
| `global String startValue`        | Start ISO value         | Start ISO value.         |
| `global String endValue`          | Exclusive end ISO value | Exclusive end ISO value. |
| `global String value`             | Point ISO value         | Point ISO value.         |
| `global List<String> ranges`      | Result ISO ranges       | Result ISO ranges.       |
| `global Long milliseconds`        | Covered milliseconds    | Covered milliseconds.    |
| `global String duration`          | Covered ISO duration    | Covered ISO duration.    |
| `global Decimal coveragePercent`  | Coverage percent        | Coverage percent.        |

### ChronoRangeResult

```apex
global ChronoRangeResult()
```

Required Flow constructor.

Types: [ChronoRangeResult](ChronoRangeResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
