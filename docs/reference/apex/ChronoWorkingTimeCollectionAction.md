# ChronoWorkingTimeCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoWorkingTimeCollectionAction`.

Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays. Collection inputs are also bulkified across Flow interviews.

## Declaration

```apex
global with sharing class ChronoWorkingTimeCollectionAction
```

Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays. Collection inputs are also bulkified across Flow interviews.

Types: [ChronoWorkingTimeCollectionAction](ChronoWorkingTimeCollectionAction.md).

## ChronoWorkingTimeCollectionAction

```apex
global class Request
```

One collection submitted by a Flow interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays. Flattens all interviews into one invocation-local batch.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoWorkingTimeCollectionAction.Request

| Field / property                            | Flow label            | Contract                                                                          |
| ------------------------------------------- | --------------------- | --------------------------------------------------------------------------------- |
| `global List<ChronoWorkingTimeInput> items` | Working-time requests | Required. Collection of ChronoWorkingTimeInput values. Results retain this order. |

### Request

```apex
global Request()
```

Global no-argument constructor for subscriber Flow.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
