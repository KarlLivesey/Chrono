# ChronoTimeAllocationCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoTimeAllocationCollectionAction`.

Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.

## Declaration

```apex
global with sharing class ChronoTimeAllocationCollectionAction
```

Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.

Types: [ChronoTimeAllocationCollectionAction](ChronoTimeAllocationCollectionAction.md).

## ChronoTimeAllocationCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoTimeAllocationCollectionResult> run(List<Request> requests)
```

Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.

Types: [ChronoTimeAllocationCollectionResult](ChronoTimeAllocationCollectionResult.md).

## ChronoTimeAllocationCollectionAction.Request

| Field / property                               | Flow label       | Contract                             |
| ---------------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoTimeAllocationInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
