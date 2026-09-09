# ChronoRangeToolsCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoRangeToolsCollectionAction`.

Validate and manipulate half-open ranges: start is included and end is excluded.

## Declaration

```apex
global with sharing class ChronoRangeToolsCollectionAction
```

Validate and manipulate half-open ranges: start is included and end is excluded.

Types: [ChronoRangeToolsCollectionAction](ChronoRangeToolsCollectionAction.md).

## ChronoRangeToolsCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoRangeCollectionResult> run(List<Request> requests)
```

Validate and manipulate half-open ranges: start is included and end is excluded.

Types: [ChronoRangeCollectionResult](ChronoRangeCollectionResult.md).

## ChronoRangeToolsCollectionAction.Request

| Field / property                           | Flow label       | Contract                             |
| ------------------------------------------ | ---------------- | ------------------------------------ |
| `global List<ChronoRangeToolsInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
