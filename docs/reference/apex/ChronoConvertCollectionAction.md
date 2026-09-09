# ChronoConvertCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoConvertCollectionAction`.

Convert or normalise all eight Chrono value types. Collection inputs are also bulkified across Flow interviews.

## Declaration

```apex
global with sharing class ChronoConvertCollectionAction
```

Convert or normalise all eight Chrono value types. Collection inputs are also bulkified across Flow interviews.

Types: [ChronoConvertCollectionAction](ChronoConvertCollectionAction.md).

## ChronoConvertCollectionAction

```apex
global class Request
```

One collection submitted by a Flow interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Convert or normalise all eight Chrono value types. Flattens all interviews into one invocation-local batch.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoConvertCollectionAction.Request

| Field / property                        | Flow label        | Contract                                                                      |
| --------------------------------------- | ----------------- | ----------------------------------------------------------------------------- |
| `global List<ChronoConvertInput> items` | Values to convert | Required. Collection of ChronoConvertInput values. Results retain this order. |

### Request

```apex
global Request()
```

Global no-argument constructor for subscriber Flow.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
