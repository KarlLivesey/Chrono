# ChronoCompareCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCompareCollectionAction`.

Compare compatible values and return before, equal or after.

## Declaration

```apex
global with sharing class ChronoCompareCollectionAction
```

Compare compatible values and return before, equal or after.

Types: [ChronoCompareCollectionAction](ChronoCompareCollectionAction.md).

## ChronoCompareCollectionAction

```apex
global class Request
```

One explicit collection per interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Compare compatible values and return before, equal or after.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoCompareCollectionAction.Request

| Field / property                        | Flow label       | Contract                                          |
| --------------------------------------- | ---------------- | ------------------------------------------------- |
| `global List<ChronoCompareInput> items` | Input collection | Ordered requests; an empty collection is allowed. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
