# ChronoRoundCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoRoundCollectionAction`.

Round to a clock increment or a calendar-day boundary.

## Declaration

```apex
global with sharing class ChronoRoundCollectionAction
```

Round to a clock increment or a calendar-day boundary.

Types: [ChronoRoundCollectionAction](ChronoRoundCollectionAction.md).

## ChronoRoundCollectionAction

```apex
global class Request
```

One explicit collection per interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Round to a clock increment or a calendar-day boundary.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoRoundCollectionAction.Request

| Field / property                      | Flow label       | Contract                                          |
| ------------------------------------- | ---------------- | ------------------------------------------------- |
| `global List<ChronoRoundInput> items` | Input collection | Ordered requests; an empty collection is allowed. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
