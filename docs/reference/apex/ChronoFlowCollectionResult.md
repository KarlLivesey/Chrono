# ChronoFlowCollectionResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoFlowCollectionResult`.

One collection response per Flow interview; items preserve input order.

## Declaration

```apex
global with sharing class ChronoFlowCollectionResult
```

One collection response per Flow interview; items preserve input order.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoFlowCollectionResult

| Field / property                        | Flow label | Contract                                                                    |
| --------------------------------------- | ---------- | --------------------------------------------------------------------------- |
| `global List<ChronoFlowResult> results` | Results    | One independent result per collection item, in input order.                 |
| `global Boolean success`                | Success    | True only when every collection item succeeds.                              |
| `global String errorMessage`            | Error      | Invalid collection input diagnostic; item errors are on individual results. |

### ChronoFlowCollectionResult

```apex
global ChronoFlowCollectionResult()
```

Global no-argument constructor for Flow.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
