# ChronoParseValueCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoParseValueCollectionAction`.

Parse an explicitly specified numeric date and time pattern without guessing.

## Declaration

```apex
global with sharing class ChronoParseValueCollectionAction
```

Parse an explicitly specified numeric date and time pattern without guessing.

Types: [ChronoParseValueCollectionAction](ChronoParseValueCollectionAction.md).

## ChronoParseValueCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Parse an explicitly specified numeric date and time pattern without guessing.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoParseValueCollectionAction.Request

| Field / property                           | Flow label       | Contract                             |
| ------------------------------------------ | ---------------- | ------------------------------------ |
| `global List<ChronoParseValueInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
