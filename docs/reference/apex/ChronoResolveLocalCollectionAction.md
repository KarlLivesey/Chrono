# ChronoResolveLocalCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoResolveLocalCollectionAction`.

Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary.

## Declaration

```apex
global with sharing class ChronoResolveLocalCollectionAction
```

Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary.

Types: [ChronoResolveLocalCollectionAction](ChronoResolveLocalCollectionAction.md).

## ChronoResolveLocalCollectionAction

```apex
global class Request
```

One explicit collection per interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoResolveLocalCollectionAction.Request

| Field / property                             | Flow label       | Contract                                          |
| -------------------------------------------- | ---------------- | ------------------------------------------------- |
| `global List<ChronoResolveLocalInput> items` | Input collection | Ordered requests; an empty collection is allowed. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
