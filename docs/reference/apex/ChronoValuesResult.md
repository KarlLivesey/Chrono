# ChronoValuesResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoValuesResult`.

Independent Flow output with native and ISO fields.

## Declaration

```apex
global with sharing class ChronoValuesResult
```

Independent Flow output with native and ISO fields.

Types: [ChronoValuesResult](ChronoValuesResult.md).

## ChronoValuesResult

| Field / property                | Flow label                      | Contract                         |
| ------------------------------- | ------------------------------- | -------------------------------- |
| `global Boolean success`        | Success                         | Success.                         |
| `global String errorMessage`    | Error                           | Error.                           |
| `global List<String> values`    | Result ISO values               | Result ISO values.               |
| `global List<Integer> indexes`  | Original zero-based indexes     | Original zero-based indexes.     |
| `global List<String> groupKeys` | Group key for each result value | Group key for each result value. |
| `global Integer count`          | Input count                     | Input count.                     |
| `global Integer uniqueCount`    | Distinct value count            | Distinct value count.            |
| `global String earliestValue`   | Earliest ISO value              | Earliest ISO value.              |
| `global String latestValue`     | Latest ISO value                | Latest ISO value.                |
| `global String value`           | Selected ISO value              | Selected ISO value.              |
| `global String duration`        | Total ISO duration              | Total ISO duration.              |

### ChronoValuesResult

```apex
global ChronoValuesResult()
```

Required Flow constructor.

Types: [ChronoValuesResult](ChronoValuesResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
