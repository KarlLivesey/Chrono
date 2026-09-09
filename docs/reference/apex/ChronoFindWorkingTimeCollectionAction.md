# ChronoFindWorkingTimeCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoFindWorkingTimeCollectionAction`.

Find an open value on or after/before the source, including holidays.

## Declaration

```apex
global with sharing class ChronoFindWorkingTimeCollectionAction
```

Find an open value on or after/before the source, including holidays.

Types: [ChronoFindWorkingTimeCollectionAction](ChronoFindWorkingTimeCollectionAction.md).

## ChronoFindWorkingTimeCollectionAction

```apex
global class Request
```

One explicit collection per interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Find an open value on or after/before the source, including holidays.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoFindWorkingTimeCollectionAction.Request

| Field / property                                | Flow label       | Contract                                          |
| ----------------------------------------------- | ---------------- | ------------------------------------------------- |
| `global List<ChronoFindWorkingTimeInput> items` | Input collection | Ordered requests; an empty collection is allowed. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
