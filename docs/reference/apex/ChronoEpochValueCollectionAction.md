# ChronoEpochValueCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoEpochValueCollectionAction`.

Convert an exact value to or from Unix seconds or milliseconds.

## Declaration

```apex
global with sharing class ChronoEpochValueCollectionAction
```

Convert an exact value to or from Unix seconds or milliseconds.

Types: [ChronoEpochValueCollectionAction](ChronoEpochValueCollectionAction.md).

## ChronoEpochValueCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoEpochCollectionResult> run(List<Request> requests)
```

Convert an exact value to or from Unix seconds or milliseconds.

Types: [ChronoEpochCollectionResult](ChronoEpochCollectionResult.md).

## ChronoEpochValueCollectionAction.Request

| Field / property                           | Flow label       | Contract                             |
| ------------------------------------------ | ---------------- | ------------------------------------ |
| `global List<ChronoEpochValueInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
