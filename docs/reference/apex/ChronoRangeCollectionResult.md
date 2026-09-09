# ChronoRangeCollectionResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoRangeCollectionResult`.

Validate and manipulate half-open ranges: start is included and end is excluded.

## Declaration

```apex
global with sharing class ChronoRangeCollectionResult
```

Validate and manipulate half-open ranges: start is included and end is excluded.

Types: [ChronoRangeCollectionResult](ChronoRangeCollectionResult.md).

## ChronoRangeCollectionResult

| Field / property                         | Flow label | Contract                                                                         |
| ---------------------------------------- | ---------- | -------------------------------------------------------------------------------- |
| `global Boolean success`                 | Success    | Validate and manipulate half-open ranges: start is included and end is excluded. |
| `global String errorMessage`             | Error      | Validate and manipulate half-open ranges: start is included and end is excluded. |
| `global List<ChronoRangeResult> results` | Results    | Validate and manipulate half-open ranges: start is included and end is excluded. |

### ChronoRangeCollectionResult

```apex
global ChronoRangeCollectionResult()
```

Required Flow constructor.

Types: [ChronoRangeCollectionResult](ChronoRangeCollectionResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
