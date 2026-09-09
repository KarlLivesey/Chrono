# ChronoTimeAllocationCollectionResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoTimeAllocationCollectionResult`.

Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.

## Declaration

```apex
global with sharing class ChronoTimeAllocationCollectionResult
```

Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.

Types: [ChronoTimeAllocationCollectionResult](ChronoTimeAllocationCollectionResult.md).

## ChronoTimeAllocationCollectionResult

| Field / property                                  | Flow label | Contract                                                                                          |
| ------------------------------------------------- | ---------- | ------------------------------------------------------------------------------------------------- |
| `global Boolean success`                          | Success    | Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules. |
| `global String errorMessage`                      | Error      | Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules. |
| `global List<ChronoTimeAllocationResult> results` | Results    | Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules. |

### ChronoTimeAllocationCollectionResult

```apex
global ChronoTimeAllocationCollectionResult()
```

Required Flow constructor.

Types: [ChronoTimeAllocationCollectionResult](ChronoTimeAllocationCollectionResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
