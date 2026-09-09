# ChronoCheckWorkingTimeCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCheckWorkingTimeCollectionAction`.

Check whether a date has opening hours or an instant is inside OperatingHours.

## Declaration

```apex
global with sharing class ChronoCheckWorkingTimeCollectionAction
```

Check whether a date has opening hours or an instant is inside OperatingHours.

Types: [ChronoCheckWorkingTimeCollectionAction](ChronoCheckWorkingTimeCollectionAction.md).

## ChronoCheckWorkingTimeCollectionAction

```apex
global class Request
```

One explicit collection per interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Check whether a date has opening hours or an instant is inside OperatingHours.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoCheckWorkingTimeCollectionAction.Request

| Field / property                                 | Flow label       | Contract                                          |
| ------------------------------------------------ | ---------------- | ------------------------------------------------- |
| `global List<ChronoCheckWorkingTimeInput> items` | Input collection | Ordered requests; an empty collection is allowed. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
