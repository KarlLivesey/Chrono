# ChronoDifferenceCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoDifferenceCollectionAction`.

Calculate signed elapsed time between two instants, optionally counting only OperatingHours. Collection inputs are also bulkified across Flow interviews.

## Declaration

```apex
global with sharing class ChronoDifferenceCollectionAction
```

Calculate signed elapsed time between two instants, optionally counting only OperatingHours. Collection inputs are also bulkified across Flow interviews.

Types: [ChronoDifferenceCollectionAction](ChronoDifferenceCollectionAction.md).

## ChronoDifferenceCollectionAction

```apex
global class Request
```

One collection submitted by a Flow interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Calculate signed elapsed time between two instants, optionally counting only OperatingHours. Flattens all interviews into one invocation-local batch.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoDifferenceCollectionAction.Request

| Field / property                           | Flow label        | Contract                                                                         |
| ------------------------------------------ | ----------------- | -------------------------------------------------------------------------------- |
| `global List<ChronoDifferenceInput> items` | Pairs of instants | Required. Collection of ChronoDifferenceInput values. Results retain this order. |

### Request

```apex
global Request()
```

Global no-argument constructor for subscriber Flow.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
