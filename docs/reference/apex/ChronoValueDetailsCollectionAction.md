# ChronoValueDetailsCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoValueDetailsCollectionAction`.

Inspect calendar and clock components with an explicit timezone for instants.

## Declaration

```apex
global with sharing class ChronoValueDetailsCollectionAction
```

Inspect calendar and clock components with an explicit timezone for instants.

Types: [ChronoValueDetailsCollectionAction](ChronoValueDetailsCollectionAction.md).

## ChronoValueDetailsCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoDetailsCollectionResult> run(List<Request> requests)
```

Inspect calendar and clock components with an explicit timezone for instants.

Types: [ChronoDetailsCollectionResult](ChronoDetailsCollectionResult.md).

## ChronoValueDetailsCollectionAction.Request

| Field / property                             | Flow label       | Contract                             |
| -------------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoValueDetailsInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
