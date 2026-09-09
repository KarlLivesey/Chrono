# ChronoAdjustCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoAdjustCollectionAction`.

Add calendar or elapsed units to a Chrono value. Collection inputs are also bulkified across Flow interviews.

## Declaration

```apex
global with sharing class ChronoAdjustCollectionAction
```

Add calendar or elapsed units to a Chrono value. Collection inputs are also bulkified across Flow interviews.

Types: [ChronoAdjustCollectionAction](ChronoAdjustCollectionAction.md).

## ChronoAdjustCollectionAction

```apex
global class Request
```

One collection submitted by a Flow interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Add calendar or elapsed units to a Chrono value. Flattens all interviews into one invocation-local batch.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoAdjustCollectionAction.Request

| Field / property                       | Flow label       | Contract                                                                     |
| -------------------------------------- | ---------------- | ---------------------------------------------------------------------------- |
| `global List<ChronoAdjustInput> items` | Values to adjust | Required. Collection of ChronoAdjustInput values. Results retain this order. |

### Request

```apex
global Request()
```

Global no-argument constructor for subscriber Flow.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
