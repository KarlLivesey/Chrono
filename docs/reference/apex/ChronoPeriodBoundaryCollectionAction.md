# ChronoPeriodBoundaryCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPeriodBoundaryCollectionAction`.

Find a calendar period boundary in an explicit timezone where applicable.

## Declaration

```apex
global with sharing class ChronoPeriodBoundaryCollectionAction
```

Find a calendar period boundary in an explicit timezone where applicable.

Types: [ChronoPeriodBoundaryCollectionAction](ChronoPeriodBoundaryCollectionAction.md).

## ChronoPeriodBoundaryCollectionAction

```apex
global class Request
```

One explicit collection per interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Find a calendar period boundary in an explicit timezone where applicable.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoPeriodBoundaryCollectionAction.Request

| Field / property                               | Flow label       | Contract                                          |
| ---------------------------------------------- | ---------------- | ------------------------------------------------- |
| `global List<ChronoPeriodBoundaryInput> items` | Input collection | Ordered requests; an empty collection is allowed. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
