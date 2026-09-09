# ChronoCollectionToolsCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCollectionToolsCollectionAction`.

Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.

## Declaration

```apex
global with sharing class ChronoCollectionToolsCollectionAction
```

Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.

Types: [ChronoCollectionToolsCollectionAction](ChronoCollectionToolsCollectionAction.md).

## ChronoCollectionToolsCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoValuesCollectionResult> run(List<Request> requests)
```

Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.

Types: [ChronoValuesCollectionResult](ChronoValuesCollectionResult.md).

## ChronoCollectionToolsCollectionAction.Request

| Field / property                                | Flow label       | Contract                             |
| ----------------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoCollectionToolsInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
