# ChronoCalendarDifferenceCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCalendarDifferenceCollectionAction`.

Count whole calendar months/days from the start, followed by remaining clock or elapsed time.

## Declaration

```apex
global with sharing class ChronoCalendarDifferenceCollectionAction
```

Count whole calendar months/days from the start, followed by remaining clock or elapsed time.

Types: [ChronoCalendarDifferenceCollectionAction](ChronoCalendarDifferenceCollectionAction.md).

## ChronoCalendarDifferenceCollectionAction

```apex
global class Request
```

One explicit collection per interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Count whole calendar months/days from the start, followed by remaining clock or elapsed time.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoCalendarDifferenceCollectionAction.Request

| Field / property                                   | Flow label       | Contract                                          |
| -------------------------------------------------- | ---------------- | ------------------------------------------------- |
| `global List<ChronoCalendarDifferenceInput> items` | Input collection | Ordered requests; an empty collection is allowed. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
